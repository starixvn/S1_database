/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@Zephyr
        DB: TSDB-TSDB
        Task: Update IP range
*/

update SiteConfig 
set ConfigValue = '[
    "202.78.231.34/24",
    "125.227.140.97/24"
]'
where ConfigType = 'Whitelist' and SiteId = 0 and ConfigKey = 'IpRange';