/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Game_Name_Get`(
  /*
  Created: 20241031@Los
	DB: TSDB-TSDB
	Task: Get all game

	Revisions:
        - 20241119@Los: Initial
*/
)
BEGIN
    SELECT tp.Tpid, tp.GameId, BetType, tpi.Lang, tpi.Name
    FROM TpGameId AS tp INNER JOIN TpGameIdInfo AS tpi
    ON tp.TpId=tpi.TpId AND tp.No=tpi.TpGameIdNo
    UNION
    SELECT GC.TpId, GC.GameId, '' AS 'BetType', GCI.Lang, GCI.Name
    FROM GameCasinoInfo AS GCI
            INNER JOIN
        SlotGame AS GC ON GCI.GameCasinoId = GC.Id;
    
END $$
DELIMITER $$;