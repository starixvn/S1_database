/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransPK_TableGame_CancelBet_Set`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
/*
  Created: 20241111@Luke
	DB: TSDB-TSDB
	Task: Cancel TableGame bet ticket

	Revisions:
		- 20241111@Luke: Initial
*/    
)
BEGIN

    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("UPDATE BettransPK_TableGame_", YYYYMM, " SET `TicketStatus` = 3, `TicketType` = 2, `SettleFlag` = 1 WHERE `TicketNo` = ? AND `TicketType` = 1");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;

END$$
DELIMITER ;
