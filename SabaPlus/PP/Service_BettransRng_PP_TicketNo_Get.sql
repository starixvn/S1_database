/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_PP_TicketNo_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_PP_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200)
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: get bet PP

	Revisions:
		- 20241029@Kathy: get bet PP
*/
BEGIN
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT * FROM BettransRng_PP_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;