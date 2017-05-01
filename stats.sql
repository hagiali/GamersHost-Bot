-- phpMyAdmin SQL Dump
-- version 4.6.4deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 01. Mai 2017 um 10:26
-- Server-Version: 5.7.17-0ubuntu0.16.10.1
-- PHP-Version: 7.0.13-0ubuntu0.16.10.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `stats`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `admin_actions`
--

CREATE TABLE `admin_actions` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `gametrack`
--

CREATE TABLE `gametrack` (
  `name` varchar(15) DEFAULT NULL,
  `realm` varchar(100) DEFAULT NULL,
  `bots` varchar(40) DEFAULT NULL,
  `lastgames` varchar(100) DEFAULT NULL,
  `total_leftpercent` double DEFAULT NULL,
  `num_leftpercent` int(11) DEFAULT NULL,
  `num_games` int(11) DEFAULT NULL,
  `time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_active` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `playingtime` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `league_games`
--

CREATE TABLE `league_games` (
  `id` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `p1` float NOT NULL,
  `p2` float NOT NULL,
  `p3` float NOT NULL,
  `p4` float NOT NULL,
  `p5` float NOT NULL,
  `p6` float NOT NULL,
  `p7` float NOT NULL,
  `p8` float NOT NULL,
  `p9` float NOT NULL,
  `p10` float NOT NULL,
  `sentWin` float NOT NULL,
  `scouWin` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `league_players`
--

CREATE TABLE `league_players` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `server` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` double NOT NULL DEFAULT '1000',
  `g` int(11) NOT NULL DEFAULT '0',
  `d` int(11) NOT NULL DEFAULT '0',
  `a` int(11) NOT NULL DEFAULT '0',
  `k` int(11) NOT NULL DEFAULT '0',
  `w` int(11) NOT NULL DEFAULT '0',
  `l` int(11) NOT NULL DEFAULT '0',
  `ck` int(11) NOT NULL DEFAULT '0',
  `cd` int(11) NOT NULL DEFAULT '0',
  `nk` int(11) NOT NULL DEFAULT '0',
  `tk` int(11) NOT NULL DEFAULT '0',
  `rk` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_admins`
--

CREATE TABLE `stats_admins` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_appeals`
--

CREATE TABLE `stats_appeals` (
  `id` int(11) NOT NULL,
  `ban_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `comment` longtext NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reply` longtext,
  `admin_member_id` int(11) DEFAULT NULL,
  `replied` datetime DEFAULT NULL,
  `identifier` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_banhistory`
--

CREATE TABLE `stats_banhistory` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `botid` int(11) NOT NULL DEFAULT '0',
  `admin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiredate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `context` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `warn` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_bans`
--

CREATE TABLE `stats_bans` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gamename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiredate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `warn` int(11) NOT NULL DEFAULT '0',
  `processed` int(11) NOT NULL DEFAULT '0',
  `targetbot` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_commands`
--

CREATE TABLE `stats_commands` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `command` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dotagames`
--

CREATE TABLE `stats_dotagames` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `winner` tinyint(4) NOT NULL DEFAULT '0',
  `min` int(11) NOT NULL DEFAULT '0',
  `sec` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dotagames_solomm`
--

CREATE TABLE `stats_dotagames_solomm` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `winner` tinyint(4) NOT NULL DEFAULT '0',
  `min` int(11) NOT NULL DEFAULT '0',
  `sec` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dotaplayers`
--

CREATE TABLE `stats_dotaplayers` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `colour` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `creepkills` int(11) NOT NULL DEFAULT '0',
  `creepdenies` int(11) NOT NULL DEFAULT '0',
  `assists` int(11) NOT NULL DEFAULT '0',
  `gold` int(11) NOT NULL DEFAULT '0',
  `neutralkills` int(11) NOT NULL DEFAULT '0',
  `item1` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item2` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item3` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item4` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item5` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item6` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hero` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `newcolour` int(11) NOT NULL DEFAULT '0',
  `towerkills` int(11) NOT NULL DEFAULT '0',
  `raxkills` int(11) NOT NULL DEFAULT '0',
  `courierkills` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `suicides` int(11) NOT NULL DEFAULT '0',
  `2k` int(11) NOT NULL DEFAULT '0',
  `3k` int(11) NOT NULL DEFAULT '0',
  `4k` int(11) NOT NULL DEFAULT '0',
  `5k` int(11) NOT NULL DEFAULT '0',
  `fb` bit(1) NOT NULL DEFAULT b'0',
  `fd` bit(1) NOT NULL DEFAULT b'0',
  `ks` int(11) NOT NULL DEFAULT '0',
  `d` int(11) NOT NULL DEFAULT '0',
  `mk` int(11) NOT NULL DEFAULT '0',
  `u` int(11) NOT NULL DEFAULT '0',
  `ws` int(11) NOT NULL DEFAULT '0',
  `mok` int(11) NOT NULL DEFAULT '0',
  `g` int(11) NOT NULL DEFAULT '0',
  `bg` int(11) NOT NULL DEFAULT '0',
  `ms` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dotaplayers_solomm`
--

CREATE TABLE `stats_dotaplayers_solomm` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `colour` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `creepkills` int(11) NOT NULL DEFAULT '0',
  `creepdenies` int(11) NOT NULL DEFAULT '0',
  `assists` int(11) NOT NULL DEFAULT '0',
  `gold` int(11) NOT NULL DEFAULT '0',
  `neutralkills` int(11) NOT NULL DEFAULT '0',
  `item1` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item2` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item3` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item4` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item5` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `item6` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `hero` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `newcolour` int(11) NOT NULL DEFAULT '0',
  `towerkills` int(11) NOT NULL DEFAULT '0',
  `raxkills` int(11) NOT NULL DEFAULT '0',
  `courierkills` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  `suicides` int(11) NOT NULL DEFAULT '0',
  `2k` int(11) NOT NULL DEFAULT '0',
  `3k` int(11) NOT NULL DEFAULT '0',
  `4k` int(11) NOT NULL DEFAULT '0',
  `5k` int(11) NOT NULL DEFAULT '0',
  `fb` bit(1) NOT NULL DEFAULT b'0',
  `fd` bit(1) NOT NULL DEFAULT b'0',
  `ks` int(11) NOT NULL DEFAULT '0',
  `d` int(11) NOT NULL DEFAULT '0',
  `mk` int(11) NOT NULL DEFAULT '0',
  `u` int(11) NOT NULL DEFAULT '0',
  `ws` int(11) NOT NULL DEFAULT '0',
  `mok` int(11) NOT NULL DEFAULT '0',
  `g` int(11) NOT NULL DEFAULT '0',
  `bg` int(11) NOT NULL DEFAULT '0',
  `ms` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dota_elo_games_scored`
--

CREATE TABLE `stats_dota_elo_games_scored` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `gameid` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dota_elo_scores`
--

CREATE TABLE `stats_dota_elo_scores` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `score` decimal(10,0) NOT NULL DEFAULT '0',
  `games` int(11) NOT NULL DEFAULT '0',
  `wins` int(11) NOT NULL DEFAULT '0',
  `losses` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `creepkills` int(11) NOT NULL DEFAULT '0',
  `creepdenies` int(11) NOT NULL DEFAULT '0',
  `assists` int(11) NOT NULL DEFAULT '0',
  `neutralkills` int(11) NOT NULL DEFAULT '0',
  `towerkills` int(11) NOT NULL DEFAULT '0',
  `raxkills` int(11) NOT NULL DEFAULT '0',
  `courierkills` int(11) NOT NULL DEFAULT '0',
  `streak` int(11) NOT NULL DEFAULT '0',
  `maxstreak` int(11) NOT NULL DEFAULT '0',
  `lossstreak` int(11) NOT NULL DEFAULT '0',
  `maxlossstreak` int(11) NOT NULL DEFAULT '0',
  `zerodeaths` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_dota_elo_scores_solomm`
--

CREATE TABLE `stats_dota_elo_scores_solomm` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `score` decimal(10,0) NOT NULL DEFAULT '0',
  `games` int(11) NOT NULL DEFAULT '0',
  `wins` int(11) NOT NULL DEFAULT '0',
  `losses` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `deaths` int(11) NOT NULL DEFAULT '0',
  `creepkills` int(11) NOT NULL DEFAULT '0',
  `creepdenies` int(11) NOT NULL DEFAULT '0',
  `assists` int(11) NOT NULL DEFAULT '0',
  `neutralkills` int(11) NOT NULL DEFAULT '0',
  `towerkills` int(11) NOT NULL DEFAULT '0',
  `raxkills` int(11) NOT NULL DEFAULT '0',
  `courierkills` int(11) NOT NULL DEFAULT '0',
  `streak` int(11) NOT NULL DEFAULT '0',
  `maxstreak` int(11) NOT NULL DEFAULT '0',
  `lossstreak` int(11) NOT NULL DEFAULT '0',
  `maxlossstreak` int(11) NOT NULL DEFAULT '0',
  `zerodeaths` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_forum_connections`
--

CREATE TABLE `stats_forum_connections` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `name` varchar(15) NOT NULL,
  `server` varchar(255) NOT NULL,
  `token` varchar(10) NOT NULL,
  `created` datetime NOT NULL,
  `changed` datetime DEFAULT NULL,
  `status` varchar(25) NOT NULL,
  `active` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_gamelist`
--

CREATE TABLE `stats_gamelist` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gamename` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ownername` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creatorname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `map` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slotstaken` int(11) NOT NULL DEFAULT '0',
  `slotstotal` int(11) NOT NULL DEFAULT '0',
  `usernames` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `totalgames` tinyint(4) NOT NULL DEFAULT '0',
  `totalplayers` int(11) NOT NULL DEFAULT '0',
  `eventtime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `age` datetime DEFAULT NULL,
  `lobby` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_gameplayers`
--

CREATE TABLE `stats_gameplayers` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `spoofed` int(11) NOT NULL DEFAULT '0',
  `reserved` int(11) NOT NULL DEFAULT '0',
  `loadingtime` int(11) NOT NULL DEFAULT '0',
  `left` int(11) NOT NULL DEFAULT '0',
  `leftreason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `team` int(11) NOT NULL DEFAULT '0',
  `colour` int(11) NOT NULL DEFAULT '0',
  `spoofedrealm` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_games`
--

CREATE TABLE `stats_games` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `server` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `map` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gamename` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ownername` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `duration` int(11) NOT NULL DEFAULT '0',
  `gamestate` int(11) NOT NULL DEFAULT '0',
  `creatorname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creatorserver` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `stats` tinyint(1) DEFAULT '0',
  `views` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_game_chatevents`
--

CREATE TABLE `stats_game_chatevents` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  `playercolour` int(11) NOT NULL DEFAULT '0',
  `playername` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `chatmessage` text COLLATE utf8mb4_unicode_ci,
  `side` tinyint(4) NOT NULL DEFAULT '0',
  `lobby` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_game_events`
--

CREATE TABLE `stats_game_events` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `event` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT '0',
  `player1_colour` int(11) NOT NULL DEFAULT '0',
  `player2_colour` int(11) NOT NULL DEFAULT '0',
  `additional1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional3` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional4` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_items`
--

CREATE TABLE `stats_items` (
  `itemid` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `playcount` int(11) DEFAULT '0',
  `code` smallint(10) NOT NULL DEFAULT '0',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shortname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_info` mediumblob,
  `price` smallint(6) NOT NULL DEFAULT '0',
  `type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_reports`
--

CREATE TABLE `stats_reports` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `reason` varchar(35) NOT NULL,
  `description` longtext NOT NULL,
  `created` datetime NOT NULL,
  `status` varchar(25) NOT NULL DEFAULT 'pending',
  `assigned_member` int(11) DEFAULT NULL,
  `last_reply` datetime DEFAULT NULL,
  `solved_date` datetime DEFAULT NULL,
  `identifier` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_report_comments`
--

CREATE TABLE `stats_report_comments` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `comment` longtext NOT NULL,
  `created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_scoredgames`
--

CREATE TABLE `stats_scoredgames` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `map` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `gamename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `duration` bigint(20) NOT NULL DEFAULT '0',
  `winner` tinyint(4) NOT NULL DEFAULT '0',
  `min` int(11) NOT NULL,
  `sec` int(11) NOT NULL DEFAULT '0',
  `gamestate` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_scored_dota`
--

CREATE TABLE `stats_scored_dota` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL,
  `server` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `score` double NOT NULL DEFAULT '1000',
  `rank` int(11) NOT NULL DEFAULT '0',
  `g` int(11) NOT NULL DEFAULT '0',
  `d` int(11) NOT NULL DEFAULT '0',
  `a` int(11) NOT NULL DEFAULT '0',
  `k` int(11) NOT NULL DEFAULT '0',
  `w` int(11) NOT NULL DEFAULT '0',
  `l` int(11) NOT NULL DEFAULT '0',
  `ck` int(11) NOT NULL DEFAULT '0',
  `cd` int(11) NOT NULL DEFAULT '0',
  `nk` int(11) NOT NULL DEFAULT '0',
  `tk` int(11) NOT NULL DEFAULT '0',
  `rk` int(11) NOT NULL DEFAULT '0',
  `cok` int(11) NOT NULL DEFAULT '0',
  `zk` int(11) NOT NULL DEFAULT '0',
  `fb` int(11) NOT NULL DEFAULT '0',
  `fd` int(11) NOT NULL DEFAULT '0',
  `r` int(11) NOT NULL DEFAULT '0',
  `2k` int(11) NOT NULL DEFAULT '0',
  `3k` int(11) NOT NULL DEFAULT '0',
  `4k` int(11) NOT NULL DEFAULT '0',
  `5k` int(11) NOT NULL DEFAULT '0',
  `lev` int(11) NOT NULL DEFAULT '0',
  `p` int(11) NOT NULL DEFAULT '0',
  `s` int(11) NOT NULL DEFAULT '0',
  `cs` int(11) NOT NULL DEFAULT '0',
  `ws` int(11) NOT NULL DEFAULT '0',
  `tws` int(11) NOT NULL DEFAULT '0',
  `ls` int(11) NOT NULL DEFAULT '0',
  `tls` int(11) NOT NULL DEFAULT '0',
  `go` int(11) NOT NULL DEFAULT '0',
  `h` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `h1` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `h2` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `i` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `i1` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `i2` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ft` tinyint(4) NOT NULL DEFAULT '-1',
  `fc` tinyint(4) NOT NULL DEFAULT '-1',
  `lt` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_scored_games`
--

CREATE TABLE `stats_scored_games` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `gameid` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_scored_players`
--

CREATE TABLE `stats_scored_players` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `teammmid` bigint(20) DEFAULT NULL,
  `solomm` bigint(20) DEFAULT NULL,
  `forum_member_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_spoof`
--

CREATE TABLE `stats_spoof` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `spoof` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_w3mmdplayers`
--

CREATE TABLE `stats_w3mmdplayers` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` int(11) NOT NULL DEFAULT '0',
  `category` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `name` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `flag` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `leaver` int(11) NOT NULL DEFAULT '0',
  `practicing` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_w3mmdvars`
--

CREATE TABLE `stats_w3mmdvars` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` int(11) NOT NULL DEFAULT '0',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `varname` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value_int` int(11) DEFAULT NULL,
  `value_real` decimal(10,2) DEFAULT NULL,
  `value_string` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_w3mmd_elo_games_scored`
--

CREATE TABLE `stats_w3mmd_elo_games_scored` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `gameid` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_w3mmd_elo_scores`
--

CREATE TABLE `stats_w3mmd_elo_scores` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `category` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `score` decimal(10,2) NOT NULL DEFAULT '0.00',
  `games` int(11) NOT NULL DEFAULT '0',
  `wins` int(11) NOT NULL DEFAULT '0',
  `losses` int(11) NOT NULL DEFAULT '0',
  `intstats0` int(11) NOT NULL DEFAULT '0',
  `intstats1` int(11) NOT NULL DEFAULT '0',
  `intstats2` int(11) NOT NULL DEFAULT '0',
  `intstats3` int(11) NOT NULL DEFAULT '0',
  `intstats4` int(11) NOT NULL DEFAULT '0',
  `intstats5` int(11) NOT NULL DEFAULT '0',
  `intstats6` int(11) NOT NULL DEFAULT '0',
  `intstats7` int(11) NOT NULL DEFAULT '0',
  `doublestats0` decimal(10,2) NOT NULL DEFAULT '0.00',
  `doublestats1` decimal(10,2) NOT NULL DEFAULT '0.00',
  `doublestats2` decimal(10,2) NOT NULL DEFAULT '0.00',
  `doublestats3` decimal(10,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_whitelist`
--

CREATE TABLE `stats_whitelist` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `admin_actions`
--
ALTER TABLE `admin_actions`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `gametrack`
--
ALTER TABLE `gametrack`
  ADD KEY `name` (`name`),
  ADD KEY `realm` (`realm`);

--
-- Indizes für die Tabelle `league_games`
--
ALTER TABLE `league_games`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `league_players`
--
ALTER TABLE `league_players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `server` (`server`);

--
-- Indizes für die Tabelle `stats_admins`
--
ALTER TABLE `stats_admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `botid` (`botid`,`name`,`server`);

--
-- Indizes für die Tabelle `stats_appeals`
--
ALTER TABLE `stats_appeals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ban_id` (`ban_id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `admin_member_id` (`admin_member_id`);

--
-- Indizes für die Tabelle `stats_banhistory`
--
ALTER TABLE `stats_banhistory`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_bans`
--
ALTER TABLE `stats_bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `ip` (`ip`),
  ADD KEY `srv` (`server`),
  ADD KEY `name_2` (`name`,`server`,`ip`);

--
-- Indizes für die Tabelle `stats_commands`
--
ALTER TABLE `stats_commands`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_dotagames`
--
ALTER TABLE `stats_dotagames`
  ADD PRIMARY KEY (`id`),
  ADD KEY `def` (`gameid`);

--
-- Indizes für die Tabelle `stats_dotagames_solomm`
--
ALTER TABLE `stats_dotagames_solomm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `def` (`gameid`);

--
-- Indizes für die Tabelle `stats_dotaplayers`
--
ALTER TABLE `stats_dotaplayers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dp_newcolour` (`newcolour`),
  ADD KEY `dp_gameid` (`gameid`),
  ADD KEY `gp_select` (`newcolour`,`gameid`);

--
-- Indizes für die Tabelle `stats_dotaplayers_solomm`
--
ALTER TABLE `stats_dotaplayers_solomm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dp_newcolour` (`newcolour`),
  ADD KEY `dp_gameid` (`gameid`),
  ADD KEY `gp_select` (`newcolour`,`gameid`);

--
-- Indizes für die Tabelle `stats_dota_elo_games_scored`
--
ALTER TABLE `stats_dota_elo_games_scored`
  ADD PRIMARY KEY (`id`),
  ADD KEY `def` (`gameid`);

--
-- Indizes für die Tabelle `stats_dota_elo_scores`
--
ALTER TABLE `stats_dota_elo_scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `def` (`name`(191));

--
-- Indizes für die Tabelle `stats_dota_elo_scores_solomm`
--
ALTER TABLE `stats_dota_elo_scores_solomm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `def` (`name`(191));

--
-- Indizes für die Tabelle `stats_forum_connections`
--
ALTER TABLE `stats_forum_connections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`,`server`);

--
-- Indizes für die Tabelle `stats_gamelist`
--
ALTER TABLE `stats_gamelist`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_gameplayers`
--
ALTER TABLE `stats_gameplayers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`(191)),
  ADD KEY `gp_gameid` (`gameid`),
  ADD KEY `gp_name_game` (`name`(171),`gameid`),
  ADD KEY `ip` (`ip`),
  ADD KEY `ip_name` (`ip`,`name`);

--
-- Indizes für die Tabelle `stats_games`
--
ALTER TABLE `stats_games`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_game_chatevents`
--
ALTER TABLE `stats_game_chatevents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gamid` (`gameid`);

--
-- Indizes für die Tabelle `stats_game_events`
--
ALTER TABLE `stats_game_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gameid` (`gameid`);

--
-- Indizes für die Tabelle `stats_items`
--
ALTER TABLE `stats_items`
  ADD PRIMARY KEY (`itemid`);

--
-- Indizes für die Tabelle `stats_reports`
--
ALTER TABLE `stats_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_report_comments`
--
ALTER TABLE `stats_report_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_id` (`report_id`);

--
-- Indizes für die Tabelle `stats_scoredgames`
--
ALTER TABLE `stats_scoredgames`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_scored_dota`
--
ALTER TABLE `stats_scored_dota`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `server` (`server`);

--
-- Indizes für die Tabelle `stats_scored_games`
--
ALTER TABLE `stats_scored_games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `def` (`gameid`);

--
-- Indizes für die Tabelle `stats_scored_players`
--
ALTER TABLE `stats_scored_players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stats_name` (`name`(191)),
  ADD KEY `team` (`teammmid`);

--
-- Indizes für die Tabelle `stats_spoof`
--
ALTER TABLE `stats_spoof`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_w3mmdplayers`
--
ALTER TABLE `stats_w3mmdplayers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`),
  ADD KEY `gameid` (`gameid`);

--
-- Indizes für die Tabelle `stats_w3mmdvars`
--
ALTER TABLE `stats_w3mmdvars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gameid` (`gameid`),
  ADD KEY `select` (`gameid`,`pid`);

--
-- Indizes für die Tabelle `stats_w3mmd_elo_games_scored`
--
ALTER TABLE `stats_w3mmd_elo_games_scored`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_w3mmd_elo_scores`
--
ALTER TABLE `stats_w3mmd_elo_scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `category` (`category`);

--
-- Indizes für die Tabelle `stats_whitelist`
--
ALTER TABLE `stats_whitelist`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `admin_actions`
--
ALTER TABLE `admin_actions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=139;
--
-- AUTO_INCREMENT für Tabelle `league_games`
--
ALTER TABLE `league_games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;
--
-- AUTO_INCREMENT für Tabelle `league_players`
--
ALTER TABLE `league_players`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=502;
--
-- AUTO_INCREMENT für Tabelle `stats_admins`
--
ALTER TABLE `stats_admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT für Tabelle `stats_appeals`
--
ALTER TABLE `stats_appeals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;
--
-- AUTO_INCREMENT für Tabelle `stats_banhistory`
--
ALTER TABLE `stats_banhistory`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=23560;
--
-- AUTO_INCREMENT für Tabelle `stats_bans`
--
ALTER TABLE `stats_bans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=23567;
--
-- AUTO_INCREMENT für Tabelle `stats_commands`
--
ALTER TABLE `stats_commands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT für Tabelle `stats_dotagames`
--
ALTER TABLE `stats_dotagames`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=25036;
--
-- AUTO_INCREMENT für Tabelle `stats_dotagames_solomm`
--
ALTER TABLE `stats_dotagames_solomm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT für Tabelle `stats_dotaplayers`
--
ALTER TABLE `stats_dotaplayers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=249581;
--
-- AUTO_INCREMENT für Tabelle `stats_dotaplayers_solomm`
--
ALTER TABLE `stats_dotaplayers_solomm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT für Tabelle `stats_dota_elo_games_scored`
--
ALTER TABLE `stats_dota_elo_games_scored`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=25036;
--
-- AUTO_INCREMENT für Tabelle `stats_dota_elo_scores`
--
ALTER TABLE `stats_dota_elo_scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=15469;
--
-- AUTO_INCREMENT für Tabelle `stats_dota_elo_scores_solomm`
--
ALTER TABLE `stats_dota_elo_scores_solomm`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
--
-- AUTO_INCREMENT für Tabelle `stats_forum_connections`
--
ALTER TABLE `stats_forum_connections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=274;
--
-- AUTO_INCREMENT für Tabelle `stats_gamelist`
--
ALTER TABLE `stats_gamelist`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=6000;
--
-- AUTO_INCREMENT für Tabelle `stats_gameplayers`
--
ALTER TABLE `stats_gameplayers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=277043;
--
-- AUTO_INCREMENT für Tabelle `stats_games`
--
ALTER TABLE `stats_games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=31306;
--
-- AUTO_INCREMENT für Tabelle `stats_game_chatevents`
--
ALTER TABLE `stats_game_chatevents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=8756273;
--
-- AUTO_INCREMENT für Tabelle `stats_game_events`
--
ALTER TABLE `stats_game_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=2131779;
--
-- AUTO_INCREMENT für Tabelle `stats_reports`
--
ALTER TABLE `stats_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=311;
--
-- AUTO_INCREMENT für Tabelle `stats_report_comments`
--
ALTER TABLE `stats_report_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=521;
--
-- AUTO_INCREMENT für Tabelle `stats_scoredgames`
--
ALTER TABLE `stats_scoredgames`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=25565;
--
-- AUTO_INCREMENT für Tabelle `stats_scored_dota`
--
ALTER TABLE `stats_scored_dota`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=16234;
--
-- AUTO_INCREMENT für Tabelle `stats_scored_games`
--
ALTER TABLE `stats_scored_games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=25680;
--
-- AUTO_INCREMENT für Tabelle `stats_scored_players`
--
ALTER TABLE `stats_scored_players`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
--
-- AUTO_INCREMENT für Tabelle `stats_spoof`
--
ALTER TABLE `stats_spoof`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT für Tabelle `stats_w3mmdplayers`
--
ALTER TABLE `stats_w3mmdplayers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=15371;
--
-- AUTO_INCREMENT für Tabelle `stats_w3mmdvars`
--
ALTER TABLE `stats_w3mmdvars`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=29499;
--
-- AUTO_INCREMENT für Tabelle `stats_w3mmd_elo_games_scored`
--
ALTER TABLE `stats_w3mmd_elo_games_scored`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
--
-- AUTO_INCREMENT für Tabelle `stats_w3mmd_elo_scores`
--
ALTER TABLE `stats_w3mmd_elo_scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
--
-- AUTO_INCREMENT für Tabelle `stats_whitelist`
--
ALTER TABLE `stats_whitelist`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=5;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
