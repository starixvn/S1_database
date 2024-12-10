/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241129@Johnny
        DB: TSDB-TSDB
        Task: Hide menu for phase 1
*/
-- Hide Pending Bonus
Update TSDB.AdminMenu
Set Status = 0
Where Id = 46;