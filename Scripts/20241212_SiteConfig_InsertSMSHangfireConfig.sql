/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241212@Zephyr
        DB: TSDB-TSDB
        Task: Insert SMS Hangfire Config
*/


INSERT INTO SiteConfig (ConfigType, SiteId, ConfigKey, ConfigGroup, ConfigValue, CreateTime, UpdateTime)
VALUES ('SMS', 1000,  'HangfireNxCloud',  'HangfireService',  '{
    "SmsTpName": "NXCloud",
    "AccountName": "NX08411-PT Eloka Jaya Lama(TEL:63917894979)-Nova88",
    "GetBalanceUrl": "https://api.nxcloud.com/api/common/getBalance",
    "CheckUrl": "https://api2.nxcloud.com/api/sms/get",
    "MiniMumLimit": 100,
    "Key1": "4ZH89fMl",
    "Key2": "xeZuxkvd"
}',  UTC_TIMESTAMP(),  UTC_TIMESTAMP());

INSERT INTO SiteConfig (ConfigType, SiteId, ConfigKey, ConfigGroup, ConfigValue, CreateTime, UpdateTime)
VALUES ('SMS', 1000,  'HangfireSkyLineOTP',  'HangfireService',  '{
    "SmsTpName": "SkyLine",
    "AccountName": "cs_0iahqs(SkyLineOTP)",
    "GetBalanceUrl": "https://api.itniotech.com/sms/getBalance",
    "CheckUrl": "https://api.itniotech.com/sms/getReport",
    "MiniMumLimit": 100,
    "Key1": "xNGyNJBp",
    "Key2": "10mF0L",
    "ApiKey": "guXEayVaVkLEjbBTUt8d1w7fP3ogu1fY",
    "ApiSecret": "OwCwjgY9cADsxRkprosolXTLD18J177m"
}',  UTC_TIMESTAMP(),  UTC_TIMESTAMP());
