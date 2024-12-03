/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/

DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_PromotionList_Get_V9`(
    IN CustId INT,
    IN SiteId INT,
    IN CurrencyId INT,
    IN DeviceType TINYINT,
    IN LangId VARCHAR(5),
    IN PromotionType TINYINT
/*
  Created: 20240212@Mira
        DB: TSDB-TSDB
        Task: Change IN to EXIST
        Revisions:
                - 20240212@Mira: init sp
*/
)
BEGIN
    
    
    
    

    SET @AffCode = NULL;
    SET @AffId = -1;
    SET @AgentId = -1;
    SET @TimeZone = NULL;
    SET @CustVipLevel = 1;
    SET @Language = CONCAT('$.', LangId);

    SELECT Aff_VN.AffId,
           CONVERT(Aff_VN.AffCode USING UTF8MB4)
    INTO @AffId,
         @AffCode
    FROM Affiliate_VN AS Aff_VN
    WHERE Aff_VN.CustId = CustId;

    SELECT Customer.AgentId
    INTO @AgentId
    FROM Customer
    WHERE Customer.CustId = CustId;

    SELECT Currency.TimeZone
         INTO @TimeZone
         FROM Currency
         WHERE Currency.CurrencyId = CurrencyId;

    SET @DiffUnixTime = UNIX_TIMESTAMP(CONVERT_TZ(NOW(), @@session.time_zone , @TimeZone)) ;

     
       SELECT CustVip.VipLevel
         INTO @CustVipLevel
         FROM CustVip
        WHERE CustVip.CustId = CustId;

    SET @CustVipLevel = IFNULL(@CustVipLevel, 1);

    SELECT P.BonusCode,
           P.PromotionType,
           JSON_UNQUOTE(JSON_EXTRACT(PS.Details, CONCAT(@Language, '.title')))                    AS Title,
           JSON_UNQUOTE(JSON_EXTRACT(PS.Details, CONCAT(@Language, '.bannerUrl')))                AS Banner,
           JSON_UNQUOTE(JSON_EXTRACT(PS.Details, CONCAT(@Language, '.description')))              AS Description,
           JSON_UNQUOTE(JSON_EXTRACT(PS.Details, CONCAT(@Language, '.promotionLink')))            AS PromotionLink,
           P.CategoryId,
           P.WalletType,
           P.DisplayFrom,
           P.DisplayTo,
           P.PeriodFrom,
           P.PeriodTo,
           PS.RollOver,
           PS.Bonus,
           PS.RequiredAmount,
           PS.LockedType,
           PS.MaxBonus,
           PS.BonusType,
           P.Sort,
           P.CategoryId,
           P.TpId,
           P.OnlyRegistered,
           P.PromotionAction,
           (CASE
                WHEN P.PromotionType = 2 THEN 3
                WHEN P.PromotionType = 3 THEN 2
                ELSE P.PromotionType END) AS SortType,
           IF(PS.Usage = 0 OR PS.Usage > PS.BeenUsed, 0, 1) AS BeenUsed,
           PS.TierAmount,
           P.BlockTagList,
           P.HideForUnlogin,
           P.PeriodType,
           P.IsPopUp,
           PS.TurnoverTpGameTypes
    FROM Promotion AS P
    INNER JOIN PromotionSpecific AS PS
            ON P.BonusCode = PS.BonusCode
           AND P.SiteId = PS.SiteId
     LEFT JOIN PromotionDisplayCondition AS PDC
            ON P.BonusCode = PDC.BonusCode
           AND P.SiteId = PDC.SiteId
           AND PDC.ConditionType = 1 
         WHERE PS.SiteId = SiteId
           AND PS.CurrencyId = CurrencyId
           AND P.`Status` = 1
           AND PS.`Status` = 1
           AND (P.DisplayFrom <= @DiffUnixTime)
           AND ( (P.IsSpecial = 0 AND P.DisplayTo >= @DiffUnixTime)
                OR (P.IsSpecial = 1 AND P.DisplayTo < @DiffUnixTime)
               )
           AND ((PS.VN_AffCodes IS NULL AND PS.VN_AffIds IS NULL AND PS.AffId = 0)
				OR EXISTS (SELECT 1 FROM JSON_TABLE(PS.VN_AffIds,  '$[*]' COLUMNS (`VN_AffId` INT PATH "$") ) AS VN_AffIds1 WHERE VN_AffIds1.VN_AffId = @AffId)
                OR IF(@AffCode IS NULL, 0, EXISTS (SELECT 1 FROM JSON_TABLE(PS.VN_AffCodes, '$[*]' COLUMNS(`AffCode` VARCHAR(20) PATH "$")) AS VN_AffIds2 WHERE VN_AffIds2.AffCode = @AffCode))
                OR PS.AffId = @AgentId)
           AND (DeviceType = 0 OR P.PromotionDeviceType = 1
                OR P.PromotionDeviceType = DeviceType OR (DeviceType = 1 AND P.PromotionDeviceType = 2))
           AND (PS.TotalUsageLimit = 0 OR PS.TotalUsageLimit > PS.TotalBeenUsed)
           AND (PDC.`Description` IS NULL  
           
                OR (PDC.`Description` IS NOT NULL
                    AND EXISTS (SELECT 1 FROM JSON_TABLE(JSON_EXTRACT(PDC.`Description`, "$.VipLevel"), '$[*]' COLUMNS(`VipLevel` INT PATH "$")) AS VipLevelList WHERE VipLevelList.VipLevel = @CustVipLevel)
                   )
               )
            
            AND (PromotionType = 0 OR P.PromotionType = PromotionType)
    ORDER BY SortType, P.Sort;
END$$

DELIMITER ;
;