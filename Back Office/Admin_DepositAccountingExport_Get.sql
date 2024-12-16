/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DepositAccountingExport_Get`(
   IN _SiteIds JSON, 
   IN _CurrencyIds JSON,
   IN _StartDate DATETIME,
   IN _EndDate DATETIME,
   IN _TransId varchar(30) CHARACTER SET ASCII,
   IN _UserName varchar(35)
       /*
  Created: 20241125@Liam 
        DB: TSDB-TSDB
        Task: fix sp crash
         Revisions:
                - 20241216@Liam: fix sp crash
*/ 

   )
BEGIN
		SELECT 
            SI.`SiteId`,
            SI.`SiteName`,
			DA.`TransId`,
			DA.`UserName`,
			DA.`CustId`,
			DA.`CurrencyId`,
            CY.`IsoCode` AS Currency,
			DA.`Amount`,
			DA.`BankName`,
			DA.`AccountNo`,
			DA.`Memo`,
			DA.`Operator`,
			DA.`ApprovedTime`,
			DA.`LatestUpdateOperator`,
			DA.`LatestUpdateTime`
		FROM DepositAccounting AS DA
			INNER JOIN
			Currency AS CY ON CY.CurrencyId=DA.CurrencyId
            INNER JOIN
			ServerInfo AS SI ON SI.SiteId = DA.SiteId
		WHERE EXISTS (
			SELECT 1
			FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList
			WHERE SiteList.SiteId = DA.SiteId
		)
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyList
			WHERE CurrencyList.CurrencyId = DA.CurrencyId
		)
		AND DA.CreateTime BETWEEN _StartDate AND _EndDate
		AND ((_TransId IS NULL AND 1=1) OR (_TransId IS NOT NULL AND DA.TransId=_TransId))
		AND ((_UserName IS NULL AND 1=1) OR (_UserName IS NOT NULL AND DA.UserName = _UserName))
		ORDER BY  DA.TransId ;
 
END$$
DELIMITER ;