/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_PG_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200),
    IN GUID VARCHAR(50)
/*
  Created: 20241112@Luke
	DB: TSDB-TSDB
	Task: Get PG bet info

	Revisions:
		- 20241112@Luke: Initial
*/
)
BEGIN
    
    SET @starttime = CURRENT_TIMESTAMP(6);

    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransRng_PG_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_BettransRng_PG_TicketNo_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
