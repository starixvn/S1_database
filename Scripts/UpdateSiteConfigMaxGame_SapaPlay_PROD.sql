/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Update MaxGame, SabaPlay
*/

UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "MaxGame",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7018"
}',
UpdateTime = NOW()
 WHERE ConfigKey= 'MaxGame' AND ConfigGroup='TP' AND SiteId=1000;

UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "SabaPlay",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7064"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'SabaPlay' AND ConfigGroup='TP' AND SiteId=1000;