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
    IN TransactionId VARCHAR(100), 
    IN Odds DECIMAL(20,2),
    IN BetChoice VARCHAR(100),
    IN TableCode VARCHAR(100),
    IN GameResult VARCHAR(2000),
    IN CurrencyISO VARCHAR(10),
    IN BonusId VARCHAR(100),
    IN BonusName VARCHAR(500),
    IN PrizeName VARCHAR(500),
	IN SettleFlag TINYINT,
	IN ActualStake DECIMAL(20,6),
    OUT SQ BIGINT
)
/*
  Created: 20241031@Luke
	DB: TSDB-TSDB
	Task: Insert FaChai bet ticket

	Revisions:
		- 20241031@Luke: Initial
*/
BEGIN
    SET @RecordId = Seq;
    SET @BankID = '';
    SET @MemberAccount = OperatorCustId; 
    SET @Currency = '' ;
    SET @GameId = GameId;
	SET @GameType = '';
    SET @isBuyFeature = 0;
    SET @Bet = CASE WHEN Stake > 0 THEN Stake ELSE ActualStake END;
    SET @Win = Payout;
    SET @JPBet = 0;
    SET @JPPrize = 0;
    SET @NetWin = 0;
    SET @RequireAmt = 0;
    SET @GameDate = FROM_UNIXTIME(SettleDateUnix);
    SET @CreateDate = NOW();
    SET @Ts = SettleDateUnix;
    SET @TicketType = TicketType;
    SET @TicketStatus = TicketStatus;
    SET @IpAddress = IpAddress;
    SET @TicketNo = TicketNo;
    SET @GameRoundId = GameRoundId;
    SET @TransactionId = TransactionId;
    SET @Odds = Odds;
    SET @BetChoice = BetChoice;
    SET @TableCode = TableCode;
    SET @GameResult = GameResult;
    SET @CurrencyISO = CurrencyISO;
    SET @BonusId = BonusId;
    SET @BonusName = BonusName;
    SET @PrizeName = PrizeName;
	SET @SettleFlag = SettleFlag;
	SET @ValidBet = ActualStake;
    
    SET @CMD = CONCAT("INSERT INTO BettransRng_FaChai_", YYYYMM,
                " (
					  `RecordID` ,
					  `BankID` ,
					  `MemberAccount` ,
					  `Currency` ,
					  `GameID` ,
					  `GameType` ,
					  `isBuyFeature` ,
					  `Bet` ,
					  `Win` ,
					  `JPBet` ,
					  `JPPrize` ,
					  `NetWin` ,
					  `RequireAmt` ,
					  `GameDate` ,
					  `CreateDate` ,
					  `Ts` ,
					  `TicketType` ,
					  `TicketStatus` ,
					  `IpAddress` ,
					  `TicketNo` ,
					  `GameRoundId` ,
					  `TransactionId` ,
					  `Odds` ,
					  `BetChoice` ,
					  `TableCode` ,
					  `GameResult` ,
					  `CurrencyISO` ,
					  `BonusId` ,
					  `BonusName` ,
					  `PrizeName` ,
					  `SettleFlag`,
					  `ValidBet`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)") ;

    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
        @RecordID,
        @BankID,
        @MemberAccount,
        @Currency,
        @GameID,
        @GameType,
        @isBuyFeature,
        @Bet,
        @Win,
        @JPBet,
        @JPPrize,
        @NetWin,
        @RequireAmt,
        @GameDate,
        @CreateDate,
        @Ts,
        @TicketType,
        @TicketStatus,
        @IpAddress,
        @TicketNo,
        @GameRoundId,
        @TransactionId,
        @Odds,
        @BetChoice,
        @TableCode,
        @GameResult,
        @CurrencyISO,
        @BonusId,
        @BonusName,
        @PrizeName,
		@SettleFlag,
		@ValidBet;
        
	SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
    
    SET SQ = LAST_INSERT_ID();
    
END$$
DELIMITER ;
