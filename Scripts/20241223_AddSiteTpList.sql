/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241213@George.Phung
        DB: TSDB-TSDB
        Task: Add SiteTpList for TpWager
        Revisions:
                - 20241213@George.Phung: Add SiteTpList for the Wager to know what Tp to scan
*/
DELETE FROM SiteTpList;
INSERT INTO SiteTpList
(
    SiteId,
    TpId,
    TpName,
    Setting,
    `Status`,
    TicketKey
)
VALUES
-- Pragmatic Play - 5
(
    1000,
    5,
    'PP',
    '{}',
    1,
    0
),
-- AllBet - 12
(
    1000,
    12,
    'AllBet',
    '{}',
    1,
    0
),
-- PG - 14
(
    1000,
    14,
    'PG',
    '{}',
    1,
    0
),
-- AESexy - 15
(
    1000,
    15,
    'AESexy',
    '{}',
    1,
    0
),
-- WE - 18
(
    1000,
    18,
    'WE',
    '{}',
    1,
    0
),
-- JILI - 32
(
    1000,
    32,
    'JILI',
    '{}',
    1,
    0
),
-- FaChai - 55
(
    1000,
    55,
    'FaChai',
    '{}',
    1,
    0
),
-- MaxGame - 61
(
    1000,
    61,
    'MaxGame',
    '{}',
    1,
    0
),
-- SabaPlay - 66
(
    1000,
    66,
    'SabaPlay',
    '{}',
    1,
    0
),
-- UuSlots - 67
(
    1000,
    67,
    'UuSlots',
    '{}',
    1,
    0
),
-- Live22 - 68
(
    1000,
    68,
    'Live22',
    '{}',
    1,
    0
),
-- FastSpin - 69
(
    1000,
    69,
    'FastSpin',
    '{}',
    1,
    0
),
-- Keno - 71
(
    1000,
    71,
    'Keno',
    '{}',
    1,
    0
),
-- Lottery - 72
(
    1000,
    72,
    'AllBet',
    '{}',
    1,
    0
),
-- TableGame - 73
(
    1000,
    73,
    'TableGame',
    '{}',
    1,
    0
);