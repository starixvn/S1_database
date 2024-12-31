/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20243112@Loki
        DB: TSDB-TSDB
        Task: Update SBSW config for LoadTest
*/

UPDATE SiteConfig SET ConfigValue = '{"ApiUrl":"http://merchant-api-001.licensee-service.t1u.nebula.prod:11080/api","VendorId":"qz7vzb5uea","OperatorId":"NSDemo1SW"}'
WHERE ConfigKey = 'SBSW' AND SiteId = 1000 AND ConfigGroup = 'TP'