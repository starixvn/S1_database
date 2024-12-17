/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_VipDowngradeReview_Get_V3`(
	IN _SiteId INT,
    IN _CalculateYearMonth CHAR(12),
    IN _SelectStatus JSON,
    IN _UserName VARCHAR(50),
    IN _CurrencyIds JSON,
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Get DownDeposit, DownDeposit in VipDowngradeReview instead of VipSystem
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
    
    SELECT SiteName INTO @SiteName
      FROM ServerInfo 
     WHERE ServerInfo.SiteId = _SiteId;

    CREATE TEMPORARY TABLE IF NOT EXISTS Temp_VipLevel_Current AS (
        SELECT SiteId, `Level`, LevelName
          FROM VipLevel
         WHERE VipLevel.SiteId = _SiteId
    );

    CREATE TEMPORARY TABLE IF NOT EXISTS Temp_VipLevel_Downgrade AS (
        SELECT * FROM Temp_VipLevel_Current
    );

    SET @CustId = 0;
    IF (_UserName <> '') THEN
        SELECT Customer.CustId
          INTO @CustId
          FROM Customer
         WHERE Customer.SiteId = _SiteId
           AND Customer.UserName = _UserName;
    END IF;

    IF (_PageSize = 0) THEN

        

            SELECT R.SiteId,
                   @SiteName AS SiteName,
                   R.CustId,
                   C.UserName,
                   R.CurrencyId,
                   Currency.IsoCode AS IsoCode,
                   R.CurrentVipLevel,
                   (SELECT LevelName FROM Temp_VipLevel_Current WHERE Temp_VipLevel_Current.Level = R.CurrentVipLevel) AS CurrentVipName,
                   R.DowngradeVipLevel,
                   (SELECT LevelName FROM Temp_VipLevel_Downgrade WHERE Temp_VipLevel_Downgrade.Level = R.DowngradeVipLevel) AS DowngradeVipName,
                   R.DowngradeDepositAmount AS ThresholdDeposit,
                   R.DepositAmount,
                   R.DowngradeTurnoverAmount AS ThresholdTurnOver,
                   R.TurnOverAmount,
                   R.`Status`,
                   R.CreateTime AS CalculateTime,
                   IF(R.`Status` = 4 ,R.SettleTime, null ) AS SettleTime,
                   CV.QualifiedTime AS QualifiedTime,
                   R.LastUpdateUser
              FROM VipDowngradeReview AS R
        INNER JOIN Customer AS C ON R.CustId = C.CustId
        INNER JOIN Currency ON R.CurrencyId = Currency.CurrencyId
         LEFT JOIN CustVip AS CV ON R.CustId = CV.CustId
             WHERE R.SiteId = _SiteId
               AND R.CalculateMonth = _CalculateYearMonth
               AND IF(_UserName <> '',R.CustId = @CustId,@CustId = 0)
               AND R.`Status` IN (SELECT `Status` FROM JSON_TABLE(_SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS StatusList)
               AND R.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyList)
          ORDER BY R.CalculateMonth,R.SiteId,R.CustId;
    ELSE
    
        
        SET _RowCount = 0;

            SELECT SQL_CALC_FOUND_ROWS
                   R.SiteId,
                   @SiteName AS SiteName,
                   R.CustId,
                   C.UserName,
                   IFNULL(CV.Exclusive, 0) AS Exclusive,
                   R.CurrencyId,
                   Currency.IsoCode AS IsoCode,
                   R.CurrentVipLevel,
                   (SELECT LevelName FROM Temp_VipLevel_Current WHERE Temp_VipLevel_Current.Level = R.CurrentVipLevel) AS CurrentVipName,
                   R.DowngradeVipLevel,
                   (SELECT LevelName FROM Temp_VipLevel_Downgrade WHERE Temp_VipLevel_Downgrade.Level = R.DowngradeVipLevel) AS DowngradeVipName,
                   R.DowngradeDepositAmount AS ThresholdDeposit,
                   R.DepositAmount,
                   R.DowngradeTurnoverAmount AS ThresholdTurnOver,
                   R.TurnOverAmount,
                   R.`Status`,
                   R.CreateTime AS CalculateTime,
                   IF(R.`Status` = 4 ,R.SettleTime, null ) AS SettleTime,
                   CV.QualifiedTime AS QualifiedTime,
                   R.LastUpdateUser
              FROM VipDowngradeReview AS R
        INNER JOIN Customer AS C ON R.CustId = C.CustId
        INNER JOIN Currency ON R.CurrencyId = Currency.CurrencyId
         LEFT JOIN CustVip AS CV ON R.CustId = CV.CustId
             WHERE R.SiteId = _SiteId
               AND R.CalculateMonth = _CalculateYearMonth
               AND IF(_UserName <> '',R.CustId = @CustId,@CustId = 0)
               AND R.`Status` IN (SELECT `Status` FROM JSON_TABLE(_SelectStatus, '$[*]' COLUMNS(`Status` INT path "$")) AS StatusList)
               AND R.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyList)
          ORDER BY R.CalculateMonth,R.SiteId,R.CustId
             LIMIT _StartIndex , _PageSize;

        SET _RowCount = FOUND_ROWS();
        IF _RowCount = 0 THEN 
            SET _TotalPages = 0;
        ELSE
            SET _TotalPages = CEIL(_RowCount/_PageSize);
        END IF;

    END IF;

    DROP TEMPORARY TABLE IF EXISTS Temp_VipLevel_Current, Temp_VipLevel_Downgrade;
END$$
DELIMITER ;






