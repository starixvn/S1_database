/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241217@George.Phung
        DB: TSDB-TSDB
        Task: Update duplicated Site Config in SiteConfig
        Revisions:
                - 20241217@George.Phung: Update for UuSlots and SabaPlay
*/
UPDATE SiteConfig
SET ConfigValue = '{}'
WHERE ConfigKey = 'UuSlots'
  AND ConfigType = 'TP'
  AND ConfigGroup = 'TP'
  AND SiteId = 1;
  
UPDATE SiteConfig
SET ConfigValue = '{}'
WHERE ConfigKey = 'SabaPlay'
  AND ConfigType = 'TP'
  AND ConfigGroup = 'TP'
  AND SiteId = 1;