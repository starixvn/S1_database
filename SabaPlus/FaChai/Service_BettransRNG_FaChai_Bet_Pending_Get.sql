/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRNG_FaChai_Bet_Pending_Get`(
    IN _BeginTime BIGINT,
    IN _EndTime BIGINT
/*
  Created: 20241105@Luke
	DB: TSDB-TSDB
	Task: Bet result check

	Revisions:
		- 20241105@Luke: Bet result check
*/    
)
BEGIN
    SET @TableName = CONCAT("BettransRng_FaChai_",  DATE_FORMAT(FROM_UNIXTIME(_BeginTime), '%Y%m'));
	SET @BeginTime = FROM_UNIXTIME(_BeginTime);
    SET @EndTime = FROM_UNIXTIME(_EndTime);
    
    SET @CMD = CONCAT("
            SELECT 
				*
            FROM
                ", @TableName, "
            WHERE
                UpdateTime BETWEEN ? AND ?
            AND 
                TicketType = 1
			AND
				SettleFlag = 0;
        ");
	PREPARE stmt FROM @CMD;
	EXECUTE stmt USING @BeginTime, @EndTime;
	DEALLOCATE PREPARE stmt;
        
END$$
DELIMITER ;
