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
    SELECT Tpid, GameId, BetType, 'en' AS Lang, Name
    FROM TpGameId
    UNION
    SELECT GC.TpId, GC.AppId  AS GameId, '' AS 'BetType', GCI.Lang, GCI.Name
    FROM GameCasinoInfo AS GCI
            INNER JOIN
        SlotGame AS GC ON GCI.GameCasinoId = GC.Id;
    
END $$
DELIMITER $$;