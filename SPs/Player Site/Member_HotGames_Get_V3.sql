/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_HotGames_Get_V3`(
    IN _SiteId int, 
    IN _CurrencyId smallint unsigned

/*
  Created: 20241113@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Get HotGames 
        Revisions:
                - 20241113@Brian.Nguyen: Get hot games
*/)
BEGIN  
    SELECT t.TpId,
           t.GameId,
           t.TpGameType,
           t.TpCategory,
           t.GameName,
           t.TpName,
           t.Sort,
           t.TopCategory
    FROM Siebog.HotGames t
    WHERE t.SiteId = _SiteId
      AND t.CurrencyId = _CurrencyId;
END$$
DELIMITER ;