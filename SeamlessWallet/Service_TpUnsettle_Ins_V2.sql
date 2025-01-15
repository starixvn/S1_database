/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpUnsettle_Ins_V2`(
    IN TpId  INT,
    IN GameType INT,
    IN TransId  VARCHAR(100),
    IN PartitionTime DateTime,
    IN GUID VARCHAR(50)
/*
  Created: 20250114@Kathy
        DB: TSDB-TSDB
        Task: load test
        Revisions:
                - 20241226@Kathy: load test
*/
)
BEGIN
    SET @starttime = CURRENT_TIMESTAMP(6);
    

    SET PartitionTime = IFNULL(PartitionTime, NOW());

    INSERT INTO `TpUnsettle`
    (
        `TpId`,
        `GameType`,
        `TransId`,
        `PartitionTime`
    )
    VALUES
    (
        TpId,
        GameType,
        TransId,
        PartitionTime
    )
    ON DUPLICATE KEY UPDATE
        `TpUnsettle`.`SettleFlag`= 2,
        `TpUnsettle`.`PartitionTime`= PartitionTime;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_TpUnsettle_Ins_V2', @starttime, CURRENT_TIMESTAMP(6), GUID);
	
END$$
DELIMITER ;
