/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20243112@Los
        DB: TSDB-TSDB
        Task: Open PP LC
*/

UPDATE TpGameId
SET Status=1
WHERE TpId=5 AND TpGameType=16 AND GameId IN (3701,
3702,
3703,
3704,
3705,
3706,
3707,
3708,
3709,
3710,
3711,
3712,
3713,
3714,
3715,
3716,
3717,
3718,
3719,
3720,
3721,
3722,
3723,
3724,
3725,
3728,
3731,
3732,
3733,
3734,
3735,
3736,
3737,
3738,
3739,
3740,
3741,
3742,
3743,
3744,
3745,
3746,
3747);

UPDATE SiteConfig
SET ConfigValue='{ "OperatorPwd": "s1hb8uik", "OperatorKey": "ck03ijvk", "GameType": "PragmaticPlay", "ApiUrl": "http://saba-plus-internal.nebula.prod:7066", "LiveCasinoApiUrl": "http://saba-plus-internal.nebula.prod:7068", "LiveCasinoGameType": "PragmaticPlayCasino", "DailySumApiUrl": "http://saba-plus-internal.nebula.prod:7033" }'
WHERE ConfigKey='PP' AND SiteId=1000;

