/*

   Copyright [2008] [Trevor Hogan]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   CODE PORTED FROM THE ORIGINAL GHOST PROJECT: http://ghost.pwner.org/

*/

#include <iomanip>
#include <iostream>
#include <map>
#include <queue>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

#ifdef WIN32
 #include "ms_stdint.h"
#else
 #include <stdint.h>
#endif

#include "config.h"
#include "elo.h"

#include <string.h>

#ifdef WIN32
 #include <winsock.h>
#endif

#include <mysql/mysql.h>

void CONSOLE_Print( string message )
{
	cout << message << endl;
}

string MySQLEscapeString( MYSQL *conn, string str )
{
	char *to = new char[str.size( ) * 2 + 1];
	unsigned long size = mysql_real_escape_string( conn, to, str.c_str( ), str.size( ) );
	string result( to, size );
	delete [] to;
	return result;
}

vector<string> MySQLFetchRow( MYSQL_RES *res )
{
	vector<string> Result;

	MYSQL_ROW Row = mysql_fetch_row( res );

	if( Row )
	{
		unsigned long *Lengths;
		Lengths = mysql_fetch_lengths( res );

		for( unsigned int i = 0; i < mysql_num_fields( res ); i++ )
		{
			if( Row[i] )
				Result.push_back( string( Row[i], Lengths[i] ) );
			else
				Result.push_back( string( ) );
		}
	}

	return Result;
}

string UTIL_ToString( uint32_t i )
{
	string result;
	stringstream SS;
	SS << i;
	SS >> result;
	return result;
}

string UTIL_ToString( float f, int digits )
{
	string result;
	stringstream SS;
	SS << std :: fixed << std :: setprecision( digits ) << f;
	SS >> result;
	return result;
}

uint32_t UTIL_ToUInt32( string &s )
{
	uint32_t result;
	stringstream SS;
	SS << s;
	SS >> result;
	return result;
}

float UTIL_ToFloat( string &s )
{
	float result;
	stringstream SS;
	SS << s;
	SS >> result;
	return result;
}

