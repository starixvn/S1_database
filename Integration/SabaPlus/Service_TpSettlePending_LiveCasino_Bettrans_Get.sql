/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_TpSettlePending_LiveCasino_Bettrans_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpSettlePending_LiveCasino_Bettrans_Get`(
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
    
    
    IF TpGameType = 9 THEN
        SELECT DISTINCT
            BettransLC_SA_Payout.Gameid AS TransId,
            BettransLC_SA_Payout.Username AS TpUserName 
        FROM
            BettransLC_SA_Payout
        WHERE
            BettransLC_SA_Payout.CreateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_SA_Payout.SettleFlag != 1;
    END IF;
    
    
    IF TpGameType = 8 THEN
        SELECT DISTINCT
            BettransLC_AGV2_Payout.transactionID AS TransId,
            REPLACE(BettransLC_AGV2_Payout.playname, 'GF4', '') AS TpUserName
        FROM
            BettransLC_AGV2_Payout
        WHERE
            BettransLC_AGV2_Payout.CreateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_AGV2_Payout.SettleFlag != 1;
    END IF;
    
    
    IF TpGameType = 10 THEN
        SELECT DISTINCT
            BettransLC_DG.TransId AS TransId,
            BettransLC_DG.Username AS TpUserName
        FROM
            BettransLC_DG
        WHERE
            BettransLC_DG.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_DG.SettleFlag != 1;
    END IF;
    
    
    IF TpGameType = 16 THEN
		SET TableName = CONCAT("BettransLC_PP_",  DATE_FORMAT(now(), '%Y%m'));
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
    
    
    IF TpGameType = 6 THEN
        SET TableName = CONCAT("BettransLC_Allbet_",  DATE_FORMAT(now(), '%Y%m'));
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
    
    
    IF TpGameType = 18 THEN
        SET TableName = CONCAT("BettransLC_Sexy_",  DATE_FORMAT(now(), '%Y%m'));
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
    
    
    IF TpGameType = 28 THEN
        SET TableName = CONCAT("BettransLC_WE_",  DATE_FORMAT(now(), '%Y%m'));
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
    
    
    IF TpGameType = 32 THEN
        SELECT DISTINCT
            BettransLC_WM.TransId AS TransId,
            BettransLC_WM.`user` AS TpUserName
        FROM
            BettransLC_WM
        WHERE
            BettransLC_WM.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_WM.SettleFlag != 1
        AND
            BettransLC_WM.category = 1;
    END IF;
    
    
    IF TpGameType = 37 THEN
        SELECT DISTINCT
            BettransLC_One789.TransId AS TransId,
            BettransLC_One789.Username AS TpUserName
        FROM
            BettransLC_One789
        WHERE
            BettransLC_One789.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_One789.SettleFlag != 1;
    END IF;

    
    IF TpGameType = 45 THEN
        SELECT DISTINCT
            BettransLC_N2Live.TransId AS TransId,
            BettransLC_N2Live.userid AS TpUserName
        FROM
            BettransLC_N2Live
        WHERE
            BettransLC_N2Live.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_N2Live.SettleFlag != 1
        AND 
            BettransLC_N2Live.TicketType = 4;
    END IF;
    
    
    IF TpGameType = 63 THEN
        SELECT DISTINCT
            BettransLC_EVO.TransactionRefId AS TransId,
            BettransLC_EVO.userId AS TpUserName
        FROM
            BettransLC_EVO
        WHERE
            BettransLC_EVO.UpdateTime BETWEEN @BeginTime AND @EndTime
        AND
            BettransLC_EVO.SettleFlag != 1;
    END IF;
    
END;;
DELIMITER ;