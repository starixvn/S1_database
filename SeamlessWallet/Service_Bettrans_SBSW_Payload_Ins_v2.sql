/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_Bettrans_SBSW_Payload_Ins_v2`(
    IN YYYYMM VARCHAR(6),
    IN Timestamp VARCHAR(64),
    IN Seq VARCHAR(64), 
    IN Payload JSON,
    IN Action VARCHAR(50),
    IN GameType VARCHAR(50),
    IN Environment VARCHAR(20),
	IN Elapsed DOUBLE,
    IN Response JSON
	/*
  Created: 20241031@Los
	DB: TSDB-TSDB
	Task: Insert log request/response

	Revisions:
        - 20241119@Los: Initial
*/
)
BEGIN
    SET @Timestamp = Timestamp;
    SET @Seq = Seq;
    SET @Payload = Payload;
    SET @Action = Action;
    SET @GameType = GameType;
    SET @Environment = Environment;
	SET @Response = Response;
	SET @Elapsed=Elapsed;

    SET @CMD = CONCAT("INSERT INTO Bettrans_SBSW_Payload_", YYYYMM,
                " (
                        `Timestamp`,
                        `Seq`,
                        `Payload`,
                        `Action`,
                        `GameType`,
                        `Environment`
						`Elapsed`,
                        `Response`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)") ;

    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
        @Timestamp,
        @Seq,
        @Payload,
        @Action,
        @GameType,
        @Environment ;
		@Elapsed,
		@Response;
		
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;