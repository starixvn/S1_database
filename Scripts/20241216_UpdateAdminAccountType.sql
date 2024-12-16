/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@issac.le
        DB: TSDB-TSDB
        Task: Admin Permission
*/

ALTER TABLE TSDB.AdminUserV2 
ADD AccountType TINYINT NULL;