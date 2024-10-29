/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_JILI_Settle_Set`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_JILI_Settle_Set`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200),
    IN TicketStatus TINYINT
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: get bet JILI

	Revisions:
		- 20241029@Kathy: update bet JILI
*/
BEGIN
    SET @TransId = TransId;
    SET @TicketStatus = TicketStatus;
    
    SET @CMD = CONCAT(
        "UPDATE BettransRng_JILI_", YYYYMM, " SET SettleFlag = 1 WHERE TicketNo = ? AND TicketStatus = ? AND SettleFlag != 1;"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId,@TicketStatus;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
END;;
DELIMITER ;

GRANT EXECUTE ON PROCEDURE Siebog.Service_BettransRng_JILI_Settle_Set TO 'app_srv'@'%';