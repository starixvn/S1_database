/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_FaChai_TicketNo_Get`;
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_FaChai_TicketNo_Get`(
    IN YYYYMM VARCHAR(6),
    IN TicketNo VARCHAR(200),
    IN GUID VARCHAR(50)
)
/*
  Created: 20241030@Luke
	DB: TSDB-TSDB
	Task: Get FaChai bet info

	Revisions:
		- 20241030@Luke: Initial
*/
BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET @TicketNo = TicketNo;
    
    SET @CMD = CONCAT("SELECT `SQ`,
						`RecordID`,
                        `MemberAccount`,
                        `GameID`,
                        `GameType`,
                        `Bet`,
                        `Win`,
                        `GameDate`,
                        `CreateDate`,
                        `Ts`,
                        `TicketType`,
                        `TicketStatus`,
                        `CreateTime`,
                        `UpdateTime`,
                        `IpAddress`,
                        `TicketNo`,
                        `GameRoundId`,
                        `SettleFlag`,
                        `ValidBet` AS ActualStake
			FROM BettransRng_FaChai_", YYYYMM, " WHERE TicketNo = ?;");
    
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_BettransRng_FaChai_TicketNo_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END 
$$
DELIMITER ;