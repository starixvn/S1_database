CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DepositLimitInfo_Get_V2`(
    IN _SiteIds JSON,
    IN _DepositTypes JSON,
    IN _CurrencyIds JSON,
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
)
BEGIN
    
    
    
      SELECT SQL_CALC_FOUND_ROWS
             SiteId,
             DepositType,
             CurrencyId,
             VipLevel,
             DepositMin,
             DepositMax,
             DepositStatus
        FROM DepositLimitInfo
       WHERE SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList)
         AND DepositType IN (SELECT * FROM JSON_TABLE(_DepositTypes, '$[*]' COLUMNS(`DepositType` INT PATH "$")) AS DepositTypeList)
         AND CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList)
    ORDER BY SiteId,DepositType,CurrencyId,VipLevel
       LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
END