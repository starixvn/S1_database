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
           AwayIconUrl
    FROM HotMatchInfo
    WHERE Status = 1 AND NOW() BETWEEN StartTime AND EndTime
    ORDER BY KickOffTime;
END$$

DELIMITER ;
;

