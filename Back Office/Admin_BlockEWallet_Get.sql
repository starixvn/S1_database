/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockEWallet_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(50),
    IN SelectStatus JSON,
    IN SelectCurrency JSON,
    IN SelectSysId JSON
    /*
  Created: 20241125@Liam 
        DB: TSDB-TSDB
        Task: fix sp crash
         Revisions:
                - 20241216@Liam: fix sp crash
*/ 
)
BEGIN
    
    
    IF AccountNum IS NOT NULL THEN
        SELECT
            BE.SysId,
            BE.AccountNum,
            BE.UpdateTime AS BlockUpdateTime,
            BE.UpdateOperator,
            BE.`Status` AS BlockStatus,
            ES.EWalletName,
            ES.CurrencyId
        FROM BlockEWallet AS BE
        INNER JOIN EWalletInfoSys AS ES ON ES.Id = BE.SysId
        WHERE
            BE.AccountNum = AccountNum AND 
		 EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp
			WHERE Temp.Currency = ES.CurrencyId
		)

		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectSysId, '$[*]' COLUMNS(Sys INT path "$")) AS Temp3
			WHERE Temp3.Sys = BE.SysId
		)

		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2
			WHERE Temp2.Status = BE.`Status`
		);
    ELSE
        SELECT
            BE.SysId,
            BE.AccountNum,
            BE.UpdateTime AS BlockUpdateTime,
            BE.UpdateOperator,
            BE.`Status` AS BlockStatus,
            ES.EWalletName,
            ES.CurrencyId
        FROM BlockEWallet AS BE
        INNER JOIN EWalletInfoSys AS ES ON ES.Id = BE.SysId
        WHERE
            BE.UpdateTime >= StartDate AND  
            BE.UpdateTime <= EndDate AND 
			 EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp
				WHERE Temp.Currency = ES.CurrencyId
			)

			AND EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectSysId, '$[*]' COLUMNS(Sys INT path "$")) AS Temp3
				WHERE Temp3.Sys = BE.SysId
			)

			AND EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(Status INT path "$")) AS Temp2
				WHERE Temp2.Status = BE.Status
			);
    END IF;
END$$
DELIMITER ;