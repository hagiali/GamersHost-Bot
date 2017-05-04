/*

	ent-ghost
	Copyright [2011-2013] [Jack Lu]

	This file is part of the ent-ghost source code.

	ent-ghost is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	ent-ghost source code is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with ent-ghost source code. If not, see <http://www.gnu.org/licenses/>.

	ent-ghost is modified from GHost++ (http://ghostplusplus.googlecode.com/)
	GHost++ is Copyright [2008] [Trevor Hogan]

*/

#include "ghost.h"
#include "util.h"
#include "language.h"
#include "socket.h"
#include "commandpacket.h"
#include "bnet.h"
#include "map.h"
#include "gameplayer.h"
#include "gameprotocol.h"
#include "gcbiprotocol.h"
#include "gpsprotocol.h"
#include "amhprotocol.h"
#include "stageplayer.h"
#include "ghostdb.h"
#include "game_base.h"

//
// CPotentialPlayer
//

CPotentialPlayer :: CPotentialPlayer( CGameProtocol *nProtocol, CBaseGame *nGame, CTCPSocket *nSocket ) : m_Protocol( nProtocol ), m_Game( nGame ), m_Socket( nSocket ), m_DeleteMe( false ), m_Error( false ), m_IncomingJoinPlayer( NULL ), m_IncomingGarenaUser( NULL ), m_ConnectionState( 0 ), m_ConnectionTime( GetTicks( ) ), m_Banned( false ), m_CallableBanCheck( NULL )
{
	if( nSocket )
		m_CachedIP = nSocket->GetIPString( );
	else
		m_CachedIP = string( );
}

CPotentialPlayer :: ~CPotentialPlayer( )
{
	if( m_Socket )
		delete m_Socket;

	while( !m_Packets.empty( ) )
	{
		delete m_Packets.front( );
		m_Packets.pop( );
	}

	delete m_IncomingJoinPlayer;
	delete m_IncomingGarenaUser;
	
	boost::mutex::scoped_lock lock( m_Game->m_GHost->m_CallablesMutex );

	if( m_CallableBanCheck )
		m_Game->m_GHost->m_Callables.push_back( m_CallableBanCheck );

	lock.unlock( );
}

BYTEARRAY CPotentialPlayer :: GetGarenaIP( )
{
	if( m_IncomingGarenaUser == NULL ) {
		return UTIL_CreateByteArray( (uint32_t) 0, true );
	} else {
		return UTIL_CreateByteArray( m_IncomingGarenaUser->GetIP( ), true );
	}
}

BYTEARRAY CPotentialPlayer :: GetExternalIP( )
{
	unsigned char Zeros[] = { 0, 0, 0, 0 };

	if( m_Socket ) {
		if( m_IncomingGarenaUser != NULL )
			return GetGarenaIP( );
		else
			return m_Socket->GetIP( );
	}

	return UTIL_CreateByteArray( Zeros, 4 );
}

string CPotentialPlayer :: GetExternalIPString( )
{
	if( m_Socket ) {
		if( m_IncomingGarenaUser != NULL ) {
			BYTEARRAY GarenaIP = GetGarenaIP( );
			return UTIL_ToString(GarenaIP[0]) + "." + UTIL_ToString(GarenaIP[1]) + "." + UTIL_ToString(GarenaIP[2]) + "." + UTIL_ToString(GarenaIP[3]);
		} else {
			string IPString = m_Socket->GetIPString( );
			
			if( !IPString.empty( ) && IPString != "0.0.0.0" )
				return m_Socket->GetIPString( );
			else
				return m_CachedIP;
		}
	}

	return m_CachedIP;
}

bool CPotentialPlayer :: Update( void *fd )
{
	if( m_DeleteMe )
		return true;

	if( !m_Socket )
		return false;

	m_Socket->DoRecv( (fd_set *)fd );
	ExtractPackets( );
	ProcessPackets( );
	
	// make sure we don't keep this socket open forever (disconnect after five seconds)
	if( m_ConnectionState == 0 && GetTicks( ) - m_ConnectionTime > 5000 && !m_Banned )
	{
		CONSOLE_Print( "[DENY] Kicking player: REQJOIN not received within five seconds" );
		m_DeleteMe = true;
        m_Game->m_GHost->DenyIP( GetExternalIPString( ), 60000, "REQJOIN not received within five seconds" );
	}
	
	else if( m_ConnectionState == 0 && GetTicks( ) - m_ConnectionTime > 30000 )
	{
		m_DeleteMe = true;
        m_Game->m_GHost->DenyIP( GetExternalIPString( ), 30000, "banned player message" );
	}
	
	// request join if we're ready
	if( m_ConnectionState == 0 && m_CallableBanCheck && m_CallableBanCheck->GetReady( ) )
	{
		CDBBan *Ban = m_CallableBanCheck->GetResult( );
		
		if( Ban )
		{
			string Name = "unknown";

			if( m_IncomingJoinPlayer )
				Name = m_IncomingJoinPlayer->GetName( );

			CONSOLE_Print( "Player [" + Name + "|" + GetExternalIPString( ) + "] is attempting to join but is banned: [" + UTIL_ToString( Ban->GetId( ) ) + "]" );
			m_Banned = true;
			SendBannedInfo( Ban, "banned" );
		}
		else
			m_Game->EventPlayerJoined( this, m_IncomingJoinPlayer, NULL );
		
		m_Game->m_GHost->m_DB->RecoverCallable( m_CallableBanCheck );
		delete m_CallableBanCheck; //deletes Ban too
		m_CallableBanCheck = NULL;
	}

	// don't call DoSend here because some other players may not have updated yet and may generate a packet for this player
	// also m_Socket may have been set to NULL during ProcessPackets but we're banking on the fact that m_DeleteMe has been set to true as well so it'll short circuit before dereferencing

	return m_DeleteMe || m_Error || m_Socket->HasError( ) || !m_Socket->GetConnected( );
}

