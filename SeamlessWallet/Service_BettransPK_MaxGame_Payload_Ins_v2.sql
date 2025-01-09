/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransPK_MaxGame_Payload_Ins_v2`(
    IN YYYYMM VARCHAR(6),
    IN Timestamp VARCHAR(64),
    IN Seq VARCHAR(64), 
    IN Payload JSON,
    IN Action VARCHAR(50),
    IN GameType VARCHAR(50),
    IN Environment VARCHAR(20),
	IN Elapsed DOUBLE,
    IN Response JSON,
	IN GUID VARCHAR(50)
)

/*
  Created: 20241029@Los
	DB: TSDB-TSDB
	Task: Add Elapsed

	Revisions:
		- 20241029@Los: Add Elapsed
*/
BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
	SET @Timestamp = Timestamp;
    SET @Seq = Seq;
    SET @Payload = Payload;
    SET @Action = Action;
    SET @GameType = GameType;
    SET @Environment = Environment;
	SET @Elapsed = Elapsed;
    SET @Response = Response;

    SET @CMD = CONCAT("INSERT INTO BettransPK_MaxGame_Payload_", YYYYMM,
                " (
                        `Timestamp`,
                        `Seq`,
                        `Payload`,
                        `Action`,
                        `GameType`,
                        `Environment`,
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
        @Environment,
		@Elapsed,
        @Response;

    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_BettransPK_MaxGame_Payload_Ins_v2', @starttime, CURRENT_TIMESTAMP(6), GUID);
END $$
DELIMITER $$;