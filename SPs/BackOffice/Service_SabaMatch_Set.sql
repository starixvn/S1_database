/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
USE `TSDB`$$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_SabaMatch_Set`(IN Matches JSON
/*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: Hot match
        Revisions:
                - 20241120@Levi.Vu: Insert Hot match data
*/)
BEGIN

 CREATE TEMPORARY TABLE TempMatches (
        MatchId INT NOT NULL,
        LeagueId INT NOT NULL,
        LeagueName VARCHAR(200) NOT NULL,
        KickOffTime DATETIME NOT NULL,
        IsLive TINYINT(1) NOT NULL,
        HomeTeamName VARCHAR(100) NULL,
        AwayTeamName VARCHAR(100) NULL,
        HomeIconUrl VARCHAR(255) NULL,
        AwayIconUrl VARCHAR(255) NULL,
        Status TINYINT(3) NOT NULL,
        LastUpdateTime DATETIME NOT NULL,
        LastUpdateUser VARCHAR(45) NULL,
        HomeOdds VARCHAR(50) NULL,
        AwayOdds VARCHAR(50) NULL,
        Handicap VARCHAR(50) NULL,
        Sort INT NULL,
        CreateTime DATETIME NOT NULL,
        TpId INT NULL,
        GameId INT NULL
    );

    INSERT INTO TempMatches
    SELECT 
        MatchId,
        LeagueId,
        LeagueName,
        KickOffTime,
        IsLive,
        HomeTeamName,
        AwayTeamName,
        HomeIconUrl,
        AwayIconUrl,
        Status,
        LastUpdateTime,
        LastUpdateUser,
        HomeOdds,
        AwayOdds,
        Handicap,
        Sort,
        CreateTime,
        TpId,
        GameId
    FROM JSON_TABLE(
        Matches,
        '$[*]' COLUMNS (
            MatchId INT PATH '$.MatchId',
            LeagueId INT PATH '$.LeagueId',
            LeagueName VARCHAR(200) PATH '$.LeagueName',
            KickOffTime DATETIME PATH '$.KickOffTime',
            IsLive TINYINT PATH '$.IsLive',
            HomeTeamName VARCHAR(100) PATH '$.HomeTeamName',
            AwayTeamName VARCHAR(100) PATH '$.AwayTeamName',
            HomeIconUrl VARCHAR(255) PATH '$.HomeIconUrl',
            AwayIconUrl VARCHAR(255) PATH '$.AwayIconUrl',
            Status TINYINT PATH '$.Status',
            LastUpdateTime DATETIME PATH '$.LastUpdateTime',
            LastUpdateUser VARCHAR(45) PATH '$.LastUpdateUser',
            HomeOdds VARCHAR(50) PATH '$.HomeOdds',
            AwayOdds VARCHAR(50) PATH '$.AwayOdds',
            Handicap VARCHAR(50) PATH '$.Handicap',
            Sort INT PATH '$.Sort',
            CreateTime DATETIME PATH '$.CreateTime',
            TpId INT PATH '$.TpId',
            GameId INT PATH '$.GameId'
        )
    ) AS ParsedJson;

    INSERT INTO HotMatchInfo (
        MatchId,
        LeagueId,
        LeagueName,
        KickOffTime,
        IsLive,
        HomeTeamName,
        AwayTeamName,
        HomeIconUrl,
        AwayIconUrl,
        Status,
        LastUpdateTime,
        LastUpdateUser,
        HomeOdds,
        AwayOdds,
        Handicap,
        Sort,
        CreateTime,
        StartTime,
        EndTime,
        TpId,
        GameId
    )
    SELECT 
        MatchId,
        LeagueId,
        LeagueName,
        KickOffTime,
        IsLive,
        HomeTeamName,
        AwayTeamName,
        HomeIconUrl,
        AwayIconUrl,
        Status,
        LastUpdateTime,
        LastUpdateUser,
        HomeOdds,
        AwayOdds,
        Handicap,
        Sort,
        CreateTime,
        now(),
        DATE_ADD(KickOffTime, INTERVAL 2 HOUR),
        TpId,
        GameId
    FROM TempMatches
    ON DUPLICATE KEY UPDATE
        LastUpdateTime = VALUES(LastUpdateTime),
        LastUpdateUser = VALUES(LastUpdateUser),
        HomeOdds = VALUES(HomeOdds),
        AwayOdds = VALUES(AwayOdds),
        Handicap = VALUES(Handicap);

    DROP TEMPORARY TABLE TempMatches;
END$$

DELIMITER ;
;

