CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BalanceForLicense_Get_V2`(
    IN _Time DATETIME,
    IN _SiteId INT,
    IN _CurrencyIds JSON)
BEGIN
    
    
    

    SELECT CONCAT(C.CustId, ';', CCB.Balance / CY.USDRate, ' USD;') AS Data
    FROM CustClosingBalance AS CCB
        INNER JOIN Customer AS C ON CCB.CustId = C.CustId
        INNER JOIN Currency AS CY on CY.CurrencyId = C.CurrencyId
    WHERE
          C.Status = 1
          AND C.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList)
          AND CCB.Time = _Time
          AND CCB.SiteId = _SiteId ;

END