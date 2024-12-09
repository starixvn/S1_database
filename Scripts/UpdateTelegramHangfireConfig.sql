/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241202@Issac
        DB: TSDB-TSDB
        Task: Update telegram hangfire config
*/

UPDATE TSDB.SiteConfig
SET ConfigGroup='HangfireService', ConfigValue='{
  "Url": "https://api.telegram.org",
  "Token": "7978386246:AAFbNxIOLPaeQzs5_JmOvF6jen1wYlzOD0M",
  "ChatId": -1002372599250,
  "Enable": true
}', CreateTime='2023-10-02 07:56:07', UpdateTime='2024-11-14 03:15:04'
WHERE ConfigType='Telegram' AND SiteId=0 AND ConfigKey='HangfireTelegram';