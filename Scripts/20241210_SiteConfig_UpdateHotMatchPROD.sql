/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Update Hot math config PROD
*/

UPDATE `TSDB`.`SiteConfig` 
SET ConfigValue = '{"ApiUrl":"http://ne-s1-sabasports-odds-direct-api-prod-service:5000","VendorId":"y2g53zl9g4", "VendorMemberId":"Starix1SW_4uo2mwe1avgc_test", "MajorLeague": "3,4,5,8,43,1837"}'
WHERE ConfigKey='HotMatchConfig' and ConfigGroup = 'TP' and ConfigType='TP'