/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_OTPVerifyinfo_Ins`(
    IN CustId int, 
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
        AND OTPVerifyinfo.CustId > 0;
    
    SELECT 
        OTPVerifyinfo.StartUnixTime, 
        OTPVerifyinfo.Request_id
    INTO 
        `StartUnixTime`, 
        `Request_id`
    FROM
        OTPVerifyinfo
    WHERE
        OTPVerifyinfo.CustId = CustId
        AND OTPVerifyinfo.OTPType = _OTPType;
    
    IF row_count() > 0 THEN
       SET `OTPstatus` = 1;
    ELSE
       SET `StartUnixTime` = @unixtime;
       
       INSERT INTO OTPVerifyinfo
          (CustId, OTPType, OTPNum, request_id, StartUnixTime, TimeOutMin)
       VALUE
          (CustId, _OTPType,`OTPNum`, `Request_id`, `StartUnixTime`, `TimeOutMin`);
          
       SET `OTPstatus` = 0;
    END IF;
    
END$$
DELIMITER ;