int main( int argc, char **argv )
{
	string CFGFile = "update_dota_elo.cfg";

	if( argc > 1 && argv[1] )
		CFGFile = argv[1];

	CConfig CFG;
	CFG.Read( CFGFile );
	string Server = CFG.GetString( "db_mysql_server", string( ) );
	string Database = CFG.GetString( "db_mysql_database", "ghost" );
	string User = CFG.GetString( "db_mysql_user", string( ) );
	string Password = CFG.GetString( "db_mysql_password", string( ) );
	int Port = CFG.GetInt( "db_mysql_port", 0 );

	cout << "connecting to database server" << endl;
	MYSQL *Connection = NULL;

	if( !( Connection = mysql_init( NULL ) ) )
	{
		cout << "error: " << mysql_error( Connection ) << endl;
		return 1;
	}

	my_bool Reconnect = true;
	mysql_options( Connection, MYSQL_OPT_RECONNECT, &Reconnect );

	if( !( mysql_real_connect( Connection, Server.c_str( ), User.c_str( ), Password.c_str( ), Database.c_str( ), Port, NULL, 0 ) ) )
	{
		cout << "error: " << mysql_error( Connection ) << endl;
		return 1;
	}

	cout << "connected" << endl;
	cout << "beginning transaction" << endl;

	string QBegin = "BEGIN";

	if( mysql_real_query( Connection, QBegin.c_str( ), QBegin.size( ) ) != 0 )
	{
		cout << "error: " << mysql_error( Connection ) << endl;
		return 1;
	}

	cout << "getting unscored games" << endl;
	queue<uint32_t> UnscoredGames;

	string QSelectUnscored = "SELECT id FROM dvstats_games WHERE id NOT IN ( SELECT gameid FROM dvstats_dota_elo_games_scored ) ORDER BY id";

	if( mysql_real_query( Connection, QSelectUnscored.c_str( ), QSelectUnscored.size( ) ) != 0 )
	{
		cout << "error: " << mysql_error( Connection ) << endl;
		return 1;
	}
	else
	{
		MYSQL_RES *Result = mysql_store_result( Connection );

		if( Result )
		{
			vector<string> Row = MySQLFetchRow( Result );

			while( !Row.empty( ) )
			{
				UnscoredGames.push( UTIL_ToUInt32( Row[0] ) );
				Row = MySQLFetchRow( Result );
			}

			mysql_free_result( Result );
		}
		else
		{
			cout << "error: " << mysql_error( Connection ) << endl;
			return 1;
		}
	}

	cout << "found " << UnscoredGames.size( ) << " unscored games" << endl;

	while( !UnscoredGames.empty( ) )
	{
		uint32_t GameID = UnscoredGames.front( );
		UnscoredGames.pop( );

		string QSelectPlayers = "SELECT dota_elo_scores.id, gameplayers.name, spoofedrealm, newcolour, winner, score, dotaplayers.kills, dotaplayers.deaths, dotaplayers.assists, dotaplayers.creepkills, dotaplayers.creepdenies, dotaplayers.neutralkills, dotaplayers.towerkills, dotaplayers.raxkills, dotaplayers.courierkills FROM dvstats_dotaplayers dotaplayers LEFT JOIN dvstats_dotagames dotagames ON dotagames.gameid=dotaplayers.gameid LEFT JOIN dvstats_gameplayers gameplayers ON gameplayers.gameid=dotaplayers.gameid AND gameplayers.colour=dotaplayers.colour LEFT JOIN dvstats_dota_elo_scores dota_elo_scores ON dota_elo_scores.name=gameplayers.name WHERE dotaplayers.gameid=" + UTIL_ToString( GameID );

		if( mysql_real_query( Connection, QSelectPlayers.c_str( ), QSelectPlayers.size( ) ) != 0 )
		{
			cout << "error: " << mysql_error( Connection ) << endl;
			return 1;
		}
		else
		{
			MYSQL_RES *Result = mysql_store_result( Connection );

			if( Result )
			{
				cout << "gameid " << UTIL_ToString( GameID ) << " found" << endl;

				bool ignore = false;
				uint32_t rowids[10];
				string names[10];
				string servers[10];
				string kills[10];
                                string deaths[10];
                                string assists[10];
                                string creeps[10];
                                string denies[10];
                                string neutrals[10];
				string towers[10];
				string rax[10];
                                string couriers[10];
				bool exists[10];
				int num_players = 0;
				float player_ratings[10];
				int player_teams[10];
				int num_teams = 2;
				float team_ratings[2];
				float team_winners[2];
				int team_numplayers[2];
				team_ratings[0] = 0.0;
				team_ratings[1] = 0.0;
				team_numplayers[0] = 0;
				team_numplayers[1] = 0;
				uint32_t winners[10];
				uint32_t colours[10];

				vector<string> Row = MySQLFetchRow( Result );

				while( Row.size( ) == 15 )
				{
					if( num_players >= 10 )
					{
						cout << "gameid " << UTIL_ToString( GameID ) << " has more than 10 players, ignoring" << endl;
						ignore = true;

						string SelectQuery = "SELECT d.botid, g.map, g.datetime, g.gamename, g.duration, d.winner, d.min, d.sec, g.gamestate FROM games g LEFT JOIN dotagames d ON d.gameid = g.id WHERE g.id = " + UTIL_ToString( GameID );
                				if( mysql_real_query( Connection, SelectQuery.c_str( ), SelectQuery.size( ) ) != 0 )
                				{
                        				cout << "error: " << mysql_error( Connection ) << endl;
                        				return 1;
                				}
                				else
                				{
                        				MYSQL_RES *Result = mysql_store_result( Connection );

                        				if( Result )
                        				{
                                				vector<string> Row = MySQLFetchRow( Result );

                                				while( Row.size( ) == 9 )
                                				{
                                        				string InQ = "INSERT INTO dvstats_scoredgames VALUE (NULL, "+UTIL_ToString(GameID)+", "+Row[0]+", "+Row[1]+", "+Row[2]+", "+Row[3]+", "+Row[4]+", "+Row[5]+", "+Row[6]+", "+Row[7]+", "+Row[8]+")";
                                        				if( mysql_real_query( Connection, InQ.c_str( ), InQ.size( ) ) != 0 )
                                        				{
                                                				cout << "error: " << mysql_error( Connection ) << endl;
                                                				return 1;
                                        				}
                                				}
                        				}
                				}
						break;
					}

					uint32_t Winner = UTIL_ToUInt32( Row[4] );
					winners[num_players] = Winner;

					if( Winner != 1 && Winner != 2 )
					{
						cout << "gameid " << UTIL_ToString( GameID ) << " has no winner, ignoring" << endl;
						ignore = true;

                                                string SelectQuery = "SELECT d.botid, g.map, g.datetime, g.gamename, g.duration, d.winner, d.min, d.sec, g.gamestate FROM games g LEFT JOIN dotagames d ON d.gameid = g.id WHERE g.id = " + UTIL_ToString( GameID );
                                                if( mysql_real_query( Connection, SelectQuery.c_str( ), SelectQuery.size( ) ) != 0 )
                                                {
                                                        cout << "error: " << mysql_error( Connection ) << endl;
                                                        return 1;
                                                }
                                                else
                                                {
                                                        MYSQL_RES *Result = mysql_store_result( Connection );

                                                        if( Result )
                                                        {
                                                                vector<string> Row = MySQLFetchRow( Result );

                                                                while( Row.size( ) == 9 )
                                                                {
                                                                        string InQ = "INSERT INTO dvstats_scoredgames VALUE (NULL, "+UTIL_ToString(GameID)+", "+Row[0]+", "+Row[1]+", "+Row[2]+", "+Row[3]+", "+Row[4]+", "+Row[5]+", "+Row[6]+", "+Row[7]+", "+Row[8]+")";
                                                                        if( mysql_real_query( Connection, InQ.c_str( ), InQ.size( ) ) != 0 )
                                                                        {
                                                                                cout << "error: " << mysql_error( Connection ) << endl;
                                                                                return 1;
                                                                        }
                                                                }
                                                        }
                                                }
						break;
					}
					else if( Winner == 1 )
					{
						team_winners[0] = 1.0;
						team_winners[1] = 0.0;
					}
					else
					{
						team_winners[0] = 0.0;
						team_winners[1] = 1.0;
					}

					if( !Row[0].empty( ) )
						rowids[num_players] = UTIL_ToUInt32( Row[0] );
					else
						rowids[num_players] = 0;

					names[num_players] = Row[1];
					servers[num_players] = Row[2];
                                        kills[num_players] = Row[6];
                                        deaths[num_players] = Row[7];
                                        assists[num_players] = Row[8];
                                        creeps[num_players] = Row[9];
                                        denies[num_players] = Row[10];
                                        neutrals[num_players] = Row[11];
                                        towers[num_players] = Row[12];
                                        rax[num_players] = Row[13];
                                        couriers[num_players] = Row[14];


					if( !Row[5].empty( ) )
					{
						exists[num_players] = true;
						player_ratings[num_players] = UTIL_ToFloat( Row[5] );
					}
					else
					{
						cout << "new player [" << Row[1] << "] found" << endl;
						exists[num_players] = false;
						player_ratings[num_players] = 1000.0;
					}

					uint32_t Colour = UTIL_ToUInt32( Row[3] );
					colours[num_players] = Colour;

					if( Colour >= 1 && Colour <= 5 )
					{
						player_teams[num_players] = 0;
						team_ratings[0] += player_ratings[num_players];
						team_numplayers[0]++;
					}
					else if( Colour >= 7 && Colour <= 11 )
					{
						player_teams[num_players] = 1;
						team_ratings[1] += player_ratings[num_players];
						team_numplayers[1]++;
					}
					else
					{
						cout << "gameid " << UTIL_ToString( GameID ) << " has a player with an invalid newcolour, ignoring" << endl;
						ignore = true;
						break;
					}

					num_players++;
					Row = MySQLFetchRow( Result );
				}

				mysql_free_result( Result );

				if( !ignore )
				{
					if( num_players == 0 )
						cout << "gameid " << UTIL_ToString( GameID ) << " has no players, ignoring" << endl;
					else if( team_numplayers[0] == 0 )
						cout << "gameid " << UTIL_ToString( GameID ) << " has no Sentinel players, ignoring" << endl;
					else if( team_numplayers[1] == 0 )
						cout << "gameid " << UTIL_ToString( GameID ) << " has no Scourge players, ignoring" << endl;
					else
					{
						cout << "gameid " << UTIL_ToString( GameID ) << " is calculating" << endl;

						float old_player_ratings[10];
						memcpy( old_player_ratings, player_ratings, sizeof( float ) * 10 );
						team_ratings[0] /= team_numplayers[0];
						team_ratings[1] /= team_numplayers[1];
						elo_recalculate_ratings( num_players, player_ratings, player_teams, num_teams, team_ratings, team_winners );

						for( int i = 0; i < num_players; i++ )
						{
							if( exists[i] )
							{
								string streakString = "streak=streak+1, lossstreak=0, maxstreak=IF((streak+1)>maxstreak, (streak+1), maxstreak),";
								if((winners[i]==2&&colours[i]<7)||(winners[i]==1&&colours[i]>=7)) {
									streakString = "lossstreak=lossstreak+1, streak=0, maxlossstreak=IF((lossstreak+1)>maxlossstreak, (lossstreak+1), maxlossstreak),";
								}
								string serverString = "";
								if(servers[i].length() > 0) {
									serverString = "server='" + MySQLEscapeString( Connection, servers[i] ) + "'";
								}
								string QUpdateScore = "UPDATE dvstats_dota_elo_scores SET "+serverString+" "+streakString+" zerodeaths=zerodeaths+"+UTIL_ToString((deaths[i] == "0") ? 1 : 0)+", score=" + UTIL_ToString( player_ratings[i], 2 ) + ", games=games+1, wins=wins+"+ UTIL_ToString(((winners[i]==1&&colours[i]<7)||(winners[i]==2&&colours[i]>=7)) ? 1 : 0) +", losses=losses+" + UTIL_ToString(((winners[i]==2&&colours[i]<7)||(winners[i]==1&&colours[i]>=7)) ? 1 : 0) +", kills=kills+"+kills[i]+", deaths=deaths+"+deaths[i]+",creepkills=creepkills+"+creeps[i]+",creepdenies=creepdenies+"+denies[i]+",assists=assists+"+assists[i]+",neutralkills=neutralkills+"+neutrals[i]+",towerkills=towerkills+"+towers[i]+",raxkills=raxkills+"+rax[i]+",courierkills=courierkills+"+couriers[i]+" WHERE id=" + UTIL_ToString( rowids[i] );

								if( mysql_real_query( Connection, QUpdateScore.c_str( ), QUpdateScore.size( ) ) != 0 )
								{
									cout << "error: " << mysql_error( Connection ) << endl;
									return 1;
								}
							}
							else
							{
								string EscName = MySQLEscapeString( Connection, names[i] );
								string EscServer = MySQLEscapeString( Connection, servers[i] );
								string QInsertScore = "INSERT INTO dvstats_dota_elo_scores VALUES ( NULL, '" + EscName + "', '" + EscServer + "', " + UTIL_ToString( player_ratings[i], 2 ) + ", 1, " + UTIL_ToString(((winners[i]==1&&colours[i]<7)||(winners[i]==2&&colours[i]>=7)) ? 1 : 0) + "," + UTIL_ToString(((winners[i]==2&&colours[i]<7)||(winners[i]==1&&colours[i]>=7)) ? 1 : 0) +", "+kills[i]+", "+deaths[i]+","+creeps[i]+","+denies[i]+","+assists[i]+","+neutrals[i]+","+towers[i]+","+rax[i]+","+couriers[i]+", "+ UTIL_ToString(((winners[i]==1&&colours[i]<7)||(winners[i]==2&&colours[i]>=7)) ? 1 : 0) +", "+ UTIL_ToString(((winners[i]==1&&colours[i]<7)||(winners[i]==2&&colours[i]>=7)) ? 1 : 0) +", "+ UTIL_ToString(((winners[i]==2&&colours[i]<7)||(winners[i]==1&&colours[i]>=7)) ? 1 : 0) +", "+ UTIL_ToString(((winners[i]==2&&colours[i]<7)||(winners[i]==1&&colours[i]>=7)) ? 1 : 0) +", "+UTIL_ToString((deaths[0] == "0" ? 1 : 0))+")";

								if( mysql_real_query( Connection, QInsertScore.c_str( ), QInsertScore.size( ) ) != 0 )
								{
									cout << "error: " << mysql_error( Connection ) << endl;
									return 1;
								}
							}
						}
					}
				}				
			}
			else
			{
				cout << "error: " << mysql_error( Connection ) << endl;
				return 1;
			}
		}

		string QInsertScored = "INSERT INTO dvstats_dota_elo_games_scored ( gameid ) VALUES ( " + UTIL_ToString( GameID ) + " )";

		if( mysql_real_query( Connection, QInsertScored.c_str( ), QInsertScored.size( ) ) != 0 )
		{
			cout << "error: " << mysql_error( Connection ) << endl;
			return 1;
		}

		string SelectQuery = "SELECT d.botid, g.map, g.datetime, g.gamename, g.duration, d.winner, d.min, d.sec, g.gamestate FROM games g LEFT JOIN dotagames d ON d.gameid = g.id WHERE g.id = " + UTIL_ToString( GameID );
		if( mysql_real_query( Connection, SelectQuery.c_str( ), SelectQuery.size( ) ) != 0 )
                {
                        cout << "error: " << mysql_error( Connection ) << endl;
                        return 1;
                }
		else
		{
                        MYSQL_RES *Result = mysql_store_result( Connection );

                        if( Result )
                        {
                                vector<string> Row = MySQLFetchRow( Result );

                                while( Row.size( ) == 9 )
                                {
					string InQ = "INSERT INTO dvstats_scoredgames VALUE (NULL, "+UTIL_ToString(GameID)+", "+Row[0]+", "+Row[1]+", "+Row[2]+", "+Row[3]+", "+Row[4]+", "+Row[5]+", "+Row[6]+", "+Row[7]+", "+Row[8]+")";
					if( mysql_real_query( Connection, InQ.c_str( ), InQ.size( ) ) != 0 )
			                {
                        			cout << "error: " << mysql_error( Connection ) << endl;
                        			return 1;
                			}
				}
			}
		}
	}

	cout << "committing transaction" << endl;

	string QCommit = "COMMIT";

	if( mysql_real_query( Connection, QCommit.c_str( ), QCommit.size( ) ) != 0 )
	{
		cout << "error: " << mysql_error( Connection ) << endl;
		return 1;
	}

	cout << "done" << endl;
	return 0;
}
