/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241206@Zephyr
        DB: TSDB-TSDB
        Task: Disable SMSCheckStatus Job
*/

update ScheduledJob
set Enable = 0
where Project = 'Hangfire' and ClassName = 'SMSCheckStatusJob' and JobName = 'SMSCheckStatus';