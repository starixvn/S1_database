/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_OTPSummary_Get`(
    IN SiteId INT,
    IN SelectCurrency JSON,
    IN OTPProvider varchar(30),
    IN OTPStatus int,
    IN UserName varchar(30),
    IN PhoneNo varchar(20),
    IN StartDate DATETIME,
    IN EndDate DATETIME
/*
  Created: 20250109@issac.Le
        DB: TSDB-TSDB
        Task: Admin OTP
        Revisions:
                - 20250109@issac.le: init sp
*/
)
BEGIN

    
    SELECT O.OTPStatus, count(O.OTPStatus) AS Total
    FROM OTPLog AS O
        INNER JOIN Customer AS  C ON O.CustId = C.CustId
        INNER JOIN Currency AS  CU ON O.CurrencyId = CU.CurrencyId
    WHERE
        C.SiteId = SiteId
        AND (json_length(SelectCurrency) = 0 OR O.CurrencyId IN (SELECT * FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(CurrencyId INT path "$")) AS CurrencyList))
        AND (OTPProvider = '' OR O.OTPProvider = OTPProvider)
        AND (OTPStatus = 0 OR O.OTPStatus = OTPStatus)    
        AND (UserName = '' OR O.UserName = UserName)
        AND (PhoneNo = '' OR O.PhoneNo = PhoneNo)
        AND 
        (
            (O.CreateTime BETWEEN StartDate AND EndDate)
            OR
            (O.UpdateTime BETWEEN StartDate AND EndDate)
            OR
            (O.VerifiedTime BETWEEN StartDate AND EndDate)
        )
    GROUP BY O.OTPStatus;
END$$
DELIMITER ;