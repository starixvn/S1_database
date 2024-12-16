/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
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
    /*
  Created: 20241125@Liam 
        DB: TSDB-TSDB
        Task: fix sp crash
         Revisions:
                - 20241216@Liam: fix sp crash
*/ 
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
			 EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT PATH "$")) AS Temp
				WHERE Temp.Currency = C.CurrencyId
			)

			AND (
				(BCW.`Status` IS NULL AND EXISTS (
					SELECT 1
					FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
					WHERE Temp2.Status = 2
				)) 
				OR EXISTS (
					SELECT 1
					FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
					WHERE Temp2.Status = BCW.`Status`
				)
			)

			AND EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectCrypto, '$[*]' COLUMNS(Crypto INT PATH "$")) AS Temp3
				WHERE Temp3.Crypto = CCWD.CurrencyId
			)

			AND EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectNetWork, '$[*]' COLUMNS(NetWork VARCHAR(10) PATH "$")) AS Temp4
				WHERE Temp4.NetWork = CCWD.NetWork
			);
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
		 EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT PATH "$")) AS Temp
			WHERE Temp.Currency = C.CurrencyId
		)

		AND (
			(BCW.`Status` IS NULL AND EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
				WHERE Temp2.Status = 2
			)) 
			OR EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
				WHERE Temp2.Status = BCW.`Status`
			)
		)

		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectCrypto, '$[*]' COLUMNS(Crypto INT PATH "$")) AS Temp3
			WHERE Temp3.Crypto = CCWD.CurrencyId
		)

		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(SelectNetWork, '$[*]' COLUMNS(NetWork VARCHAR(10) PATH "$")) AS Temp4
			WHERE Temp4.NetWork = CCWD.NetWork
		);
    END IF;
END$$
DELIMITER ;