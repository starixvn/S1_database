CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockCryptoWallet_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN Address VARCHAR(260),
    IN UserName VARCHAR(30) CHARACTER SET ASCII,
    IN SelectStatus JSON,
    IN SelectCurrency JSON,
    IN SelectCrypto JSON,
    IN SelectNetWork JSON,
    IN SiteId INT
)
BEGIN
    
    
    
    IF Address IS NOT NULL OR UserName IS NOT NULL THEN
        SELECT  
             CCWD.CustId,
             C.UserName,
             CBI.AccountName,
             CCWD.Network,
             CCWD.Address,
             CCWD.CreateTime,
             CCWD.UpdateTime,
             BCW.UpdateTime AS BlockUpdateTime,
             BCW.UpdateOperator,
             IFNULL(BCW.`Status`,2) AS BlockStatus,
             CCWD.`Status`,
             C.CurrencyId,
             CY.IsoCode AS CryptoType
        FROM CustCryptoWalletDetail AS CCWD
            JOIN Customer AS C on C.CustId = CCWD.CustId
            JOIN CustBankInfo AS CBI ON CBI.CustId = C.CustId 
            LEFT JOIN BlockCryptoWallet AS BCW ON CCWD.Address = BCW.Address
            LEFT JOIN Currency AS CY ON CCWD.CurrencyId = CY.CurrencyId
        WHERE
			C.SiteId = SiteId AND
            ((Address IS NULL) OR (Address IS NOT NULL AND CCWD.Address = Address)) AND
            ((UserName IS NULL) OR (UserName IS NOT NULL AND C.UserName = UserName)) AND
            C.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            ((BCW.`Status` IS NULL AND 2 IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)) OR 
            (BCW.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2))) AND
            CCWD.CurrencyId IN (SELECT Crypto FROM JSON_TABLE(SelectCrypto, '$[*]' COLUMNS(Crypto INT path "$")) AS Temp3) AND 
            CCWD.NetWork IN (SELECT NetWork FROM JSON_TABLE(SelectNetWork, '$[*]' COLUMNS(NetWork VARCHAR(10) path "$")) AS Temp4);
    ELSE
        SELECT  
             CCWD.CustId,
             C.UserName,
             CBI.AccountName,
             CCWD.Network,
             CCWD.Address,
             CCWD.CreateTime,
             CCWD.UpdateTime,
             BCW.UpdateTime AS BlockUpdateTime,
             BCW.UpdateOperator,
             IFNULL(BCW.`Status`,2) AS BlockStatus,
             CCWD.`Status`,
             C.CurrencyId,
             CY.IsoCode AS CryptoType
        FROM CustCryptoWalletDetail AS CCWD
            JOIN Customer AS C on C.CustId = CCWD.CustId
            JOIN CustBankInfo AS CBI ON CBI.CustId = C.CustId
            LEFT JOIN BlockCryptoWallet AS BCW ON CCWD.Address = BCW.Address
            LEFT JOIN Currency AS CY ON CCWD.CurrencyId = CY.CurrencyId
        WHERE
			C.SiteId = SiteId AND
            CCWD.CreateTime >= StartDate AND  
            CCWD.CreateTime <= EndDate AND
            C.CurrencyId IN (SELECT Currency FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT path "$")) AS Temp) AND
            ((BCW.`Status` IS NULL AND 2 IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2)) OR 
            (BCW.`Status` IN (SELECT `Status` FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp2))) AND
            CCWD.CurrencyId IN (SELECT Crypto FROM JSON_TABLE(SelectCrypto, '$[*]' COLUMNS(Crypto INT path "$")) AS Temp3) AND 
            CCWD.NetWork IN (SELECT NetWork FROM JSON_TABLE(SelectNetWork, '$[*]' COLUMNS(NetWork VARCHAR(10) path "$")) AS Temp4);
    END IF;
END