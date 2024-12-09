/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241128@Johnny
        DB: TSDB-TSDB
        Task: add permission delete in game exclusion menu
*/

UPDATE TSDB.AdminMenu
SET AdditionalSetting = '{"Permission": [1, 3, 4, 12]}'
WHERE Id = 62;