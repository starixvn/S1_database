/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241213@Zephyr
        DB: TSDB-TSDB
        Task: Update SMS Config
*/

update SiteConfig 
set ConfigValue = '{
    "SmsTpName": "SkyLine",
    "AccountName": "SkyLineOTP",
    "GetBalanceUrl": "https://api.itniotech.com/sms/getBalance",
    "CheckUrl": "https://api.itniotech.com/sms/getReport",
    "MiniMumLimit": 100,
    "Key1": "xNGyNJBp",
    "Key2": "10mF0L",
    "ApiKey": "guXEayVaVkLEjbBTUt8d1w7fP3ogu1fY",
    "ApiSecret": "OwCwjgY9cADsxRkprosolXTLD18J177m"
}'
where ConfigType = 'SMS' and SiteId = 0 and ConfigKey = 'HangfireSkyLineOTP';


update SiteConfig 
set ConfigValue = '{
    "SmsTpName": "NXCloud",
    "AccountName": "NxCloud",
    "GetBalanceUrl": "https://api.nxcloud.com/api/common/getBalance",
    "CheckUrl": "https://api2.nxcloud.com/api/sms/get",
    "MiniMumLimit": 100,
    "Key1": "4ZH89fMl",
    "Key2": "xeZuxkvd"
}'
where ConfigType = 'SMS' and SiteId = 0 and ConfigKey = 'HangfireNxCloud';