void CPotentialPlayer :: ExtractPackets( )
{
	if( !m_Socket )
		return;

	// extract as many packets as possible from the socket's receive buffer and put them in the m_Packets queue

	string *RecvBuffer = m_Socket->GetBytes( );
	BYTEARRAY Bytes = UTIL_CreateByteArray( (unsigned char *)RecvBuffer->c_str( ), RecvBuffer->size( ) );

	// a packet is at least 4 bytes so loop as long as the buffer contains 4 bytes

	while( Bytes.size( ) >= 4 )
	{
		if( Bytes[0] == W3GS_HEADER_CONSTANT || Bytes[0] == GPS_HEADER_CONSTANT || Bytes[0] == GCBI_HEADER_CONSTANT || Bytes[0] == AMH_HEADER_CONSTANT )
		{
			// bytes 2 and 3 contain the length of the packet

			uint16_t Length = UTIL_ByteArrayToUInt16( Bytes, false, 2 );

			if( Length >= 4 )
			{
				if( Bytes.size( ) >= Length )
				{
					m_Packets.push( new CCommandPacket( Bytes[0], Bytes[1], BYTEARRAY( Bytes.begin( ), Bytes.begin( ) + Length ) ) );
					*RecvBuffer = RecvBuffer->substr( Length );
					Bytes = BYTEARRAY( Bytes.begin( ) + Length, Bytes.end( ) );
				}
				else
					return;
			}
			else
			{
				m_Error = true;
				m_ErrorString = "received invalid packet from player (bad length)";
				return;
			}
		}
		else
		{
			m_Error = true;
			m_ErrorString = "received invalid packet from player (bad header constant)";
			return;
		}
	}
}

void CPotentialPlayer :: ProcessPackets( )
{
	if( !m_Socket )
		return;

	// process all the received packets in the m_Packets queue

	while( !m_Packets.empty( ) )
	{
		CCommandPacket *Packet = m_Packets.front( );
		m_Packets.pop( );

		if( Packet->GetPacketType( ) == W3GS_HEADER_CONSTANT )
		{
			// the only packet we care about as a potential player is W3GS_REQJOIN, ignore everything else

			switch( Packet->GetID( ) )
			{
			case CGameProtocol :: W3GS_REQJOIN:
				delete m_IncomingJoinPlayer;
				m_IncomingJoinPlayer = m_Protocol->RECEIVE_W3GS_REQJOIN( Packet->GetData( ) );

				if( m_IncomingJoinPlayer && !m_Banned )
				{
					// check for bans on this player
					m_CallableBanCheck = m_Game->m_GHost->m_DB->ThreadedBanCheck( m_Game->GetJoinedRealm( m_IncomingJoinPlayer->GetHostCounter( ) ), m_IncomingJoinPlayer->GetName( ), GetExternalIPString( ), m_Game->m_GHost->HostNameLookup( GetExternalIPString( ) ), m_Game->GetOwnerName( ) + "@" + m_Game->GetOwnerRealm( ) );
				}

				// don't continue looping because there may be more packets waiting and this parent class doesn't handle them
				// EventPlayerJoined creates the new player, NULLs the socket, and sets the delete flag on this object so it'll be deleted shortly
				// any unprocessed packets will be copied to the new CGamePlayer in the constructor or discarded if we get deleted because the game is full

				delete Packet;
				return;
			}
		}
		
		else if( Packet->GetPacketType( ) == GCBI_HEADER_CONSTANT )
		{
			if( Packet->GetID( ) == CGCBIProtocol :: GCBI_INIT && m_Game->m_GHost->IsLocal( GetExternalIPString( ) ) )
			{
				delete m_IncomingGarenaUser;
				m_IncomingGarenaUser = m_Game->m_GHost->m_GCBIProtocol->RECEIVE_GCBI_INIT( Packet->GetData( ) );
                CONSOLE_Print( "[GCBI] Garena user detected; userid=" + UTIL_ToString( m_IncomingGarenaUser->GetUserID( ) ) + ", roomid=" + UTIL_ToString( m_IncomingGarenaUser->GetRoomID( ) ) + ", experience=" + UTIL_ToString( m_IncomingGarenaUser->GetUserExp( ) ) + ", country=" + m_IncomingGarenaUser->GetCountryCode( ) );
			}
		}

		delete Packet;
	}
}

void CPotentialPlayer :: Send( BYTEARRAY data )
{
	if( m_Socket )
		m_Socket->PutBytes( data );
}

void CPotentialPlayer :: SendBannedInfo( CDBBan *Ban, string type )
{
	// send slot info to the banned player
	
	CMap *Map = m_Game->GetMap( );
	
	if( Map )
	{
		vector<CGameSlot> Slots = Map->GetSlots( );
		m_Socket->PutBytes( m_Protocol->SEND_W3GS_SLOTINFOJOIN( 2, m_Socket->GetPort( ), GetExternalIP( ), Slots, 0, Map->GetMapGameType( ) == GAMETYPE_CUSTOM ? 3 : 0, Map->GetMapNumPlayers( ) ) );
	
		BYTEARRAY IP;
		IP.push_back( 0 );
		IP.push_back( 0 );
		IP.push_back( 0 );
		IP.push_back( 0 );
	
        m_Socket->PutBytes( m_Protocol->SEND_W3GS_PLAYERINFO( 1, "DotA Vision", IP, IP ) );
	
		// send a map check packet to the new player
	
		m_Socket->PutBytes( m_Protocol->SEND_W3GS_MAPCHECK( Map->GetMapPath( ), Map->GetMapSize( ), Map->GetMapInfo( ), Map->GetMapCRC( ), Map->GetMapSHA1( ) ) );
	
		if(type == "banned")
		{
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "Sorry, but you are currently banned." ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "    Username: " + Ban->GetName( ) ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "    Admin: " + Ban->GetAdmin( ) ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "    Reason: " + Ban->GetReason( ) ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "    Gamename: " + Ban->GetGameName( ) ) );
            m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "Most bans are temporary; register on dota.vision and connect your account for more details on your ban." ) );
            m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "You can also appeal your ban on dota.vision." ) );
		}
		else if(type == "score") {
		
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "Error: you do not have the required score or number of wins to join this game." ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "For autobalanced games, you need to achieve ten wins for the same map." ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "For DotA HR, you need to have 1150+ ELO and at least 20 wins." ) );
			m_Socket->PutBytes( m_Protocol->SEND_W3GS_CHAT_FROM_HOST( 1, UTIL_CreateByteArray( 2 ), 16, BYTEARRAY( ), "For Legion TD Mega HR, you need to have 1100+ ELO and at least 15 wins." ) );
		}
	}
}

