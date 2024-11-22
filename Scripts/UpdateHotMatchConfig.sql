/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Update config Hot Match: using service name
*/

update SiteConfig set ConfigValue = '{"ApiUrl":"http://ne-s1-sabasports-odds-direct-api-uat-service:5000","VendorId":"y2g53zl9g4", "VendorMemberId":"Starix1SW_4uo2mwe1avgc_test", "MajorLeague": "3,4,5,8,43,1837"}'
where configType = 'TP' and siteId = 0 and ConfigKey='HotMatchConfig'