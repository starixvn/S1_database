/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpBetRecordDetail_Get_V2`(
    IN TpId  INT,
    IN GameType INT,
    IN TransId  VARCHAR(100),
    IN SettledTime DATETIME
/*
  Created: 20241219@Luke
        DB: TSDB-TSDB
        Task: Add DEALLOCATE stmt for non-standard SPs
        Revisions:
                - 20241219@Luke: Add DEALLOCATE stmt for non-standard SPs
*/)
BEGIN
    
    
    
    SET @TpId=TpId;
    SET @GameType=GameType;
    SET @TransId=TransId;
    
    SET @cmd = concat("SELECT TpId,GameType,TransId,CurrencyId,Detail,BinaryDetail FROM TpBetRecordDetail_", DATE_FORMAT(IFNULL(SettledTime, NOW()),'%Y%m')," WHERE TpId = ? AND GameType = ? AND TransId = ? ;");        
    PREPARE stmt FROM @cmd;
    EXECUTE stmt USING @TpId, @GameType,@TransId;
    DEALLOCATE PREPARE stmt;
	
END$$
DELIMITER ;