//
// CGamePlayer
//

CGamePlayer :: CGamePlayer( CGameProtocol *nProtocol, CBaseGame *nGame, CTCPSocket *nSocket, unsigned char nPID, string nJoinedRealm, string nName, BYTEARRAY nInternalIP, bool nReserved ) : CPotentialPlayer( nProtocol, nGame, nSocket ), m_PID( nPID ), m_Name( nName ), m_InternalIP( nInternalIP ), m_JoinedRealm( nJoinedRealm ), m_TotalPacketsSent( 0 ), m_TotalPacketsReceived( 0 ), m_LeftCode( PLAYERLEAVE_LOBBY ), m_SyncCounter( 0 ), m_JoinTime( GetTime( ) ), m_LastMapPartSent( 0 ), m_LastMapPartAcked( 0 ), m_StartedDownloadingTicks( 0 ), m_FinishedLoadingTicks( 0 ), m_StartedLaggingTicks( 0 ), m_TotalLaggingTicks( 0 ), m_LastLaggingTicks( 0 ), m_StatsSentTime( 0 ), m_StatsDotASentTime( 0 ), m_KickVoteTime( 0 ), m_LastGProxyWaitNoticeSentTime( 0 ), m_Score( -100000.0 ), m_Spoofed( false ), m_Reserved( nReserved ), m_WhoisShouldBeSent( false ), m_WhoisSent( false ), m_DownloadAllowed( false ), m_DownloadStarted( false ), m_DownloadFinished( false ), m_FinishedLoading( false ), m_Lagging( false ), m_DropVote( false ), m_KickVote( false ), m_StartVote( false ), m_Muted( false ), m_LeftMessageSent( false ), m_GProxy( false ), m_GProxyDisconnectNoticeSent( false ), m_GProxyReconnectKey( rand( ) ), m_LastGProxyAckTime( 0 ), m_Autoban( false ), m_ForfeitVote( false ), m_ForfeitVoteTime( 0 ), m_FriendlyName( nName ), m_DrawVote( false ), m_DrawVoteTime( 0 ), m_Fun( false ), m_LastAMHPingTime( 0 ), m_LastAMHPongTime( 0 ), m_AMHInitSent( false ), m_ForcedMute( false )
{
    m_ConnectionState = 1;
	m_GProxyExtended = false;
	m_GProxyVersion = 0;
	m_TotalDisconnectTime = 0;
	m_LastDisconnectTime = 0;
	m_Disconnected = false;
}

CGamePlayer :: CGamePlayer( CPotentialPlayer *potential, unsigned char nPID, string nJoinedRealm, string nName, BYTEARRAY nInternalIP, bool nReserved ) : CPotentialPlayer( potential->m_Protocol, potential->m_Game, potential->GetSocket( ) ), m_PID( nPID ), m_Name( nName ), m_InternalIP( nInternalIP ), m_JoinedRealm( nJoinedRealm ), m_TotalPacketsSent( 0 ), m_TotalPacketsReceived( 1 ), m_LeftCode( PLAYERLEAVE_LOBBY ), m_Cookies( 0 ), m_SyncCounter( 0 ), m_JoinTime( GetTime( ) ), m_LastMapPartSent( 0 ), m_LastMapPartAcked( 0 ), m_StartedDownloadingTicks( 0 ), m_FinishedLoadingTicks( 0 ), m_StartedLaggingTicks( 0 ), m_TotalLaggingTicks( 0 ), m_LastLaggingTicks( 0 ), m_StatsSentTime( 0 ), m_StatsDotASentTime( 0 ), m_LastGProxyWaitNoticeSentTime( 0 ), m_Score( -100000.0 ), m_Spoofed( false ), m_Reserved( nReserved ), m_WhoisShouldBeSent( false ), m_WhoisSent( false ), m_DownloadAllowed( false ), m_DownloadStarted( false ), m_DownloadFinished( false ), m_FinishedLoading( false ), m_Lagging( false ), m_DropVote( false ), m_KickVote( false ), m_StartVote( false ), m_Muted( false ), m_LeftMessageSent( false ), m_GProxy( false ), m_GProxyDisconnectNoticeSent( false ), m_GProxyReconnectKey( rand( ) ), m_LastGProxyAckTime( 0 ), m_Autoban( false ), m_ForfeitVote( false ), m_ForfeitVoteTime( 0 ), m_FriendlyName( nName ), m_DrawVote( false ), m_DrawVoteTime( 0 ), m_Fun( false ), m_LastAMHPingTime( 0 ), m_LastAMHPongTime( 0 ), m_AMHInitSent( false ), m_ForcedMute( false )
{
	// todotodo: properly copy queued packets to the new player, this just discards them
	// this isn't a big problem because official Warcraft III clients don't send any packets after the join request until they receive a response
	// m_Packets = potential->GetPackets( );


        // hackhack: we initialize m_TotalPacketsReceived to 1 because the CPotentialPlayer must have received a W3GS_REQJOIN before this class was created
	// to fix this we could move the packet counters to CPotentialPlayer and copy them here
	// note: we must make sure we never send a packet to a CPotentialPlayer otherwise the send counter will be incorrect too! what a mess this is...
	// that said, the packet counters are only used for managing GProxy++ reconnections
    m_ConnectionState = 1;
    
    m_IncomingGarenaUser = potential->GetGarenaUser( );
	m_GProxyExtended = false;
	m_GProxyVersion = 0;
	m_TotalDisconnectTime = 0;
	m_LastDisconnectTime = 0;
	m_Disconnected = false;
}

