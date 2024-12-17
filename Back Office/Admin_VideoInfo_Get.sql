/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_VideoInfo_Get`(
    IN _SiteId INT,
    IN _CurrencyIds JSON,
    IN _LangList JSON,
    IN _PageSize INT,
    IN _StartIndex INT,
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
        DATE_FORMAT( VI.`Date`, '%Y-%m-%d') AS Date,
        VI.SiteId,
        VI.CurrencyId,
        VI.LangId,
        VI.Title,
        VI.Link,
        IFNULL(VI.UpdateTime,VI.CreateTime) AS LastUpdateTime,
        IFNULL(VI.UpdateOperator,VI.CreateOperator) AS Operator
    FROM 
        VideoInfo AS VI
        INNER JOIN 
        ServerInfo AS SI ON VI.SiteId = SI.SiteId
    WHERE 
        VI.SiteId = _SiteId
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` TINYINT PATH "$")) AS CurrencyIdList
			WHERE CurrencyIdList.CurrencyId = VI.CurrencyId
		)
		AND EXISTS (
			SELECT 1
			FROM JSON_TABLE(_LangList, '$[*]' COLUMNS(`Lang` VARCHAR(10) PATH "$")) AS LangList
			WHERE LangList.Lang = VI.LangId
		)
    ORDER BY VI.`Date` DESC, IFNULL(VI.UpdateTime,VI.CreateTime) DESC
    LIMIT _StartIndex , _PageSize;
    
    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
END$$
DELIMITER ;