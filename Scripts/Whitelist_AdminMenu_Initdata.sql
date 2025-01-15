/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241401@Henry
        DB: TSDB-TSDB
        Task: Add whitelist
*/

INSERT INTO TSDB.AdminMenu
(Id, Name, HeirId, Sort, AdditionalSetting, `Translation`, Status)
VALUES(164, 'White List IP', 9, 0, '{"Permission": [1, 3, 4, 5]}', NULL, 1);

INSERT INTO TSDB.WhitelistIP (IPFrom, IPTo, Memo, CreateTime, UpdateOperator)
VALUES
    ('0.0.0.0', '255.255.255.255', 'Public', NOW(), 'admin');