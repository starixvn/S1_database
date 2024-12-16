CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DepositAccounting_Get`(
   IN _SiteIds JSON, 
   IN _CurrencyIds JSON,
   IN _StartDate DATETIME,
   IN _EndDate DATETIME,
   IN _TransId varchar(30) CHARACTER SET ASCII,
   IN _UserName varchar(35),
   IN _StartIndex INT,
   IN _PageSize INT,
   OUT _TotalPages INT,
   OUT _RowCount INT
   )
BEGIN
   
   
		SELECT SQL_CALC_FOUND_ROWS
			SI.`SiteName`,
            DA.`SiteId`,
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
		WHERE DA.SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList)
		AND DA.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyList)
		AND DA.CreateTime BETWEEN _StartDate AND _EndDate
		AND ((_TransId IS NULL AND 1=1) OR (_TransId IS NOT NULL AND DA.TransId=_TransId))
		AND ((_UserName IS NULL AND 1=1) OR (_UserName IS NOT NULL AND DA.UserName = _UserName))
		ORDER BY  DA.TransId
			LIMIT _StartIndex , _PageSize;
    
		SET _RowCount = FOUND_ROWS();
		IF _RowCount = 0 THEN 
			SET _TotalPages = 0;
		ELSE
			SET _TotalPages = CEIL(_RowCount/_PageSize);        
		END IF;

END