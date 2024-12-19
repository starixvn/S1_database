/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BonusSummaryDetail_Get_V2`(
	IN _MultiSiteRequest JSON, 
    IN _BonusCode VARCHAR(50),
    IN _StartDate DATETIME,
    IN _EndDate DATETIME,
    IN _ClaimStatuses JSON,
    IN _BaseCurrencyId INT,
    IN _TimeZone VARCHAR(6)
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Limit show percent don't exceed 100%
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS `TempPaymentSummaryForBonusSummaryDetail`;

     CREATE TEMPORARY TABLE TempPaymentSummaryForBonusSummaryDetail ( 
        CustId INT NOT NULL PRIMARY KEY,
        TotalDeposit DECIMAL(20,4) NOT NULL,
        TotalWithdrawal DECIMAL(20,4) NOT NULL
    );
            
    INSERT INTO TempPaymentSummaryForBonusSummaryDetail
    SELECT 
        PS.CustId,
        SUM(CASE When SummaryType = 1 Then PS.SuccessAmount Else 0 End ) as TotalDeposit,
        SUM(CASE When SummaryType = 2 Then PS.SuccessAmount Else 0 End ) as TotalWithdrawal
    FROM
        PaymentSummary AS PS
    WHERE
        PS.SuccessAmount != 0
    AND PS.Time BETWEEN _StartDate AND _EndDate
    GROUP BY PS.CustId ;
    
    SELECT      C.CurrencyId,
                CY.IsoCode AS CurrencyName,
                C.SiteId,
                SI.SiteName,
                C.UserName,
                BSD.BonusCode,
                CONVERT_TZ(BSD.ClaimDate, @@session.time_zone, _TimeZone) AS ClaimDate, 
                CASE WHEN _BaseCurrencyId = 0 THEN BSD.BonusAmountClaim ELSE (BSD.BonusAmountClaim * ER.Rate ) END AS BonusAmountClaim,
                BSD.TransactionType,
                BSD.ClaimStatus,
                CASE WHEN _BaseCurrencyId = 0 THEN TPS.TotalDeposit ELSE (TPS.TotalDeposit * ER.Rate ) END AS TotalDeposit,
                CASE WHEN _BaseCurrencyId = 0 THEN TPS.TotalWithdrawal ELSE (TPS.TotalWithdrawal * ER.Rate ) END AS TotalWithdrawal,
                LEAST((BSD.Turnover / BSD.Rollover) * 100, 100)  AS `Completion`
            FROM
                BonusSummaryDetail AS BSD
                    INNER JOIN 
                Customer AS C ON C.CustId = BSD.CustId
                    INNER JOIN 
                Currency AS CY ON CY.CurrencyId = BSD.CurrencyId
                    LEFT JOIN
                TempPaymentSummaryForBonusSummaryDetail AS TPS ON TPS.CustId = BSD.CustId
                    LEFT JOIN 
                ExchangeRate AS ER ON ( IF( EXTRACT(YEAR_MONTH FROM BSD.ClaimDate) < EXTRACT(YEAR_MONTH FROM NOW()) , ER.RateDate = LAST_DAY(BSD.ClaimDate) , ER.RateDate = DATE(BSD.ClaimDate) )
                                    AND ER.CurrencyId = BSD.CurrencyId
                                    AND ER.TargetCurrencyId = _BaseCurrencyId)
                    LEFT JOIN
                ServerInfo AS SI ON BSD.SiteId = SI.SiteId
                    INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
            ON BSD.SiteId = SC.SiteId AND BSD.CurrencyId = SC.CurrencyId
            WHERE
                BSD.BonusCode = _BonusCode
            AND BSD.ClaimDate BETWEEN _StartDate AND _EndDate
            AND BSD.BonusAmountClaim > 0
            AND (BSD.ClaimStatus = 0 OR BSD.ClaimStatus IN (SELECT ClaimStatus FROM JSON_TABLE(_ClaimStatuses, '$[*]' COLUMNS(`ClaimStatus` INT path "$")) AS ClaimStatusList));
END$$
DELIMITER ;