CGamePlayer :: CGamePlayer( CStagePlayer *potential, CGameProtocol *nProtocol, CBaseGame *nGame, unsigned char nPID, string nJoinedRealm, string nName, BYTEARRAY nInternalIP, bool nReserved ) : CPotentialPlayer( nProtocol, nGame, potential->GetSocket( ) ), m_PID( nPID ), m_Name( nName ), m_InternalIP( nInternalIP ), m_JoinedRealm( nJoinedRealm ), m_TotalPacketsSent( 0 ), m_TotalPacketsReceived( 1 ), m_LeftCode( PLAYERLEAVE_LOBBY ), m_Cookies( 0 ), m_SyncCounter( 0 ), m_JoinTime( GetTime( ) ), m_LastMapPartSent( 0 ), m_LastMapPartAcked( 0 ), m_StartedDownloadingTicks( 0 ), m_FinishedLoadingTicks( 0 ), m_StartedLaggingTicks( 0 ), m_TotalLaggingTicks( 0 ), m_LastLaggingTicks( 0 ), m_StatsSentTime( 0 ), m_StatsDotASentTime( 0 ), m_LastGProxyWaitNoticeSentTime( 0 ), m_Score( -100000.0 ), m_Spoofed( false ), m_Reserved( nReserved ), m_WhoisShouldBeSent( false ), m_WhoisSent( false ), m_DownloadAllowed( false ), m_DownloadStarted( false ), m_DownloadFinished( false ), m_FinishedLoading( false ), m_Lagging( false ), m_DropVote( false ), m_KickVote( false ), m_StartVote( false ), m_Muted( false ), m_LeftMessageSent( false ), m_GProxy( false ), m_GProxyDisconnectNoticeSent( false ), m_GProxyReconnectKey( rand( ) ), m_LastGProxyAckTime( 0 ), m_Autoban( false ), m_ForfeitVote( false ), m_ForfeitVoteTime( 0 ), m_FriendlyName( nName ), m_DrawVote( false ), m_DrawVoteTime( 0 ), m_Fun( false ), m_LastAMHPingTime( 0 ), m_LastAMHPongTime( 0 ), m_AMHInitSent( false ), m_ForcedMute( false )
{
	// todotodo: properly copy queued packets to the new player, this just discards them
	// this isn't a big problem because official Warcraft III clients don't send any packets after the join request until they receive a response
	// m_Packets = potential->GetPackets( );


        // hackhack: we initialize m_TotalPacketsReceived to 1 because the CPotentialPlayer must have received a W3GS_REQJOIN before this class was created
	// to fix this we could move the packet counters to CPotentialPlayer and copy them here
	// note: we must make sure we never send a packet to a CPotentialPlayer otherwise the send counter will be incorrect too! what a mess this is...
	// that said, the packet counters are only used for managing GProxy++ reconnections
    m_ConnectionState = 1;
	m_GProxyExtended = false;
	m_GProxyVersion = 0;
	m_TotalDisconnectTime = 0;
	m_LastDisconnectTime = 0;
	m_Disconnected = false;
}

CGamePlayer :: ~CGamePlayer( )
{

}

string CGamePlayer :: GetNameTerminated( )
{
	// if the player's name contains an unterminated colour code add the colour terminator to the end of their name
	// this is useful because it allows you to print the player's name in a longer message which doesn't colour all the subsequent text

	string LowerName = m_Name;
	transform( LowerName.begin( ), LowerName.end( ), LowerName.begin( ), (int(*)(int))tolower );
	string :: size_type Start = LowerName.find( "|c" );
	string :: size_type End = LowerName.find( "|r" );

	if( Start != string :: npos && ( End == string :: npos || End < Start ) )
		return m_Name + "|r";
	else
		return m_Name;
}

uint32_t CGamePlayer :: GetPing( bool LCPing )
{
	// just average all the pings in the vector, nothing fancy

	if( m_Pings.empty( ) )
		return 0;

	uint32_t AvgPing = 0;

        for( unsigned int i = 0; i < m_Pings.size( ); ++i )
		AvgPing += m_Pings[i];

	AvgPing /= m_Pings.size( );

	if( LCPing )
		return AvgPing / 2;
	else
		return AvgPing;
}

bool CGamePlayer :: GetIsIgnoring( string username )
{
	transform( username.begin( ), username.end( ), username.begin( ), (int(*)(int))tolower );
	
	for( vector<string> :: iterator i = m_IgnoreList.begin( ); i != m_IgnoreList.end( ); ++i )
	{
		if( (*i) == username )
			return true;
	}
	
	return false;
}

void CGamePlayer :: Ignore( string username )
{
	if( GetIsIgnoring( username ) ) return;
	transform( username.begin( ), username.end( ), username.begin( ), (int(*)(int))tolower );
	
	m_IgnoreList.push_back( username );
}

