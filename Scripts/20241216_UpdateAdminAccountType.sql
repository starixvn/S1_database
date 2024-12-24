/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@issac.le
        DB: TSDB-TSDB
        Task: Admin Permission
*/

ALTER TABLE TSDB.AdminUserV2 
ADD AccountType TINYINT NULL;

UPDATE AdminUserV2 
SET AccountType = CASE 
	WHEN IsSuper = 1 THEN 2
	WHEN IsSuper = 0 THEN 0
END
WHERE IsSuper IN (0, 1)