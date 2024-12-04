/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_OTPVerifyinfo_Get`(
    IN CustId int, 
    IN _OTPType tinyint,
    OUT Request_id varchar(100), 
    OUT StartUnixTime bigint,
    OUT OTPstatus int
/*
  Created: 20241204@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Update UNIX_TIMESTAMP
        Revisions:
                - 20241204@Zephyr.Nguyen: Update UNIX_TIMESTAMP
*/)
BEGIN
    

    SET OTPstatus = 0;
    SET StartUnixTime = 0;
    SET @unixtime = UNIX_TIMESTAMP();
    
    SELECT 
        OTPVerifyinfo.StartUnixTime,
        OTPVerifyinfo.Request_id
    INTO
        StartUnixTime,
        Request_id
    FROM OTPVerifyinfo 
    WHERE OTPVerifyinfo.CustId = CustId
        AND OTPVerifyinfo.OTPType = _OTPType
        AND OTPVerifyinfo.StartUnixTime + OTPVerifyinfo.TimeOutMin * 60 > @unixtime
    ;
    
    IF (StartUnixTime != 0) THEN
        SET OTPstatus = 1;
    END IF;
END$$
DELIMITER ;

