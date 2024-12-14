/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_GetUnchosenGamesByTpIdAndCategoryId_Get`(
    IN _TpId int, 
    IN _CategoryId int,
    IN _SiteId int,
    IN _CurrencyId smallint unsigned,
    IN _TopCategory tinyint
/*
  Created: 20241204@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Fix bug Duplicate game data creation show error 500
        Revisions:
                - 20241214@Zephyr.Nguyen: Create New SP Admin_GetUnchosenGamesByTpIdAndCategoryId_Get
*/)
BEGIN
    SELECT 
        TGI.TpId,
        TGI.GameId,
        TGI.Name
    FROM TSDB.TpGameId AS TGI
    LEFT JOIN TpGameType AS TGT ON TGT.Type = TGI.TpGameType
    WHERE TGT.TpId = _TpId
      AND TGT.CategoryId = _CategoryId
      AND TGI.BetType = ''
      AND TGI.GameId NOT IN (
          SELECT t.GameId
          FROM TSDB.HotGames t
          INNER JOIN TpGameType TI on t.TpGameType = TI.Type
          INNER JOIN TpCategory TJ on t.TpCategory = TJ.Id
          INNER JOIN TpList TL on t.TpId = TL.Id
          WHERE t.SiteId = _SiteId
            AND t.CurrencyId = _CurrencyId
            AND t.TopCategory = _TopCategory
            AND (_TpId = 0 OR t.TpId = _TpId)
      )
      
    UNION

    SELECT
        GC.TpId,
        GC.GameId,
        GCI.Name
    FROM GameCasinoInfo AS GCI
    INNER JOIN SlotGame AS GC ON GCI.GameCasinoId = GC.Id
    WHERE GC.TpId = _TpId
      AND GCI.Lang = 'en'
      AND GC.CategoryId = _CategoryId
      AND GC.GameId NOT IN (
          SELECT t.GameId
          FROM TSDB.HotGames t
          INNER JOIN TpGameType TI on t.TpGameType = TI.Type
          INNER JOIN TpCategory TJ on t.TpCategory = TJ.Id
          INNER JOIN TpList TL on t.TpId = TL.Id
          WHERE t.SiteId = _SiteId
            AND t.CurrencyId = _CurrencyId
            AND t.TopCategory = _TopCategory
            AND (_TpId = 0 OR t.TpId = _TpId)
      )
    GROUP BY GCI.GameCasinoId, GCI.Name;
END$$
DELIMITER ;

