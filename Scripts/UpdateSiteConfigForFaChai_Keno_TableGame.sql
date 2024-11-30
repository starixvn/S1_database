/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241126@Los
        DB: TSDB-TSDB
        Task: Update TP Config for FaChai/Keno
        Revisions:
                - 20241126@George.Phung: Update TP Config for FaChai/Keno
*/
UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "FaChai",
    "ApiUrl": "http://owapi3.playonesit.com",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'FaChai';

UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "Keno",
    "ApiUrl": "http://owapi1.playonesit.com:7052",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'RNGKeno';

UPDATE SiteConfig
SET
ConfigValue = 
'{
       "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "TableGame",
    "ApiUrl": "http://owapi1.playonesit.com:7056",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'TableGame';

UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "MaxGame",
    "ApiUrl": "http://owapi1.playonesit.com:7018",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'MaxGame';

UPDATE SiteConfig
SET
ConfigValue = 
'{
     "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "JiLi",
    "ApiUrl": "http://owapi1.playonesit.com:7005",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'JILI'