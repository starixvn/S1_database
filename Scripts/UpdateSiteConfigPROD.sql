/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Update MaxGame, SabaPlay
*/

/*MaxGame*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "MaxGame",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7018",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
 WHERE ConfigKey= 'MaxGame' AND ConfigGroup='TP' AND SiteId=1000;

/*SabaPlay*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "SabaPlay",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7064",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'SabaPlay' AND ConfigGroup='TP' AND SiteId=1000;

/*Live 22*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "Live22",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7016",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'Live22' AND ConfigGroup='TP' AND SiteId=1000;

/*JILI*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "JiLi",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7005",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'JILI' AND ConfigGroup='TP' AND SiteId=1000;

/*Keno*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "Keno",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7052",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'RNGKeno' AND ConfigGroup='TP' AND SiteId=1000;

/*Lottery*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "Lottery",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7054",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'Lottery' AND ConfigGroup='TP' AND SiteId=1000;

/*TableGame*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "TableGame",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7056",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'TableGame' AND ConfigGroup='TP' AND SiteId=1000;

/*UuSlots*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "UuSlots",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7015",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'UuSlots' AND ConfigGroup='TP' AND SiteId=1000;

/*PragmaticPlay*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "PragmaticPlay",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7066",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'PP' AND ConfigGroup='TP' AND SiteId=1000;

/*AllBet*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "AllBet",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7073",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'AllBet' AND ConfigGroup='TP' AND SiteId=1000;

/*FastSpin*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "FastSpin",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7077",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'FastSpin' AND ConfigGroup='TP' AND SiteId=1000;

/*FaChai*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "FaChai",
    "ApiUrl": "http://saba-plus-internal.nebula.prod:7082",
	"DailySumApiUrl": "https://boapi.gadmin888.com/api/OperatorApi/GetDailyTicketSummary"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'FaChai' AND ConfigGroup='TP' AND SiteId=1000;

