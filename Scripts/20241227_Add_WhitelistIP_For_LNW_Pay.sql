
/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241227@Liam.Pham 
        DB: TSDB-TSDB
        Task: add whitelist Ip for LNWPay
        Revisions:
                - 20241227@Liam.Pham : add whitelist Ip for LNWPay
*/

update  SiteConfig 
set ConfigValue = '["54.254.99.145"]'
where ConfigType ='Whitelist' and SiteId = 0 and ConfigKey = 'LNWPay'