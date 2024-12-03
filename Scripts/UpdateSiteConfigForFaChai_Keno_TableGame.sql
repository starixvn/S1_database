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
AND ConfigKey = 'JILI';

UPDATE SiteConfig
SET
ConfigValue = 
'{
     "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "SabaPlay",
    "ApiUrl": "http://owapi1.playonesit.com:7064",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'SabaPlay';


UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "UuSlots",
    "ApiUrl": "http://owapi1.playonesit.com:7015",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'UuSlots';

UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "Live22",
    "ApiUrl": "http://owapi1.playonesit.com:7016",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'Live22';


UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "FastSpin",
    "ApiUrl": "http://owapi1.playonesit.com:7077",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'FastSpin';


UPDATE SiteConfig
SET
ConfigValue = 
'{
     "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "AllBet",
    "ApiUrl": "http://owapi1.playonesit.com:7073",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'AllBet';

UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "Lottery",
    "ApiUrl": "http://owapi1.playonesit.com:7054",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'Lottery';


UPDATE SiteConfig
SET
ConfigValue = 
'{
	"OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "WorldEntertainment",
    "ApiUrl": "http://owapi1.playonesit.com:7017",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1
AND ConfigKey = 'We';


UPDATE SiteConfig
SET
ConfigValue = 
'{
	  "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "SexyCasino",
    "ApiUrl": "http://owapi1.playonesit.com:7002",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 0
AND ConfigKey = 'AESexy';