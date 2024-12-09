/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_JILI_Settle_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_JILI_Settle_Get`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
/*
  Created: 20241029@Kathy
	DB: TSDB-TSDB
	Task: get bet JILI

	Revisions:
		- 20241029@Kathy: get bet JILI
*/
)

BEGIN
    SET @TransId = TransId;
    
    SET @CMD = CONCAT(
        "SELECT 
            userId AS `Account`,
            TicketNo AS TransId,
            Game AS GameId,
            ABS(betAmount) AS Stake,
            ABS(betAmount) AS ValidBet,
            winloseAmount - ABS(betAmount) AS WinLostAmount,
            TicketStatus AS TicketStatus,
            wagersTime AS TransTime,
            wagersTime AS SettleTime
        FROM BettransRng_JILI_", YYYYMM, " 
        WHERE TicketNo = ?
        AND TicketType != 2"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId;                    
    DEALLOCATE PREPARE stmt;
END;;
DELIMITER ;
