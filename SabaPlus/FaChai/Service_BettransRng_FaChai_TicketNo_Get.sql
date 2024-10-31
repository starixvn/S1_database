/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_FaChai_TicketNo_Get`;
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_FaChai_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
)
/*
  Created: 20241030@Luke
	DB: TSDB-Siebog
	Task: Get FaChai bet info

	Revisions:
		- 20241030@Luke: Initial
*/
BEGIN
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransRng_FaChai_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
END 
$$
DELIMITER ;