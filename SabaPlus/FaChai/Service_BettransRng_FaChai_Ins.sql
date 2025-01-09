/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_FaChai_Ins`(
    IN YYYYMM VARCHAR(6),
    IN Seq VARCHAR(64),
    IN OperatorCustId VARCHAR(32),
    IN GameId VARCHAR(50),
    IN Stake DECIMAL(20,6),
    IN Payout DECIMAL(20,6),
    IN SettleDateUnix BIGINT,
    IN TicketType TINYINT,
    IN TicketStatus TINYINT,
    IN IpAddress VARCHAR(25),
    IN TicketNo VARCHAR(200),
    IN GameRoundId VARCHAR(100),
    IN SettleFlag TINYINT,
    IN ActualStake DECIMAL(20,6),
    IN NetStake DECIMAL(20,6),
    OUT SQ BIGINT
/*
  Created: 20241031@Luke
	DB: TSDB-TSDB
	Task: Get FaChai bet ticket info from TicketNo

	Revisions:
		- 20241031@Luke: Initial
*/
)
BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET @RecordId = Seq;
    SET @MemberAccount = OperatorCustId;
    SET @GameId = GameId;
    SET @GameType = 'FaChai';
    SET @Bet = Stake;
    SET @Win = Payout;
    SET @GameDate = FROM_UNIXTIME(SettleDateUnix);
    SET @CreateDate = NOW();
    SET @Ts = SettleDateUnix;
    SET @TicketType = TicketType;
    SET @TicketStatus = TicketStatus;
    SET @IpAddress = IpAddress;
    SET @TicketNo = TicketNo;
    SET @GameRoundId = GameRoundId;
    SET @SettleFlag = SettleFlag;
    SET @ValidBet = CASE WHEN NetStake > 0 THEN NetStake ELSE ActualStake END;
   
    SET @CMD = CONCAT("INSERT INTO BettransRng_FaChai_", YYYYMM,
                " (
                      `RecordID` ,
                      `MemberAccount` ,
                      `GameID` ,
                      `GameType` ,
                      `Bet` ,
                      `Win` ,
                      `GameDate` ,
                      `CreateDate` ,
                      `Ts` ,
                      `TicketType` ,
                      `TicketStatus` ,
                      `IpAddress` ,
                      `TicketNo` ,
                      `GameRoundId` ,
                      `SettleFlag`,
                      `ValidBet`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)") ;
 
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING
        @RecordID,
        @MemberAccount,
        @GameID,
        @GameType,
        @Bet,
        @Win,
        @GameDate,
        @CreateDate,
        @Ts,
        @TicketType,
        @TicketStatus,
        @IpAddress,
        @TicketNo,
        @GameRoundId,
        @SettleFlag,
        @ValidBet;
       
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
   
    SET SQ = LAST_INSERT_ID();
	
	INSERT INTO SPLog (spname, starttime, endtime) VALUES ('Service_BettransRng_FaChai_Ins', @starttime, CURRENT_TIMESTAMP(6));
END$$
DELIMITER ;