/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Update unique table hotgames
        Revisions:
                - 20241216@Brian.Nguyen: Update unique table hotgames
*/
ALTER TABLE TSDB.HotGames DROP INDEX `ux_SiteId_CurrencyId_TopCategory_GameName`;

ALTER TABLE TSDB.HotGames 
ADD CONSTRAINT ux_SiteId_CurrencyId_TopCategory_TpId_GameId 
UNIQUE (SiteId, CurrencyId, TopCategory, TpId, GameId);