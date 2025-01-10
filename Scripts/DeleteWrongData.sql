/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20250110@Johnny
        DB: TSDB-TSDB
        Task: Delete wrong data to trigger FinancialAccountClosingBalanceJob in PROD
*/

DELETE
FROM FinancialAccountClosingBalance
WHERE SQ = 1