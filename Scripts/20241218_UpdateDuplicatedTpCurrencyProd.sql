/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241217@George.Phung
        DB: TSDB-TSDB
        Task: Update duplicated currency in TpCurrency for production
        Revisions:
                - 20241217@George.Phung: Update Duplicated Tp Currency for production
*/
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
WHERE `TpId` = 61   -- max game
    AND `CurrencyId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
WHERE `TpId` = 14   -- PG
    AND `CurrencyId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
WHERE `TpId` = 5   -- PP
    AND `CurrencyId` = 72;

-- 32 JILI

UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'MYR'
    WHERE `CurrencyId` = 2
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'USD'
    WHERE `CurrencyId` = 3
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'CNY'
    WHERE `CurrencyId` = 13
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'IDR'
    WHERE `CurrencyId` = 15
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'JPY'
    WHERE `CurrencyId` = 32
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KRW'
    WHERE `CurrencyId` = 45
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'VND'
    WHERE `CurrencyId` = 51
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'INR'
    WHERE `CurrencyId` = 61
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
    WHERE `CurrencyId` = 72
    AND `TpId` = 32;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'BDT'
    WHERE `CurrencyId` = 74
    AND `TpId` = 32;
-- Saba Play
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
    WHERE `CurrencyId` = 72
    AND `TpId` = 66;

-- UuSlots
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
    WHERE `CurrencyId` = 72
    AND `TpId` = 67;

-- Live22
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
    WHERE `CurrencyId` = 72
    AND `TpId` = 68;

-- Live22
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
    WHERE `CurrencyId` = 72
    AND `TpId` = 69;

-- AllBet
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'MYR'
    WHERE `CurrencyId` = 2
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'USD'
    WHERE `CurrencyId` = 3
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'THB'
    WHERE `CurrencyId` = 4
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'IDR'
    WHERE `CurrencyId` = 15
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'JPY'
    WHERE `CurrencyId` = 32
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KRW'
    WHERE `CurrencyId` = 45
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'VND'
    WHERE `CurrencyId` = 51
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'INR'
    WHERE `CurrencyId` = 61
    AND `TpId` = 12;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'BRL'
    WHERE `CurrencyId` = 82
    AND `TpId` = 12;

-- Lottery
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'MYR'
    WHERE `CurrencyId` = 2
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'USD'
    WHERE `CurrencyId` = 3
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'THB'
    WHERE `CurrencyId` = 4
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'IDR'
    WHERE `CurrencyId` = 15
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'JPY'
    WHERE `CurrencyId` = 32
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KRW'
    WHERE `CurrencyId` = 45
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'VND'
    WHERE `CurrencyId` = 51
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'INR'
    WHERE `CurrencyId` = 61
    AND `TpId` = 72;
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'BRL'
    WHERE `CurrencyId` = 82
    AND `TpId` = 72;

-- AE SExy
UPDATE `TpCurrency`
    SET `TpCurrencyId` = 'KHUSD'
    WHERE `CurrencyId` = 72
    AND `TpId` = 15;