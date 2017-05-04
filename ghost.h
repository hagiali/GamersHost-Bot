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

#ifndef GHOST_H
#define GHOST_H

#include "includes.h"

//
// CGHost
//

class CUDPSocket;
class CTCPServer;
class CTCPSocket;
class CGPSProtocol;
class CGCBIProtocol;
class CAMHProtocol;
class CGameProtocol;
class CStreamPlayer;
class CStagePlayer;
class CCRC32;
class CSHA1;
class CBNET;
class CBaseGame;
class CGHostDB;
class CBaseCallable;
class CLanguage;
class CMap;
class CSaveGame;
class CConfig;
class CCallableCommandList;
class CCallableSpoofList;
struct DenyInfo;
struct GameCreateRequest;
struct QueuedSpoofAdd;
struct HostNameInfo;

struct GProxyReconnector {
	CTCPSocket *socket;
	unsigned char PID;
	uint32_t ReconnectKey;
	uint32_t LastPacket;
	uint32_t PostedTime;
};

class CGHost
{
public:
	vector<CUDPSocket *> m_UDPSockets;		// a UDP socket for sending broadcasts and other junk (used with !sendlan)
	CUDPSocket *m_LocalSocket;				// a UDP socket for sending broadcasts and other junk (used with !sendlan)
	CTCPServer *m_ReconnectSocket;			// listening socket for GProxy++ reliable reconnects
	CTCPServer *m_StreamSocket;				// listening socket for streamers
	vector<CTCPSocket *> m_ReconnectSockets;// vector of sockets attempting to reconnect (connected but not identified yet)
	vector<CStreamPlayer *> m_StreamPlayers;// vector of stream players
	vector<CStagePlayer *> m_StagePlayers;	// vector of players waiting for a game
	vector<string> m_SlapPhrases;           // vector of phrases
	CGPSProtocol *m_GPSProtocol;
	CGCBIProtocol *m_GCBIProtocol;
	CAMHProtocol *m_AMHProtocol;
	CGameProtocol *m_GameProtocol;
	CCRC32 *m_CRC;							// for calculating CRC's
	CSHA1 *m_SHA;							// for calculating SHA1's
	vector<CBNET *> m_BNETs;				// all our battle.net connections (there can be more than one)
	CBaseGame *m_CurrentGame;				// this game is still in the lobby state
	vector<CBaseGame *> m_Games;			// these games are in progress
	boost::mutex m_GamesMutex;
	CGHostDB *m_DB;							// database
	vector<CBaseCallable *> m_Callables;	// vector of orphaned callables waiting to die
	boost::mutex m_CallablesMutex;
	vector<BYTEARRAY> m_LocalAddresses;		// vector of local IP addresses
	map<string, DenyInfo> m_DenyIP;			// map (IP -> DenyInfo) of denied IP addresses
	boost::mutex m_DenyMutex;
	CLanguage *m_Language;					// language
	CMap *m_Map;							// the currently loaded map
	boost::mutex m_MapMutex;				// mutex to protect asynchronous map loading
	GameCreateRequest *m_MapGameCreateRequest; // game create request after last asynchronous load completes
	uint32_t m_MapGameCreateRequestTicks;
	CMap *m_AdminMap;						// the map to use in the admin game
	vector<CMap*> m_AutoHostMap;			// the maps to use when autohosting
	CSaveGame *m_SaveGame;					// the save game to use
	GeoIP *m_GeoIP;							// GeoIP object
	vector<PIDPlayer> m_EnforcePlayers;		// vector of pids to force players to use in the next game (used with saved games)
	bool m_Exiting;							// set to true to force ghost to shutdown next update (used by SignalCatcher)
	bool m_ExitingNice;						// set to true to force ghost to disconnect from all battle.net connections and wait for all games to finish before shutting down
	bool m_Enabled;							// set to false to prevent new games from being created
	string m_Version;						// GHost++ version string
	uint32_t m_HostCounter;					// the current host counter (a unique number to identify a game, incremented each time a game is created)
	string m_AutoHostGameName;				// the base game name to auto host with
	string m_AutoHostOwner;
	string m_AutoHostServer;
	uint32_t m_AutoHostMaximumGames;		// maximum number of games to auto host
	uint32_t m_AutoHostAutoStartPlayers;	// when using auto hosting auto start the game when this many players have joined
	uint32_t m_LastAutoHostTime;			// GetTime when the last auto host was attempted
	uint32_t m_LastCommandListTime;			// GetTime when last refreshed command list
	CCallableCommandList *m_CallableCommandList;			// threaded database command list in progress
    bool m_AutoHostMatchMaking;
	double m_AutoHostMinimumScore;
	double m_AutoHostMaximumScore;
	bool m_AllGamesFinished;				// if all games finished (used when exiting nicely)
	uint32_t m_AllGamesFinishedTime;		// GetTime when all games finished (used when exiting nicely)
	string m_LanguageFile;					// config value: language file
	string m_Warcraft3Path;					// config value: Warcraft 3 path
	bool m_TFT;								// config value: TFT enabled or not
	string m_BindAddress;					// config value: the address to host games on
	uint16_t m_HostPort;					// config value: the port to host games on
	bool m_Reconnect;						// config value: GProxy++ reliable reconnects enabled or not
	uint16_t m_ReconnectPort;				// config value: the port to listen for GProxy++ reliable reconnects on
	uint32_t m_ReconnectWaitTime;			// config value: the maximum number of minutes to wait for a GProxy++ reliable reconnect
	uint32_t m_ReconnectExtendedTime;		// config value: the maximum number of minutes to wait for an extended GProxy++ reliable reconnect	
	uint32_t m_MaxGames;					// config value: maximum number of games in progress
	char m_CommandTrigger;					// config value: the command trigger inside games
	string m_MapCFGPath;					// config value: map cfg path
	string m_SaveGamePath;					// config value: savegame path
	string m_MapPath;						// config value: map path
	bool m_SaveReplays;						// config value: save replays
	string m_ReplayPath;					// config value: replay path
	string m_VirtualHostName;				// config value: virtual host name
	bool m_HideIPAddresses;					// config value: hide IP addresses from players
	bool m_CheckMultipleIPUsage;			// config value: check for multiple IP address usage
	uint32_t m_SpoofChecks;					// config value: do automatic spoof checks or not
	bool m_RequireSpoofChecks;				// config value: require spoof checks or not
	bool m_ReserveAdmins;					// config value: consider admins to be reserved players or not
	bool m_RefreshMessages;					// config value: display refresh messages or not (by default)
	bool m_AutoLock;						// config value: auto lock games when the owner is present
	bool m_AutoSave;						// config value: auto save before someone disconnects
	bool m_AMH;								// config value: whether LG-AMH is enabled on this bot
	uint32_t m_AllowDownloads;				// config value: allow map downloads or not
	bool m_PingDuringDownloads;				// config value: ping during map downloads or not
	uint32_t m_MaxDownloaders;				// config value: maximum number of map downloaders at the same time
	uint32_t m_MaxDownloadSpeed;			// config value: maximum total map download speed in KB/sec
	bool m_LCPings;							// config value: use LC style pings (divide actual pings by two)
	uint32_t m_AutoKickPing;				// config value: auto kick players with ping higher than this
	string m_IPBlackListFile;				// config value: IP blacklist file (ipblacklist.txt)
	uint32_t m_LobbyTimeLimit;				// config value: auto close the game lobby after this many minutes without any reserved players
	uint32_t m_Latency;						// config value: the latency (by default)
	uint32_t m_SyncLimit;					// config value: the maximum number of packets a player can fall out of sync before starting the lag screen (by default)
	bool m_VoteStartAllowed;			    // config value: if votestarts are allowed or not
    bool m_VoteStartAutohostOnly;           // config value: if votestarts are only allowed in autohosted games
    uint32_t m_VoteStartMinPlayers;             // config value: minimum number of players before users can !votestart
	bool m_VoteKickAllowed;					// config value: if votekicks are allowed or not
	uint32_t m_VoteKickPercentage;			// config value: percentage of players required to vote yes for a votekick to pass
	string m_DefaultMap;					// config value: default map (map.cfg)
	string m_MOTDFile;						// config value: motd.txt
	string m_GameLoadedFile;				// config value: gameloaded.txt
	string m_GameOverFile;					// config value: gameover.txt
	string m_GeoIPFile;						// config value: geoip.dat file
	bool m_LocalAdminMessages;				// config value: send local admin messages or not
	unsigned char m_LANWar3Version;			// config value: LAN warcraft 3 version
	uint32_t m_ReplayWar3Version;			// config value: replay warcraft 3 version (for saving replays)
	uint32_t m_ReplayBuildNumber;			// config value: replay build number (for saving replays)
	bool m_TCPNoDelay;						// config value: use Nagle's algorithm or not
	uint32_t m_MatchMakingMethod;			// config value: the matchmaking method
	vector<GProxyReconnector *> m_PendingReconnects;
	boost::mutex m_ReconnectMutex;
	uint32_t m_MapGameType;
	bool m_Openstats;						// config value: whether we have openstats tables
	uint32_t m_Autoban;						// config value: how long to autoban for (hours)
	uint32_t m_AutobanFirstLeavers;			// config value: number of first leavers to autoban
	uint32_t m_AutobanFirstLimit;			// config value: time limit on banning first leavers, from beginning of game (seconds)
	uint32_t m_AutobanMinAllies;			// config value: if player has less than this many allies, don't autoban
	uint32_t m_AutobanMinEnemies;			// config value: if player has less than this many enemies, don't autoban (seconds)
	uint32_t m_AutobanGameLimit;			// config value: time limit measured backwards from end of game to autoban
	uint32_t m_GameCounterLimit;			// config value: limit to the #XX autohosting
	
