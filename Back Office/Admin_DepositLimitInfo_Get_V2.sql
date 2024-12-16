/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DepositLimitInfo_Get_V2`(
    IN _SiteIds JSON,
    IN _DepositTypes JSON,
    IN _CurrencyIds JSON,
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
           /*
  Created: 20241125@Liam 
        DB: TSDB-TSDB
        Task: fix sp crash
         Revisions:
                - 20241216@Liam: fix sp crash
*/ 

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
     WHERE EXISTS (
			SELECT 1
			FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList
			WHERE SiteList.SiteId = SiteId
		)
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(_DepositTypes, '$[*]' COLUMNS(`DepositType` INT PATH "$")) AS DepositTypeList
			WHERE DepositTypeList.DepositType = DepositType
		)
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList
			WHERE CurrencyIdList.CurrencyId = CurrencyId
		)
    ORDER BY SiteId,DepositType,CurrencyId,VipLevel
       LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
END$$
DELIMITER ;