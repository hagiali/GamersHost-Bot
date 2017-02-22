-- phpMyAdmin SQL Dump
-- version 4.6.4deb1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 21. Feb 2017 um 10:56
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
-- Tabellenstruktur für Tabelle `stats_admins`
--

CREATE TABLE `stats_admins` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `server` enum('europe.battle.net','useast.battle.net','uswest.battle.net','asia.battle.net') COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_banhistory`
--

CREATE TABLE `stats_banhistory` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `botid` int(11) NOT NULL DEFAULT '0',
  `admin` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `expiredate` datetime DEFAULT CURRENT_TIMESTAMP,
  `context` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `warn` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_bans`
--

CREATE TABLE `stats_bans` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ip` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  `gamename` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiredate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `warn` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_commands`
--

CREATE TABLE `stats_commands` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `command` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
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
  `zerodeaths` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `age` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_gameplayers`
--

CREATE TABLE `stats_gameplayers` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
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
  `spoofedrealm` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stats_games`
--

CREATE TABLE `stats_games` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `botid` tinyint(4) NOT NULL DEFAULT '0',
  `server` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `map` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `datetime` datetime DEFAULT CURRENT_TIMESTAMP,
  `gamename` varchar(31) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `ownername` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `duration` int(11) NOT NULL DEFAULT '0',
  `gamestate` int(11) NOT NULL DEFAULT '0',
  `creatorname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `creatorserver` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
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
  `playername` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
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
  `event` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `time` int(11) NOT NULL DEFAULT '0',
  `player1_colour` int(11) NOT NULL DEFAULT '0',
  `player2_colour` int(11) NOT NULL DEFAULT '0',
  `additional1` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional3` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `additional4` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
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
-- Tabellenstruktur für Tabelle `stats_spoof`
--

CREATE TABLE `stats_spoof` (
  `id` bigint(20) UNSIGNED NOT NULL COMMENT 'ID Number',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `stats_admins`
--
ALTER TABLE `stats_admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `botid` (`botid`,`name`,`server`);

--
-- Indizes für die Tabelle `stats_banhistory`
--
ALTER TABLE `stats_banhistory`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `stats_bans`
--
ALTER TABLE `stats_bans`
  ADD PRIMARY KEY (`id`);

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
-- Indizes für die Tabelle `stats_dotaplayers`
--
ALTER TABLE `stats_dotaplayers`
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
  ADD KEY `gp_name_game` (`name`(171),`gameid`);

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
-- AUTO_INCREMENT für Tabelle `stats_admins`
--
ALTER TABLE `stats_admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_banhistory`
--
ALTER TABLE `stats_banhistory`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_bans`
--
ALTER TABLE `stats_bans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_commands`
--
ALTER TABLE `stats_commands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
--
-- AUTO_INCREMENT für Tabelle `stats_dotagames`
--
ALTER TABLE `stats_dotagames`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_dotaplayers`
--
ALTER TABLE `stats_dotaplayers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_dota_elo_games_scored`
--
ALTER TABLE `stats_dota_elo_games_scored`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_dota_elo_scores`
--
ALTER TABLE `stats_dota_elo_scores`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_gamelist`
--
ALTER TABLE `stats_gamelist`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_gameplayers`
--
ALTER TABLE `stats_gameplayers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_games`
--
ALTER TABLE `stats_games`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_game_chatevents`
--
ALTER TABLE `stats_game_chatevents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_game_events`
--
ALTER TABLE `stats_game_events`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_spoof`
--
ALTER TABLE `stats_spoof`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
--
-- AUTO_INCREMENT für Tabelle `stats_w3mmdplayers`
--
ALTER TABLE `stats_w3mmdplayers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number', AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT für Tabelle `stats_w3mmdvars`
--
ALTER TABLE `stats_w3mmdvars`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
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
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID Number';
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
