/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockAccount_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(100),
    IN SelectStatus JSON,
    IN SelectCurrency JSON    
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
            BA.UpdateTime AS BlockUpdateTime,
            BA.UpdateOperator,
            BA.`Status` AS BlockStatus,
            BA.SysId,
            BA.AccountNum,
            BS.BankName,
            BS.CurrencyId
        FROM BlockAccount AS BA
        INNER JOIN BankInfoSys AS BS ON BS.Id = BA.SysId
        WHERE
            BA.AccountNum = AccountNum 
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
			WHERE Temp2.Status = BA.`Status`
		)
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT PATH "$")) AS Temp
			WHERE Temp.Currency = BS.CurrencyId
		);
    ELSE
        SELECT  
            BA.UpdateTime AS BlockUpdateTime,
            BA.UpdateOperator,
            BA.`Status` AS BlockStatus,
            BA.SysId,
            BA.AccountNum,
            BS.BankName,
            BS.CurrencyId
        FROM BlockAccount AS BA
        INNER JOIN BankInfoSys AS BS ON BS.Id = BA.SysId
        WHERE
            BA.UpdateTime >= StartDate AND  
            BA.UpdateTime <= EndDate AND
		EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
			WHERE Temp2.Status = BA.`Status`
		)
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT PATH "$")) AS Temp
			WHERE Temp.Currency = BS.CurrencyId
		);
    END IF;
END$$
DELIMITER ;