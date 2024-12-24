/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Member_DepositPromotion_Get_V4`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_DepositPromotion_Get_V4`(
    IN CustId INT,
    IN DeviceType TINYINT
/*
  Created: 
	DB: TSDB-TSDB
	Task: get promotion code

	Revisions:
		- 20241203@Kathy: get promotion code
*/
)
BEGIN
    
    
    

    SET @CustId = CustId;
    SET @SiteId = 0;
    SET @CurrencyId = 0;
    SET @AffId = 0;
    SET @AffCode = 0;
    SET @AgentId = 0;
    SET @CustVipLevel = 1;
    SET @TimeZone = NULL;
    SET @CategoryId = 0;

    SELECT
        C.SiteId,
        C.CurrencyId,
        C.AgentId,
        C.ActStatus
    INTO
       @SiteId,
       @CurrencyId,
       @AgentId,
       @ActStatus
    FROM
        Customer AS C
            LEFT JOIN
        CustProfile AS CP ON CP.CustId = C.CustId
    WHERE C.CustId = @CustId;

    SELECT Currency.TimeZone
    INTO @TimeZone
    FROM Currency
    WHERE Currency.CurrencyId = @CurrencyId;

    SELECT CONVERT_TZ(NOW(), @@session.time_zone, @TimeZone) INTO @CurrentTime;
    SELECT STR_TO_DATE(DATE_ADD(@CurrentTime, INTERVAL 1 DAY), '%Y-%c-%e') INTO @EndDate;
    SELECT CONVERT_TZ(STR_TO_DATE(@CurrentTime, '%Y-%c-%e'), @TimeZone, @@session.time_zone) INTO @TodayUtcStart;
    SELECT DATE_SUB(CONVERT_TZ(@EndDate, @TimeZone, @@session.time_zone), INTERVAL 1 MICROSECOND) INTO @TodayUtcEnd;

    SET @DiffUnixTime = UNIX_TIMESTAMP(CONVERT_TZ(NOW(), @@session.time_zone , @TimeZone)) ;

    IF @ActStatus = 2 THEN
        SELECT P2.CategoryId
        INTO @CategoryId
        FROM BonusInfo AS BI
                 INNER JOIN Promotion AS P2 ON BI.BonusCode = P2.BonusCode
        WHERE BI.CustId = @CustId
          AND BI.PromotionType = 2
          AND BI.CreateTime BETWEEN @TodayUtcStart AND @TodayUtcEnd
          AND P2.PeriodType = 4
        Limit 1;
    END IF;

    
    SELECT CustVip.VipLevel
         INTO @CustVipLevel
         FROM CustVip
        WHERE CustVip.CustId = @CustId
          AND CustVip.SiteId = @SiteId
    FOR SHARE;

    SELECT
        Aff_VN.AffId,
        Aff_VN.AffCode
    INTO
        @AffId,
        @AffCode
    FROM
        Affiliate_VN AS Aff_VN
    WHERE
        Aff_VN.CustId = @CustId;











    SELECT
        P.BonusCode,
        P.PromotionType,
        PS.Details,
        P.CategoryId,
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
        P.BlockTagList,
        PS.TierAmount
    FROM
        Promotion P
    INNER JOIN
        PromotionSpecific PS ON P.BonusCode = PS.BonusCode AND P.SiteId = PS.SiteId
    LEFT JOIN PromotionDisplayCondition AS PDC
        ON P.BonusCode = PDC.BonusCode
       AND P.SiteId = PDC.SiteId
       AND PDC.ConditionType = 1 
    WHERE
        P.SiteId = @SiteId
        AND P.`Status` = 1
        AND @DiffUnixTime BETWEEN P.PeriodFrom AND P.PeriodTo
        AND (PS.`Usage`= 0 OR PS.`Usage` > PS.BeenUsed)
		AND (PS.TotalUsageLimit = 0 OR PS.TotalUsageLimit > PS.TotalBeenUsed)
        AND PS.CurrencyId = @CurrencyId
        AND PS.SiteId = @SiteId
        AND PS.`Status` = 1
        AND ((PS.VN_AffCodes IS NULL AND PS.VN_AffIds IS NULL AND PS.AffId = 0)
            OR @AffId IN (SELECT VN_AffIds1.VN_AffId FROM JSON_TABLE(PS.VN_AffIds, '$[*]' COLUMNS(`VN_AffId` INT path "$")) AS VN_AffIds1)
            OR IF(@AffCode IS NULL, 0, @AffCode IN (SELECT VN_AffIds1.AffCode FROM JSON_TABLE(PS.VN_AffCodes, '$[*]' COLUMNS(`AffCode` VARCHAR(20) PATH "$")) AS VN_AffIds1))
            OR PS.AffId = @AgentId)
        AND (P.PromotionDeviceType = 1 OR P.PromotionDeviceType = DeviceType)
        AND P.IsSpecial = 0
        AND P.PromotionType = IF(@ActStatus = 1, 1, 2)
        AND NOT EXISTS(SELECT 1
                     FROM BonusInfo AS BI
                              INNER JOIN Promotion AS P2 ON BI.BonusCode = P2.BonusCode
                     WHERE BI.CustId = @CustId
							AND 1 = CASE 
										WHEN BI.`Status` IN (0, 1, 5) THEN 1 -- another bonus is running 
										WHEN @ActStatus = 1 AND BI.PromotionType IN (1, 5) THEN 1 -- first deposit
										WHEN BI.PromotionType = 2 
											THEN CASE 
													WHEN P2.PeriodType = 4 THEN CASE 
																					WHEN P.PeriodType <> P2.PeriodType AND BI.CreateTime BETWEEN @TodayUtcStart AND @TodayUtcEnd THEN 1 
                                                                                    ELSE 0 
																				END
													ELSE -- re-deposit and not UNLIMITED
														 CASE
																WHEN BI.CreateTime BETWEEN @TodayUtcStart AND @TodayUtcEnd THEN 1
																WHEN P2.PeriodType = P.PeriodType AND P2.PeriodType = 2 AND BI.CreateTime <= STR_TO_DATE(DATE_ADD(BI.CreateTime, INTERVAL 1 WEEK ), '%Y-%c-%e')  THEN 1 -- weekly
																WHEN P2.PeriodType = P.PeriodType AND P2.PeriodType = 3 AND BI.CreateTime <= STR_TO_DATE(DATE_ADD(BI.CreateTime, INTERVAL 1 MONTH ), '%Y-%c-%e')  THEN 1 -- monthly
																ELSE 0
															END 
													END
										ELSE 0
									END
        )
        AND (@ActStatus = 2 OR NOT EXISTS(SELECT 1
                                        FROM WithdrawalInfo
                                        WHERE WithdrawalInfo.CustId = @CustId
                                          AND WithdrawalInfo.`Status` NOT IN (5, 7)))
        AND (@CategoryId = 0
            OR (P.PeriodType = 4 AND P.CategoryId = @CategoryId))
        AND (PDC.`Description` IS NULL  
            OR (PDC.`Description` IS NOT NULL
                AND @CustVipLevel IN (SELECT * FROM JSON_TABLE( JSON_EXTRACT(PDC.`Description`, "$.VipLevel"),
                    '$[*]' COLUMNS(`VipLevel` INT PATH "$")) AS VipLevelList)
               )
           )
    ;
END;;
DELIMITER ;