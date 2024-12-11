/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DashBoard_TodayExtra_Get_V2`(
	IN _SiteIds JSON,
    IN _CurrencyId INT,
    IN _BaseCurrencyId INT,
    IN _StartDate DATETIME,
    IN _EndDate DATETIME,
    IN _Type INT
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Update get dashboard data
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
    
    SELECT
        ActualRate
    INTO
        @BaseRateToMYR
    FROM
        Currency AS C
    WHERE
        C.CurrencyId = _BaseCurrencyId;

    CREATE TEMPORARY TABLE IF NOT EXISTS Temp_Table
    (
        CustId INT PRIMARY KEY
    );

    IF _Type = 0 THEN
        SET @ReportName = "Today Deposit";
        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT DISTINCT(DI.CustId)
        FROM DepositInfo AS DI
        WHERE DI.CreateTime >= DATE_ADD(_StartDate, INTERVAL -7 DAY)
          AND ((DI.DepositTime IS NULL AND DI.UpdateTime BETWEEN _StartDate AND _EndDate)
            OR (DI.DepositTime IS NOT NULL AND DI.DepositTime BETWEEN _StartDate AND _EndDate))
          AND DI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS (`SiteId` INT PATH "$")) AS Temp)
          AND (_CurrencyId = 0 OR (_CurrencyId != 0 AND DI.CurrencyId = _CurrencyId))
          AND DI.`status` = 3;
    END IF;


    IF _Type = 1 THEN
        SET @ReportName = "Today Withdrawal";
        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT DISTINCT(WI.CustId)
        FROM WithdrawalInfo AS WI
        WHERE WI.`status` = 6 AND
        WI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND WI.CurrencyId = _CurrencyId)) AND
        WI.FlowEndTime BETWEEN _StartDate AND _EndDate;
    END IF;


    IF _Type = 2 THEN
        
        SET @ReportName = "Today First Deposit";
        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT DISTINCT(DI.CustId)
        FROM DepositInfo AS DI
        WHERE DI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS (`SiteId` INT PATH "$")) AS Temp)
          AND (_CurrencyId = 0 OR (_CurrencyId != 0 AND DI.CurrencyId = _CurrencyId))
          AND DI.`status` = 3
          AND DI.CreateTime >= DATE_ADD(_StartDate, INTERVAL -7 DAY)
          AND ((DI.DepositTime IS NULL AND DI.UpdateTime BETWEEN _StartDate AND _EndDate)
            OR (DI.DepositTime IS NOT NULL AND DI.DepositTime BETWEEN _StartDate AND _EndDate))
          AND DI.FirstDeposit = 1;
    END IF;


    IF _Type = 3 THEN
        
        SET @ReportName = "Today Second Deposit";
        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT CustId
        FROM (SELECT CustId,
                     IFNULL(DepositTime, UpdateTime) AS _recorddate,
                     DENSE_RANK() OVER ( PARTITION BY CustId ORDER BY IFNULL(DepositTime, UpdateTime) ASC) AS _no
              FROM DepositInfo AS DI
              WHERE DI.SiteId IN
                    (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS (`SiteId` INT PATH "$")) AS Temp)
                AND (_CurrencyId = 0 OR (_CurrencyId != 0 AND DI.CurrencyId = _CurrencyId))
                AND DI.`status` = 3
                AND DI.CreateTime < _EndDate) AS _TempDepositSort
        WHERE _no = 2
          AND _recorddate BETWEEN _StartDate AND _EndDate;
    END IF;


    IF _Type = 4 THEN
        SET @ReportName = "Today Bonus Claim";

        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT distinct(BI.CustId)
        FROM BonusInfo BI
        WHERE BI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND BI.CurrencyId = _CurrencyId)) AND
        BI.CreateTime BETWEEN _StartDate AND _EndDate;

        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT distinct(DL.CustId)
        FROM DrawLog AS DL FORCE INDEX (ix_DrawEventDate)
        INNER JOIN DrawPrize AS DP ON DP.EventId = DL.EventId AND DP.PrizeId = DL.PrizeId
        INNER JOIN EventDraw AS ED ON ED.EventId = DL.EventId
        WHERE ED.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND DP.CurrencyId = _CurrencyId)) AND
        DL.DrawEventDate BETWEEN _StartDate AND _EndDate;

        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT distinct(RC.CustId)
        FROM RebateCLog AS RC
        WHERE RC.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND RC.CurrencyId = _CurrencyId)) AND
        RC.CreateTime BETWEEN _StartDate AND _EndDate AND
        RC.RebateType = 1;

        INSERT IGNORE INTO Temp_Table(CustId)
        SELECT distinct(AI.CustId)
        FROM AdjustmentInfo AS AI
        WHERE AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND AI.CurrencyId = _CurrencyId)) AND
        AI.CreateTime BETWEEN _StartDate AND _EndDate AND
        AI.AdjustType = 3 AND
        AI.Status = 2;
    END IF;

    SELECT
        COUNT(T.CustId)
    INTO
        @NoPlayer
    FROM
        Temp_Table AS T;

    SELECT
        COUNT(DISTINCT(AI.CustId)),
        IFNULL(ROUND(SUM(IF(AI.AdjustType = 2,AI.Amount * -1 * CY.ActualRate / @BaseRateToMYR,AI.Amount * CY.ActualRate / @BaseRateToMYR)),2),0)
    INTO
        @NoAdjustmentPlayers,
        @NoAdjustmentAmount
    FROM
        AdjustmentInfo AI
        JOIN Currency AS CY ON CY.CurrencyId = AI.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = AI.CustId
    WHERE
        AI.`Status` = 2 AND
        AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND AI.CurrencyId = _CurrencyId)) AND
        AI.CreateTime BETWEEN _StartDate AND _EndDate;

    SELECT SUM(DIT.ActualDeposit * CY.ActualRate / @BaseRateToMYR)
    INTO
        @TotalDeposit
    FROM DepositInfo AS DIT
             JOIN Currency AS CY ON CY.CurrencyId = DIT.CurrencyId
             INNER JOIN Temp_Table AS T ON T.CustId = DIT.CustId
    WHERE DIT.`status` = 3
      AND DIT.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS (`SiteId` INT PATH "$")) AS Temp)
      AND (_CurrencyId = 0 OR (_CurrencyId != 0 AND DIT.CurrencyId = _CurrencyId))
      AND DIT.CreateTime >= DATE_ADD(_StartDate, INTERVAL -7 DAY)
      AND ((DIT.DepositTime IS NULL AND DIT.UpdateTime BETWEEN _StartDate AND _EndDate)
        OR (DIT.DepositTime IS NOT NULL AND DIT.DepositTime BETWEEN _StartDate AND _EndDate));

    SELECT
        SUM(WI.Amount * CY.ActualRate / @BaseRateToMYR)
    INTO
        @TotalWithdrawal
    FROM
        WithdrawalInfo WI
        JOIN Currency AS CY ON CY.CurrencyId = WI.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = WI.CustId
    WHERE
        WI.`status` = 6 AND
        WI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND WI.CurrencyId = _CurrencyId)) AND
        WI.UpdateTime BETWEEN _StartDate AND _EndDate;

    SELECT
        SUM(BI.BonusAmount * CY.ActualRate / @BaseRateToMYR)
    INTO
        @Bonus
    FROM
        BonusInfo BI
        JOIN Currency AS CY ON CY.CurrencyId = BI.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = BI.CustId
    WHERE
        BI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND BI.CurrencyId = _CurrencyId)) AND
        BI.CreateTime BETWEEN _StartDate AND _EndDate;

    SELECT
        SUM(DL.Amount * CY.ActualRate/ @BaseRateToMYR)
    INTO
        @DrawPrize
    FROM
        DrawLog AS DL FORCE INDEX (ix_DrawEventDate)
        INNER JOIN DrawPrize AS DP ON DP.EventId = DL.EventId AND DP.PrizeId = DL.PrizeId
        INNER JOIN EventDraw AS ED ON ED.EventId = DL.EventId
        JOIN Currency AS CY ON DP.CurrencyId = CY.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = DL.CustId
    WHERE
        ED.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND DP.CurrencyId = _CurrencyId)) AND
        DL.DrawEventDate BETWEEN _StartDate AND _EndDate;

    SELECT
        SUM(RC.RedeemAmount * CY.ActualRate/ @BaseRateToMYR)
    INTO
        @VIPRebate
    FROM
        RebateCLog AS RC
        LEFT JOIN Currency AS CY ON CY.CurrencyId = RC.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = RC.CustId
    WHERE
        RC.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND RC.CurrencyId = _CurrencyId)) AND
        RC.CreateTime BETWEEN _StartDate AND _EndDate AND
        RC.RebateType = 1;

    SELECT
        SUM(AI.Amount * CY.ActualRate / @BaseRateToMYR)
    INTO
        @AdjustmentBonus
    FROM
        AdjustmentInfo AS AI
        INNER JOIN Currency AS CY ON CY.CurrencyId = AI.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = AI.CustId
    WHERE
        AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND AI.CurrencyId = _CurrencyId)) AND
        AI.CreateTime BETWEEN _StartDate AND _EndDate AND
        AI.AdjustType = 3 AND
        AI.Status = 2;

    SELECT
        SUM(IFNULL(TBR.ValidBet,TBR.Stake) * CY.ActualRate / @BaseRateToMYR),
        SUM(IF(TBR.GameType IN (41,42),IFNULL(Revenue,0) * CY.ActualRate / @BaseRateToMYR,WinlostAmount * CY.ActualRate / @BaseRateToMYR*-1))
    INTO
        @VaildTurnover,
        @GGR
    FROM
        TpBetRecord TBR FORCE INDEX (ix_SettledTime, ix_CustId)
        JOIN Currency AS CY ON CY.CurrencyId = TBR.CurrencyId
        INNER JOIN Temp_Table AS T ON T.CustId = TBR.CustId
    WHERE
        TBR.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND TBR.CurrencyId = _CurrencyId)) AND
        TBR.SettledTime BETWEEN _StartDate AND _EndDate  AND
        TBR.SettlementType IN (1,3);

    SELECT
        @ReportName AS ReportName,
        @NoPlayer AS NoPlayer,
        @NoAdjustmentAmount AS NoAdjustmentAmount,
        @NoAdjustmentPlayers AS NoAdjustmentPlayers,
        @TotalDeposit AS TotalDeposit,
        @TotalWithdrawal AS TotalWithdrawal,
        (IFNULL(@Bonus,0) + IFNULL(@DrawPrize,0) + IFNULL(@VIPRebate,0) + IFNULL(@AdjustmentBonus,0)) AS TotalBonus,
        @VaildTurnover AS VaildTurnover,
        @GGR AS GGR,
        IFNULL(@GGR,0) * 100/IFNULL(@VaildTurnover,0) AS Margin,
        IFNULL(@GGR,0)-(IFNULL(@Bonus,0) + IFNULL(@DrawPrize,0) + IFNULL(@VIPRebate,0) + IFNULL(@AdjustmentBonus,0)) AS NetRevenue,
        IFNULL(@TotalDeposit,0)-IFNULL(@TotalWithdrawal,0) AS NetCash;

    DROP TEMPORARY TABLE IF EXISTS Temp_Table;
END$$
DELIMITER ;






