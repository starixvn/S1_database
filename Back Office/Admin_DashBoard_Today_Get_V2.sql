/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DashBoard_Today_Get_V2`(
	IN _SiteIds JSON,
    IN _CurrencyId INT,
    IN _BaseCurrencyId INT,
    IN _StartDate DATETIME,
    IN _EndDate DATETIME
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

    SELECT
        COUNT(DISTINCT(AI.CustId)),
        IFNULL(ROUND(SUM(IF(AI.AdjustType = 2,AI.Amount * -1 * CY.ActualRate / @BaseRateToMYR,AI.Amount * CY.ActualRate / @BaseRateToMYR)),2),0)
    INTO
        @NoAdjustmentPlayers,
        @NoAdjustmentAmount
    FROM
        AdjustmentInfo AI
        JOIN Currency AS CY ON CY.CurrencyId = AI.CurrencyId
    WHERE
        AI.`Status` = 2 AND
        AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
        (_CurrencyId = 0 OR (_CurrencyId != 0 AND AI.CurrencyId = _CurrencyId)) AND
        AI.CreateTime BETWEEN _StartDate AND _EndDate;

    SELECT SUM(DI.ActualDeposit * CY.ActualRate / @BaseRateToMYR)
    INTO
        @TotalDeposit
    FROM DepositInfo AS DI
             JOIN Currency AS CY ON CY.CurrencyId = DI.CurrencyId
    WHERE DI.`status` = 3
      AND DI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS (`SiteId` INT PATH "$")) AS Temp)
      AND (_CurrencyId = 0 OR (_CurrencyId != 0 AND DI.CurrencyId = _CurrencyId))
      AND DI.CreateTime >= DATE_ADD(_StartDate, INTERVAL -7 DAY)
      AND IF(DI.DepositTime IS NULL,
             DI.UpdateTime BETWEEN _StartDate AND _EndDate,
             DI.DepositTime BETWEEN _StartDate AND _EndDate);

    SELECT
        SUM(WI.Amount * CY.ActualRate / @BaseRateToMYR)
    INTO
        @TotalWithdrawal
    FROM
        WithdrawalInfo WI
        JOIN Currency AS CY ON CY.CurrencyId = WI.CurrencyId
    WHERE
        WI.`status` = 6 AND
        WI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
         (_CurrencyId = 0 OR (_CurrencyId != 0 AND WI.CurrencyId = _CurrencyId)) AND
        WI.FlowEndTime BETWEEN _StartDate AND _EndDate;

    SELECT
        SUM(BI.BonusAmount * CY.ActualRate / @BaseRateToMYR)
    INTO
        @Bonus
    FROM
        BonusInfo BI
        JOIN Currency AS CY ON CY.CurrencyId = BI.CurrencyId
    WHERE
        BI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
         (_CurrencyId = 0 OR (_CurrencyId != 0 AND BI.CurrencyId = _CurrencyId)) AND
        BI.CreateTime BETWEEN _StartDate AND _EndDate;

    SELECT
        SUM(DL.Amount * CY.ActualRate/ @BaseRateToMYR)
    INTO
        @DrawPrize
    FROM
        DrawLog AS DL
        INNER JOIN DrawPrize AS DP ON DP.EventId = DL.EventId AND DP.PrizeId = DL.PrizeId
        INNER JOIN EventDraw AS ED ON ED.EventId = DL.EventId
        JOIN Currency AS CY ON DP.CurrencyId = CY.CurrencyId
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
    WHERE
        AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
         (_CurrencyId = 0 OR (_CurrencyId != 0 AND AI.CurrencyId = _CurrencyId)) AND
        AI.CreateTime BETWEEN _StartDate AND _EndDate AND
        AI.AdjustType = 3 AND
        AI.Status = 2;

    SELECT
        count(distinct(TBR.CustId)),
        SUM(IFNULL(TBR.ValidBet,TBR.Stake) * CY.ActualRate / @BaseRateToMYR),
        SUM(IF(TBR.GameType IN (41,42),IFNULL(Revenue,0) * CY.ActualRate / @BaseRateToMYR,WinlostAmount * CY.ActualRate / @BaseRateToMYR*-1))
    INTO
        @NoPlayer,
        @VaildTurnover,
        @GGR
    FROM
        TpBetRecord TBR FORCE INDEX (ix_SettledTime)
        JOIN Currency AS CY ON CY.CurrencyId = TBR.CurrencyId
    WHERE
        TBR.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS Temp) AND
         (_CurrencyId = 0 OR (_CurrencyId != 0 AND TBR.CurrencyId = _CurrencyId)) AND
        TBR.SettledTime BETWEEN _StartDate AND _EndDate AND
        TBR.SettlementType IN (1,3);

    SELECT
        "Today" AS ReportName,
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
END$$
DELIMITER ;






