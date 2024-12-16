/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_HotGames_Get_V3`(
    IN _SiteId INT, 
    IN _Top INT, 
    IN _TpCategory VARCHAR(255), -- Comma-separated list of category IDs, e.g., '1,2,3'
    IN _CurrencyId SMALLINT UNSIGNED

/*
  Created: 20241113@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Get HotGames 
        Revisions:
                - 20241113@Brian.Nguyen: Get hot games follow top and tpcategory
				- 20241216@Brian.Nguyen: Get All Tp category for new games
*/)
BEGIN  
   SELECT 
        t.TpId,
        t.GameId,
        t.TpGameType,
        t.TpCategory,
        t.GameName,
        TP.DisplayName AS TPName,
        TP.TPName AS TPNameKey,
        t.Sort,
        t.TopCategory
    FROM (
        SELECT 
            t.*,
            ROW_NUMBER() OVER (PARTITION BY t.TpCategory ORDER BY t.Sort ASC) AS rn
        FROM 
            TSDB.HotGames t
            LEFT JOIN TSDB.TpGameId AS TGI ON TGI.GameId = t.GameId AND TGI.TpId = t.TpId
			LEFT JOIN TSDB.SlotGame AS SL ON SL.GameId = t.GameId AND SL.TpId = t.TpId
            LEFT JOIN TSDB.SlotGameStatus AS SLT ON SLT.SlotGameId = SL.Id AND SLT.SiteId = _SiteId AND SLT.CurrencyId = _CurrencyId
        WHERE 
            t.SiteId = _SiteId
            AND ( FIND_IN_SET(t.TpCategory, _TpCategory) > 0 OR t.TopCategory = 2)
            AND t.CurrencyId = _CurrencyId
            AND ( TGI.Status > 0 OR SLT.Status > 0)
    ) t
    INNER JOIN TSDB.TpList AS TP ON t.TpId = TP.Id
    WHERE 
        t.rn <= _Top
    ORDER BY  
        t.Sort ASC;
END$$
DELIMITER ;