void CGamePlayer :: UnIgnore( string username )
{
	transform( username.begin( ), username.end( ), username.begin( ), (int(*)(int))tolower );
	
	for( vector<string> :: iterator i = m_IgnoreList.begin( ); i != m_IgnoreList.end( ); )
	{
		if( (*i) == username )
		{
			m_IgnoreList.erase( i );
			continue;
		}
		
		++i;
	}
}

bool CGamePlayer :: Update( void *fd )
{
	// wait 4 seconds after joining before sending the /whois or /w
	// if we send the /whois too early battle.net may not have caught up with where the player is and return erroneous results

	if( m_WhoisShouldBeSent && !m_Spoofed && !m_WhoisSent && !m_JoinedRealm.empty( ) && GetTime( ) - m_JoinTime >= 4 )
	{
		// todotodo: we could get kicked from battle.net for sending a command with invalid characters, do some basic checking

		for( vector<CBNET *> :: iterator i = m_Game->m_GHost->m_BNETs.begin( ); i != m_Game->m_GHost->m_BNETs.end( ); ++i )
		{
			if( (*i)->GetServer( ) == m_JoinedRealm )
			{
				if( m_Game->GetGameState( ) == GAME_PUBLIC )
				{
					if( (*i)->GetPasswordHashType( ) == "pvpgn" )
						(*i)->QueueChatCommand( "/whereis " + m_Name );
					else
						(*i)->QueueChatCommand( "/whois " + m_Name );
				}
				else if( m_Game->GetGameState( ) == GAME_PRIVATE )
					(*i)->QueueChatCommand( m_Game->m_GHost->m_Language->SpoofCheckByReplying( ), m_Name, true );
			}
		}

		m_WhoisSent = true;
	}

	// check for socket timeouts
	// if we don't receive anything from a player for 30 seconds we can assume they've dropped
	// this works because in the lobby we send pings every 5 seconds and expect a response to each one
	// and in the game the Warcraft 3 client sends keepalives frequently (at least once per second it looks like)

	if( m_Socket && GetTime( ) - m_Socket->GetLastRecv( ) >= 30 )
	{
		if( !m_Disconnected )
			m_LastDisconnectTime = GetTime( );

		m_Disconnected = true;
		m_Game->EventPlayerDisconnectTimedOut( this );
		m_Socket->Reset( );
	}
	
	// make sure we're not waiting too long for the first MAPSIZE packet
	
    if( m_ConnectionState == 1 && GetTicks( ) - m_ConnectionTime > 5000 && !m_Game->GetGameLoaded() && !m_Game->GetGameLoading() )
	{
		CONSOLE_Print( "[DENY] Kicking player: MAPSIZE not received within five seconds" );
		m_DeleteMe = true;
        SetLeftReason( "MAPSIZE not received within five seconds" );
        SetLeftCode( PLAYERLEAVE_LOBBY );
        m_Game->OpenSlot( m_Game->GetSIDFromPID( GetPID( ) ), false );
        m_Game->m_GHost->DenyIP( GetExternalIPString( ), 60000, "MAPSIZE not received within five seconds" );	
    }
	
	// disconnect if the player is downloading too slowly
	
    if( m_DownloadStarted && !m_DownloadFinished && !m_Game->GetGameLoaded() && !m_Game->GetGameLoading() && GetLastMapPartSent( ) > 0 )
	{
		uint32_t downloadingTime = GetTicks( ) - m_StartedDownloadingTicks;
		
		if( downloadingTime > 8000 && GetLastMapPartAcked( ) / downloadingTime < 10 ) // GetLastMapPartAcked( ) / downloadingTime is B/ms, approximately KB/sec
		{
			CONSOLE_Print( "[DENY] Kicking player: download speed too low" );
			m_DeleteMe = true;
            SetLeftReason( "download speed too low" );
            SetLeftCode( PLAYERLEAVE_LOBBY );
            m_Game->OpenSlot( m_Game->GetSIDFromPID( GetPID( ) ), false );		
        }
	}
	
	// unmute player
    if( GetMuted( ) &&! getForcedMute( ) && ( GetTicks( ) - m_MutedTicks > 60000 || ( m_MutedAuto && GetTicks( ) - m_MutedTicks > 15000 ) ) )
	{
		SetMuted( false );
		m_Game->SendAllChat( "[" + m_Name + "] has been automatically unmuted. (Don't spam or you'll be muted again!)" );
		m_MuteMessages.clear( );
	}

	// GProxy++ acks

	if( m_GProxy && GetTime( ) - m_LastGProxyAckTime >= 10 )
	{
		if( m_Socket )
			m_Socket->PutBytes( m_Game->m_GHost->m_GPSProtocol->SEND_GPSS_ACK( m_TotalPacketsReceived ) );

		m_LastGProxyAckTime = GetTime( );
	}
	
	if( m_Game->m_GHost->m_AMH )
	{
		// AMH init
	
		if( !m_AMHInitSent )
		{
			m_Socket->PutBytes( m_Game->m_GHost->m_AMHProtocol->SEND_AMH_INIT( ) );
			m_AMHInitSent = true;
		}
	
		// AMH ping
	
		if( GetTime( ) - m_LastAMHPingTime >= 10 )
		{
			BYTEARRAY ping;
		
			for( unsigned int i = 0; i < 32; i++ )
				ping.push_back( rand( ) % 256 );
		
			m_Socket->PutBytes( m_Game->m_GHost->m_AMHProtocol->SEND_AMH_PING( ping ) );
		
			ping[5] = ping[5] + 1;
			m_NextAMHResponse.push( ping );
		
			while( m_NextAMHResponse.size( ) > 2 )
				m_NextAMHResponse.pop( );
		
			m_LastAMHPingTime = GetTime( );
		}
	
		// AMH timeout
	
		if( ( m_LastAMHPongTime == 0 && GetTime( ) - m_JoinTime > 15 ) || ( m_LastAMHPongTime != 0 && GetTime( ) - m_LastAMHPongTime > 60 ) )
		{
			if( m_LastAMHPongTime != 0 && GetTime( ) - m_LastAMHPongTime > 60 )
				m_Game->SendAllChat( m_PID, "[" + m_Name + "] !!! I am probably maphacking !!!" );
			
			m_Game->EventPlayerAMH( this, "AMH timeout" );
		}
	}

	// base class update

	CPotentialPlayer :: Update( fd );
	bool Deleting;

	if( m_GProxy && m_Game->GetGameLoaded( ) )
		Deleting = m_DeleteMe || m_Error;
	else
		Deleting = m_DeleteMe || m_Error || m_Socket->HasError( ) || !m_Socket->GetConnected( );

	// try to find out why we're requesting deletion
	// in cases other than the ones covered here m_LeftReason should have been set when m_DeleteMe was set
	
	if( m_Error )
	{
		m_Game->m_GHost->DenyIP( GetExternalIPString( ), 180000, "player error" );

		if( !m_Disconnected )
			m_LastDisconnectTime = GetTime( );

		m_Disconnected = true;
		m_Game->EventPlayerDisconnectPlayerError( this );
		m_Socket->Reset( );
		return Deleting;
	}

	if( m_Socket )
	{
		if( m_Socket->HasError( ) )
		{
			if( !m_Disconnected )
				m_LastDisconnectTime = GetTime( );

			m_Disconnected = true;
			m_Game->EventPlayerDisconnectSocketError( this );

			if( !m_GProxy && !m_GProxyExtended )
				m_Game->m_GHost->DenyIP( GetExternalIPString( ), 20000, "socket error" );

			m_Socket->Reset( );
		}
		else if( !m_Socket->GetConnected( ) )
		{
			if( !m_Disconnected )
				m_LastDisconnectTime = GetTime( );

			m_Disconnected = true;
			m_Game->EventPlayerDisconnectConnectionClosed( this );
			m_Socket->Reset( );
		}
	}

	return Deleting;
}

