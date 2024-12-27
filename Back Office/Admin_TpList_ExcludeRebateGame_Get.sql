/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_TpList_ExcludeRebateGame_Get`(
    IN _SiteIds JSON, 
    IN _CurrencyId INT
    /*
      Created: 20241226@Johnny
      DB: TSDB-TSDB
      Task: Get Slot game for TpCategory is 2 (exclude SabaPlay)

      Revisions:
          - 20241226@Johnny: Init sp
    */      
)
BEGIN
     SELECT DISTINCT TL.Id AS TpId,
              TL.TpName AS TpName
         FROM `TSDB`.`TpGameType` AS TGT
    LEFT JOIN `TSDB`.`TpGameTypeCurrency` AS TGTC 
           ON TGT.`Type` = TGTC.TpGameType
    LEFT JOIN `TSDB`.`TpList` AS TL
           ON TGT.TpId = TL.Id
   INNER JOIN `TSDB`.`SlotGame` AS SG
           ON SG.TpId = TL.Id
        WHERE TGTC.`Status` = 1
          AND TL.`Status` = 1
          AND EXISTS (
              SELECT 1
              FROM JSON_TABLE(
                  _SiteIds, 
                  '$[*]' COLUMNS(`SiteId` INT path "$")
              ) AS SiteList
              WHERE SiteList.SiteId = TGTC.SiteId
          )
          AND ((_CurrencyId = 0) OR (_CurrencyId != 0 AND TGTC.CurrencyId = _CurrencyId))
          AND TGT.CategoryId = 2
     ORDER BY TL.Id;  
END$$
DELIMITER ;
