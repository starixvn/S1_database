/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241217@George.Phung
        DB: TSDB-TSDB
        Task: Remove duplicated currency in TpCurrency
        Revisions:
                - 20241217@George.Phung: Remove Duplicated Tp Currency
*/
DELETE FROM TpCurrency
WHERE TpId = 61
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 14
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 5
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 32;
INSERT INTO TpCurrency
(
    TpId,
    CurrencyId,
    TpCurrencyId,
    ExChangeRate,
    IsSubCurrency
)
VALUES
(
    32,
    4,
    'THB',
    1,
    0
);
DELETE FROM TpCurrency
WHERE TpId = 66
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 67
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 68
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 69
    AND CurrencyId = 72;
DELETE FROM TpCurrency
WHERE TpId = 12;
INSERT INTO TpCurrency
(
    TpId,
    CurrencyId,
    TpCurrencyId,
    ExChangeRate,
    IsSubCurrency
)
VALUES
(
    12,
    4,
    'THB',
    1,
    0
);
DELETE FROM TpCurrency
WHERE TpId = 72;
INSERT INTO TpCurrency
(
    TpId,
    CurrencyId,
    TpCurrencyId,
    ExChangeRate,
    IsSubCurrency
)
VALUES
(
    72,
    4,
    'THB',
    1,
    0
);
DELETE FROM TpCurrency
WHERE TpId = 15
    AND CurrencyId = 72;
UPDATE TpCurrency
SET TpCurrencyId = 'USD'
WHERE TpId = 15
    AND CurrencyId = 3;
DELETE FROM TpCurrency
WHERE TpId = 18
    AND CurrencyId = 72;