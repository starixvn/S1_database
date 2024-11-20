/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
USE `TSDB`$$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_HotMatchDataList_Get`(
    IN _Status tinyint,
    IN _PageSize int,
    IN _StartIndex int, 
	IN _LeagueId int, 
    OUT _TotalPages int,
    OUT _RowCount int
)
/*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: Hot match
        Revisions:
                - 20241120@Levi.Vu: Get hot Match
*/
BEGIN
    SELECT COUNT(*) INTO _RowCount
    FROM HotMatchInfo
    WHERE (_Status = 2 OR Status = _Status) and (_LeagueId = 0 OR LeagueId = _LeagueId) and  KickOffTime >= DATE_SUB(CURDATE(), INTERVAL 14 DAY);

    IF _RowCount = 0 THEN
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount / _PageSize);
    END IF;

    SELECT MatchId AS Id,
           HomeTeamName AS HomeTeamName,
           AwayTeamName AS AwayTeamName,
           LeagueName AS LeagueName,
           Status AS Status,
           StartTime AS StartTime,
           EndTime AS EndTime,
           KickOffTime AS BattleTime,
           LastUpdateUser AS LastUpdateUser,
           LastUpdateTime AS LastUpdateTime
    FROM HotMatchInfo
    WHERE (_Status = 2 OR Status = _Status) and (_LeagueId = 0 OR LeagueId = _LeagueId)  and  KickOffTime >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
    ORDER BY KickOffTime DESC
    LIMIT _StartIndex, _PageSize;
END$$

DELIMITER ;
;

