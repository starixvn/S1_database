/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Los
        DB: TSDB-TSDB
        Task: Add new col to table TPDailySummary
*/

ALTER TABLE TSDB.TpDailySummary
ADD COLUMN CurrencyIso VARCHAR(15) AFTER CurrencyId;