/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_GetGameIdByTpIdAndCategoryId_Get`(
	IN _TpId int, 
    IN _CategoryId int
    /*
      Created: 20250110@Johnny
      DB: TSDB-TSDB
      Task: Get game by CategoryId, TpId

      Revisions:
          - 20250110@Johnny: Exclude Inactive game
    */   
)
BEGIN
    SELECT 
        TGI.TpId,
        TGI.GameId,
        TGI.Name
    FROM TSDB.TpGameId AS TGI
    LEFT JOIN TpGameType AS TGT ON TGT.Type = TGI.TpGameType
    WHERE TGT.TpId = _TpId
    AND TGT.CategoryId = _CategoryId
    AND BetType =''
    AND TGI.Status = 1
    
    UNION

    SELECT
            GC.TpId,
            GC.GameId,
            GCI.Name
        FROM
            GameCasinoInfo AS GCI 
                INNER JOIN
            SlotGame AS GC ON GCI.GameCasinoId = GC.Id
        WHERE
            GC.TpId = _TpId
        AND GCI.Lang = 'en'
        AND GC.CategoryId = _CategoryId
        GROUP BY
            GCI.GameCasinoId,GCI.Name;
END$$
DELIMITER ;