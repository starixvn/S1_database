/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_Banner_Get_V3`(
    IN SiteId INT,
    IN BannerType INT,
    IN ShowStatus INT,
    IN CurrencyId TINYINT
    /*
  Created: 20250114@Mira
        DB: TSDB-TSDB
        Task: get category id
        Revisions:
                - 20250114@Mira: init sp
*/
)
BEGIN
    
    
    
    SELECT
        b.BannerName,
        b.BannerType,
        b.ActionMode,
        b.BonusCode,
        b.TpId,
        b.GameId,
        b.UrlRouter,
        b.Details,
        b.CategoryId
    FROM
        Banner b
    WHERE
        b.SiteId = SiteId
        AND b.BannerType = BannerType
        AND ( b.ShowStatus = ShowStatus OR b.ShowStatus = 3)
        AND NOW() BETWEEN b.StartTime AND b.EndTime
        AND b.CurrencyId = IF(  BannerType = 2 , 0,  CurrencyId ) 
        AND b.`Status` = 1
    ORDER BY
        b.sort ASC
        ;
END$$

DELIMITER ;
;