/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_PP_Settle_Get`;
DELIMITER ;;
CREATE DEFINER=`nova88`@`%` PROCEDURE `Service_BettransRng_PP_Settle_Get`(
    IN YYYYMM VARCHAR(6),
    IN TransId VARCHAR(200)
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: get bet PP

	Revisions:
		- 20241029@Kathy: get bet PP
*/
BEGIN
    SET @TransId = TransId;
    
    SET @CMD = CONCAT(
        "SELECT 
            userId AS `Account`,
            TicketNo AS TransId,
            GameId AS GameId,
            IFNULL(SUM(IF(Type = 1, ABS(amount), 0)), 0) AS Stake,
            IFNULL(SUM(IF(Type = 4, ABS(amount), 0)), 0) AS ValidBet,
            IFNULL(SUM(IF(Type = 4, ABS(amount), 0)), 0) - IFNULL(SUM(IF(Type = 1, ABS(amount), 0)), 0) AS WinLostAmount,
            UNIX_TIMESTAMP(MAX(timestamp)) AS TransTime,
            UNIX_TIMESTAMP(MAX(timestamp)) AS SettleTime
        FROM BettransRng_PP_", YYYYMM, " 
        WHERE TicketNo = ?
        AND Type != 2
        GROUP BY TicketNo, userId, GameId"
    );
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TransId;                    
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
