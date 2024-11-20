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
*/)
BEGIN  
    SELECT 
        t.TpId,
        t.GameId,
        t.TpGameType,
        t.TpCategory,
        t.GameName,
        t.TpName,
        t.Sort,
        t.TopCategory
    FROM (
        SELECT 
            t.*,
            ROW_NUMBER() OVER (PARTITION BY t.TpCategory ORDER BY t.Sort DESC) AS rn
        FROM 
            TSDB.HotGames t
        WHERE 
            t.SiteId = _SiteId
            AND FIND_IN_SET(t.TpCategory, _TpCategory) > 0
            AND t.CurrencyId = _CurrencyId
    ) t
    WHERE 
        t.rn <= _Top
    ORDER BY 
        t.TpCategory, 
        t.Sort DESC;
END$$
DELIMITER ;