/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241214@Issac
        DB: TSDB-TSDB
        Task: Add assign brand permission
*/

INSERT INTO TSDB.AdminMenu
(Id, Name, HeirId, Sort, AdditionalSetting, `Translation`, Status)
VALUES(163, 'Assign Brand', 9, 0, '{"Permission": [1]}', NULL, 1);