/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_PP_Ins`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_PP_Ins`(
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
)
/*
  Created: 20241029@Kathy
	DB: TSDB-Siebog
	Task: insert bet PP

	Revisions:
		- 20241029@Kathy: insert bet PP
*/
BEGIN
	SET @reference  = seq;
    SET @roundId = GameRoundId;
    SET @gameId = GameId;
    SET @amount = ActualStake;
    SET @userId = OperatorCustId;
    SET @roundDetails = '';	
    SET @timestamp = UNIX_TIMESTAMP(IFNULL(SettleDateUnix,NOW())); 
    SET @bonusCode = '';
    SET @jackpotId = 0;
    SET @jackpotContribution = 0;
    SET @type = TicketType;
    SET @TicketStatus = TicketStatus;
	SET @Flag = SettleFlag;	
    SET @promoWinAmount = 0;
    SET @promoWinReference = '';
    SET @promoCampaignID = 0;
    SET @promoCampaignType = ''; 
    SET @TicketNo = TicketNo;
   
   SET @CMD = CONCAT("INSERT INTO BettransRng_PP_", YYYYMM,
                " (
                        `reference`,
                        `roundId`,
                        `gameId`,
                        `amount`,
                        `userId`,
                        `roundDetails`,
                        `timestamp`,
                        `bonusCode`,
                        `jackpotId`,
                        `jackpotContribution`,
                        `type`,
                        `TicketStatus`,
                        `promoWinAmount`,
                        `promoWinReference`,
                        `promoCampaignID`,
                        `promoCampaignType`,
                        `TicketNo`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)") ;
                
	PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
		@reference
        ,@roundId
        ,@gameId
        ,@amount
        ,@userId
        ,@roundDetails
        ,@timestamp
        ,@bonusCode
		,@jackpotId
        ,@jackpotContribution
        ,@type
        ,@TicketStatus
        ,@promoWinAmount
        ,@promoWinReference
        ,@promoCampaignID
        ,@promoCampaignType
        ,@TicketNo;
        
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
	
	SET SQ = LAST_INSERT_ID();
END;;
DELIMITER ;