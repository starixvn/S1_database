/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/

DELIMITER $$
USE `TSDB`$$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_PromotionCashBackSetting_Get`(
    IN BonusCode VARCHAR(50),
    IN SiteId INT,
    IN CurrencyId TINYINT
/*
  Created: 20240212@Mira
        DB: TSDB-TSDB
        Task: Change IN to EXIST
        Revisions:
                - 20240212@Mira: init sp
*/
)
BEGIN
    

    SELECT TpId, CategoryId, Level, LossAmount, Percentage
    FROM PromotionCashBackSetting AS PCB
    LEFT JOIN PromotionDisplayCondition AS PDC
            ON PCB.BonusCode = PDC.BonusCode
           AND PCB.SiteId = PDC.SiteId
           AND PDC.ConditionType = 1
    WHERE PCB.BonusCode = BonusCode
      AND PCB.SiteId = SiteId
      AND PCB.CurrencyId = CurrencyId
      AND PCB.Status = 1
      AND PCB.Percentage > 0
      AND (PDC.`Description` IS NULL OR
      (PDC.`Description` IS NOT NULL AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(
				JSON_EXTRACT(PDC.`Description`, "$.VipLevel"),
				'$[*]' COLUMNS (`VipLevel` INT PATH "$")
			) AS VipLevelList
			WHERE VipLevelList.VipLevel = PCB.Level
		)));

END$$

DELIMITER ;
;