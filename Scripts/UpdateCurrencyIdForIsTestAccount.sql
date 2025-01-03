/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Update currency for is test account
*/


UPDATE Customer
SET CurencyId=20
WHERE IsTest=1;

INSERT INTO TpCurrency(TpId,CurrencyId, TpCurrencyId,ExchangeRate,IsSubCurrency)
VALUES
(55,20,'UUS',1,0),
(71,20,'UUS',1,0),
(73,20,'UUS',1,0),
(61,20,'UUS',1,0),
(14,20,'UUS',1,0),
(5,20,'UUS',1,0),
(32,20,'UUS',1,0),
(66,20,'UUS',1,0),
(67,20,'UUS',1,0),
(68,20,'UUS',1,0),
(69,20,'UUS',1,0),
(12,20,'UUS',1,0),
(72,20,'UUS',1,0),
(15,20,'UUS',1,0),
(18,20,'UUS',1,0)

