/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLC_Sexy_TicketNo_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLC_Sexy_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200),
    IN GUID VARCHAR(50)
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: get bet AE Sexy

	Revisions:
		- 20241029@Kathy: get bet AE Sexy
*/
)

BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransLC_Sexy_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_BettransLC_Sexy_TicketNo_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END ;;
DELIMITER ;