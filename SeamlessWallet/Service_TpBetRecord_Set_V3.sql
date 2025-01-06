/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_TpBetRecord_Set_V3`;
DELIMITER ;;
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
     IN GameID varchar(50)
/*
  Created: 
	DB: TSDB-TSDB
	Task: update TpBetRecord

	Revisions:
		- 20250106@Kathy: remove "update with duplicate key" statement
*/
)
BEGIN
    

    SET @SettledTime = IF(SettledTime=0, NOW(), FROM_UNIXTIME(SettledTime));
    SET @TransTime = IF(TransTime=0, NOW(), FROM_UNIXTIME(TransTime));
    
	IF EXISTS(SELECT 1 FROM TpBetRecord t WHERE t.TpId = TpId AND t.TransId = TransId AND t.GameType = GameType ) THEN
		UPDATE TpBetRecord t 
			SET TransTime = @TransTime,
				SettledTime = @SettledTime, 
				Stake = Stake, 
				ValidBet = ValidBet,
				Revenue = Revenue,
				WinlostAmount = WinlostAmount,
				ProgressiveBet = ProgressiveBet,
				ProgressiveWin = ProgressiveWin,
				SettlementType = SettlementType,
				TicketStatus = TicketStatus,
				OriginalState = OriginalState,
				TicketKey = TicketKey,
				BonusId = BonusId,
				GameID = GameID
		WHERE 	t.TpId = TpId
				AND t.TransId = TransId
				AND t.GameType = GameType;
		
		INSERT INTO TpBetRecord_testing (
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
			) ;
	ELSE
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
			) ;
			
		INSERT INTO TpBetRecord_testing (
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
			) ;
	END IF;
END;;
DELIMITER ;