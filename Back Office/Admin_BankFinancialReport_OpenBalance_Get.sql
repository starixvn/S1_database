/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BankFinancialReport_OpenBalance_Get`(
    IN _SiteId INT,
    IN _FinancialIds JSON,
    IN _StartTime DATETIME
    /*
      Created: 20250109@Johnny
      DB: TSDB-TSDB
      Task: Correct calculate Open Balance

      Revisions:
          - 20250109@Johnny: Init sp
    */   
)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS Tmp_AccountInfo;
    CREATE TEMPORARY TABLE Tmp_AccountInfo ( 
        FinancialId INT NOT NULL,
        AccountNo VARCHAR(50) NOT NULL,
        DisplayName VARCHAR(80) NOT NULL,
        PayId INT,
        ClosingBalance DECIMAL(20,4) NOT NULL,
        ClosingTime DATETIME NOT NULL,
        PRIMARY KEY (FinancialId)
    );
    
    
    INSERT INTO Tmp_AccountInfo
    (
        FinancialId,
        AccountNo,
        DisplayName,
        PayId,
        ClosingBalance,
        ClosingTime
    )
    SELECT
        BFTA.Id,
        BFTA.AccountNo,
        BFTA.DisplayName,
        BFTA.PayId,
        IFNULL(TCB.ClosingBalance, BFTA.InitialAmount),
        IFNULL(TCB.ClosingTime, BFTA.InitialTime)
    FROM BankFinancialTransferAccount AS BFTA
    LEFT JOIN 
    (
        SELECT
            FACB.FinancialAccountId,
            FACB.ClosingBalance,
            FACB.ClosingTime
        FROM FinancialAccountClosingBalance AS FACB
        WHERE FACB.ClosingTime <= _StartTime AND FACB.ClosingTime > DATE_ADD( _StartTime, INTERVAL -1 MONTH)
    ) AS TCB ON TCB.FinancialAccountId = BFTA.Id
    WHERE BFTA.SiteId = _SiteId
        AND EXISTS (SELECT 1
					FROM JSON_TABLE(_FinancialIds, '$[*]' COLUMNS(Id INT PATH "$")) AS FI
                    WHERE BFTA.Id = FI.Id);
    
    DROP TEMPORARY TABLE IF EXISTS Tmp_TransferInfo;
    CREATE TEMPORARY TABLE Tmp_TransferInfo ( 
        FinancialId INT NOT NULL,
        Summary DECIMAL(20,4) NOT NULL,
        PRIMARY KEY (FinancialId)
    );
    
    
    INSERT INTO Tmp_TransferInfo
    (
        FinancialId,
        Summary
    )
    SELECT
        TAI.FinancialId,
        SUM(IF(TI.PlusOrMinus = 1, TI.Amount, TI.Amount * -1)) AS Summary
    FROM BankFinancialTransferInfo AS TI
    INNER JOIN Tmp_AccountInfo AS TAI ON TI.AccountNo = TAI.AccountNo
    WHERE TI.SiteId = _SiteId
        AND TI.TransDate BETWEEN TAI.ClosingTime AND _StartTime
    GROUP BY TAI.FinancialId;
    
    
    INSERT INTO Tmp_TransferInfo
    (
        FinancialId,
        Summary
    )
    SELECT FinancialId, Summary
    FROM
    (
        SELECT
            TAI.FinancialId,
            SUM(DI.ActualDeposit) AS Summary
        FROM DepositInfo AS DI
        INNER JOIN Customer AS C ON DI.CustId = C.CustId
        INNER JOIN Tmp_AccountInfo AS TAI ON DI.DepositInfo->>'$.AccountNo' = TAI.AccountNo
        WHERE DI.`status` = 3
            AND C.IsTest = 0
            AND DI.SiteId = _SiteId
            AND DI.StatementTime BETWEEN TAI.ClosingTime AND _StartTime
        GROUP BY TAI.FinancialId
    ) tmp
    ON DUPLICATE KEY UPDATE
        Tmp_TransferInfo.Summary = Tmp_TransferInfo.Summary + tmp.Summary;
    
    INSERT INTO Tmp_TransferInfo
    (
        FinancialId,
        Summary
    )
    SELECT FinancialId, Summary
    FROM
    (
        SELECT
            TAI.FinancialId,
            SUM(DI.ActualDeposit) AS Summary
        FROM DepositInfo AS DI
        INNER JOIN Customer AS C ON DI.CustId = C.CustId
        INNER JOIN Tmp_AccountInfo AS TAI ON CAST(DI.DepositInfo->>'$.PayId' AS UNSIGNED INTEGER) = TAI.PayId
        WHERE DI.`status` = 3
            AND C.IsTest = 0
            AND DI.SiteId = _SiteId
            AND DI.StatementTime BETWEEN TAI.ClosingTime AND _StartTime
        GROUP BY TAI.FinancialId
    ) tmp
    ON DUPLICATE KEY UPDATE
        Tmp_TransferInfo.Summary = Tmp_TransferInfo.Summary + tmp.Summary;
    
    
    INSERT INTO Tmp_TransferInfo
    (
        FinancialId,
        Summary
    )
    SELECT FinancialId, Summary
    FROM
    (
        SELECT
            TAI.FinancialId,
            SUM(WI.Amount * -1) AS Summary
        FROM WithdrawalInfo AS WI
        INNER JOIN Customer AS C ON WI.CustId = C.CustId
        INNER JOIN Tmp_AccountInfo AS TAI ON WI.WithdrawalInfo->>'$.AccountNo' = TAI.AccountNo
        LEFT JOIN WithdrawalBankAccounting AS WBA ON WBA.TransId = WI.TransId
        WHERE WI.`status` = 6
            AND C.IsTest = 0
            AND WI.SiteId = _SiteId
            AND WI.FlowEndTime BETWEEN TAI.ClosingTime AND _StartTime
            AND WBA.TransId IS NULL
        GROUP BY TAI.FinancialId
    ) tmp
    ON DUPLICATE KEY UPDATE
        Tmp_TransferInfo.Summary = Tmp_TransferInfo.Summary + tmp.Summary;
    
    INSERT INTO Tmp_TransferInfo
    (
        FinancialId,
        Summary
    )
    SELECT FinancialId, Summary
    FROM
    (
        SELECT
            TAI.FinancialId,
            SUM(WBA.Amount * -1) AS Summary
        FROM WithdrawalInfo AS WI
        INNER JOIN Customer AS C ON WI.CustId = C.CustId
        INNER JOIN WithdrawalBankAccounting AS WBA ON WBA.TransId = WI.TransId
        INNER JOIN Tmp_AccountInfo AS TAI ON WBA.BankAccountNo = TAI.AccountNo
        WHERE WI.`status` = 6
            AND C.IsTest = 0
            AND WI.SiteId = _SiteId
            AND WI.FlowEndTime BETWEEN TAI.ClosingTime AND _StartTime
        GROUP BY TAI.FinancialId
    ) tmp
    ON DUPLICATE KEY UPDATE
        Tmp_TransferInfo.Summary = Tmp_TransferInfo.Summary + tmp.Summary;
    
    INSERT INTO Tmp_TransferInfo
    (
        FinancialId,
        Summary
    )
    SELECT FinancialId, Summary
    FROM
    (
        SELECT
            TAI.FinancialId,
            SUM(WI.Amount * -1) AS Summary
        FROM WithdrawalInfo AS WI
        INNER JOIN Customer AS C ON WI.CustId = C.CustId
        INNER JOIN Tmp_AccountInfo AS TAI ON CAST(WI.WithdrawalInfo->>'$.PayId' AS UNSIGNED INTEGER) = TAI.PayId
        WHERE WI.`status` = 6
            AND C.IsTest = 0
            AND WI.SiteId = _SiteId
            AND WI.FlowEndTime BETWEEN TAI.ClosingTime AND _StartTime
        GROUP BY TAI.FinancialId
    ) tmp
    ON DUPLICATE KEY UPDATE
        Tmp_TransferInfo.Summary = Tmp_TransferInfo.Summary + tmp.Summary;
    SELECT
        TA.FinancialId,
        TA.DisplayName,
        TA.ClosingBalance + IFNULL(TTI.Summary, 0) AS OpenBalance
    FROM Tmp_AccountInfo AS TA
    LEFT JOIN Tmp_TransferInfo AS TTI ON TA.FinancialId = TTI.FinancialId;
END$$
DELIMITER ;