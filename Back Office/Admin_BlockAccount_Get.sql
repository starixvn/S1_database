CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockAccount_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(100),
    IN SelectStatus JSON,
    IN SelectCurrency JSON
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
            BA.AccountNum = AccountNum AND
            BA.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2) AND
            BS.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp);
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
            BA.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2) AND
            BS.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp);
    END IF;
END