/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BettransLC_PP_Ins`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransLC_PP_Ins`(
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
	Task: insert bet PP

	Revisions:
		- 20241029@Kathy: insert bet PP
*/
)

BEGIN
	SET @seq  = seq;
    SET @roundId = GameRoundId;
    SET @gameId = GameId;
    SET @OperatorCustId = OperatorCustId;	
    SET @SettleDateUnix = FROM_UNIXTIME(SettleDateUnix);   
    SET @TicketType = TicketType;
    SET @TicketStatus = TicketStatus;
	SET @SettleFlag = SettleFlag;	    
    SET @TicketNo = TicketNo;
	SET @ActualStake = ActualStake;
	SET @Payout = Payout;
	SET @NetStake = NetStake;
   
   SET @CMD = CONCAT("INSERT INTO BettransLC_PP_", YYYYMM,
                " (
                        `seq`,
                        `roundId`,
                        `gameId`,
                        `ActualStake`,
						`Payout`,
                        `OperatorCustId`,                        
                        `SettleDate`,                        
                        `TicketType`,
                        `TicketStatus`,
						`SettleFlag`,                       
                        `TicketNo`,
						`NetStake`
                    )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)") ;
                
	PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
		@seq
        ,@roundId
        ,@gameId
        ,@ActualStake
		,@Payout
        ,@OperatorCustId        
        ,@SettleDateUnix        
        ,@TicketType
        ,@TicketStatus
		,@SettleFlag       
        ,@TicketNo
		,@NetStake
		;
        
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
	
	SET SQ = LAST_INSERT_ID();
END;;
DELIMITER ;