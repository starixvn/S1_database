/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_Bettrans_SBSW_Payload_Set_v2`(
	IN YYYYMM VARCHAR(6),
	IN Seq VARCHAR(64),
    IN Response JSON
	/*
  Created: 20241031@Los
	DB: TSDB-TSDB
	Task: Update log request/response

	Revisions:
        - 20241119@Los: Initial
*/
)
BEGIN
    SET @Seq = Seq;
    SET @Response = Response;
    
    SET @CMD = CONCAT("UPDATE Bettrans_SBSW_Payload_", YYYYMM, " SET `Response` = ? WHERE `Seq` = ?");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @Response, @Seq;

    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;