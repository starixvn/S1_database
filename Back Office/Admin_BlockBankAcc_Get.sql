CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockBankAcc_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(100),
    IN UserName VARCHAR(50) CHARACTER SET ASCII,
    IN SelectStatus JSON,
    IN SelectCurrency JSON
)
BEGIN
    
    
    IF AccountNum IS NOT NULL OR UserName IS NOT NULL THEN
        SELECT  
            CBD.CustId,
            C.UserName,
            BS.BankName,
            CBI.AccountName,
            CBD.AccountNo AS AccountNum,
            CBD.SysId,
            CBD.CreateTime,
            CBD.UpdateTime,
            CBD.IFSCCode,
            BA.UpdateTime AS BlockUpdateTime,
            BA.UpdateOperator,
            IFNULL(BA.`Status`,2) AS BlockStatus,
            CBD.`Status`,
            C.CurrencyId
        FROM CustBankDetail AS CBD
        JOIN Customer AS C on C.CustId = CBD.CustId
        JOIN CustBankInfo AS CBI ON CBI.CustId = C.CustId 
   LEFT JOIN BlockAccount AS BA ON CBD.SysId = BA.SysId AND CBD.AccountNo = BA.AccountNum
   LEFT JOIN BankInfoSys AS BS ON BS.Id = CBD.SysId
        WHERE
            ((AccountNum IS NULL) OR (AccountNum IS NOT NULL AND CBD.AccountNo = AccountNum)) AND
            ((UserName IS NULL) OR (UserName IS NOT NULL AND C.UserName = UserName)) AND
            C.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            ((BA.`Status` IS NULL AND 2 IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)) OR 
            (BA.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)));
    ELSE
        SELECT 
            CBD.CustId,
            C.UserName,
            BS.BankName,
            CBI.AccountName,
            CBD.AccountNo AS AccountNum,
            CBD.SysId,
            CBD.CreateTime,
            CBD.UpdateTime,
            CBD.IFSCCode,
            BA.UpdateTime AS BlockUpdateTime,
            BA.UpdateOperator,
            IFNULL(BA.`Status`,2) AS BlockStatus,
            CBD.`Status`,
            C.CurrencyId
        FROM CustBankDetail AS CBD
        JOIN Customer AS C on C.CustId = CBD.CustId
        JOIN CustBankInfo AS CBI ON CBI.CustId = C.CustId 
   LEFT JOIN BlockAccount AS BA ON CBD.SysId = BA.SysId AND CBD.AccountNo = BA.AccountNum
   LEFT JOIN BankInfoSys AS BS ON BS.Id = CBD.SysId
        WHERE
            CBD.CreateTime >= StartDate AND  
            CBD.CreateTime <= EndDate AND
            C.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            ((BA.`Status` IS NULL AND 2 IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)) OR 
            (BA.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)));
    END IF;
END