/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241126@George.Phung
        DB: TSDB-TSDB
        Task: Update TP Config for PP PragmaticPlay
        Revisions:
                - 20241126@George.Phung: Update TP Config for PP PragmaticPlay for UAT
*/
UPDATE SiteConfig
SET
ConfigValue = 
'{
    "OperatorPwd": "s1hb8uik",
    "OperatorKey": "ck03ijvk",
    "GameType": "PragmaticPlay",
    "ApiUrl": "http://owapi1.playonesit.com:7066",
    "LiveCasinoApiUrl": "http://owapi1.playonesit.com:7068",
    "LiveCasinoGameType": "PragmaticPlayCasino",
    "DailySumApiUrl":"https://owapi1.playonesit.com:7062"
}',
UpdateTime = NOW()
WHERE ConfigType = 'TP'
AND ConfigKey = 'PP'
AND SiteId = 1000

