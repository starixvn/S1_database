CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BankFinancialReport_Withdrawal_Get_V3`(
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
   
    SELECT
        WI.CurrencyId,
        IF(WI.WithdrawalType = 1, BFTA2.Id, IFNULL(BFTA.Id, BFTA3.Id)) AS FinancialId,
        IFNULL(BFTA.AccountNo, IFNULL(BFTA3.AccountNo, WI.WithdrawalInfo->>'$.FromAccountNo'))  AS AccountNo,
        IF(WI.WithdrawalType = 2, BFTA.Agent, PL.PayName) AS Agent,
        IF(WI.WithdrawalType = 2, 1, 3) AS Channel,
        99 AS TransferType,
        SUM(IFNULL(WBA.Amount, WI.Amount) * -1) AS Summary,
        SUM(IFNULL(WBA.ChargeFee, WI.ChargeFee)) AS FeeSummary
    FROM WithdrawalInfo AS WI
    INNER JOIN Customer AS C ON WI.CustId = C.CustId
    LEFT JOIN WithdrawalBankAccounting AS WBA
        ON WI.TransId = WBA.TransId
    LEFT JOIN BankFinancialTransferAccount AS BFTA
        ON WI.WithdrawalInfo->>'$.FromAccountNo' = BFTA.AccountNo AND BFTA.SiteId = _SiteId
    LEFT JOIN BankFinancialTransferAccount AS BFTA2
        ON CAST(WI.WithdrawalInfo->>'$.PayId' AS UNSIGNED INTEGER) = BFTA2.PayId AND BFTA2.SiteId = _SiteId AND BFTA2.CurrencyId = WI.CurrencyId
    LEFT JOIN BankFinancialTransferAccount AS BFTA3
        ON WBA.BankAccountNo = BFTA3.AccountNo AND BFTA.SiteId = _SiteId
    LEFT JOIN PayList AS PL ON PL.Id = CAST(WI.WithdrawalInfo->>'$.PayId' AS UNSIGNED INTEGER)
    WHERE WI.`status` = 6
        AND C.IsTest = 0
        AND WI.SiteId = _SiteId
        AND WI.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS Temp)
        AND (_Agents IS NULL
            OR BFTA.Agent IN (SELECT * FROM JSON_TABLE(_Agents, '$[*]' COLUMNS(`Agent` VARCHAR(50) PATH "$")) AS Temp))
        AND (_Channel IS NULL
            OR BFTA.`Channel` IN (SELECT * FROM JSON_TABLE(_Channel, '$[*]' COLUMNS(`Channel` TINYINT PATH "$")) AS Temp))
        AND (_FinancialAccountIds IS NULL
            OR BFTA.Id IN (SELECT * FROM JSON_TABLE(_FinancialAccountIds, '$[*]' COLUMNS(`Id` INT PATH "$")) AS Temp))
        AND WI.FlowEndTime BETWEEN @StartDate AND @EndDate
    GROUP BY WI.CurrencyId,
        IF(WI.WithdrawalType = 1, BFTA2.Id, IFNULL(BFTA.Id, BFTA3.Id)),
        IFNULL(BFTA.AccountNo, IFNULL(BFTA3.AccountNo, WI.WithdrawalInfo->>'$.FromAccountNo')),
        IF(WI.WithdrawalType = 2, BFTA.Agent, PL.PayName),
        IF(WI.WithdrawalType = 2, 1, 3)
    ;
END