/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BankFinancialReport_Transfer_Get_V3`(
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
				- 20241216@Liam: fix sp crash
*/ 
)
BEGIN
   
   
    SET @StartDate = _StartTime;
    SET @EndDate =_EndTime;
    
    WITH cte_TransferAccountInfo
    AS
    (
        SELECT
            Id AS FinancialId,
            AccountNo,
            DisplayName
        FROM BankFinancialTransferAccount AS BFTA
        WHERE BFTA.SiteId = _SiteId
		   AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(_FinancialAccountIds, '$[*]' COLUMNS(`Id` INT PATH "$")) AS Temp
			WHERE Temp.Id = BFTA.Id
		)
    )
    SELECT
        TI.CurrencyId,
        cTA.FinancialId,
        TI.AccountNo,
        IFNULL(TI.Agent, PL.PayName) AS Agent,
        TI.Channel,
        TI.TransferType,
        SUM(IF(TI.PlusOrMinus = 1, TI.Amount, TI.Amount * -1)) AS Summary,
        SUM(TI.Fee) AS FeeSummary
    FROM BankFinancialTransferInfo AS TI
    LEFT JOIN cte_TransferAccountInfo AS cTA
        ON TI.AccountNo = cTA.AccountNo
    LEFT JOIN PayList AS PL ON PL.Id = TI.PayId
    WHERE TI.SiteId = _SiteId
	AND EXISTS (
		SELECT 1 
		FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS Temp
		WHERE Temp.CurrencyId = TI.CurrencyId
	)
	AND (_Agents IS NULL
		OR EXISTS (
			SELECT 1
			FROM JSON_TABLE(_Agents, '$[*]' COLUMNS(`Agent` VARCHAR(50) PATH "$")) AS Temp
			WHERE Temp.Agent = TI.Agent
		)
	)
	AND (_Channel IS NULL
		OR EXISTS (
			SELECT 1
			FROM JSON_TABLE(_Channel, '$[*]' COLUMNS(`Channel` TINYINT PATH "$")) AS Temp
			WHERE Temp.Channel = TI.Channel
		)
	)
        AND TI.TransDate BETWEEN @StartDate AND @EndDate
  GROUP BY CurrencyId, cTA.FinancialId, AccountNo, IFNULL(TI.Agent, PL.PayName), Channel, TransferType;

END$$
DELIMITER ;