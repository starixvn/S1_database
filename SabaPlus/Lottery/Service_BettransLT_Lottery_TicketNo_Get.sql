/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLT_Lottery_TicketNo_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLT_Lottery_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: get bet Lottery

	Revisions:
		- 20241029@Kathy: get bet Lottery
*/
)

BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransLT_Lottery_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
	
	INSERT INTO SPLog (spname, starttime, endtime) VALUES ('Service_BettransLT_Lottery_TicketNo_Get', @starttime, CURRENT_TIMESTAMP(6));
END ;;
DELIMITER ;