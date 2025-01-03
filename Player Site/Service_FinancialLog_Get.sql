/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_FinancialLog_Get`(
    IN CustId INT,    
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN RefTransId VARCHAR(100) CHARACTER SET ASCII,
    IN YYYYMM CHAR(6)
/*
  Created: 20240102@Mira
        DB: TSDB-TSDB
        Task: Correct property name
        Revisions:
                - 20240102@Mira: init sp
*/
)
BEGIN
    
    
    SELECT TimeZone INTO @CustTimeZone FROM
    Customer INNER JOIN Currency ON Customer.CurrencyId = Currency.CurrencyId
    WHERE Customer.CustId = CustId;
    
    SET @CustId=CustId;
    SET @StartDate=StartDate;
    SET @EndDate=EndDate;
    SET @RefTransId =RefTransId;
    
    SET @cmd = concat("
        SELECT 
            FL.Id AS TransId,
            FL.CreateTime,              
            FL.Direction, 
            FL.ChangeAmount, 
            FL.BeforeAmount, 
            FL.AfterAmount, 
            FL.RefTransId,
            FL.Memo,
            FL.`Type`,
            IF(FT.`Type` IS NULL, '', FT.TypeName) AS TypeName,
            FL.RefTransId,
            @CustTimeZone AS CustTimeZone
        FROM
            FinancialLog_", YYYYMM ," AS FL LEFT OUTER JOIN
            FinancialType AS FT ON FL.`Type` = FT.`Type`
        WHERE
            FL.CustId = ?
            AND FL.CreateTime BETWEEN ? AND ? 
            AND (FL.RefTransId = ? OR ? IS NULL); ")
         ;
    PREPARE stmt FROM @cmd;
    EXECUTE stmt USING 
    @CustId, 
    @StartDate, @EndDate, 
    @RefTransId,@RefTransId;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
;