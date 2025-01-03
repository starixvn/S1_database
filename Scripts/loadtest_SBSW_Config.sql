/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20243112@Loki
        DB: TSDB-TSDB
        Task: Update SBSW config for LoadTest
*/

UPDATE SiteConfig SET ConfigValue = '{"ApiUrl":"http://vn-s1-sabasports-api-uat.nebula.prod/api/SabaSport","VendorId":"qz7vzb5uea","OperatorId":"NSDemo1SW"}'
WHERE ConfigKey = 'SBSW' AND SiteId = 1000 AND ConfigGroup = 'TP'

UPDATE SiteConfig SET ConfigValue = '{}'
WHERE ConfigKey = 'SBSW' AND SiteId = 1 AND ConfigGroup = 'TP'