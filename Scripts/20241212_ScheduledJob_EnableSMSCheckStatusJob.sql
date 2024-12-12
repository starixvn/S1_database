/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241212@Zephyr
        DB: TSDB-TSDB
        Task: Enable SMS Check Status Job
*/

UPDATE ScheduledJob
SET 
    Enable = 1
WHERE 
    Project = 'Hangfire' 
    AND ClassName = 'SMSCheckStatusJob' 
    AND JobName = 'SMSCheckStatus';