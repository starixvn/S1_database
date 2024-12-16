CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockEWalletAcc_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(50),
    IN UserName VARCHAR(50) CHARACTER SET ASCII, 
    IN SelectStatus JSON,
    IN SelectCurrency JSON,
    IN SelectSysId JSON
)
BEGIN
    
    
    IF AccountNum IS NOT NULL OR UserName IS NOT NULL THEN
        SELECT 
            CED.CustId,
            C.UserName,
            ES.EWalletName,
            CED.AccountNo AS AccountNum,
            CED.SysId,
            CED.CreateTime,
            CED.UpdateTime,
            BE.UpdateTime AS BlockUpdateTime,
            BE.UpdateOperator,
            IFNULL(BE.`Status`,2) AS BlockStatus,
            CED.`Status`,
            C.CurrencyId
        FROM
            CustEWalletDetail AS CED
            INNER JOIN 
            CustBankInfo AS CBI ON CED.CustId = CBI.CustId
            INNER JOIN 
            Customer AS C ON CBI.SiteId = C.SiteId AND CBI.CustId = C.CustId
            LEFT JOIN 
            BlockEWallet AS BE ON CED.SysId = BE.SysId AND CED.AccountNo = BE.AccountNum
            LEFT JOIN 
            EWalletInfoSys AS ES ON ES.Id = CED.SysId
        WHERE
            ((UserName IS NULL) OR (UserName IS NOT NULL AND C.UserName = UserName)) AND
            ((AccountNum IS NULL) OR (AccountNum IS NOT NULL AND CED.AccountNo = AccountNum)) AND
            C.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            CED.SysId IN (SELECT Sys FROM JSON_TABLE(SelectSysId, '$[*]' COLUMNS(Sys INT path "$")) AS Temp3) AND
            ((BE.`Status` IS NULL AND 2 IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)) OR 
            (BE.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)));        
    ELSE
        SELECT 
            CED.CustId, 
            C.UserName,
            ES.EWalletName,
            CED.AccountNo AS AccountNum,
            CED.SysId,
            CED.CreateTime,
            CED.UpdateTime,
            BE.UpdateTime AS BlockUpdateTime,
            BE.UpdateOperator,
            IFNULL(BE.`Status`,2) AS BlockStatus,
            CED.`Status`,
            C.CurrencyId
        FROM
            CustEWalletDetail AS CED
            INNER JOIN 
            CustBankInfo AS CBI ON CED.CustId = CBI.CustId
            INNER JOIN 
            Customer AS C ON CBI.SiteId = C.SiteId AND CBI.CustId = C.CustId
            LEFT JOIN 
            BlockEWallet AS BE ON CED.SysId = BE.SysId AND CED.AccountNo = BE.AccountNum
            LEFT JOIN 
            EWalletInfoSys AS ES ON ES.Id = CED.SysId
        WHERE
            CED.CreateTime >= StartDate AND  
            CED.CreateTime <= EndDate AND
            C.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            CED.SysId IN (SELECT Sys FROM JSON_TABLE(SelectSysId, '$[*]' COLUMNS(Sys INT path "$")) AS Temp3) AND
            ((BE.`Status` IS NULL AND 2 IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)) OR 
            (BE.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)));
    END IF;
END