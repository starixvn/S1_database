/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_AdjustmentTotalAmount_Get_V7`(
IN _SiteIds json,
IN _CurrencyIds json,
IN _GetFromAdjustmentInfo tinyint(1),
IN _AdjustTypesForAI json,
IN _GetFromLogAdminAdjustWallet tinyint(1),
IN _AdjustTypesForLAAW json,
IN _StartDate datetime,
IN _EndDate datetime,
IN _UserName varchar(30) CHARACTER SET ASCII ,
IN _TpUserName varchar(30) CHARACTER SET ASCII ,
IN _DepositId varchar(30) CHARACTER SET ASCII ,
IN _TransId varchar(30) CHARACTER SET ASCII ,
IN _MemberTypes json
 /*
  Created: 20241108@Mira
	DB: TSDB-TSDB
	Task: Initial

	Revisions:
		- 20241108@Mira: Initial
*/ 
)
BEGIN
    

    DROP TEMPORARY TABLE IF EXISTS `TempAdjustmentTotalAmount`;
    CREATE TEMPORARY TABLE TempAdjustmentTotalAmount (
        Currency CHAR(4),
        Amount DECIMAL(20,4) NOT NULL,
        Record INT
    );

    
    IF _GetFromAdjustmentInfo=TRUE THEN

        IF _UserName IS NULL AND _TpUserName IS NULL THEN
          INSERT IGNORE INTO TempAdjustmentTotalAmount
                   (Currency,Amount,Record)
            SELECT CY.IsoCode,
                   SUM(AI.Amount),
                   COUNT(CY.IsoCode)
              FROM AdjustmentInfo AS AI
        INNER JOIN Customer AS C ON C.CustId = AI.CustId
        LEFT JOIN Currency AS CY ON AI.CurrencyId = CY.CurrencyId
        LEFT JOIN AdjustmentDepositLog ADL ON ADL.TransId = AI.TransId AND ADL.AdjustType = 1
        LEFT JOIN DepositInfo DP ON DP.DepositId = ADL.DepositId
               WHERE AI.CreateTime BETWEEN _StartDate AND _EndDate
               AND AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
               AND AI.AdjustType IN (SELECT AdjustTypesForAI FROM JSON_TABLE(_AdjustTypesForAI, '$[*]' COLUMNS(`AdjustTypesForAI` INT path "$")) AS AdjustTypesForAIList)
               AND AI.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyIdList)
               AND (_TransId IS NULL OR (AI.TransId = _TransId))
               AND (_DepositId IS NULL OR (DP.TransId = _DepositId))
               AND C.MemberType IN (SELECT MemberType FROM JSON_TABLE(_MemberTypes, '$[*]' COLUMNS(`MemberType` INT path "$")) AS MemberTypeList)
          GROUP BY CY.IsoCode;
        END IF;

        IF _UserName IS NOT NULL THEN
            INSERT IGNORE INTO TempAdjustmentTotalAmount
                   (Currency,Amount,Record)
            SELECT CY.IsoCode,
                   SUM(AI.Amount),
                   COUNT(CY.IsoCode)
              FROM AdjustmentInfo AS AI
              INNER JOIN Customer AS C ON C.CustId = AI.CustId
              LEFT JOIN Currency AS CY ON AI.CurrencyId = CY.CurrencyId
              LEFT JOIN AdjustmentDepositLog ADL ON ADL.TransId = AI.TransId AND ADL.AdjustType = 1
              LEFT JOIN DepositInfo DP ON DP.DepositId = ADL.DepositId
              WHERE AI.CreateTime BETWEEN _StartDate AND _EndDate
               AND AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
               AND AI.AdjustType IN (SELECT AdjustTypesForAI FROM JSON_TABLE(_AdjustTypesForAI, '$[*]' COLUMNS(`AdjustTypesForAI` INT path "$")) AS AdjustTypesForAIList)
               AND AI.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyIdList)
               AND (_UserName IS NULL OR (C.UserName = _UserName))
               AND (_TransId IS NULL OR (AI.TransId = _TransId))
               AND (_DepositId IS NULL OR (DP.TransId = _DepositId))
               AND C.MemberType IN (SELECT MemberType FROM JSON_TABLE(_MemberTypes, '$[*]' COLUMNS(`MemberType` INT path "$")) AS MemberTypeList)
          GROUP BY CY.IsoCode;

        END IF;

        IF _TpUserName IS NOT NULL THEN
            INSERT IGNORE INTO TempAdjustmentTotalAmount
                   (Currency,Amount,Record)
            SELECT CY.IsoCode,
                   SUM(AI.Amount),
                   COUNT(CY.IsoCode)
              FROM AdjustmentInfo AS AI
              INNER JOIN Customer AS C ON C.CustId = AI.CustId
              LEFT JOIN Currency AS CY ON AI.CurrencyId = CY.CurrencyId
              LEFT JOIN TpCustInfo AS TCI ON TCI.CustId = C.CustId AND TCI.TpId=1
              LEFT JOIN AdjustmentDepositLog ADL ON ADL.TransId = AI.TransId AND ADL.AdjustType = 1
              LEFT JOIN DepositInfo DP ON DP.DepositId = ADL.DepositId
             WHERE AI.CreateTime BETWEEN _StartDate AND _EndDate
              
               AND AI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
               AND AI.AdjustType IN (SELECT AdjustTypesForAI FROM JSON_TABLE(_AdjustTypesForAI, '$[*]' COLUMNS(`AdjustTypesForAI` INT path "$")) AS AdjustTypesForAIList)
               AND AI.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyIdList)
               AND (TCI.TpUserName = _TpUserName)
               AND (_TransId IS NULL OR (AI.TransId = _TransId))
               AND (_DepositId IS NULL OR (DP.TransId = _DepositId))
               AND C.MemberType IN (SELECT MemberType FROM JSON_TABLE(_MemberTypes, '$[*]' COLUMNS(`MemberType` INT path "$")) AS MemberTypeList)
          GROUP BY CY.IsoCode;

        END IF;

    END IF;


    

    IF _GetFromLogAdminAdjustWallet=TRUE THEN

        IF _UserName IS NULL AND _TpUserName IS NULL THEN
             INSERT IGNORE INTO TempAdjustmentTotalAmount
                   (Currency,Amount,Record)
             SELECT CY.IsoCode,
                   SUM(LAAW.Amount),
                   COUNT(CY.IsoCode)
             FROM LogAdminAdjustWallet AS LAAW
             INNER JOIN Customer AS C ON C.CustId = LAAW.CustId
             LEFT JOIN Currency AS CY ON C.CurrencyId = CY.CurrencyId
             LEFT JOIN AdjustmentDepositLog ADL ON ADL.TransId = LAAW.TransId AND ADL.AdjustType = 2
             LEFT JOIN DepositInfo DP ON DP.DepositId = ADL.DepositId
              WHERE LAAW.CreateTime BETWEEN _StartDate AND _EndDate
               AND LAAW.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
               AND C.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyIdList)
               AND LAAW.Direction IN (SELECT AdjustTypesForLAAW FROM JSON_TABLE(_AdjustTypesForLAAW, '$[*]' COLUMNS(`AdjustTypesForLAAW` INT path "$")) AS AdjustTypesForLAAWList)
               AND (_TransId IS NULL OR (LAAW.TransId = _TransId))
               AND (_DepositId IS NULL OR (DP.TransId = _DepositId))
               AND C.MemberType IN (SELECT MemberType FROM JSON_TABLE(_MemberTypes, '$[*]' COLUMNS(`MemberType` INT path "$")) AS MemberTypeList)
            GROUP BY CY.IsoCode;
        END IF;

        IF _UserName IS NOT NULL THEN
            INSERT IGNORE INTO TempAdjustmentTotalAmount
                   (Currency,Amount,Record)
            SELECT CY.IsoCode,
                   SUM(LAAW.Amount),
                   COUNT(CY.IsoCode)
              FROM LogAdminAdjustWallet AS LAAW
              INNER JOIN Customer AS C ON C.CustId = LAAW.CustId
              LEFT JOIN Currency AS CY ON C.CurrencyId = CY.CurrencyId
              LEFT JOIN AdjustmentDepositLog ADL ON ADL.TransId = LAAW.TransId AND ADL.AdjustType = 2
             LEFT JOIN DepositInfo DP ON DP.DepositId = ADL.DepositId
             WHERE LAAW.CreateTime BETWEEN _StartDate AND _EndDate
               AND LAAW.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
               AND C.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyIdList)
               AND LAAW.Direction IN (SELECT AdjustTypesForLAAW FROM JSON_TABLE(_AdjustTypesForLAAW, '$[*]' COLUMNS(`AdjustTypesForLAAW` INT path "$")) AS AdjustTypesForLAAWList)
               AND (_UserName IS NULL OR (C.UserName = _UserName))
               AND (_TransId IS NULL OR (LAAW.TransId = _TransId))
               AND (_DepositId IS NULL OR (DP.TransId = _DepositId))
               AND C.MemberType IN (SELECT MemberType FROM JSON_TABLE(_MemberTypes, '$[*]' COLUMNS(`MemberType` INT path "$")) AS MemberTypeList)
            GROUP BY CY.IsoCode;
        END IF;

        IF _TpUserName IS NOT NULL THEN
            INSERT IGNORE INTO TempAdjustmentTotalAmount
                   (Currency,Amount,Record)
            SELECT CY.IsoCode,
                   SUM(LAAW.Amount),
                   COUNT(CY.IsoCode)
              FROM LogAdminAdjustWallet AS LAAW
              INNER JOIN Customer AS C ON C.CustId = LAAW.CustId
              LEFT JOIN Currency AS CY ON C.CurrencyId = CY.CurrencyId
              LEFT JOIN TpCustInfo AS TCI ON TCI.CustId = C.CustId AND TCI.TpId=1
              LEFT JOIN AdjustmentDepositLog ADL ON ADL.TransId = LAAW.TransId AND ADL.AdjustType = 2
              LEFT JOIN DepositInfo DP ON DP.DepositId = ADL.DepositId
             WHERE LAAW.CreateTime BETWEEN _StartDate AND _EndDate
               AND LAAW.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
               AND C.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyIdList)
               AND LAAW.Direction IN (SELECT AdjustTypesForLAAW FROM JSON_TABLE(_AdjustTypesForLAAW, '$[*]' COLUMNS(`AdjustTypesForLAAW` INT path "$")) AS AdjustTypesForLAAWList)
               AND (TCI.TpUserName = _TpUserName)
               AND (_TransId IS NULL OR (LAAW.TransId = _TransId))
               AND (_DepositId IS NULL OR (DP.TransId = _DepositId))
               AND C.MemberType IN (SELECT MemberType FROM JSON_TABLE(_MemberTypes, '$[*]' COLUMNS(`MemberType` INT path "$")) AS MemberTypeList)
            GROUP BY CY.IsoCode;
        END IF;

    END IF;

    SELECT TEMP.Currency AS Currency,
             SUM(TEMP.Amount) AS Amount,
             SUM(TEMP.Record) AS Record
        FROM TempAdjustmentTotalAmount AS TEMP
    GROUP BY TEMP.Currency;

    DROP TEMPORARY TABLE IF EXISTS `TempAdjustmentTotalAmount`;

END$$
DELIMITER ;
