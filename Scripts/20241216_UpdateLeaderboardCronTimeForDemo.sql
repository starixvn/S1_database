/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@Loki
        DB: TSDB-TSDB
        Task: Update Leaderboard CronTime for Demo
        Revisions:
                - 20241216@Loki: Update Leaderboard CronTime for Demo
*/

UPDATE ScheduledJob
SET
    Cron = '0-19/5,25-49/5,55 * * * *'
Where
    Project = 'Hangfire'
    AND ClassName = 'LeaderboardJob'
    AND JobName = 'LeaderBoard.nsDemo.Days.Category'
    AND ScheduledJob.Group = 'Report'