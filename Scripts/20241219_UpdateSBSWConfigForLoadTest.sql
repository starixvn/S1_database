/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241219@Loki
        DB: TSDB-TSDB
        Task: Update Config SBSW for LoadTest
        Revisions:
                - 20241219@Loki: Update Config SBSW for LoadTest
*/

UPDATE SiteConfig SET ConfigValue = '{"ApiUrl":"https://simulatorapi.vgamesuat.com/api/SabaSport","VendorId":"loadtestid","OperatorId":"N88"}' 
WHERE ConfigKey = 'SBSW' AND SiteId = 1 AND ConfigGroup = 'TP'