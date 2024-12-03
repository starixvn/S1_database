/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Johnny
        DB: TSDB-TSDB
        Task: Update vip level name
*/

Update TSDB.VipLevel
Set LevelName = 'INFINITY CLUB'
Where SiteId in (1,1000) AND Level = 6