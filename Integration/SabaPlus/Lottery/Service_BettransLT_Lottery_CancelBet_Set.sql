/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLT_Lottery_CancelBet_Set`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLT_Lottery_CancelBet_Set`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: get bet Lottery

	Revisions:
		- 20241029@Kathy: cancel bet Lottery
*/
)

BEGIN
    
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("UPDATE BettransLT_Lottery_", YYYYMM, " SET `TicketStatus` = 3, `TicketType` = 2, `SettleFlag` = 1 WHERE `TicketNo` = ? AND `TicketType` = 1");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;