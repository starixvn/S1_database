/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@Loki
        DB: TSDB-TSDB
        Task: Revert Leaderboard CronTime for Demo
        Revisions:
                - 20241216@Loki: Revert Leaderboard CronTime for Demo
*/

UPDATE ScheduledJob
SET
    Cron = '16,46 * * * *'
Where
    Project = 'Hangfire'
    AND ClassName = 'LeaderboardJob'
    AND JobName = 'LeaderBoard.nsDemo.Days.Category'
    AND ScheduledJob.Group = 'Report'