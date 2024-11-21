/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241126@George.Phung
        DB: TSDB-TSDB
        Task: Update TP Config for PG PocketGames
        Revisions:
                - 20241126@George.Phung: Update TP Config for PG PocketGames
                - 20241129@George.Phung: Update TP Config for PG PocketGames for only PG in UAT
*/
UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "PocketGames",
    "ApiUrl": "http://owapi1.playonesit.com:7103",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND ConfigKey = 'PG'
AND SiteId = 1000

