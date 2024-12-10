CREATE DEFINER=`dbo`@`%` PROCEDURE `Finance_Tp_DailySummary_Set`(
  SummaryType int ,
  SummaryDate date ,
  TpId int ,
  CurrencyId int ,
  Stake decimal(20,6),
  ValidBet decimal(20,6),
  Payout decimal(20,6),
  Revenue decimal(20,6) ,
  WinlostAmount decimal(20,6),
  ProgressiveBet decimal(20,6),
  ProgressiveWin decimal(20,6),
  Reward decimal(20,6),
  CurrencyIso VARCHAR(15)
  /*
  Created: 20241031@Los
	DB: TSDB-TSDB
	Task: Add Alias

	Revisions:
        - 20241119@Los: Initial
*/
)
BEGIN
    
    INSERT INTO TpDailySummary
    (
        SummaryType,
        SummaryDate,
        TpId,
        CurrencyId,
        Stake,
        ValidBet,
        Payout,
        Revenue,
        WinlostAmount,
        ProgressiveBet,
        ProgressiveWin,
        Reward,
		CurrencyIso
    )
    VALUES
    (
        SummaryType,
        SummaryDate,
        TpId,
        CurrencyId,
        Stake,
        ValidBet,
        Payout,
        Revenue,
        WinlostAmount,
        ProgressiveBet,
        ProgressiveWin,
        Reward,
		CurrencyIso
    )
    ON DUPLICATE KEY UPDATE 
        TpDailySummary.Stake= Stake,
        TpDailySummary.ValidBet = ValidBet,
        TpDailySummary.Payout = Payout,
        TpDailySummary.Revenue = Revenue,
        TpDailySummary.WinlostAmount = WinlostAmount,
        TpDailySummary.ProgressiveBet = ProgressiveBet,
        TpDailySummary.ProgressiveWin = ProgressiveWin,
        TpDailySummary.Reward = Reward,
        TpDailySummary.CurrencyIso=CurrencyIso;
END