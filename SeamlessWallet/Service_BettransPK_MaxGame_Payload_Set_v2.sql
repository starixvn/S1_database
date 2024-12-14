/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransPK_MaxGame_Payload_Set_v2`(
	IN YYYYMM VARCHAR(6),
	IN Seq VARCHAR(64),
    IN Response JSON,
    IN Elapsed INT
	/*
  Created: 20241029@Los
	DB: TSDB-TSDB
	Task: add Elapsed

	Revisions:
		- 20241029@Los: add Elapsed
*/
)
BEGIN
    SET @Seq = Seq;
     SET @Elapsed = Elapsed;
    SET @Response = Response;
    
    SET @CMD = CONCAT("UPDATE BettransPK_MaxGame_Payload_", YYYYMM, " SET `Response` = ?, Elapsed = ? WHERE `Seq` = ?");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @Response, @Elapsed, @Seq;

    DEALLOCATE PREPARE stmt;

END $$
DELIMITER $$;