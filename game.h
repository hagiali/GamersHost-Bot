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

#ifndef GAME_H
#define GAME_H

//
// CGame
//

class CDBBan;
class CDBGame;
class CDBGamePlayer;
class CStats;
class CCallableBanCheck;
class CCallableBanAdd;
class CCallableGameAdd;
class CCallableGameUpdate;
class CCallableGamePlayerSummaryCheck;
class CCallableDotAPlayerSummaryCheck;
class CCallableVampPlayerSummaryCheck;
class CCallableTreePlayerSummaryCheck;
class CCallableIslandPlayerSummaryCheck;
class CCallableSnipePlayerSummaryCheck;
class CCallableShipsPlayerSummaryCheck;
class CCallableRVSPlayerSummaryCheck;
class CCallableW3MMDPlayerSummaryCheck;
class CCallableAdminCommand;
class CCallableAliasCheck;
class CCallableVerifyUser; 

typedef pair<string,CCallableBanCheck *> PairedBanCheck;
typedef pair<string,CCallableBanAdd *> PairedBanAdd;
typedef pair<string,CCallableBanRemove *> PairedBanRemove;
typedef pair<string,CCallableGamePlayerSummaryCheck *> PairedGPSCheck;
typedef pair<string,CCallableDotAPlayerSummaryCheck *> PairedDPSCheck;
typedef pair<string,CCallableVampPlayerSummaryCheck *> PairedVPSCheck;
typedef pair<string,CCallableTreePlayerSummaryCheck *> PairedTPSCheck;
typedef pair<string,CCallableIslandPlayerSummaryCheck *> PairedIPSCheck;
typedef pair<string,CCallableSnipePlayerSummaryCheck *> PairedSPSCheck;
typedef pair<string,CCallableShipsPlayerSummaryCheck *> PairedBPSCheck;
typedef pair<string,CCallableRVSPlayerSummaryCheck *> PairedRPSCheck;
typedef pair<string,CCallableW3MMDPlayerSummaryCheck *> PairedWPSCheck;
typedef pair<string,CCallableAliasCheck *> PairedAliasCheck;
typedef pair<string,CCallableVerifyUser *> PairedVerifyUserCheck; 

class CGame : public CBaseGame
{
private:
    uint32_t m_Guess;
protected:
	CDBBan *m_DBBanLast;						// last ban for the !banlast command - this is a pointer to one of the items in m_DBBans
	vector<CDBBan *> m_DBBans;					// vector of potential ban data for the database (see the Update function for more info, it's not as straightforward as you might think)
	CDBGame *m_DBGame;							// potential game data for the database
	vector<CDBGamePlayer *> m_DBGamePlayers;	// vector of potential gameplayer data for the database
	CStats *m_Stats;							// class to keep track of game stats such as kills/deaths/assists in dota
	CCallableGetTournament *m_CallableGetTournament; // threaded database tournament info check in progress
	CCallableGameAdd *m_CallableGameAdd;		// threaded database game addition in progress
	vector<PairedBanCheck> m_PairedBanChecks;	// vector of paired threaded database ban checks in progress
	vector<PairedBanAdd> m_PairedBanAdds;		// vector of paired threaded database ban adds in progress
	vector<PairedBanRemove> m_PairedBanRemoves;	// vector of paired threaded database ban removes in progress
	vector<PairedGPSCheck> m_PairedGPSChecks;	// vector of paired threaded database game player summary checks in progress
	vector<PairedDPSCheck> m_PairedDPSChecks;	// vector of paired threaded database DotA player summary checks in progress
	vector<PairedVPSCheck> m_PairedVPSChecks;	// vector of paired threaded database vamp player summary checks in progress
	vector<PairedTPSCheck> m_PairedTPSChecks;	// vector of paired threaded database treetag player summary checks in progress
	vector<PairedIPSCheck> m_PairedIPSChecks;	// vector of paired threaded database islanddefense player summary checks in progress
	vector<PairedSPSCheck> m_PairedSPSChecks;	// vector of paired threaded database sniper player summary checks in progress
	vector<PairedBPSCheck> m_PairedBPSChecks;	// vector of paired threaded database battleships player summary checks in progress
	vector<PairedWPSCheck> m_PairedWPSChecks;	// vector of paired threaded database battleships player summary checks in progress
	vector<PairedRPSCheck> m_PairedRPSChecks;	// vector of paired threaded database battleships player summary checks in progress
	vector<PairedAliasCheck> m_PairedAliasChecks;	// vector of paired threaded database alias checks in progress
	vector<PairedVerifyUserCheck> m_PairedVerifyUserChecks; // gr
	
    string m_MapType;							// recorded map type after game starts because map is deleted
	vector<string> m_AutoBans;
	uint32_t m_ForfeitTime;						// time that players forfeited, or 0 if not forfeited
	uint32_t m_ForfeitTeam;						// id of team that forfeited
	bool m_FirstLeaver;							// first leaver more likely to be banned
	uint32_t m_SetWinnerTicks;
	uint32_t m_SetWinnerTeam;
	bool m_SoloTeam;							// if one of the teams has a single player
	uint32_t m_ForceBanTicks;					// if non-zero, all players who left before this ingame ticks will be autobanned
	
	CCallableGameUpdate *m_CallableGameUpdate;	// threaded game update in progress
	uint32_t m_GameUpdateID;
	uint32_t m_LastGameUpdateTime;
	uint32_t m_LastInvalidActionNotifyTime;
	
	bool IsAutoBanned( string name );

public:
	CGame( CGHost *nGHost, CMap *nMap, CSaveGame *nSaveGame, uint16_t nHostPort, unsigned char nGameState, string nGameName, string nOwnerName, string nCreatorName, string nCreatorServer );
	virtual ~CGame( );

	virtual bool Update( void *fd, void *send_fd );
	virtual CGamePlayer *EventPlayerJoined( CPotentialPlayer *potential, CIncomingJoinPlayer *joinPlayer, double *score );
	virtual void EventPlayerDeleted( CGamePlayer *player );
	virtual bool EventPlayerAction( CGamePlayer *player, CIncomingAction *action );
	virtual bool EventPlayerBotCommand( CGamePlayer *player, string command, string payload );
	virtual void EventGameStarted( );
	virtual bool IsGameDataSaved( );
	virtual void SaveGameData( );
	virtual void CloseGame( );
    virtual uint32_t GetGuess() {return m_Guess;}
    virtual void SetGuess( uint32_t nGuess )     { m_Guess = nGuess; }
    virtual void GetStatsUser( string *statsUser, string *statsRealm );
    virtual void InvalidActionNotify( string message );

};

#endif
