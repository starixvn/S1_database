CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WithdrawalInfoAndAccounting_Get_V3`(
   IN _SiteIds json, 
   IN _CurrencyIds json,
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
       WI.TransId,
       WI.CustId,
       WI.UserName,
       WI.SiteId,
       SI.SiteName,
       WI.CurrencyId,
       C.IsoCode,
       WI.Amount,
       WI.ChargeFee,
       WI.CreateTime,
       WI.Operator,
       WI.FlowEndTime,
       IFNULL(WBA.AccountingCount,0) AS AccountingCount,
       IFNULL(WBA.AccountingAmount,0) AS AccountingAmount,
       IFNULL(WBA.AccountingChargeFee,0) AS AccountingChargeFee
FROM WithdrawalInfo AS WI
LEFT JOIN ServerInfo AS SI ON WI.SiteId = SI.SiteId
LEFT JOIN Currency AS C ON WI.CurrencyId = C.CurrencyId
LEFT JOIN (SELECT TransId AS TransId,
                  COUNT(1) AS AccountingCount,
                  SUM(Amount) AS AccountingAmount,
                  SUM(ChargeFee) AS AccountingChargeFee
FROM WithdrawalBankAccounting GROUP BY TransId) AS WBA ON WI.TransId = WBA.TransId
WHERE WI.`Status` =6
AND WI.WithdrawalType=2 
AND WI.SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList)
AND WI.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyList)
AND WI.FlowEndTime BETWEEN _StartDate AND _EndDate
AND ((_TransId IS NULL AND 1=1) OR (_TransId IS NOT NULL AND WI.TransId=_TransId))
AND ((_UserName IS NULL AND 1=1) OR (_UserName IS NOT NULL AND WI.UserName = _UserName))
ORDER BY  WI.TransId
    LIMIT _StartIndex , _PageSize;
    
    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);        
    END IF;

END