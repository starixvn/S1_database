/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@George.Phung
        DB: TSDB-TSDB
        Task: Enable Telegram UAT
        Revisions:
                - 20241216@George.Phung: Enable Telegram Messaging for UAT
*/
UPDATE SiteConfig 
SET ConfigValue = '{"Url":"https://api.telegram.org","Token":"2109224850:AAE028Pfae0YHptFCeYd9qQ-ajKm35xrS2A","ChatId":-594288926,"Enable":true}'
WHERE ConfigKey = 'HangfireTelegram'