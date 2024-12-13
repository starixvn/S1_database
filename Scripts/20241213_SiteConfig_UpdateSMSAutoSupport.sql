/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241213@Zephyr
        DB: TSDB-TSDB
        Task: Update SMSAutoSupport
*/


update SiteConfig 
set ConfigValue = '{
    "SMSSupport": {
        "+66": [
            "SkyLine"
        ],
        "+84": [
            "SkyLine"
        ],
        "Default": [
            "SkyLine"
        ]
    }
}'
where ConfigType = 'SMS' and SiteId = 0 and ConfigKey = 'SMSAutoSupport';


update SiteConfig 
set ConfigValue = '{
    "SMSSupport": {
        "+66": [
            "SkyLine"
        ],
        "+84": [
            "SkyLine"
        ],
        "Default": [
            "SkyLine"
        ]
    }
}'
where ConfigType = 'SMS' and SiteId = 1000 and ConfigKey = 'SMSAutoSupport';