	uint32_t m_BanDuration;					// config value: default ban duration (hours)
	uint32_t m_CBanDuration;				// config value: cban duration (hours)
	uint32_t m_TBanDuration;				// config value: tban duration (hours)
	uint32_t m_PBanDuration;				// config value: pban duration (hours)
	uint32_t m_WBanDuration;				// config value: wban duration (hours)
	
	uint32_t m_AutoMuteSpammer;				// config value: auto mute spammers?
	bool m_StatsOnJoin;						// config value: attempt to show stats on join?
	bool m_AllowAnyConnect;					// config value: allow any wc3connect users to join? (don't check session)

	bool m_Gamelist;	
    bool m_FastReconnect;					// config value: whether this is a fast reconnect bot
	bool m_ShowScoreOnJoin;	
    string m_LocalIPs;						// config value: list of local IP's (which Garena is allowed from)
    
    vector<string> m_FlameTriggers;			// triggers for antiflame system
    
	uint32_t m_LastDenyCleanTime;			// last time we cleaned the deny table
	bool m_CloseSinglePlayer;				// whether to close games when there's only one player left
	
	boost::mutex m_SpoofMutex;
	map<string, string> m_SpoofList; 		// donators can opt to spoof their name
	uint32_t m_LastSpoofRefreshTime;		// refresh spoof list every 2 hours
	CCallableSpoofList *m_CallableSpoofList; // spoof list refresh in progress
	
