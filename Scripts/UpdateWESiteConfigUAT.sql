/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Los
        DB: TSDB-TSDB
        Task: Update WE in SiteConfig table UAT
*/

UPDATE TpBetLimit SET LimitGroup='{"Max": 0, "Min": 0}' WHERE GameType=28