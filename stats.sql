-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 23, 2017 at 05:23 PM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ghost`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_actions`
--

CREATE TABLE IF NOT EXISTS `admin_actions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `desc` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `dota2games`
--

CREATE TABLE IF NOT EXISTS `dota2games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `winner` int(11) NOT NULL,
  `min` int(11) NOT NULL,
  `sec` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`),
  KEY `winner` (`winner`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `dota2players`
--

CREATE TABLE IF NOT EXISTS `dota2players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `colour` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `creepkills` int(11) NOT NULL,
  `creepdenies` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `gold` int(11) NOT NULL,
  `neutralkills` int(11) NOT NULL,
  `item1` char(4) NOT NULL,
  `item2` char(4) NOT NULL,
  `item3` char(4) NOT NULL,
  `item4` char(4) NOT NULL,
  `item5` char(4) NOT NULL,
  `item6` char(4) NOT NULL,
  `hero` char(4) NOT NULL,
  `newcolour` int(11) NOT NULL,
  `towerkills` int(11) NOT NULL,
  `raxkills` int(11) NOT NULL,
  `courierkills` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`,`colour`),
  KEY `colour` (`colour`),
  KEY `newcolour` (`newcolour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `dota2_elo_games_scored`
--

CREATE TABLE IF NOT EXISTS `dota2_elo_games_scored` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `dota2_elo_scores`
--

