/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpBetRecordExtend_Ins_V2`(
    IN TpId INT,
    IN TransId VARCHAR(100),
    IN GameType INT,
    IN CustId INT,
    IN UserName VARCHAR(30),
    IN CurrencyId TINYINT,
    IN SiteId INT,
    IN TpUserName VARCHAR(50),
    IN TransTime BIGINT,
    IN SettledTime BIGINT,
    IN Stake DECIMAL(20,6),
    IN ValidBet DECIMAL(20,6),
    IN Revenue DECIMAL(20,6),
    IN WinlostAmount DECIMAL(20,6),
    IN ProgressiveBet DECIMAL(20,6),
    IN ProgressiveWin DECIMAL(20,6),
    IN SettlementType TINYINT,
    IN TicketStatus TINYINT,
    IN OriginalState varchar(10),
    IN TicketKey BIGINT,
    IN BonusId INT,
    IN ProviderID varchar(30),
    IN Currency varchar(20),
    IN RefNo varchar(50),
    IN GameID varchar(50),
    IN Provider varchar(20),
    IN Product varchar(50),
    IN Category varchar(20),
    IN Game varchar(200),
    IN Title varchar(100),
    IN MatchID varchar(40),
    IN BetType varchar(100),
    IN BetChoice varchar(1000),
    IN Result text,
    IN Odds decimal(18,2),
    IN OddsType varchar(20),
    IN Platform varchar(30),
    IN Live varchar(20),
    IN IP varchar(50)
	/*
  Created: 20241029@Los
	DB: TSDB-TSDB
	Task: get bet AE Sexy

	Revisions:
		- 20241029@Los: include Alias
*/
)
BEGIN
	
    
    SET @TpId=TpId;
    SET @TransId=TransId;
    SET @GameType=GameType;
    SET @CustId=CustId;
    SET @UserName=UserName;
    SET @CurrencyId=CurrencyId;
    SET @SiteId=SiteId;
    SET @TpUserName=TpUserName;
    SET @TransTime = IF(TransTime=0, NOW(), FROM_UNIXTIME(TransTime));
    SET @SettledTime = IF(SettledTime=0, NOW(), FROM_UNIXTIME(SettledTime));    
    SET @Stake=Stake;
    SET @ValidBet=ValidBet;
    SET @Revenue=Revenue;
    SET @WinlostAmount=WinlostAmount;
    SET @ProgressiveBet=ProgressiveBet;
    SET @ProgressiveWin=ProgressiveWin;
    SET @SettlementType=SettlementType;
    SET @TicketStatus=TicketStatus;
    SET @OriginalState=OriginalState;
    SET @TicketKey=TicketKey;
    SET @BonusId=BonusId;
    SET @ProviderID=ProviderID;
    SET @Currency=Currency;
    SET @RefNo=RefNo;
    SET @GameID=GameID;
    SET @Provider=Provider;
    SET @Product=Product;
    SET @Category=Category;
    SET @Game=Game;
    SET @Title=Title;
    SET @MatchID=MatchID;
    SET @BetType=BetType;
    SET @BetChoice=BetChoice;
    SET @Result=Result;
    SET @Odds=Odds;
    SET @OddsType=OddsType;
    SET @Platform=Platform;
    SET @Live=Live;
    SET @IP=IP;
     
    
    SET @PartitionDate = IF(@SettledTime > DATE_ADD(NOW(), INTERVAL 1 DAY), NOW(), @SettledTime);      
    
    SET @cmd = concat("INSERT INTO TpBetRecordExtend_", DATE_FORMAT(@PartitionDate, '%Y%m%d'), 
    " (
    TpId,
    TransId,
    GameType,
    CustId,
    UserName,
    CurrencyId,
    SiteId,
    TpUserName,
    TransTime,
    SettledTime,
    Stake,
    ValidBet,
    Revenue,
    WinlostAmount,
    ProgressiveBet,
    ProgressiveWin,
    SettlementType,
    TicketStatus,
    OriginalState,
    TicketKey,
    BonusId,
    ProviderID,
    Currency,
    RefNo,
    GameID,
    Provider,
    Product,
    Category,
    Game,
    Title,
    MatchID,
    BetType,
    BetChoice,
    Result,
    Odds,
    OddsType,
    Platform,
    Live,
    IP
    )
     VALUES  
    (
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?,
    ?
    ) 
    ON DUPLICATE KEY UPDATE 
    ValidBet=?,
    SettledTime=?,
    WinlostAmount=?,
    SettlementType=?,
    TicketStatus=?,
    Revenue=?,
    ProgressiveBet=?,
    ProgressiveWin=?,
    TransTime=?,
    ProviderID=?,
    Currency=?,
    RefNo=?,
    GameID=?,
    Provider=?,
    Product=?,
    Category=?,
    Game=?,
    Title=?,
    MatchID=?,
    BetType=?,
    BetChoice=?,
    Result=?,
    Odds=?,
    OddsType=?,
    Platform=?,
    Live=?,
    IP=?
    ;");        
    PREPARE stmt FROM @cmd;
    EXECUTE stmt USING
    @TpId,
    @TransId,
    @GameType,
    @CustId,
    @UserName,
    @CurrencyId,
    @SiteId,
    @TpUserName,
    @TransTime,
    @SettledTime,
    @Stake,
    @ValidBet,
    @Revenue,
    @WinlostAmount,
    @ProgressiveBet,
    @ProgressiveWin,
    @SettlementType,
    @TicketStatus,
    @OriginalState,
    @TicketKey,
    @BonusId,
    @ProviderID,
    @Currency,
    @RefNo,
    @GameID,
    @Provider,
    @Product,
    @Category,
    @Game,
    @Title,
    @MatchID,
    @BetType,
    @BetChoice,
    @Result,
    @Odds,
    @OddsType,
    @Platform,
    @Live,
    @IP,
    @ValidBet,
    @SettledTime,
    @WinlostAmount,
    @SettlementType,
    @TicketStatus,
    @Revenue,
    @ProgressiveBet,
    @ProgressiveWin,
    @TransTime,
    @ProviderID,
    @Currency,
    @RefNo,
    @GameID,
    @Provider,
    @Product,
    @Category,
    @Game,
    @Title,
    @MatchID,
    @BetType,
    @BetChoice,
    @Result,
    @Odds,
    @OddsType,
    @Platform,
    @Live,
    @IP;
    SELECT ROW_COUNT();
    DEALLOCATE PREPARE stmt;
END $$
DELIMITER $$;