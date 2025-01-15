/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpBetRecord_Set_V3`(
     IN TpId int,
     IN TransId varchar(100) ,
     IN GameType int,
     IN CustId int,
     IN UserName varchar(30),
     IN CurrencyId int,
     IN SiteId int,
     IN TpUserName varchar(50),
     IN TransTime bigint,
     IN SettledTime bigint ,
     IN Stake decimal(20,6),
     IN ValidBet decimal(20,6),
     IN Revenue decimal(20,6),
     IN WinlostAmount decimal(20,6),
     IN ProgressiveBet decimal(20,6),
     IN ProgressiveWin decimal(20,6),
     IN SettlementType tinyint,
     IN TicketStatus tinyint,
     IN OriginalState varchar(10),
     IN TicketKey bigint,
     IN BonusId int,
     IN GameID varchar(50),
     IN GUID VARCHAR(50)
/*
  Created: 20250114@Kathy
        DB: TSDB-TSDB
        Task: load test
        Revisions:
                - 20241226@Kathy: load test
*/
)
BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);

    SET @SettledTime = IF(SettledTime=0, NOW(), FROM_UNIXTIME(SettledTime));
    SET @TransTime = IF(TransTime=0, NOW(), FROM_UNIXTIME(TransTime));
    
    INSERT INTO TpBetRecord
    (
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
        BonusId,
        GameID,
        TicketKey
    )
    VALUES
    (
        TpId,
        TransId,
        GameType,
        CustId,
        UserName,
        CurrencyId,
        SiteId,
        TpUserName,
        @TransTime,
        @SettledTime,
        Stake,
        ValidBet,
        Revenue,
        WinlostAmount,
        ProgressiveBet,
        ProgressiveWin,
        SettlementType,
        TicketStatus,
        OriginalState,
        BonusId,
        GameID,
        TicketKey
    )
    ON DUPLICATE KEY UPDATE 
        TpBetRecord.TransTime = @TransTime,
        TpBetRecord.SettledTime = @SettledTime, 
        TpBetRecord.Stake = Stake, 
        TpBetRecord.ValidBet = ValidBet,
        TpBetRecord.Revenue = Revenue,
        TpBetRecord.WinlostAmount = WinlostAmount,
        TpBetRecord.ProgressiveBet = ProgressiveBet,
        TpBetRecord.ProgressiveWin = ProgressiveWin,
        TpBetRecord.SettlementType = SettlementType,
        TpBetRecord.TicketStatus = TicketStatus,
        TpBetRecord.OriginalState = OriginalState,
        TpBetRecord.TicketKey = TicketKey,
        TpBetRecord.BonusId = BonusId,
        TpBetRecord.GameID = GameID;
		
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_TpBetRecord_Set_V3', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
