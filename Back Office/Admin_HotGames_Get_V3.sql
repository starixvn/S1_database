/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_HotGames_Get_V3`(IN _SiteId int, IN _CurrencyId int, IN _TopCategory tinyint, IN _TpId int, IN _TpGameType int, IN _PageSize int, IN _StartIndex int, OUT _TotalPages int, OUT _RowCount int
/*
  Created: 20240212@Mira
        DB: TSDB-TSDB
        Task: Get right TPName
        Revisions:
                - 20241206@Mira: init sp
*/
)
BEGIN
    
    
    SELECT
    SQL_CALC_FOUND_ROWS 
               t.Id,
               t.TpId,
               TL.TpName,
               t.GameId,
               t.GameName,
               t.TpGameType,
               TI.TypeName AS GameTypeName,
               t.TpCategory,
               TJ.Name AS CategoryName,
               t.Sort,
               t.LastUpdateTime,
               t.LastUpdateUser,
               t.TopCategory AS TopCategory
        FROM TSDB.HotGames t
        INNER JOIN TpGameType TI on t.TpGameType = TI.Type
        INNER JOIN TpCategory TJ on t.TpCategory = TJ.Id
        INNER JOIN TpList TL on t.TpId = TL.Id
        WHERE t.SiteId = _SiteId
          AND t.CurrencyId = _CurrencyId
          AND t.TopCategory = _TopCategory
          AND (_TpId = 0 OR t.TpId = _TpId)
          AND (_TpGameType = 0 OR t.TpGameType = _TpGameType)
        ORDER BY t.Sort ASC
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