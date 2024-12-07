/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_HotMatch_Status_Set`(
/*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: Hot match
        Revisions:
                - 20241120@Levi.Vu: Update HotMatch status by EndTime
                - 20241204@Levi.Vu: Update status by Top 10
                - 20241206@Levi.Vu: Update status by Top 10 nearest KickOffTime, MatchId
*/)

BEGIN
     CREATE TEMPORARY TABLE ClosestTenMatches AS
     SELECT MatchId
     FROM HotMatchInfo
     WHERE KickOffTime IS NOT NULL AND KickOffTime > NOW()
     ORDER BY KickOffTime ASC, matchId DESC
     LIMIT 10;

     
    UPDATE HotMatchInfo
    SET  LastUpdateUser = 'Service',
    STATUS = CASE
    WHEN NOW() > EndTime OR MatchId NOT IN (SELECT MatchId FROM ClosestTenMatches) THEN 0
    ELSE 1
END;

DROP TEMPORARY TABLE ClosestTenMatches;
END$$

DELIMITER ;

