CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockEWallet_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(50),
    IN SelectStatus JSON,
    IN SelectCurrency JSON,
    IN SelectSysId JSON
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
            ES.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            BE.SysId IN (SELECT Sys FROM JSON_TABLE(SelectSysId, '$[*]' COLUMNS(Sys INT path "$")) AS Temp3) AND
            BE.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2);
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
            ES.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            BE.SysId IN (SELECT Sys FROM JSON_TABLE(SelectSysId, '$[*]' COLUMNS(Sys INT path "$")) AS Temp3) AND
            BE.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2);
    END IF;
END