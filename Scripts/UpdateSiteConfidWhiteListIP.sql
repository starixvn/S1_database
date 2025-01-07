/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20240107@Mira
        DB: TSDB-TSDB
        Task: Update WhiteListIP
*/

UPDATE SiteConfig 
SET 
    ConfigValue = '["202.78.231.34/32","202.78.231.35/32","202.78.231.38/32","120.72.109.34/32","120.72.109.38/32", "120.72.83.130/32","125.227.140.97/32","211.75.116.91/32"]'
WHERE
    ConfigType = 'Whitelist'
        AND ConfigKey = 'IpRange'
