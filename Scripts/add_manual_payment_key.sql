/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Liam.Pham 
        DB: TSDB-TSDB
        Task: add ManualPayment Key to SiteConfig
        Revisions:
                - 20241207@Liam.Pham : add ManualPayment Key to SiteConfig
*/

INSERT INTO SiteConfig (ConfigType, SiteId, ConfigKey, ConfigGroup, ConfigValue, CreateTime, UpdateTime)
VALUES 
('Key', 
0, 
'ManualPaymentKey', 
'All', 
'c3VwZXJzZWNyZXRrZXlzYW1wbGU', 
UTC_TIMESTAMP(), 
UTC_TIMESTAMP());