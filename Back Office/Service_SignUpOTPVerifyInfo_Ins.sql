/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_SignUpOTPVerifyInfo_Ins`(
    IN _PhoneNo varchar(30), 
    IN _OTPType tinyint, 
    IN OTPNum varchar(10),
    IN TimeOutMin int, 
    INOUT Request_id varchar(100),
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
    SET @unixtime = UNIX_TIMESTAMP();
    
    DELETE FROM OTPVerifyinfo 
    WHERE
        OTPVerifyinfo.StartUnixTime  < @unixtime - (OTPVerifyinfo.TimeOutMin * 60) 
        AND OTPVerifyinfo.PhoneNo = _PhoneNo;
    
    SELECT 
        OTPVerifyinfo.StartUnixTime, 
        OTPVerifyinfo.Request_id
    INTO 
        `StartUnixTime`, 
        `Request_id`
    FROM
        OTPVerifyinfo
    WHERE
        OTPVerifyinfo.PhoneNo = _PhoneNo
        AND OTPVerifyinfo.OTPType = _OTPType;
    
    IF row_count() > 0 THEN
       SET `OTPstatus` = 1;
    ELSE
       SET `StartUnixTime` = @unixtime;
       
       INSERT INTO OTPVerifyinfo
          (CustId, PhoneNo, OTPType, OTPNum, request_id, StartUnixTime, TimeOutMin )
       VALUE
          (0, _PhoneNo,_OTPType,`OTPNum`, `Request_id`, `StartUnixTime`, `TimeOutMin`);
          
       SET `OTPstatus` = 0;
    END IF;
    
END$$
DELIMITER ;

