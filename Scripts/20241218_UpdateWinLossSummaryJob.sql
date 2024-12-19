/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241218@issac.le
        DB: TSDB-TSDB
        Task: Update Win Loss Summary Job
*/

UPDATE ScheduledJob 
SET Enable = 0
WHERE SQ IN (88, 89)
