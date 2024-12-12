/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Update Hot math config PROD
         Revisions:
                - 20241212@Levi.Vu : Update Hot math config PROD
*/

UPDATE `TSDB`.`SiteConfig` 
SET ConfigValue = '{"ApiUrl":"http://ne-s1-sabasports-odds-direct-api-prod-service:5000","VendorId":"qz7vzb5uea", "VendorMemberId":"qatest01", "MajorLeague": "3,4,5,8,43,1837"}'
WHERE ConfigKey='HotMatchConfig' and ConfigGroup = 'TP' and ConfigType='TP'