void CGamePlayer :: ExtractPackets( )
{
	if( !m_Socket )
		return;

	// extract as many packets as possible from the socket's receive buffer and put them in the m_Packets queue

	string *RecvBuffer = m_Socket->GetBytes( );
	BYTEARRAY Bytes = UTIL_CreateByteArray( (unsigned char *)RecvBuffer->c_str( ), RecvBuffer->size( ) );

	// a packet is at least 4 bytes so loop as long as the buffer contains 4 bytes

	while( Bytes.size( ) >= 4 )
	{
		if( Bytes[0] == W3GS_HEADER_CONSTANT || Bytes[0] == GPS_HEADER_CONSTANT || Bytes[0] == GCBI_HEADER_CONSTANT || Bytes[0] == AMH_HEADER_CONSTANT )
		{
			// bytes 2 and 3 contain the length of the packet

			uint16_t Length = UTIL_ByteArrayToUInt16( Bytes, false, 2 );

			if( Length >= 4 )
			{
				if( Bytes.size( ) >= Length )
				{
					m_Packets.push( new CCommandPacket( Bytes[0], Bytes[1], BYTEARRAY( Bytes.begin( ), Bytes.begin( ) + Length ) ) );

					if( Bytes[0] == W3GS_HEADER_CONSTANT )
                                                ++m_TotalPacketsReceived;

					*RecvBuffer = RecvBuffer->substr( Length );
					Bytes = BYTEARRAY( Bytes.begin( ) + Length, Bytes.end( ) );
				}
				else
					return;
			}
			else
			{
				m_Error = true;
				m_ErrorString = "received invalid packet from player (bad length)";
				return;
			}
		}
		else
		{
			m_Error = true;
			m_ErrorString = "received invalid packet from player (bad header constant)";
			return;
		}
	}
}

