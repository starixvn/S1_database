/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20243112@Los
        DB: TSDB-TSDB
        Task: Update BetLimitGroup
*/

UPDATE TpBetLimit
SET DefaultGroup='OneWorksLow'
WHERE GameType=16 AND CurrencyId=4;

