/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Los
        DB: TSDB-TSDB
        Task: Remove Proxy in SiteConfig
*/

DELETE FROM SiteConfig WHERE ConfigType ='Proxy'