void CGamePlayer :: ProcessPackets( )
{
	if( !m_Socket )
		return;

	CIncomingAction *Action = NULL;
	CIncomingChatPlayer *ChatPlayer = NULL;
	CIncomingMapSize *MapSize = NULL;
	bool HasMap = false;
	uint32_t CheckSum = 0;
	uint32_t Pong = 0;

	// process all the received packets in the m_Packets queue

	while( !m_Packets.empty( ) )
	{
		CCommandPacket *Packet = m_Packets.front( );
		m_Packets.pop( );

		if( Packet->GetPacketType( ) == W3GS_HEADER_CONSTANT )
		{
			switch( Packet->GetID( ) )
			{
			case CGameProtocol :: W3GS_LEAVEGAME:
				m_Game->EventPlayerLeft( this, m_Protocol->RECEIVE_W3GS_LEAVEGAME( Packet->GetData( ) ) );
				break;

			case CGameProtocol :: W3GS_GAMELOADED_SELF:
				if( m_Protocol->RECEIVE_W3GS_GAMELOADED_SELF( Packet->GetData( ) ) )
				{
					if( !m_FinishedLoading && m_Game->GetGameLoading( ) )
					{
						m_FinishedLoading = true;
						m_FinishedLoadingTicks = GetTicks( );
						m_Game->EventPlayerLoaded( this );
					}
					else
					{
						// we received two W3GS_GAMELOADED_SELF packets from this player!
					}
				}

				break;

			case CGameProtocol :: W3GS_OUTGOING_ACTION:
				Action = m_Protocol->RECEIVE_W3GS_OUTGOING_ACTION( Packet->GetData( ), m_PID );

				if( Action )
					m_Game->EventPlayerAction( this, Action );

				// don't delete Action here because the game is going to store it in a queue and delete it later

				break;

			case CGameProtocol :: W3GS_OUTGOING_KEEPALIVE:
				CheckSum = m_Protocol->RECEIVE_W3GS_OUTGOING_KEEPALIVE( Packet->GetData( ) );
				m_CheckSums.push( CheckSum );
                                ++m_SyncCounter;
				m_Game->EventPlayerKeepAlive( this, CheckSum );
				break;

			case CGameProtocol :: W3GS_CHAT_TO_HOST:
				ChatPlayer = m_Protocol->RECEIVE_W3GS_CHAT_TO_HOST( Packet->GetData( ) );
				
				if( ChatPlayer )
				{
					// determine if we should auto-mute this player
					if( ChatPlayer->GetType( ) == CIncomingChatPlayer :: CTH_MESSAGE || ChatPlayer->GetType( ) == CIncomingChatPlayer :: CTH_MESSAGEEXTRA )
					{
						m_MuteMessages.push_back( GetTicks( ) );
					
						if( m_MuteMessages.size( ) > 7 )
							m_MuteMessages.erase( m_MuteMessages.begin( ) );
					
						uint32_t RecentCount = 0;

						for( unsigned int i = 0; i < m_MuteMessages.size( ); ++i )
						{
							if( GetTicks( ) - m_MuteMessages[i] < 7000 )
								RecentCount++;
						}
					
						if( !GetMuted( ) && RecentCount >= 7 )
						{
							SetMuted( true );
							m_MutedAuto = true;
							m_Game->SendAllChat( "[" + m_Name + "] has been automatically muted for spamming. (You will be unmuted momentarily, but please do not spam again!)" );
							m_MuteMessages.clear( );
						}
					
						//now check for flamers
						if( m_Game->m_GHost->FlameCheck( ChatPlayer->GetMessage( ) ) )
						{
							m_FlameMessages.push_back( GetTicks( ) );
					
							if( m_FlameMessages.size( ) > 10 )
								m_FlameMessages.erase( m_FlameMessages.begin( ) );
					
							RecentCount = 0;

							for( unsigned int i = 0; i < m_FlameMessages.size( ); ++i )
							{
								if( GetTicks( ) - m_FlameMessages[i] < 80000 )
									RecentCount++;
							}
					
							if( RecentCount >= 4 )
							{
								m_Game->SendAllChat( "Use !ignore <playername> to ignore players (for example, if they are flaming); partial names work. Don't flame back!" );
								m_FlameMessages.clear( );
							}
							else if( RecentCount >= 3 )
							{
				            	m_Game->SendAllChat( "[Calm] has refilled [" + GetName() + "]'s cookie jar. [" + GetName() + "] now has three cookies (try !eat)!");
				            	SetCookies(3);
							}
						}
					}
					
					m_Game->EventPlayerChatToHost( this, ChatPlayer );
				}

				delete ChatPlayer;
				ChatPlayer = NULL;
				break;

			case CGameProtocol :: W3GS_DROPREQ:
				// todotodo: no idea what's in this packet

				if( !m_DropVote )
				{
					m_DropVote = true;
					m_Game->EventPlayerDropRequest( this );
				}

				break;

			case CGameProtocol :: W3GS_MAPSIZE:
				m_ConnectionState = 2;
				m_ConnectionTime = GetTicks( );
				
				MapSize = m_Protocol->RECEIVE_W3GS_MAPSIZE( Packet->GetData( ), m_Game->m_GHost->m_Map->GetMapSize( ) );

				if( MapSize )
					m_Game->EventPlayerMapSize( this, MapSize );

				delete MapSize;
				MapSize = NULL;
				break;

			case CGameProtocol :: W3GS_PONG_TO_HOST:
				Pong = m_Protocol->RECEIVE_W3GS_PONG_TO_HOST( Packet->GetData( ) );

				// we discard pong values of 1
				// the client sends one of these when connecting plus we return 1 on error to kill two birds with one stone

				if( Pong != 1 )
				{
					// we also discard pong values when we're downloading because they're almost certainly inaccurate
					// this statement also gives the player a 5 second grace period after downloading the map to allow queued (i.e. delayed) ping packets to be ignored

					if( !m_DownloadStarted || ( m_DownloadFinished && GetTime( ) - m_FinishedDownloadingTime >= 5 ) )
					{
						// we also discard pong values when anyone else is downloading if we're configured to

						if( m_Game->m_GHost->m_PingDuringDownloads || !m_Game->IsDownloading( ) )
						{
							m_Pings.push_back( GetTicks( ) - Pong );

							if( m_Pings.size( ) > 20 )
								m_Pings.erase( m_Pings.begin( ) );
						}
					}
				}

				m_Game->EventPlayerPongToHost( this, Pong );
				break;
			}
		}
		else if( Packet->GetPacketType( ) == GPS_HEADER_CONSTANT )
		{
			BYTEARRAY Data = Packet->GetData( );

			if( Packet->GetID( ) == CGPSProtocol :: GPS_INIT )
			{
				if( m_Game->m_GHost->m_Reconnect )
				{
					m_GProxy = true;
					m_GProxyVersion = UTIL_ByteArrayToUInt32( Data, false, 4 );
					m_Socket->PutBytes( m_Game->m_GHost->m_GPSProtocol->SEND_GPSS_INIT( m_Game->m_GHost->m_ReconnectPort, m_PID, m_GProxyReconnectKey, m_Game->GetGProxyEmptyActions( ) ) );
					CONSOLE_Print( "[GAME: " + m_Game->GetGameName( ) + "] player [" + m_Name + "] is using GProxy++" );

					if( m_Game->m_GHost->m_ReconnectExtendedTime > 0 && m_GProxyVersion >= 2 )
						m_Socket->PutBytes( m_Game->m_GHost->m_GPSProtocol->SEND_GPSS_SUPPORT_EXTENDED( m_Game->m_GHost->m_ReconnectExtendedTime * 60 ) );
				}
				else
				{
					// todotodo: send notice that we're not permitting reconnects
					// note: GProxy++ should never send a GPS_INIT message if bot_reconnect = 0 because we don't advertise the game with invalid map dimensions
					// but it would be nice to cover this case anyway
				}
			}
			else if( Packet->GetID( ) == CGPSProtocol :: GPS_RECONNECT )
			{
				// this is handled in ghost.cpp
			}
			else if( Packet->GetID( ) == CGPSProtocol :: GPS_ACK && Data.size( ) == 8 )
			{
				uint32_t LastPacket = UTIL_ByteArrayToUInt32( Data, false, 4 );
				uint32_t PacketsAlreadyUnqueued = m_TotalPacketsSent - m_GProxyBuffer.size( );

				if( LastPacket > PacketsAlreadyUnqueued )
				{
					uint32_t PacketsToUnqueue = LastPacket - PacketsAlreadyUnqueued;

					if( PacketsToUnqueue > m_GProxyBuffer.size( ) )
						PacketsToUnqueue = m_GProxyBuffer.size( );

					while( PacketsToUnqueue > 0 )
					{
						m_GProxyBuffer.pop( );
                                                --PacketsToUnqueue;
					}
				}
			}
			else if( Packet->GetID( ) == CGPSProtocol :: GPS_SUPPORT_EXTENDED )
			{
				uint32_t seconds = UTIL_ByteArrayToUInt32( Data, false, 4 );
				m_GProxyExtended = true;
				CONSOLE_Print( "[GAME: " + m_Game->GetGameName( ) + "] player [" + m_Name + "] is using GProxy Extended" );
			}
		}
		else if( Packet->GetPacketType( ) == AMH_HEADER_CONSTANT && m_Game->m_GHost->m_AMH )
		{
			BYTEARRAY Data = Packet->GetData( );
			
			if( Packet->GetID( ) == CAMHProtocol :: AMH_PONG && !m_NextAMHResponse.empty( ) )
			{
				CAMHPong *Pong = m_Game->m_GHost->m_AMHProtocol->RECEIVE_AMH_PONG( Data );
				
				CONSOLE_Print( m_Name + " ||| receiving AMH pong" );
				
				if( Pong->GetVersion( ) != 5 )
					m_Game->EventPlayerAMH( this, "bad AMH version" );
				else
				{
					bool FoundMatch = false;
				
					while( !m_NextAMHResponse.empty( ) )
					{
						BYTEARRAY ExpectedPong = m_NextAMHResponse.front( );
						m_NextAMHResponse.pop( );
					
						if( ExpectedPong == Pong->GetPong( ) )
						{
							FoundMatch = true;
							break;
						}
					}
				
					if( FoundMatch )
					{
						if( m_LastAMHPongTime == 0 )
							CONSOLE_Print( "[GAME: " + m_Game->GetGameName( ) + "] player [" + m_Name + "] sent initial AMH packet" );

						m_LastAMHPongTime = GetTime( );
						CONSOLE_Print( m_Name + " ||| received amh match" );
					}
					else
						CONSOLE_Print( m_Name + " ||| amh mismatch error" );
				}
				
				delete Pong;
			}
		}

		delete Packet;
	}
}

