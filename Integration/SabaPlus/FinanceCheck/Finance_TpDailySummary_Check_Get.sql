/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Finance_TpDailySummary_Check_Get`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Finance_TpDailySummary_Check_Get`(
    SummaryType int ,
    BeginTime datetime,
    EndTime datetime
/*
  Created: 20241206@Kathy
	DB: TSDB-TSDB
	Task: get data TpDailySummary

	Revisions:
		- 20241206@Kathy: get data TpDailySummary
*/
)
BEGIN

     SELECT 
        TpId,
        CurrencyId,
        SUM(IFNULL(Stake,0)) AS Stake,
        SUM(IFNULL(ValidBet,0)) AS ValidBet,
        SUM(IFNULL(Payout,0)) AS Payout,
        SUM(IFNULL(Revenue,0)) AS Revenue,
        SUM(IFNULL(WinlostAmount,0)) AS WinlostAmount,
        SUM(IFNULL(ProgressiveBet,0)) AS ProgressiveBet,
        SUM(IFNULL(ProgressiveWin,0)) AS ProgressiveWin,
        SUM(IFNULL(Reward,0)) AS Reward
    FROM TpDailySummary
    WHERE TpDailySummary.SummaryType = SummaryType
        AND TpDailySummary.SummaryDate >= BeginTime  
        AND TpDailySummary.SummaryDate < EndTime  
    GROUP BY TpId,CurrencyId
    ORDER BY TpId,CurrencyId;
    
END ;;
DELIMITER ;