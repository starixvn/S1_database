/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Create Table Hot Match
*/


CREATE TABLE `TSDB`.`HotMatchInfo` (
  `MatchId` INT NOT NULL,
  `LeagueId` INT NOT NULL,
  `LeagueName` VARCHAR(200) NOT NULL,
  `KickOffTime` DATETIME NULL,
  `IsLive` TINYINT NULL,
  `HomeTeamName` VARCHAR(100) NULL,
  `AwayTeamName` VARCHAR(100) NULL,
  `HomeIconUrl` VARCHAR(200) NULL,
  `AwayIconUrl` VARCHAR(200) NULL,
  `Status` TINYINT(3) NOT NULL,
  `StartTime` DATETIME NULL,
  `EndTime` DATETIME NULL,
  `LastUpdateTime` DATETIME NULL,
  `LastUpdateUser` VARCHAR(45) NULL,
  `HomeOdds` DECIMAL(18,2) NULL,
  `AwayOdds` DECIMAL(18,2) NULL,
  `Handicap` DECIMAL(18,2) NULL,
  `Sort` INT NULL,
  `CreateTime` DATETIME NULL,
  PRIMARY KEY (`MatchId`));


ALTER TABLE `TSDB`.`HotMatchInfo` 
ADD UNIQUE INDEX `MatchId_UNIQUE` (`MatchId` ASC) VISIBLE;