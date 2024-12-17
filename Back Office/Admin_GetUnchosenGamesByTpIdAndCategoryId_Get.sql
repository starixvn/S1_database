/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_GetUnchosenGamesByTpIdAndCategoryId_Get`(
    IN _TpId INT, 
    IN _CategoryId INT,
    IN _SiteId INT,
    IN _CurrencyId INT,
    IN _TopCategory TINYINT
/*
  Created: 20241217@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Fix bug Duplicate game data creation show error 500
        Revisions:
                - 20241217@Zephyr.Nguyen: Create New SP Admin_GetUnchosenGamesByTpIdAndCategoryId_Get
*/)
BEGIN
    CREATE TEMPORARY TABLE ChosenGames AS
    SELECT DISTINCT t.GameId
    FROM TSDB.HotGames t
    INNER JOIN TpGameType TI ON t.TpGameType = TI.Type
    WHERE t.SiteId = _SiteId
      AND t.CurrencyId = _CurrencyId
      AND t.TopCategory = _TopCategory
      AND t.TpId = _TpId;

    CREATE TEMPORARY TABLE TempResult1 AS
    SELECT 
        TGI.TpId,
        TGI.GameId,
        TGI.Name
    FROM TSDB.TpGameId AS TGI
    LEFT JOIN TpGameType AS TGT ON TGT.Type = TGI.TpGameType
    LEFT JOIN ChosenGames CG ON TGI.GameId = CG.GameId
    WHERE TGT.TpId = _TpId
      AND TGT.CategoryId = _CategoryId
      AND TGI.BetType = ''
      AND TGI.Status = 1
      AND CG.GameId IS NULL;

    CREATE TEMPORARY TABLE TempResult2 AS
    SELECT
        GC.TpId,
        GC.GameId,
        GCI.Name
    FROM GameCasinoInfo AS GCI
    INNER JOIN SlotGame AS GC ON GCI.GameCasinoId = GC.Id
    INNER JOIN SlotGameStatus AS GCS ON GCS.SlotGameId = GC.Id AND GCS.SiteId = _SiteId AND GCS.CurrencyId = _CurrencyId
    LEFT JOIN ChosenGames CG ON GC.GameId = CG.GameId
    WHERE GC.TpId = _TpId
      AND GCI.Lang = 'en'
      AND GC.CategoryId = _CategoryId
      AND CG.GameId IS NULL;

    SELECT * FROM TempResult1
    UNION ALL
    SELECT * FROM TempResult2;

    DROP TEMPORARY TABLE IF EXISTS ChosenGames;
    DROP TEMPORARY TABLE IF EXISTS TempResult1;
    DROP TEMPORARY TABLE IF EXISTS TempResult2;
END$$
DELIMITER ;

