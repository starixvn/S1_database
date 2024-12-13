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
            "SkyLine",
            "NxCloud"
        ],
        "+84": [
            "SkyLine",
            "NxCloud"
        ],
        "Default": [
            "SkyLine",
            "NxCloud"
        ]
    }
}'
where ConfigType = 'SMS' and SiteId = 0 and ConfigKey = 'SMSAutoSupport';


update SiteConfig 
set ConfigValue = '{
    "SMSSupport": {
        "+66": [
            "SkyLine",
            "NxCloud"
        ],
        "+84": [
            "SkyLine",
            "NxCloud"
        ],
        "Default": [
            "SkyLine",
            "NxCloud"
        ]
    }
}'
where ConfigType = 'SMS' and SiteId = 1000 and ConfigKey = 'SMSAutoSupport';
