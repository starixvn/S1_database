/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Update WE, AESexy, PG
*/


/*We*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "WorldEntertainment",
    "ApiUrl": "http://worldentertainment.edge2cast.com",
	"DailySumApiUrl": "http://saba-plus-internal.nebula.prod:7033"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'WE' AND ConfigGroup='TP' AND SiteId=1000;

/*AESexy*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "SexyCasino",
    "ApiUrl": "http://aesxc.edge2cast.com",
	"DailySumApiUrl": "http://saba-plus-internal.nebula.prod:7033"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'AESexy' AND ConfigGroup='TP' AND SiteId=1000;

/*PG*/
UPDATE SiteConfig
SET ConfigValue='{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "PocketGames",
    "ApiUrl": "http://pocketgames.edge2cast.com",
	"DailySumApiUrl": "http://saba-plus-internal.nebula.prod:7033"
}',
UpdateTime = NOW()
WHERE ConfigKey= 'PG' AND ConfigGroup='TP' AND SiteId=1000;

