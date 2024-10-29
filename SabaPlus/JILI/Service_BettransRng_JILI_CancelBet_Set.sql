/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_JILI_CancelBet_Set`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_JILI_CancelBet_Set`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: get bet JILI

	Revisions:
		- 20241029@Kathy: cancel bet JILI
*/
BEGIN
    
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("UPDATE BettransRng_JILI_", YYYYMM, " SET `TicketStatus` = 3, `TicketType` = 2, `SettleFlag` = 1 WHERE `TicketNo` = ? AND `TicketType` = 1");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;