	bool m_Stream;							// whether streaming is enabled
	uint32_t m_StreamPort;					// port to accept streamers on
	uint32_t m_StreamLimit;					// seconds from beginning of game before players can stream
	
	bool m_Stage;
	vector<CTCPSocket *> m_StageDoAdd;		// incoming connections to add to staging
	boost::mutex m_StageMutex;				// mutex for the above vector
	uint32_t m_LastStageTime;				// last time we tried to create a staging game
	vector<QueuedSpoofAdd> m_DoSpoofAdd;	// pending spoof checks to process

	deque<HostNameInfo> m_HostNameCache;	// host name lookup cache
	boost::mutex m_HostNameCacheMutex;

    bool m_ShowWaitingMessage;

	CGHost( CConfig *CFG );
	~CGHost( );

	// processing functions

	bool Update( long usecBlock );

	// events

	void EventBNETConnecting( CBNET *bnet );
	void EventBNETConnected( CBNET *bnet );
	void EventBNETDisconnected( CBNET *bnet );
	void EventBNETLoggedIn( CBNET *bnet );
	void EventBNETGameRefreshed( CBNET *bnet );
	void EventBNETGameRefreshFailed( CBNET *bnet );
	void EventBNETConnectTimedOut( CBNET *bnet );
	void EventBNETWhisper( CBNET *bnet, string user, string message );
	void EventBNETChat( CBNET *bnet, string user, string message );
	void EventBNETEmote( CBNET *bnet, string user, string message );
	void EventGameDeleted( CBaseGame *game );

	// other functions

	void ClearAutoHostMap( );
	void ReloadConfigs( );
	void SetConfigs( CConfig *CFG );
	void ExtractScripts( );
	void LoadIPToCountryData( ); // delete?
	void CreateGame( CMap *map, unsigned char gameState, bool saveGame, string gameName, string ownerName, string creatorName, string creatorServer, bool whisper );
	
	void DenyIP( string ip, uint32_t duration, string reason );
	bool CheckDeny( string ip );
	bool FlameCheck( string message );
	string GetSpoofName( string name );
	bool IsLocal( string ip );
	string FromCheck( string ip ); //
	uint32_t CountStagePlayers( );
	void BroadcastChat( string name, string message );

	void AsynchronousMapLoad( CConfig *CFG, string nCFGFile );
	void AsynchronousMapLoadHelper( CConfig *CFG, string nCFGFile );

	string HostNameLookup( string ip );
};

struct DenyInfo {
	uint32_t Time;
	uint32_t Duration;
	uint32_t Count;
};

struct GameCreateRequest {
	unsigned char gameState;
	bool saveGame;
	string gameName;
	string ownerName;
	string creatorName;
	string creatorServer;
	bool whisper;
};

struct HostNameInfo {
	string ip;
	string hostname;
};

#endif
