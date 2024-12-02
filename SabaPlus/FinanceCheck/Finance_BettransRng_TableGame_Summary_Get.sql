/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Finance_BettransRng_TableGame_Summary_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Finance_BettransRng_TableGame_Summary_Get`(
    IN YYYYMM varchar(6),
    IN _BeginTime BIGINT,
    IN _EndTime BIGINT
/*
  Created: 20241205@Kathy
	DB: TSDB-TSDB
	Task: check bet tablegame

	Revisions:
		- 20241029@Kathy: check bet tablegame
*/
)
BEGIN

    
    
    SET @BeginTime = FROM_UNIXTIME(_BeginTime);
    SET @EndTime = FROM_UNIXTIME(_EndTime);
    
    SET @CMD = CONCAT("
        SELECT
            CU.CurrencyId AS CurrencyId,
            IFNULL(SUM(IF(BPM.TicketType = 4, ABS(BPM.ActualStake), 0)), 0) AS Stake,
            IFNULL(SUM(IF(BPM.TicketType = 4, ABS(BPM.NetStake), 0)), 0) AS ValidBet,
            IFNULL(SUM(BPM.Payout), 0) AS Payout,
            IFNULL(SUM(BPM.Payout), 0) - IFNULL(SUM(IF(BPM.TicketType = 4, ABS(BPM.ActualStake), 0)), 0) AS WinLostAmount
        FROM
            BettransRng_TableGame_", YYYYMM, " AS BPM
        LEFT JOIN 
            TpCustInfo AS TCI ON TCI.TpUserName = CONVERT(BPM.OperatorCustId USING ASCII) AND TCI.TpId = 73
        LEFT JOIN 
            Customer AS CU ON TCI.CustId = CU.CustId
        WHERE
            BPM.SettleDate BETWEEN ? AND ?
        AND
            BPM.TicketStatus NOT IN (3)
        AND 
            BPM.SettleFlag = 1    
        GROUP BY CU.CurrencyId
        ORDER BY CU.CurrencyId;
    ");
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @BeginTime,@EndTime;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;