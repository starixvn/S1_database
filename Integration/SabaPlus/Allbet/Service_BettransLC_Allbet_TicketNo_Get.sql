/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLC_Allbet_TicketNo_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLC_Allbet_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: get bet Allbet

	Revisions:
		- 20241029@Kathy: get bet Allbet
*/
)

BEGIN
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransLC_Allbet_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;