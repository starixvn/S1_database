/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241202@Issac
        DB: TSDB-TSDB
        Task: Update Admin Menu
*/

-- UPDATE AdminMenu 
-- SET Status = 0
-- WHERE Id IN (54, 152, 156, 21)

Update TSDB.AdminMenu
Set Status = 0
Where Id in (64,65,66,67,68)

Update TSDB.AdminMenu
Set Status = 1
Where Id = 21