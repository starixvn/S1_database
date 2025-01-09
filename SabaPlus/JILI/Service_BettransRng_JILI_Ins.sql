/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransRng_JILI_Ins`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_JILI_Ins`(
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
	DB: TSDB-TSDB
	Task: insert bet JILI

	Revisions:
		- 20241029@Kathy: insert bet JILI
*/
)


BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET @reqId = Seq;
    SET @userId = OperatorCustId; 
    SET @currency = '' ;
    SET @game = GameId;
    SET @wagersTime = CASE WHEN SettleDateUnix = 0 THEN UNIX_TIMESTAMP(NOW()) ELSE SettleDateUnix END; 
    SET @betAmount = CASE WHEN NetStake > 0 THEN NetStake ELSE ActualStake END;
    SET @winloseAmount = Payout;
    SET @SiteId = 0;
    SET @CustId = 0; -- CustId;
    SET @CurrencyId = 0 ;
    SET @TicketType = TicketType;
    SET @TicketStatus = TicketStatus;
    SET @SettleFlag = SettleFlag;
    SET @TicketNo = TicketNo;
    SET @IpAddress = IpAddress;
	SET @GameRoundId = GameRoundId;
	SET @GameType = GameType;
	
    SET @CMD = CONCAT("INSERT INTO BettransRng_JILI_", YYYYMM,
                " (
                        `reqId`,
                        `userId`,
                        `currency`,
                        `game`,
                        `wagersTime`,
                        `betAmount`,
                        `winloseAmount`,
                        `SiteId`,
                        `CustId`,
                        `CurrencyId`,
                        `TicketType`,
                        `TicketStatus`,
                        `SettleFlag`,
                        `TicketNo`,
						`GameRoundId`,
						`IpAddress`,
						`GameType`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)") ;

    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
        @reqId,
        @userId,
        @currency,
        @game,
        @wagersTime,
        @betAmount,
        @winloseAmount,        
        @SiteId,
        @CustId,
        @CurrencyId,
        @TicketType,
        @TicketStatus,
        @SettleFlag,
        @TicketNo,
		@GameRoundId,
		@IpAddress	,
		@GameType
		;
        
	SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
    
    SET SQ = LAST_INSERT_ID();
	
	INSERT INTO SPLog (spname, starttime, endtime) VALUES ('Service_BettransRng_JILI_Ins', @starttime, CURRENT_TIMESTAMP(6));
    
END ;;
DELIMITER ;
