/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_Nextspin_Settle_Set`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_Nextspin_Settle_Set`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: update bet Nextspin

	Revisions:
		- 20241029@Kathy: update bet Nextspin
*/
)

BEGIN
    SET @TransId = TransId;
    
    SET @CMD = CONCAT(
        "UPDATE BettransRng_Nextspin_", YYYYMM, " SET SettleFlag = 1 WHERE TicketNo = ? AND SettleFlag != 1;"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
END;;
DELIMITER ;