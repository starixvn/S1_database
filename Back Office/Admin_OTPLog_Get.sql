/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_OTPLog_Get`(
    IN SiteId INT,
    IN SelectCurrency JSON,
    IN OTPProvider varchar(30),
    IN OTPStatus int,
    IN UserName varchar(30),
    IN PhoneNo varchar(20),
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN PageSize INT,
    IN StartIndex INT,
    OUT RowCount INT
/*
		Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: Admin OTP
        Revisions:
                - 20250109@Kathy: modify sp
*/
)
BEGIN
    SET RowCount = 0;
    
    DROP TEMPORARY TABLE IF EXISTS tmp_OTPLog;
    
    CREATE TEMPORARY TABLE tmp_OTPLog (SQ BIGINT, OTPStatus TINYINT) ;
    
    INSERT INTO tmp_OTPLog(SQ, OTPStatus)
    SELECT 
        O.SQ,
        O.OTPStatus
    FROM OTPLog AS O      
    WHERE
        O.SiteId = SiteId
        AND (json_length(SelectCurrency) = 0 
			OR EXISTS (SELECT 1 FROM JSON_TABLE(SelectCurrency, '$[*]' COLUMNS(CurrencyId INT path "$")) AS cl WHERE cl.CurrencyId = O.CurrencyId)
		)
        AND (OTPProvider = '' OR O.OTPProvider = OTPProvider)
        AND (OTPStatus = 0 OR O.OTPStatus = OTPStatus)    
        AND (UserName = '' OR O.UserName = UserName)
        AND (PhoneNo = '' OR O.PhoneNo = PhoneNo)
        AND O.CreateTime BETWEEN StartDate AND EndDate ;
        
	SET RowCount = ROW_COUNT() ;
    
	SELECT O.OTPStatus, COUNT(1) AS Total
	FROM tmp_OTPLog O
	GROUP BY O.OTPStatus;
     
	SELECT O.SiteId,
        O.CurrencyId,
        CU.IsoCode,
        O.OTPType,
        O.CustId,
        O.UserName,
        O.OTPProvider,
        O.PhoneNo,
        O.Content,
        O.OTPNum,
        O.Request_id,
        O.OTPStatus,
        O.OTPResponse,
        O.Verified,
        O.VerifiedTime,
        O.CreateTime,
        O.UpdateTime
    FROM tmp_OTPLog t
		INNER JOIN OTPLog O 
			ON t.SQ = O.SQ
		LEFT JOIN Currency AS  CU ON O.CurrencyId = CU.CurrencyId
    ORDER BY O.UpdateTime DESC
    LIMIT StartIndex, PageSize;
	
END$$
DELIMITER ;
