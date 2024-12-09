/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLC_Sexy_Bet_Pending_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLC_Sexy_Bet_Pending_Get`(
    IN _BeginTime BIGINT,
    IN _EndTime BIGINT
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: check pending bet AE Sexy

	Revisions:
		- 20241029@Kathy: check pending bet AE Sexy
*/
)

BEGIN
 
    SET @TableName = CONCAT("BettransLC_Sexy_",  DATE_FORMAT(FROM_UNIXTIME(_BeginTime), '%Y%m'));
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
        
END ;;
DELIMITER ;