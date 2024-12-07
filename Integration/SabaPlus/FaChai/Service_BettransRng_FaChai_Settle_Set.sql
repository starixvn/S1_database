/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_FaChai_Settle_Set`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_FaChai_Settle_Set`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
/*
  Created: 
	DB: TSDB-TSDB
	Task: update bet FaChai

	Revisions:
		- 20241029@Kathy: update bet FaChai
*/
)

BEGIN
    SET @TransId = TransId;
    
    SET @CMD = CONCAT(
        "UPDATE BettransRng_FaChai_", YYYYMM, " SET SettleFlag = 1 WHERE TicketNo = ? AND SettleFlag != 1;"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
END;;
DELIMITER ;