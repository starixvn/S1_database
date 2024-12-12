/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241212@Zephyr
        DB: TSDB-TSDB
        Task: Update FPS config for PROD
*/

update SiteConfig
set ConfigValue = '{
    "ApiUrl": "http://fpsapi.nebula.prod/",
    "ResourceURL": "http://fpsapi.nebula.prod/FPS/CheckTransaction",
    "Subscriber": "NSDemo1SW",
    "Token": ""
}'
where ConfigType = 'FPS' and SiteId = 1000 and ConfigKey = 'FPS';

