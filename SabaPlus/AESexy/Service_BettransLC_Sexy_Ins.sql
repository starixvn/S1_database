/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLC_Sexy_Ins`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLC_Sexy_Ins`(
    IN YYYYMM VARCHAR(6),
    IN Seq VARCHAR(64), 
    IN OperatorCustId VARCHAR(32), 
    IN GameType VARCHAR(50),
    IN IpAddress VARCHAR(25), 
    IN TicketNo VARCHAR(200), 
    IN GameId VARCHAR(50), 
    IN GameRoundId VARCHAR(100), 
    IN TransactionId VARCHAR(100), 
    IN Stake DECIMAL(20,6), 
    IN ActualStake DECIMAL(20,6),
    IN NetStake DECIMAL(20,6),
    IN Payout DECIMAL(20,6),
    IN Odds DECIMAL(20,2),
    IN BetChoice VARCHAR(100),
    IN TableCode VARCHAR(100),
    IN GameResult VARCHAR(2000),
    IN CurrencyISO VARCHAR(10),
    IN BonusId VARCHAR(100),
    IN BonusName VARCHAR(500),
    IN PrizeName VARCHAR(500),
    IN SettleDateUnix BIGINT,
    IN TicketType TINYINT,
    IN TicketStatus TINYINT,
    IN SettleFlag TINYINT,
    OUT SQ BIGINT
/*
  Created: 
	DB: TSDB-Siebog
	Task: insert bet AE Sexy

	Revisions:
		- 20241029@Kathy: insert bet AE Sexy
*/
)


BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET @Seq = Seq;
    SET @OperatorCustId = OperatorCustId;
    SET @GameType = GameType;
    SET @IpAddress = IpAddress;
    SET @TicketNo = TicketNo;
    SET @GameId = GameId;
    SET @GameRoundId = GameRoundId;
    SET @TransactionId = TransactionId;
    SET @Stake = Stake;
    SET @ActualStake = ActualStake;
    SET @NetStake = NetStake;
    SET @Payout = Payout;
    SET @Odds = Odds;
    SET @BetChoice = BetChoice;
    SET @TableCode = TableCode;
    SET @GameResult = GameResult;
    SET @CurrencyISO = CurrencyISO;
    SET @BonusId = BonusId;
    SET @BonusName = BonusName;
    SET @PrizeName = PrizeName;
    SET @SettleDateUnix = FROM_UNIXTIME(SettleDateUnix);
    SET @TicketType = TicketType;
    SET @TicketStatus = TicketStatus;
    SET @SettleFlag = SettleFlag;
	
    SET @CMD = CONCAT("INSERT INTO BettransLC_Sexy_", YYYYMM,
                " (
                        `Seq`,
                        `OperatorCustId`,
                        `GameType`,
                        `IpAddress`,
                        `SettleDate`,
                        `TicketNo`,
                        `GameId`,
                        `GameRoundId`,
                        `TransactionId`,
                        `Stake`,
                        `ActualStake`,
                        `NetStake`,
                        `Payout`,
                        `Odds`,
                        `BetChoice`,
                        `TableCode`,
                        `GameResult`,
                        `CurrencyISO`,
                        `BonusId`,
                        `BonusName`,
                        `PrizeName`,
                        `TicketType`,
                        `TicketStatus`,
                        `SettleFlag`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)") ;

    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
        @Seq,
        @OperatorCustId,
        @GameType,
        @IpAddress,
        @SettleDateUnix,
        @TicketNo,
        @GameId,
        @GameRoundId,
        @TransactionId,
        @Stake,
        @ActualStake,
        @NetStake,
        @Payout,
        @Odds,
        @BetChoice,
        @TableCode,
        @GameResult,
        @CurrencyISO,
        @BonusId,
        @BonusName,
        @PrizeName,
        @TicketType,
        @TicketStatus,
        @SettleFlag;

    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
    
    SET SQ = LAST_INSERT_ID();
	
	INSERT INTO SPLog (spname, starttime, endtime) VALUES ('Service_BettransLC_Sexy_Ins', @starttime, CURRENT_TIMESTAMP(6));
    
END ;;
DELIMITER ;