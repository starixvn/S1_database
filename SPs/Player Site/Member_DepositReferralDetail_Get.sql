/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_DepositReferralDetail_Get`(
    IN _CustId INT,
    IN _StartDate BIGINT,
    IN _EndDate BIGINT,  
    IN _PageSize INT,
    IN _StartIndex INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
)
/*
  Created: 20241115@Johnny
        DB: TSDB-TSDB
        Task: Get referral new 
        Revisions:
                - 20241115@Johnny: init sp
*/

BEGIN
    SELECT TimeZone INTO @CustTimeZone FROM
    Customer INNER JOIN Currency ON Customer.CurrencyId = Currency.CurrencyId
    WHERE Customer.CustId = _CustId;
    
    SET _RowCount = 0;
    SET @StartDate = FROM_UNIXTIME(_StartDate);
    SET @EndDate =  FROM_UNIXTIME(_EndDate);
    
       SELECT SQL_CALC_FOUND_ROWS
			  RL.SQ AS Id,
              DATE_FORMAT(RL.SettledDate, '%Y-%m-%d') AS SettledDate,
              C.UserName,
              RL.CalculateSummary AS TotalDeposit,
              RL.ReferralAmount AS RewardAmount
         FROM ReferralLog AS RL
    LEFT JOIN Customer AS C ON RL.CustId = C.CustId
        WHERE RL.CreateTime Between @StartDate and @EndDate
          AND RL.`Type` = 2
          AND RL.AgentId = _CustId
	 ORDER BY SettledDate DESC
        LIMIT _StartIndex , _PageSize;
    
    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;

END;;
DELIMITER ;