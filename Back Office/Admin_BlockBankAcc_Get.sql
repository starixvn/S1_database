/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BlockBankAcc_Get`(
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN AccountNum VARCHAR(100),
    IN UserName VARCHAR(50) CHARACTER SET ASCII,
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
			 EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT PATH "$")) AS Temp
				WHERE Temp.Currency = C.CurrencyId
			)

			AND (
				(BA.`Status` IS NULL AND EXISTS (
					SELECT 1
					FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
					WHERE Temp2.Status = 2
				)) 
				OR EXISTS (
					SELECT 1
					FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
					WHERE Temp2.Status = BA.`Status`
				)
			);
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
			EXISTS (
				SELECT 1
				FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(Currency INT PATH "$")) AS Temp
				WHERE Temp.Currency = C.CurrencyId
			)

			AND (
				(BA.`Status` IS NULL AND EXISTS (
					SELECT 1
					FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
					WHERE Temp2.Status = 2
				)) 
				OR EXISTS (
					SELECT 1
					FROM JSON_TABLE(SelectStatus, '$[*]' COLUMNS(`Status` INT PATH "$")) AS Temp2
					WHERE Temp2.Status = BA.`Status`
				)
			);
    END IF;
END$$
DELIMITER ;