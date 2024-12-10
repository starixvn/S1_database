/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/

DELIMITER $$
USE `TSDB`$$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_HotMatchDataList_Get`(
    /*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: Hot match
        Revisions:
                - 20241120@Levi.Vu: Get hot Match
                - 20241125@Levi.vu: Get TpId and GameId
                - 20241127@Levi.vu: Get Top 10
                - 20241204@Levi.vu: Remove get Top 10
*/
)

BEGIN
 SELECT LeagueName AS SportLeaguesTitle,
           MatchId,
           HomeTeamName, 
           AwayTeamName, 
           DATE_FORMAT(CONVERT_TZ(KickOffTime, @@session.time_zone, '+00:00'), '%Y-%m-%dT%TZ') AS BattleTime,  
           HomeOdds, 
           AwayOdds, 
           Handicap,
           HomeIconUrl,
           AwayIconUrl,
           tpId,
           gameId
    FROM HotMatchInfo
    WHERE Status = 1 AND NOW() BETWEEN StartTime AND EndTime
    ORDER BY KickOffTime DESC;
END$$

DELIMITER ;

