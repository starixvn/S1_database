CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_AdminAdjustmentInfoLog_Get`(
    IN _SiteIds JSON,
    IN _CurrencyIds JSON,
    IN _Menus JSON,
    IN _ActionTypes JSON,
    IN _StartDate DATETIME,
    IN _EndDate DATETIME,  
    IN _RefTransId VARCHAR(50),
    IN _Operator VARCHAR(30),
    IN _PageSize INT,
    IN _StartIndex INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
)
BEGIN
    

      SELECT SQL_CALC_FOUND_ROWS
             AL.Id,
             AL.CurrencyId,
             C.IsoCode,
             AL.SiteId,
             SI.SiteName,
             AL.Menu,
             AL.ActionType,
             AL.RefTransId,
             AL.BeforeDetailInfo,
             AL.AfterDetailInfo,
             AL.CreateTime,
             AL.Operator
        FROM AdminAdjustmentInfoLog AS AL
        LEFT JOIN Currency AS C
            ON AL.CurrencyId = C.CurrencyId
        LEFT JOIN ServerInfo AS SI
            ON AL.SiteId = SI.SiteId
       WHERE (AL.SiteId = 0 OR AL.SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteIdList))
         AND (AL.CurrencyId = 0 OR AL.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` TINYINT PATH "$")) AS CurrencyIdList))
         AND AL.Menu IN (SELECT * FROM JSON_TABLE(_Menus, '$[*]' COLUMNS(`Menu` TINYINT PATH "$")) AS MenuList)
         AND AL.ActionType IN (SELECT * FROM JSON_TABLE(_ActionTypes, '$[*]' COLUMNS(`Menu` TINYINT PATH "$")) AS ActionTypeList)
         AND AL.CreateTime BETWEEN _StartDate AND _EndDate
         AND (_RefTransId IS NULL OR AL.RefTransId = _RefTransId)
         AND (_Operator IS NULL OR AL.Operator = _Operator)
    ORDER BY AL.CreateTime DESC
       LIMIT _StartIndex , _PageSize;
    
    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
END