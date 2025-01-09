/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Finance_Bettrans_PP_Check_TransId_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Finance_Bettrans_PP_Check_TransId_Get`(
    IN YYYYMM varchar(6),
    IN _BeginTime BIGINT,
    IN _EndTime BIGINT
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: check bet PP

	Revisions:
		- 20241029@Kathy: check bet PP
*/
)
BEGIN

    
    
    SET @BeginTime = FROM_UNIXTIME(_BeginTime);
    SET @EndTime = FROM_UNIXTIME(_EndTime);
    
    SET @CMD = CONCAT("
        SELECT
			BPM.TicketNo AS TransId,
            CU.CurrencyId AS CurrencyId,
            IFNULL(SUM(IF(BPM.TicketType = 4, ABS(BPM.ActualStake), 0)), 0) AS Stake,
            IFNULL(SUM(IF(BPM.TicketType = 4, ABS(BPM.NetStake), 0)), 0) AS ValidBet,
            IFNULL(SUM(BPM.Payout), 0) AS Payout,
            IFNULL(SUM(BPM.Payout), 0) - IFNULL(SUM(IF(BPM.TicketType = 4, ABS(BPM.ActualStake), 0)), 0) AS WinLostAmount
        FROM
			(
				SELECT  TicketNo, TicketType, NetStake, ActualStake, Payout, OperatorCustId
				FROM 	BettransRng_PP_", YYYYMM, " AS BPM
				WHERE 	BPM.SettleDate BETWEEN ? AND ?
						AND BPM.TicketStatus NOT IN (3)
						AND BPM.SettleFlag = 1   
				UNION ALL
				SELECT  TicketNo, TicketType, NetStake, ActualStake, Payout, OperatorCustId
				FROM 	BettransLC_PP_", YYYYMM, " AS BPM
				WHERE 	BPM.SettleDate BETWEEN ? AND ?
						AND BPM.TicketStatus NOT IN (3)
						AND BPM.SettleFlag = 1   
			) BPM
        LEFT JOIN 
            TpCustInfo AS TCI ON TCI.TpUserName = CONVERT(BPM.OperatorCustId USING ASCII) AND TCI.TpId = 5
        LEFT JOIN 
            Customer AS CU ON TCI.CustId = CU.CustId        
        GROUP BY BPM.TicketNo, CU.CurrencyId
        ORDER BY CU.CurrencyId;
    ");
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @BeginTime,@EndTime,@BeginTime,@EndTime;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;