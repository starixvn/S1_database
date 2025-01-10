/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_FinancialAccount_ClosingBalance_Set`(
    IN _FinancialAccountId INT,
    IN _YYYYMM CHAR(6),
    OUT _Result INT
    /*
      Created: 20250109@Johnny
      DB: TSDB-TSDB
      Task: Correct calculate ClosingBalance

      Revisions:
          - 20250109@Johnny: Init sp
    */   
)
ClosingBlance:BEGIN
    
    
    SET _Result = -9; 
    SET @LastDay = LAST_DAY(STR_TO_DATE(CONCAT(_YYYYMM, '01'),'%Y%m%d'));
    SET @ClosingTime = DATE_ADD(@LastDay, INTERVAL 1 DAY);
    SET @OpenBalance = null, @StartTime = null;
    
    SELECT
        BFTA.SiteId,
        BFTA.DisplayName,
        BFTA.AccountNo,
        BFTA.PayId,
        BFTA.InitialAmount,
        BFTA.InitialTime
    INTO @SiteId, @DisplayName, @AccountNo, @PayId, @OpenBalance, @StartTime
    FROM BankFinancialTransferAccount AS BFTA
    WHERE BFTA.Id = _FinancialAccountId;
    
    
    IF @StartTime > @ClosingTime THEN
        SET _Result = -1;
        LEAVE ClosingBlance;
    END IF;
    
    
    SELECT
        ClosingBalance,
        ClosingTime
    INTO @OpenBalance, @StartTime
    FROM FinancialAccountClosingBalance
    WHERE FinancialAccountId = _FinancialAccountId AND ClosingTime >= DATE_ADD(NOW(), INTERVAL -2 MONTH)
    ORDER BY ClosingTime DESC
    LIMIT 1;
    
    SELECT @StartTime AS StartTime, @ClosingTime AS ClosingTime;
    
    
    IF @StartTime > @ClosingTime THEN
        SET _Result = -2;
        LEAVE ClosingBlance;
    END IF;
    
    SET @Summary = 0;
    
    SELECT SUM(IF(TI.PlusOrMinus = 1, TI.Amount, TI.Amount * -1))
    INTO @TransferSummary
    FROM BankFinancialTransferInfo AS TI
    WHERE TI.SiteId = @SiteId
        AND TI.AccountNo = @AccountNo
        AND TI.TransDate >= @StartTime AND TI.TransDate < @ClosingTime;
    
    SET @Summary = @Summary + IFNULL(@TransferSummary, 0);
    
    IF @PayId IS NULL THEN
        BEGIN
            SELECT SUM(DI.ActualDeposit)
            INTO @DepositSummary
            FROM DepositInfo AS DI
            INNER JOIN Customer AS C ON DI.CustId = C.CustId
            WHERE DI.`status` = 3
                AND C.IsTest = 0
                AND DI.SiteId = @SiteId
                AND DI.DepositInfo->>'$.AccountNo' = @AccountNo
                AND DI.StatementTime >= @StartTime AND DI.StatementTime < @ClosingTime;
        END;
    ELSE
        BEGIN
            SELECT SUM(DI.ActualDeposit)
            INTO @DepositSummary
            FROM DepositInfo AS DI
            INNER JOIN Customer AS C ON DI.CustId = C.CustId
            WHERE DI.`status` = 3
                AND C.IsTest = 0
                AND DI.SiteId = @SiteId
                AND DI.DepositInfo->>'$.PayId' = @PayId
                AND DI.StatementTime >= @StartTime AND DI.StatementTime < @ClosingTime;
        END;
    END IF;
    
    SET @Summary = @Summary + IFNULL(@DepositSummary, 0);
    
    IF @PayId IS NULL THEN
        BEGIN
            SELECT SUM(WI.Amount)
            INTO @WithdrawalSummary
            FROM WithdrawalInfo AS WI
            INNER JOIN Customer AS C ON WI.CustId = C.CustId
            LEFT JOIN WithdrawalBankAccounting AS WBA ON WBA.TransId = WI.TransId
            WHERE WI.`status` = 6
                AND C.IsTest = 0
                AND WI.SiteId = @SiteId
                AND WI.WithdrawalInfo->>'$.FromAccountNo' = @AccountNo
                AND WI.FlowEndTime >= @StartTime AND WI.FlowEndTime < @ClosingTime;
        END;
    ELSE
        BEGIN
            SELECT SUM(WI.Amount)
            INTO @WithdrawalSummary
            FROM WithdrawalInfo AS WI
            INNER JOIN Customer AS C ON WI.CustId = C.CustId
            WHERE WI.`status` = 6
                AND C.IsTest = 0
                AND WI.SiteId = @SiteId
                AND WI.WithdrawalInfo->>'$.PayId' = @PayId
                AND WI.FlowEndTime >= @StartTime AND WI.FlowEndTime < @ClosingTime;
        END;
    END IF;
    
    SET @Summary = @Summary - IFNULL(@WithdrawalSummary, 0);
    
    INSERT INTO FinancialAccountClosingBalance
    (
        FinancialAccountId,
        ClosingTime,
        ClosingBalance
    )
    SELECT _FinancialAccountId, @ClosingTime, @OpenBalance + @Summary
    ON DUPLICATE KEY UPDATE
        ClosingBalance = @OpenBalance + @Summary;
    
    IF ROW_COUNT() < 1 THEN
        SET _Result = -3;
        LEAVE ClosingBlance;
    END IF;
    
    SELECT
        @OpenBalance + @Summary AS ClosingBalance,
        @TransferSummary AS TransferSummary,
        @DepositSummary AS DepositSummary,
        @WithdrawalSummary AS WithdrawalSummary;
    
    SET _Result = 0;  
END$$
DELIMITER ;