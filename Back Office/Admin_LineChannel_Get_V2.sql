/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_LineChannel_Get_V2`(
    IN _IsList BOOLEAN,
    IN _Id INT,
    IN _SiteId INT,
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
			LC.Id,
             LC.SiteId,
             SI.SiteName,
             LC.CurrencyId,
             C.IsoCode,
             LC.Link,
             LC.`Status`,
             LC.CreateTime,
             LC.UpdateTime,
             LC.LastOperator
        FROM LineChannel AS LC
   LEFT JOIN ServerInfo AS SI ON LC.SiteId = SI.SiteId
   LEFT JOIN Currency AS C ON LC.CurrencyId = C.CurrencyId
       WHERE (_IsList IS FALSE AND LC.Id = _Id)
          OR (_IsList IS TRUE 
             AND LC.SiteId = _SiteId 
           AND EXISTS (
				SELECT 1
				FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyList
				WHERE CurrencyList.CurrencyId = LC.CurrencyId
			))
    ORDER BY Id
       LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
END$$
DELIMITER ;