CREATE TABLE IF NOT EXISTS `dota2_elo_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(15) NOT NULL,
  `server` varchar(100) NOT NULL,
  `score` double NOT NULL,
  `games` int(11) NOT NULL,
  `wins` int(11) NOT NULL,
  `losses` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `creepkills` int(11) NOT NULL,
  `creepdenies` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `neutralkills` int(11) NOT NULL,
  `towerkills` int(11) NOT NULL,
  `raxkills` int(11) NOT NULL,
  `courierkills` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `eihlgames`
--

CREATE TABLE IF NOT EXISTS `eihlgames` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `winner` int(11) NOT NULL,
  `min` int(11) NOT NULL,
  `sec` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`),
  KEY `winner` (`winner`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `eihlplayers`
--

CREATE TABLE IF NOT EXISTS `eihlplayers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `colour` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `creepkills` int(11) NOT NULL,
  `creepdenies` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `gold` int(11) NOT NULL,
  `neutralkills` int(11) NOT NULL,
  `item1` char(4) NOT NULL,
  `item2` char(4) NOT NULL,
  `item3` char(4) NOT NULL,
  `item4` char(4) NOT NULL,
  `item5` char(4) NOT NULL,
  `item6` char(4) NOT NULL,
  `hero` char(4) NOT NULL,
  `newcolour` int(11) NOT NULL,
  `towerkills` int(11) NOT NULL,
  `raxkills` int(11) NOT NULL,
  `courierkills` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`,`colour`),
  KEY `colour` (`colour`),
  KEY `newcolour` (`newcolour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `eihl_elo_games_scored`
--

CREATE TABLE IF NOT EXISTS `eihl_elo_games_scored` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `eihl_elo_scores`
--

CREATE TABLE IF NOT EXISTS `eihl_elo_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(15) NOT NULL,
  `server` varchar(100) NOT NULL,
  `score` double NOT NULL,
  `games` int(11) NOT NULL,
  `wins` int(11) NOT NULL,
  `losses` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `creepkills` int(11) NOT NULL,
  `creepdenies` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `neutralkills` int(11) NOT NULL,
  `towerkills` int(11) NOT NULL,
  `raxkills` int(11) NOT NULL,
  `courierkills` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `gametrack`
--

CREATE TABLE IF NOT EXISTS `gametrack` (
  `name` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `realm` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bots` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastgames` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_leftpercent` double DEFAULT NULL,
  `num_leftpercent` int(11) DEFAULT NULL,
  `num_games` int(11) DEFAULT NULL,
  `time_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `time_active` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `playingtime` int(11) DEFAULT NULL,
  KEY `name` (`name`),
  KEY `realm` (`realm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lodgames`
--

CREATE TABLE IF NOT EXISTS `lodgames` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `winner` int(11) NOT NULL,
  `min` int(11) NOT NULL,
  `sec` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`),
  KEY `winner` (`winner`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `lodplayers`
--

CREATE TABLE IF NOT EXISTS `lodplayers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `botid` int(11) NOT NULL,
  `gameid` int(11) NOT NULL,
  `colour` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `creepkills` int(11) NOT NULL,
  `creepdenies` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `gold` int(11) NOT NULL,
  `neutralkills` int(11) NOT NULL,
  `item1` char(4) NOT NULL,
  `item2` char(4) NOT NULL,
  `item3` char(4) NOT NULL,
  `item4` char(4) NOT NULL,
  `item5` char(4) NOT NULL,
  `item6` char(4) NOT NULL,
  `hero` char(4) NOT NULL,
  `newcolour` int(11) NOT NULL,
  `towerkills` int(11) NOT NULL,
  `raxkills` int(11) NOT NULL,
  `courierkills` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`,`colour`),
  KEY `colour` (`colour`),
  KEY `newcolour` (`newcolour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `lod_elo_games_scored`
--

CREATE TABLE IF NOT EXISTS `lod_elo_games_scored` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `lod_elo_scores`
--

CREATE TABLE IF NOT EXISTS `lod_elo_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(15) NOT NULL,
  `server` varchar(100) NOT NULL,
  `score` double NOT NULL,
  `games` int(11) NOT NULL,
  `wins` int(11) NOT NULL,
  `losses` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `creepkills` int(11) NOT NULL,
  `creepdenies` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `neutralkills` int(11) NOT NULL,
  `towerkills` int(11) NOT NULL,
  `raxkills` int(11) NOT NULL,
  `courierkills` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_admins`
--

CREATE TABLE IF NOT EXISTS `stats_admins` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` tinyint(4) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `server` enum('europe.battle.net','useast.battle.net','uswest.battle.net','asia.battle.net') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `botid` (`botid`,`name`,`server`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_banhistory`
--

CREATE TABLE IF NOT EXISTS `stats_banhistory` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `botid` int(11) NOT NULL DEFAULT '0',
  `admin` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `date` datetime DEFAULT NULL,
  `expiredate` datetime DEFAULT NULL,
  `context` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `warn` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_bans`
--

CREATE TABLE IF NOT EXISTS `stats_bans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date` datetime DEFAULT NULL,
  `gamename` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiredate` timestamp NULL DEFAULT NULL,
  `warn` int(11) NOT NULL DEFAULT '0',
  `processed` int(11) NOT NULL,
  `targetbot` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_commands`
--

CREATE TABLE IF NOT EXISTS `stats_commands` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `command` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_dotagames`
--

CREATE TABLE IF NOT EXISTS `stats_dotagames` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `winner` tinyint(4) NOT NULL DEFAULT '0',
  `min` int(11) NOT NULL DEFAULT '0',
  `sec` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `def` (`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_dotaplayers`
--

CREATE TABLE IF NOT EXISTS `stats_dotaplayers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
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
  `ms` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `dp_newcolour` (`newcolour`),
  KEY `dp_gameid` (`gameid`),
  KEY `gp_select` (`newcolour`,`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_dota_elo_games_scored`
--

CREATE TABLE IF NOT EXISTS `stats_dota_elo_games_scored` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `def` (`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_dota_elo_scores`
--

CREATE TABLE IF NOT EXISTS `stats_dota_elo_scores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `zerodeaths` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `def` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_gamelist`
--

CREATE TABLE IF NOT EXISTS `stats_gamelist` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
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
  `lobby` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`)
) ENGINE=MEMORY  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_gameplayers`
--

CREATE TABLE IF NOT EXISTS `stats_gameplayers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `spoofed` int(11) NOT NULL DEFAULT '0',
  `reserved` int(11) NOT NULL DEFAULT '0',
  `loadingtime` int(11) NOT NULL DEFAULT '0',
  `left` int(11) NOT NULL DEFAULT '0',
  `leftreason` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `team` int(11) NOT NULL DEFAULT '0',
  `colour` int(11) NOT NULL DEFAULT '0',
  `spoofedrealm` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `gp_gameid` (`gameid`),
  KEY `gp_name_game` (`name`(171),`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_games`
--

CREATE TABLE IF NOT EXISTS `stats_games` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `map` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `datetime` datetime DEFAULT NULL,
  `gamename` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ownername` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `duration` int(11) NOT NULL DEFAULT '0',
  `gamestate` int(11) NOT NULL DEFAULT '0',
  `creatorname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creatorserver` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `stats` tinyint(1) DEFAULT '0',
  `views` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_game_chatevents`
--

CREATE TABLE IF NOT EXISTS `stats_game_chatevents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `time` int(11) NOT NULL DEFAULT '0',
  `playercolour` int(11) NOT NULL DEFAULT '0',
  `playername` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `chatmessage` text COLLATE utf8mb4_unicode_ci,
  `side` tinyint(4) NOT NULL DEFAULT '0',
  `lobby` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `gamid` (`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_game_events`
--

CREATE TABLE IF NOT EXISTS `stats_game_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `event` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT '0',
  `player1_colour` int(11) NOT NULL DEFAULT '0',
  `player2_colour` int(11) NOT NULL DEFAULT '0',
  `additional1` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional3` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional4` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_items`
--

CREATE TABLE IF NOT EXISTS `stats_items` (
  `itemid` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `playcount` int(11) DEFAULT '0',
  `code` smallint(10) NOT NULL DEFAULT '0',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shortname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_info` mediumblob,
  `price` smallint(6) NOT NULL DEFAULT '0',
  `type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
--
-- Table structure for table `stats_scoredgames`
--

CREATE TABLE IF NOT EXISTS `stats_scoredgames` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(20) NOT NULL,
  `rowids` int(11) NOT NULL,
  `names` int(11) NOT NULL,
  `servers` int(11) NOT NULL,
  `colours` int(11) NOT NULL,
  `winner` int(11) NOT NULL,
  `player_ratings` int(11) NOT NULL,
  `kills` int(11) NOT NULL,
  `deaths` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_spoof`
--

CREATE TABLE IF NOT EXISTS `stats_spoof` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `spoof` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_w3mmdplayers`
--

CREATE TABLE IF NOT EXISTS `stats_w3mmdplayers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` int(11) NOT NULL DEFAULT '0',
  `category` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `name` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `flag` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `leaver` int(11) NOT NULL DEFAULT '0',
  `practicing` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `category` (`category`),
  KEY `gameid` (`gameid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_w3mmdvars`
--

CREATE TABLE IF NOT EXISTS `stats_w3mmdvars` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `botid` int(11) NOT NULL DEFAULT '0',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `varname` varchar(25) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `value_int` int(11) DEFAULT NULL,
  `value_real` decimal(10,2) DEFAULT NULL,
  `value_string` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`),
  KEY `select` (`gameid`,`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_w3mmd_elo_games_scored`
--

CREATE TABLE IF NOT EXISTS `stats_w3mmd_elo_games_scored` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `gameid` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_w3mmd_elo_scores`
--

CREATE TABLE IF NOT EXISTS `stats_w3mmd_elo_scores` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
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
  `doublestats3` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stats_whitelist`
--

CREATE TABLE IF NOT EXISTS `stats_whitelist` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `stream_games`
--

CREATE TABLE IF NOT EXISTS `stream_games` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `gamename` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mappath` varchar(181) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mapcrc` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mapflags` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `port` int(10) NOT NULL,
  `botid` int(10) NOT NULL,
  `last_update` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;










--
-- Table structure for table `stream_players`
--

CREATE TABLE IF NOT EXISTS `stream_players` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID Number',
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gamename` varchar(181) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_update` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;




--
-- Table structure for table `w3mmd_elo_games_scored`
--

CREATE TABLE IF NOT EXISTS `w3mmd_elo_games_scored` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gameid` (`gameid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
