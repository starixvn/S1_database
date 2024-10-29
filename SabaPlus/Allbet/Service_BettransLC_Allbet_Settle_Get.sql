/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLC_Allbet_Settle_Get`;
DELIMITER ;;
CREATE DEFINER=`nova88`@`%` PROCEDURE `Service_BettransLC_Allbet_Settle_Get`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: get bet Allbet

	Revisions:
		- 20241029@Kathy: get bet Allbet
*/
BEGIN
    SET @TransId = TransId;
    
    SET @CMD = CONCAT(
        "SELECT 
            OperatorCustId AS `Account`,
            TicketNo AS TransId,
            GameId AS GameId,
            IFNULL(SUM(IF(TicketType = 1, ABS(ActualStake), 0)), 0) AS Stake,
            IFNULL(SUM(IF(TicketType = 4, ABS(NetStake), 0)), 0) AS ValidBet,
            IFNULL(SUM(Payout), 0) - IFNULL(SUM(IF(TicketType = 1, ABS(ActualStake), 0)), 0) AS WinLostAmount,
            UNIX_TIMESTAMP(MAX(SettleDate)) AS TransTime,
            UNIX_TIMESTAMP(MAX(SettleDate)) AS SettleTime
        FROM BettransLC_Allbet_", YYYYMM, " 
        WHERE TicketNo = ?
        AND TicketType != 2
        GROUP BY TicketNo, OperatorCustId, GameId"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId;                    
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
