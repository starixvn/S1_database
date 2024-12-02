/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Service_BonusExpired_Get_V3`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BonusExpired_Get_V3`(
    IN `Limit` INT
/*
  Created:
	DB: TSDB-TSDB
	Task: get bonus expired

	Revisions:
		- 20241029@Kathy: get bonus expired
*/
)
BEGIN
    SET @fromunixtime = UNIX_TIMESTAMP('2023-06-01 00:00:00'); -- follow the init code
	SET @unixtime = UNIX_TIMESTAMP();
      
    SELECT 
        B.BonusId,
        B.CustId,
        C.SiteId,
        C.UserName,
        C.UserLang,
        C.CurrencyId,
        B.PromoCategoryId,
        B.Bonus,
        CASE
                WHEN 
                    (B.Bonus - B.BonusAmount) > B.LockedAmount
                THEN 
                    B.LockedAmount
                WHEN
                    (B.Bonus - B.BonusAmount) < 0
                THEN
                    0.0000
                ELSE 
                    (B.Bonus - B.BonusAmount)
        END AS Refund
    FROM
        CustBonus AS B
        INNER JOIN Customer AS C ON C.CustId = B.CustId
        INNER JOIN PromotionCategory AS PC ON B.PromoCategoryId = PC.Id
    WHERE
		B.ExpiryTime > @fromunixtime AND B.ExpiryTime < @unixtime
        AND B.`Status` = 1
        AND PC.WalletType = 1
		AND NOT EXISTS(SELECT 1
                       FROM TpBetRecord AS TBR
                       WHERE TBR.BonusId = B.BonusId
                           AND TBR.CustId = B.CustId
                           AND (TBR.SettlementType = 0 OR TBR.TicketStatus = 0))
    LIMIT `Limit`;
    
END;;
DELIMITER ;