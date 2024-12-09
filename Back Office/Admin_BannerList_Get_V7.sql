/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/

DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BannerList_Get_V7`(
    IN _SiteIds JSON,
    IN _BannerTypes JSON,
    IN _Statuses JSON,
    IN _CurrencyIds JSON,
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
/*
  Created: 20240212@Mira
        DB: TSDB-TSDB
        Task: Change IN to EXIST
        Revisions:
                - 20240212@Mira: init sp
*/
)
BEGIN
    
    
    
      SELECT SQL_CALC_FOUND_ROWS
             b.SiteId,
             S.SiteName,
             C.IsoCode AS Currency,
             b.BannerType,
             b.`Status`,
             b.BannerName,
             b.ActionMode,
             b.ShowStatus,
             b.StartTime AS StartTime,
             b.EndTime AS EndTime,
             b.BonusCode,
             b.TpId,
             b.GameId,
             b.UrlRouter,
             b.Sort,
             ANY_VALUE(IFNULL(b.UpdateUser, b.CreateUser)) AS LastUpdateUser,
             ANY_VALUE(IFNULL(b.UpdateTime, b.CreateTime)) AS LastUpdateTime
        FROM Banner b
            INNER JOIN 
            Currency AS C ON b.CurrencyId = C.CurrencyId
            LEFT JOIN 
            ServerInfo AS S ON b.SiteId = S.SiteId
       WHERE EXISTS (SELECT 1 FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList WHERE SiteList.SiteId = b.SiteId)
		AND EXISTS (SELECT 1 FROM JSON_TABLE(_BannerTypes, '$[*]' COLUMNS(`BannerType` INT PATH "$")) AS BannerTypeList WHERE BannerTypeList.BannerType = b.BannerType)
		AND EXISTS (SELECT 1 FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList WHERE CurrencyIdList.CurrencyId = b.CurrencyId)
		AND EXISTS (SELECT 1 FROM JSON_TABLE(_Statuses, '$[*]' COLUMNS(`Status` INT PATH "$")) AS StatusList WHERE StatusList.Status = b.`Status`)
    ORDER BY LastUpdateTime DESC, `Status` DESC
       LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
    
END$$

DELIMITER ;
;