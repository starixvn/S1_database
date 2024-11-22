/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_TpSettlePending_Slot_Bettrans_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpSettlePending_Slot_Bettrans_Get`(
    IN TpGameType INT,
    IN BeginTime BIGINT,
    IN EndTime BIGINT
/*
  Created: 
	DB: TSDB-TSDB
	Task: check pending ticket

	Revisions:
		- 20241122@Kathy: check pending ticket
*/
)
BEGIN
    
    
    DECLARE TableName VARCHAR(60);
    SET @BeginTime = FROM_UNIXTIME(BeginTime);
    SET @EndTime = FROM_UNIXTIME(EndTime);
    
    
    IF TpGameType = 7 THEN
		SET TableName = CONCAT("BettransRng_Live22_",  DATE_FORMAT(now(), '%Y%m'));
        SET @BeginTime = BeginTime;
        SET @EndTime = EndTime;
        
        SET @CMD = CONCAT("
            SELECT DISTINCT
                L2.TicketNo AS TransId,
                L2.OperatorCustId AS TpUserName
            FROM
                ", TableName, " AS L2
            WHERE
                L2.UpdateTime BETWEEN ? AND ?
            AND 
                L2.SettleFlag != 1;
        ");
        PREPARE stmt FROM @CMD;
        EXECUTE stmt USING @BeginTime, @EndTime;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    
    IF TpGameType = 11 THEN
        SELECT DISTINCT
            BettransRng_GPI.round_id AS TransId,
            BettransRng_GPI.cust_id AS TpUserName
        FROM
            BettransRng_GPI
        WHERE
            BettransRng_GPI.CreateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransRng_GPI.SettleFlag = 2
        AND 
            BettransRng_GPI.`type` != 2;
    END IF;
    
    
    IF TpGameType = 15 THEN
        SELECT DISTINCT
            BettransRng_SG.transferId AS TransId,
            BettransRng_SG.acctId AS TpUserName
        FROM
            BettransRng_SG
        WHERE
            BettransRng_SG.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransRng_SG.SettleFlag != 1;
    END IF;
    
    
    IF TpGameType = 17 THEN
		SET TableName = CONCAT("BettransRng_PG_",  DATE_FORMAT(now(), '%Y%m'));
        SET @BeginTime = BeginTime;
        SET @EndTime = EndTime;
        
        SET @CMD = CONCAT("
            SELECT DISTINCT
                L2.TicketNo AS TransId,
                L2.OperatorCustId AS TpUserName
            FROM
                ", TableName, " AS L2
            WHERE
                L2.UpdateTime BETWEEN ? AND ?
            AND 
                L2.SettleFlag != 1;
        ");
        PREPARE stmt FROM @CMD;
        EXECUTE stmt USING @BeginTime, @EndTime;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    
    IF TpGameType = 29 THEN
        SELECT DISTINCT
            BettransRNG_CQ9.roundid AS TransId,
            BettransRNG_CQ9.`account` AS TpUserName
        FROM
            BettransRNG_CQ9
        WHERE
            BettransRNG_CQ9.CreateTimes BETWEEN @BeginTime AND @EndTime
        AND
            BettransRNG_CQ9.SettleFlag != 1;
    END IF;
    
    
    IF TpGameType = 39 THEN
        SELECT
            BettransRng_Iconic.transactionId AS TransId,
            BettransRng_Iconic.username AS TpUserName
        FROM
            BettransRng_Iconic
        WHERE
            BettransRng_Iconic.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransRng_Iconic.SettleFlag != 1;
    END IF;

    
    IF TpGameType = 53 THEN
        
        SET TableName = CONCAT("BettransRng_JILI_",  DATE_FORMAT(now(), '%Y%m'));
        SET @BeginTime = BeginTime;
        SET @EndTime = EndTime;
        
        SET @CMD = CONCAT("
            SELECT DISTINCT
                L2.TicketNo AS TransId,
                L2.userId AS TpUserName
            FROM
                ", TableName, " AS L2
            WHERE
                L2.UpdateTime BETWEEN ? AND ?
            AND 
                L2.SettleFlag != 1;
        ");
        PREPARE stmt FROM @CMD;
        EXECUTE stmt USING @BeginTime, @EndTime;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    
    IF TpGameType = 57 THEN
        SELECT DISTINCT
            BettransRng_MG.betId AS TransId,
            BettransRng_MG.playerId AS TpUserName
        FROM
            BettransRng_MG
        WHERE
            BettransRng_MG.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransRng_MG.SettleFlag != 1
        AND 
            BettransRng_MG.completed = 1;
    END IF;
    
    
    IF TpGameType = 64 THEN
        SELECT DISTINCT
            BettransRng_Netent.TransactionRefId AS TransId,
            BettransRng_Netent.userId AS TpUserName
        FROM
            BettransRng_Netent
        WHERE
            BettransRng_Netent.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransRng_Netent.SettleFlag = 2;
    END IF;
    
    
    IF TpGameType = 65 THEN
        SELECT DISTINCT
            BettransRng_RedTiger.TransactionRefId AS TransId,
            BettransRng_RedTiger.userId AS TpUserName
        FROM
            BettransRng_RedTiger
        WHERE
            BettransRng_RedTiger.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransRng_RedTiger.SettleFlag != 1;
    END IF;
    
    
    IF TpGameType = 120 THEN
        
        SET TableName = CONCAT("BettransRng_UuSlots_",  DATE_FORMAT(now(), '%Y%m'));
        SET @BeginTime = BeginTime;
        SET @EndTime = EndTime;
        
        SET @CMD = CONCAT("
            SELECT DISTINCT
                UUS.TicketNo AS TransId,
                UUS.OperatorCustId AS TpUserName
            FROM
                ", TableName, " AS UUS
            WHERE
                UUS.UpdateTime BETWEEN ? AND ?
            AND 
                UUS.SettleFlag != 1;
        ");
        PREPARE stmt FROM @CMD;
        EXECUTE stmt USING @BeginTime, @EndTime;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    
    IF TpGameType = 121 THEN
        
        SET TableName = CONCAT("BettransRng_Live22_",  DATE_FORMAT(now(), '%Y%m'));
        SET @BeginTime = BeginTime;
        SET @EndTime = EndTime;
        
        SET @CMD = CONCAT("
            SELECT DISTINCT
                L2.TicketNo AS TransId,
                L2.OperatorCustId AS TpUserName
            FROM
                ", TableName, " AS L2
            WHERE
                L2.UpdateTime BETWEEN ? AND ?
            AND 
                L2.SettleFlag != 1;
        ");
        PREPARE stmt FROM @CMD;
        EXECUTE stmt USING @BeginTime, @EndTime;
        DEALLOCATE PREPARE stmt;
    END IF;
    
    
    IF TpGameType = 122 THEN
        
        SET TableName = CONCAT("BettransRng_FastSpin_",  DATE_FORMAT(now(), '%Y%m'));
        SET @BeginTime = BeginTime;
        SET @EndTime = EndTime;
        
        SET @CMD = CONCAT("
            SELECT DISTINCT
                FS.TicketNo AS TransId,
                FS.OperatorCustId AS TpUserName
            FROM
                ", TableName, " AS FS
            WHERE
                FS.UpdateTime BETWEEN ? AND ?
            AND 
                FS.SettleFlag != 1;
        ");
        PREPARE stmt FROM @CMD;
        EXECUTE stmt USING @BeginTime, @EndTime;
        DEALLOCATE PREPARE stmt;
    END IF;

END;;
DELIMITER ;