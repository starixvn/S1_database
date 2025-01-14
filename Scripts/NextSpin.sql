/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20250114@Kathy
        DB: TSDB-TSDB
        Task: NextSpin
*/


rename table BettransRng_Nextspin_202501 to del_BettransRng_Nextspin_202501;
rename table BettransRng_Nextspin_202502 to del_BettransRng_Nextspin_202502;

CREATE TABLE `BettransRng_Nextspin_202501` (
  `SQ` bigint NOT NULL AUTO_INCREMENT,
  `Seq` varchar(64) NOT NULL,
  `OperatorCustId` varchar(32) NOT NULL,
  `GameType` varchar(50) NOT NULL COMMENT 'Game of Vendor',
  `IpAddress` varchar(25) NOT NULL DEFAULT '',
  `SettleDate` datetime NOT NULL COMMENT 'The Tickets settle time',
  `TicketNo` varchar(200) NOT NULL COMMENT 'the ticket number. (Unique value).',
  `GameId` varchar(50) NOT NULL COMMENT 'the id of game with gametype',
  `GameRoundId` varchar(100) NOT NULL COMMENT 'Game-Vendor’s GameRoundId for stake',
  `TransactionId` varchar(100) NOT NULL DEFAULT '' COMMENT 'Game-Vendor’s TransId for stake. (LiveCasino/TableGame may have this)',
  `Stake` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `ActualStake` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `NetStake` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `Payout` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `Odds` decimal(20,2) NOT NULL DEFAULT '0.00',
  `BetChoice` varchar(100) NOT NULL DEFAULT '',
  `TableCode` varchar(100) NOT NULL DEFAULT '',
  `GameResult` varchar(2000) NOT NULL DEFAULT '',
  `CurrencyISO` varchar(10) NOT NULL DEFAULT '',
  `BonusId` varchar(100) NOT NULL DEFAULT '',
  `BonusName` varchar(500) NOT NULL DEFAULT '' COMMENT 'Bonus event name',
  `PrizeName` varchar(500) NOT NULL DEFAULT '' COMMENT 'Prize name',
  `TicketType` tinyint NOT NULL DEFAULT '0',
  `TicketStatus` tinyint NOT NULL DEFAULT '0',
  `SettleFlag` tinyint NOT NULL DEFAULT '0' COMMENT '0. Unsettle, 1. Settled, 2. Paid, 3. Not Exists.',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `OtherBetInfo` json DEFAULT NULL,
  PRIMARY KEY (`SQ`),
  UNIQUE KEY `ux_TicketNo_TicketType_Seq` (`TicketNo`,`TicketType`,`Seq`),
  KEY `ix_SettleDate` (`SettleDate`),
  KEY `ix_UpdateTime` (`UpdateTime`)
) ENGINE=InnoDB AUTO_INCREMENT=202501000000596 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Nextspin';


CREATE TABLE `BettransRng_Nextspin_202502` (
  `SQ` bigint NOT NULL AUTO_INCREMENT,
  `Seq` varchar(64) NOT NULL,
  `OperatorCustId` varchar(32) NOT NULL,
  `GameType` varchar(50) NOT NULL COMMENT 'Game of Vendor',
  `IpAddress` varchar(25) NOT NULL DEFAULT '',
  `SettleDate` datetime NOT NULL COMMENT 'The Tickets settle time',
  `TicketNo` varchar(200) NOT NULL COMMENT 'the ticket number. (Unique value).',
  `GameId` varchar(50) NOT NULL COMMENT 'the id of game with gametype',
  `GameRoundId` varchar(100) NOT NULL COMMENT 'Game-Vendor’s GameRoundId for stake',
  `TransactionId` varchar(100) NOT NULL DEFAULT '' COMMENT 'Game-Vendor’s TransId for stake. (LiveCasino/TableGame may have this)',
  `Stake` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `ActualStake` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `NetStake` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `Payout` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `Odds` decimal(20,2) NOT NULL DEFAULT '0.00',
  `BetChoice` varchar(100) NOT NULL DEFAULT '',
  `TableCode` varchar(100) NOT NULL DEFAULT '',
  `GameResult` varchar(2000) NOT NULL DEFAULT '',
  `CurrencyISO` varchar(10) NOT NULL DEFAULT '',
  `BonusId` varchar(100) NOT NULL DEFAULT '',
  `BonusName` varchar(500) NOT NULL DEFAULT '' COMMENT 'Bonus event name',
  `PrizeName` varchar(500) NOT NULL DEFAULT '' COMMENT 'Prize name',
  `TicketType` tinyint NOT NULL DEFAULT '0',
  `TicketStatus` tinyint NOT NULL DEFAULT '0',
  `SettleFlag` tinyint NOT NULL DEFAULT '0' COMMENT '0. Unsettle, 1. Settled, 2. Paid, 3. Not Exists.',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `OtherBetInfo` json DEFAULT NULL,
  PRIMARY KEY (`SQ`),
  UNIQUE KEY `ux_TicketNo_TicketType_Seq` (`TicketNo`,`TicketType`,`Seq`),
  KEY `ix_SettleDate` (`SettleDate`),
  KEY `ix_UpdateTime` (`UpdateTime`)
) ENGINE=InnoDB AUTO_INCREMENT=202501000000596 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Nextspin';



