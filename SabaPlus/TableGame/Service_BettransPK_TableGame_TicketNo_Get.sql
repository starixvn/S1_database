/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransPK_TableGame_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
/*
  Created: 20241111@Luke
	DB: TSDB-TSDB
	Task: Get TableGame bet info

	Revisions:
		- 20241111@Luke: Initial
*/
)
BEGIN
    
    

    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransPK_TableGame_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;
