/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BonusInfoTotalAmount_Get_V8`(
	IN _MultiSiteRequest JSON,
    IN _BonusCode varchar(30),
    IN _TransId varchar(30),
    IN _UserName varchar(30),
    IN _PromotionTypes json,
    IN _StartDate datetime,
    IN _EndDate datetime,
    IN _BaseCurrencyId tinyint,
    IN _CategoryTypes json,
    IN _Statuses json,
    IN _AtPages json
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Get correct property
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
    SELECT ActualRate
      INTO @BaseRateToMYR
      FROM Currency
     WHERE CurrencyId = _BaseCurrencyId;

        SELECT SI.SiteName AS SiteName,
               CY.IsoCode AS Currency,
               SUM(IF(_BaseCurrencyId = 0, BI.BonusAmount ,BI.BonusAmount * CY.ActualRate / @BaseRateToMYR)) AS Amount,
               COUNT(CY.IsoCode) AS Record
          FROM BonusInfo AS BI
    INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
            ON BI.SiteId = SC.SiteId AND BI.CurrencyId = SC.CurrencyId
    INNER JOIN Currency AS CY ON CY.CurrencyId = BI.CurrencyId
    INNER JOIN ServerInfo AS SI ON SI.SiteId = BI.SiteId
         WHERE BI.CreateTime BETWEEN _StartDate AND _EndDate
           AND ( _BonusCode IS NULL OR BI.BonusCode = _BonusCode )
           AND ( _TransId IS NULL OR BI.TransId = _TransId )
           AND ( _UserName IS NULL OR BI.UserName = _UserName )
           AND BI.PromotionType IN (SELECT * FROM JSON_TABLE(_PromotionTypes, '$[*]' COLUMNS(`PromotionType` INT path "$")) AS PromotionTypeList)
           AND BI.`BonusInfo`->'$.CategoryId' IN (SELECT * FROM JSON_TABLE(_CategoryTypes, '$[*]' COLUMNS(`CategoryType` INT path "$")) AS CategoryTypeList)
           AND BI.`Status` IN (SELECT * FROM JSON_TABLE(_Statuses, '$[*]' COLUMNS(`Status` INT path "$")) AS StatusList)
           AND BI.AtPage IN (SELECT * FROM JSON_TABLE(_AtPages, '$[*]' COLUMNS(AtPage TINYINT path "$")) AS tmp)
      GROUP BY BI.SiteId,SI.SiteName,CY.IsoCode
      ORDER BY BI.SiteId,CY.IsoCode;
END$$
DELIMITER ;
