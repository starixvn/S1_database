/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: Create config Hot Match
*/

INSERT INTO `TSDB`.`SiteConfig`
(`ConfigType`,
`SiteId`,
`ConfigKey`,
`ConfigGroup`,
`ConfigValue`,
`CreateTime`,
`UpdateTime`)
VALUES
('TP',
0,
'HotMatchConfig',
'TP',
'{"ApiUrl":"http://odds-api.vgamesuat.com","VendorId":"y2g53zl9g4", "VendorMemberId":"Starix1SW_4uo2mwe1avgc_test"}',
NOW(),
NOW());