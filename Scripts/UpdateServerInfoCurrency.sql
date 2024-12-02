/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241202@Issac
        DB: TSDB-TSDB
        Task: Update server info currency and default currency
*/

UPDATE TSDB.ServerInfo
SET CurrencyList='[2, 4, 15, 13, 3]'
WHERE SiteId=1;

UPDATE Currency
SET Sort = CASE
	WHEN  CurrencyId = 2 THEN 2
	WHEN CurrencyId = 4 THEN 1
END
WHERE CurrencyId IN (2, 4)