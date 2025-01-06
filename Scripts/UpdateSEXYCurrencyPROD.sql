/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Update sexy, WE currency
*/

UPDATE TpCurrency
SET TpCurrencyId='USD'
WHERE TpId=15 AND CurrencyId=3 AND TpCurrencyId='THB';

UPDATE TpCurrency
SET TpCurrencyId='USD'
WHERE TpId=18 AND CurrencyId=3 AND TpCurrencyId='UST'

