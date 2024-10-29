/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_JILI_ResultId_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_JILI_ResultId_Get`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: get bet JILI

	Revisions:
		- 20241029@Kathy: get bet JILI
*/
BEGIN

    SET @TicketNo = TransId;
   
    SET @CMD = CONCAT("SELECT * FROM BettransRng_JILI_", YYYYMM, " WHERE TicketNo = ? AND ResultId != '';");
   
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;                    
    DEALLOCATE PREPARE stmt;
END;;
DELIMITER ;