void CGamePlayer :: Send( BYTEARRAY data )
{
	// must start counting packet total from beginning of connection
	// but we can avoid buffering packets until we know the client is using GProxy++ since that'll be determined before the game starts
	// this prevents us from buffering packets for non-GProxy++ clients

	++m_TotalPacketsSent;

	if( m_GProxy && m_Game->GetGameLoaded( ) )
		m_GProxyBuffer.push( data );

	if( !m_Disconnected )
		CPotentialPlayer :: Send( data );
}

void CGamePlayer :: EventGProxyReconnect( CTCPSocket *NewSocket, uint32_t LastPacket )
{
	delete m_Socket;
	m_Socket = NewSocket;
	m_Socket->PutBytes( m_Game->m_GHost->m_GPSProtocol->SEND_GPSS_RECONNECT( m_TotalPacketsReceived ) );

	uint32_t PacketsAlreadyUnqueued = m_TotalPacketsSent - m_GProxyBuffer.size( );

	if( LastPacket > PacketsAlreadyUnqueued )
	{
		uint32_t PacketsToUnqueue = LastPacket - PacketsAlreadyUnqueued;

		if( PacketsToUnqueue > m_GProxyBuffer.size( ) )
			PacketsToUnqueue = m_GProxyBuffer.size( );

		while( PacketsToUnqueue > 0 )
		{
			m_GProxyBuffer.pop( );
                        --PacketsToUnqueue;
		}
	}

	// send remaining packets from buffer, preserve buffer

	queue<BYTEARRAY> TempBuffer;

	while( !m_GProxyBuffer.empty( ) )
	{
		m_Socket->PutBytes( m_GProxyBuffer.front( ) );
		TempBuffer.push( m_GProxyBuffer.front( ) );
		m_GProxyBuffer.pop( );
	}

	m_GProxyBuffer = TempBuffer;
	m_GProxyDisconnectNoticeSent = false;
	m_Disconnected = false;

	if( m_LastDisconnectTime > 0 )
		m_TotalDisconnectTime += GetTime( ) - m_LastDisconnectTime;

	m_Game->SendAllChat( m_Game->m_GHost->m_Language->PlayerReconnectedWithGProxy( m_Name ) );
	m_CachedIP = m_Socket->GetIPString( );
}

uint32_t CGamePlayer :: GetTotalDisconnectTime( )
{
	if( !m_Disconnected || !m_LastDisconnectTime )
		return m_TotalDisconnectTime;
	else
		return m_TotalDisconnectTime + GetTime( ) - m_LastDisconnectTime;
}
