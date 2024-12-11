/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241126@Los
        DB: TSDB-TSDB
        Task: Update TP Config for UpdateSiteConfigForFaChai_Keno_TableGame_MaxGame_PG_PP_Jili_SabaPlay_UUSLot_Live22_FastSpin_Allbet_Lottery_AESexy_We_UAT
        Revisions:
                - 20241126@Los: UpdateSiteConfigForFaChai_Keno_TableGame_MaxGame_PG_PP_Jili_SabaPlay_UUSLot_Live22_FastSpin_Allbet_Lottery_AESexy_We_UAT
*/
UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"FaChai","ApiUrl":"http://owapi3.playonesit.com",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'FaChai';

UPDATE SiteConfig
SET
ConfigValue = 
'{
   "OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"Keno","ApiUrl":"http://owapi1.playonesit.com:7052",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'RNGKeno';

UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"TableGame","ApiUrl":"http://owapi1.playonesit.com:7056",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'TableGame';

UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"MaxGame","ApiUrl":"http://owapi1.playonesit.com:7018",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'MaxGame';

UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"PocketGames","ApiUrl":"http://owapi1.playonesit.com:7103",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'PG';

UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"PragmaticPlay","ApiUrl":"http://owapi1.playonesit.com:7066","LiveCasinoApiUrl":"http://owapi1.playonesit.com:7068","LiveCasinoGameType":"PragmaticPlayCasino",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'PP';


UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"JiLi","ApiUrl":"http://owapi1.playonesit.com:7005",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'JILI';

UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"SabaPlay","ApiUrl":"http://owapi1.playonesit.com:7064",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'SabaPlay';


UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"UuSlots","ApiUrl":"http://owapi1.playonesit.com:7015",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'UuSlots';

UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"Live22","ApiUrl":"http://owapi1.playonesit.com:7016",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'Live22';


UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"FastSpin","ApiUrl":"http://owapi1.playonesit.com:7077",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'FastSpin';


UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"AllBet","ApiUrl":"http://owapi1.playonesit.com:7073",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'AllBet';

UPDATE SiteConfig
SET
ConfigValue = 
'{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"Lottery","ApiUrl":"http://owapi1.playonesit.com:7054",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'Lottery';


UPDATE SiteConfig
SET
ConfigValue = 
'{
	"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"WorldEntertainment","ApiUrl":"http://owapi1.playonesit.com:7017","DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'We';


UPDATE SiteConfig
SET
ConfigValue = '{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"SexyCasino","ApiUrl":"http://owapi1.playonesit.com:7002","DailySumApiUrl":"https://owapi1.playonesit.com:7062"}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND SiteId = 1000
AND ConfigKey = 'AESexy';