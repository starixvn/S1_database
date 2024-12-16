/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_GetUnchosenGamesByTpIdAndCategoryId_Get`(
    IN _TpId int, 
    IN _CategoryId int,
    IN _SiteId int,
    IN _CurrencyId int,
    IN _TopCategory tinyint
/*
  Created: 20241216@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Fix bug Duplicate game data creation show error 500
        Revisions:
                - 20241216@Zephyr.Nguyen: Create New SP Admin_GetUnchosenGamesByTpIdAndCategoryId_Get
*/)
BEGIN
    CREATE TEMPORARY TABLE ChosenGames AS
    SELECT DISTINCT t.GameId
    FROM TSDB.HotGames t
    INNER JOIN TpGameType TI ON t.TpGameType = TI.Type
    WHERE t.SiteId = _SiteId
      AND t.CurrencyId = _CurrencyId
      AND t.TopCategory = _TopCategory
      AND (t.TpId = _TpId);

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
      AND CG.GameId IS NULL;

    DROP TEMPORARY TABLE IF EXISTS ChosenGames;
END$$
DELIMITER ;

