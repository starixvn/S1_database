/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_TableGame_Settle_Set`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
 /*
  Created: 20241111@Luke
	DB: TSDB-TSDB
	Task: Settle TableGame ticket

	Revisions:
		- 20241111@Luke: Initial
*/   
)
BEGIN

    SET @TransId = TransId;
    
    SET @CMD = CONCAT(
        "UPDATE BettransRng_TableGame_", YYYYMM, " SET SettleFlag = 1 WHERE TicketNo = ? AND SettleFlag != 1;"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;
