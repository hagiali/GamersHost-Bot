<?php
# gametrack collects information based on the latest games
# specifically, for every player (name-realm combination), it maintains:
#  * the last ten bots that the player was seen in
#  * the last ten games that the player was seen in
#  * averagy stay percentage
#  * total number of games
#  * time user was first seen
#  * time user was last seen
# the bots and games are based on games.botid and games.id respectively
#  additionally, they are both stored as comma-delimited strings
#  to retrieve an array of ID integers, use explode(',', $str)
# it is recommended to set this up as a cronjob every five minutes:
#    */5 * * * * cd /path/to/gametrack/ && php gametrack.php > /dev/null
# BEGIN CONFIGURATION
$db_name = "ghost";
$db_host = "localhost";
$db_username = "user";
$db_password = "pass";
# END CONFIGURATION
function escape($str) {
	return mysql_real_escape_string($str);
}
echo "Connecting to database\n";
mysql_connect($db_host, $db_username, $db_password);
mysql_select_db($db_name);
	mysql_query("UPDATE bans SET context = 'ttr.cloud' WHERE context = '' OR context IS NULL");
	
	# add unrecorded bans to the ban history, but only 1000 at a time
	$result = mysql_query("SELECT id, server, name, ip, date, gamename, admin, reason, expiredate, botid FROM stats_bans WHERE id > ( SELECT IFNULL(MAX(banid), 0) FROM ban_history ) AND context = 'ttr.cloud' ORDER BY id LIMIT 1000");

	while($result && $row = $result->fetch_array()) {
		$id = escape($link, $row[0]);
		$server = escape($link, $row[1]);
		$name = escape($link, $row[2]);
		$ip = escape($link, $row[3]);
		$date = escape($link, $row[4]);
		$gamename = escape($link, $row[5]);
		$admin = escape($link, $row[6]);
		$reason = escape($link, $row[7]);
		$expiredate = escape($link, $row[8]);
		$botid = escape($link, $row[9]);
		

		
		# insert into history table
		# mysql_query("INSERT INTO stats_banhistory ( banid, server, name, ip, date, gamename, admin, reason, expiredate ) VALUES ('$id', '$server', '$name', '$ip', '$date', '$gamename', '$admin', '$reason', '$expiredate')");
		
		# put banid in ban cache so that bots can update to it
		#mysql_query("INSERT INTO bancache (banid, datetime, status) VALUES ('$id', NOW(), 0)"); # 0 means new ban, 1 means del ban
	}

	# update cache to reflect deleted bans
	# $result = mysql_query("UPDATE bancache SET status = '1', datetime = NOW() WHERE status = '0' AND (SELECT COUNT(*) FROM stats_bans WHERE bans.id = banid) = 0");
echo "...................\n";	
echo "Delete expired bans\n";
mysql_query("DELETE FROM stats_bans WHERE expiredate <= CURRENT_TIMESTAMP() AND expiredate != '' AND expiredate!='0000-00-00 00:00:00'");

	
	
	
# create table if not already there
#echo "Creating table if not exists\n";


	
	
	
# mysql_query("CREATE TABLE IF NOT EXISTS gametrack (name VARCHAR(15), realm VARCHAR(100), bots VARCHAR(40), lastgames VARCHAR(100), total_leftpercent DOUBLE, num_leftpercent INT, num_games INT, time_created DATETIME, time_active DATETIME, KEY name (name), KEY realm (realm))") or die(mysql_error());
# read the next player from file




echo "Detecting next player\n";
$next_player = 1;
$filename = "next_player.txt";
if(file_exists($filename) && is_readable($filename)) {
	$fh = fopen($filename, 'r');
	$next_player = intval(trim(fgets($fh)));
	fclose($fh);
}
echo "Detected next player: $next_player\n";
# get the next 5000 players
echo "Reading next 5000 players\n";
$result = mysql_query("SELECT stats_gameplayers.botid, name, spoofedrealm, gameid, stats_gameplayers.id, (`left`/duration) FROM stats_gameplayers LEFT JOIN stats_games ON stats_games.id = gameid WHERE stats_gameplayers.id >= '$next_player' ORDER BY stats_gameplayers.id LIMIT 5000") or die(mysql_error());
echo "Got " . mysql_num_rows($result) . " players\n";
while($row = mysql_fetch_array($result)) {
	$botid = intval($row[0]);
	$name = escape($row[1]);
	$realm = escape($row[2]);
	$gameid = escape($row[3]);
	$leftpercent = escape($row[5]);
	
	# see if this player already has an entry, and retrieve if there is
	$checkResult = mysql_query("SELECT bots, lastgames FROM gametrack WHERE name = '$name' AND realm = '$realm'") or die(mysql_error());
	
	if($checkRow = mysql_fetch_array($checkResult)) {
		# update bots and lastgames shifting-window arrays
		$bots = explode(',', $checkRow[0]);
		$lastgames = explode(',', $checkRow[1]);
		
		if(in_array($botid, $bots)) {
			$bots = array_diff($bots, array($botid));
		}
		
		$bots[] = $botid;
		$lastgames[] = $gameid;
		
		if(count($bots) > 10) {
			array_shift($bots);
		}
		
		if(count($lastgames) > 10) {
			array_shift($lastgames);
		}
		
		$botString = escape(implode(',', $bots));
		$lastString = escape(implode(',', $lastgames));
		mysql_query("UPDATE gametrack SET bots = '$botString', lastgames = '$lastString', total_leftpercent = total_leftpercent + '$leftpercent', num_leftpercent = num_leftpercent + 1, num_games = num_games + 1, time_active = NOW() WHERE name = '$name' AND realm = '$realm'") or die(mysql_error());
	} else {
		$botString = escape($botid);
		$lastString = escape($gameid);
		mysql_query("INSERT INTO gametrack (name, realm, bots, lastgames, total_leftpercent, num_leftpercent, num_games, time_created, time_active) VALUES ('$name', '$realm', '$botString', '$lastString', '$leftpercent', '1', '1', NOW(), NOW())") or die(mysql_error());
	}
	
	$next_player = $row[4] + 1;
}
$fh = fopen($filename, 'w');
fwrite($fh, $next_player . "\n");
?>
