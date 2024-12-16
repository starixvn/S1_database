CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DomainTablebySite_Get_V3`(
    IN _SiteIds JSON,
    IN _CurrencyIds JSON,
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
)
BEGIN

    
    

       SELECT SQL_CALC_FOUND_ROWS
              DT.Id AS DId,
              DT.CurrencyId,
              CY.IsoCode AS Currency,
              DT.Domain,
              DT.Sort,
              DT.`Status`,
              DT.LastUpdateUser,
              DT.UpdateTime AS LastUpdateTime
         FROM DomainTable AS DT
    LEFT JOIN Currency AS CY ON DT.CurrencyId = CY.CurrencyId
        WHERE DT.SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList)
          AND DT.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList)
     ORDER BY DT.Sort 
        LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;

END