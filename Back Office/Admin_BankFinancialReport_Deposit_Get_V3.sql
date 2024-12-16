CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BankFinancialReport_Deposit_Get_V3`(
    IN _SiteId INT,
    IN _CurrencyIds JSON,
    IN _Agents JSON,
    IN _Channel JSON,
    IN _FinancialAccountIds JSON,
    IN _StartTime DATETIME,
    IN _EndTime DATETIME
    /*
  Created: 20241125@Liam 
        DB: TSDB-TSDB
        Task: correct datetime 
         Revisions:
                - 20241125@Liam: correct datetime 
*/ 
)
BEGIN
    
   
    SET @StartDate = _StartTime;
    SET @EndDate = _EndTime;
    SET @StartDate_C = DATE_SUB(@StartDate, INTERVAL 7 DAY);
    SET @EndDate_C = DATE_ADD(@EndDate, INTERVAL 1 DAY);
    
    SELECT
        DI.CurrencyId,
        IFNULL(BFTA.Id, BFTA2.Id) AS FinancialId,
        IFNULL(BFTA.AccountNo, IFNULL(BFTA2.AccountNo, DI.DepositInfo->>'$.AccountNo')) AS AccountNo,
        IF(DI.DepositType = 3, BFTA.Agent, PL.PayName) AS Agent,
        IF(DI.DepositType = 3, 1, 3) AS Channel,
        98 AS TransferType,
        SUM(DI.ActualDeposit) AS Summary,
        SUM(DI.Fee) AS FeeSummary
    FROM DepositInfo AS DI
    INNER JOIN Customer AS C ON DI.CustId = C.CustId
    LEFT JOIN BankFinancialTransferAccount AS BFTA
        ON DI.DepositInfo->>'$.AccountNo' = BFTA.AccountNo AND BFTA.SiteId = _SiteId
    LEFT JOIN BankFinancialTransferAccount AS BFTA2
        ON CAST(DI.DepositInfo->>'$.PayId' AS UNSIGNED INTEGER) = BFTA2.PayId AND BFTA2.SiteId = _SiteId AND BFTA2.CurrencyId = DI.CurrencyId
    LEFT JOIN PayList AS PL ON PL.Id = CAST(DI.DepositInfo->>'$.PayId' AS UNSIGNED INTEGER)
    WHERE DI.`status` = 3
        AND C.IsTest = 0
        AND DI.SiteId = _SiteId
        AND DI.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS Temp)
        AND (_Agents IS NULL
            OR BFTA.Agent IN (SELECT * FROM JSON_TABLE(_Agents, '$[*]' COLUMNS(`Agent` VARCHAR(50) PATH "$")) AS Temp))
        AND (_Channel IS NULL
            OR BFTA.`Channel` IN (SELECT * FROM JSON_TABLE(_Channel, '$[*]' COLUMNS(`Channel` TINYINT PATH "$")) AS Temp))
        AND (_FinancialAccountIds IS NULL
            OR BFTA.Id IN (SELECT * FROM JSON_TABLE(_FinancialAccountIds, '$[*]' COLUMNS(`Id` INT PATH "$")) AS Temp)
            OR BFTA2.Id IN (SELECT * FROM JSON_TABLE(_FinancialAccountIds, '$[*]' COLUMNS(`Id` INT PATH "$")) AS Temp))
        AND DI.CreateTime BETWEEN @StartDate_C AND @EndDate_C
        AND DI.StatementTime BETWEEN @StartDate AND @EndDate
    GROUP BY CurrencyId,
        IFNULL(BFTA.Id, BFTA2.Id),
        IFNULL(BFTA.AccountNo, IFNULL(BFTA2.AccountNo, DI.DepositInfo->>'$.AccountNo')),
        IF(DI.DepositType = 3, BFTA.Agent, PL.PayName),
        IF(DI.DepositType = 3, 1, 3)
    ;
   
END