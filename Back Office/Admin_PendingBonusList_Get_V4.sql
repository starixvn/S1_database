CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_PendingBonusList_Get_V4`(
    IN _SiteIds JSON,
    IN _CurrencyIds JSON,
    IN _BonusCode VARCHAR(50),
    IN _PromotionTypes JSON,
    IN _UserName VARCHAR(30),
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
)
BEGIN

    
    
    
    
    
        SELECT SQL_CALC_FOUND_ROWS
               BI.BonusCode,
               BI.PromotionType,
               BI.SiteId,
               SI.SiteName,
               BI.CustId,
               BI.UserName,
               cb.BonusId,
               cb.LockedAmount,
               cb.BonusAmount,
               cb.Bonus,
               cbr.Rollover,
               FROM_UNIXTIME(cb.ExpiryTime) AS ExpiryTime,
               cb.CreateTime AS CreateTime,
               cb.TpId
          FROM CustBonus cb
    INNER JOIN CustBonusRollover cbr ON cbr.BonusId = cb.BonusId
    INNER JOIN BonusInfo BI ON cb.BonusId = BI.BonusId
    INNER JOIN ServerInfo SI ON BI.SiteId = SI.SiteId
         WHERE cb.`Status` = 1
           AND cb.TpId > 0
           AND BI.SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList)
           AND BI.PromotionType IN (SELECT * FROM JSON_TABLE(_PromotionTypes, '$[*]' COLUMNS(`PromotionType` INT PATH "$")) AS PromotionTypeList)
           AND BI.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList)
           AND ((_BonusCode IS NULL) OR (_BonusCode IS NOT NULL AND BI.BonusCode = _BonusCode))
           AND ((_UserName IS NULL) OR (_UserName IS NOT NULL AND BI.UserName = _UserName))
      ORDER BY cb.CreateTime DESC
         LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;

END