/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241213@Zephyr
        DB: TSDB-TSDB
        Task: Update SMSCheckBalanceJob and SMSAutoSupport 
*/

update ScheduledJob
set Enable = 1,
    Cron = '0 10,18 * * *'
where Project = 'Hangfire' and ClassName = 'SMSCheckBalanceJob' and JobName = 'SMSCheckBalance';

