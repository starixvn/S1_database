/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Update bet limit PROD for AllBet
*/


UPDATE TpBetLimit
SET DefaultGroup='50_5K'
WHERE GameType=6 AND CurrencyId=4;

