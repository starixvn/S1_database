/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Zephyr
        DB: TSDB-TSDB
        Task: Update ScheduledJob FPS Config
*/

update ScheduledJob
set Parameters = '{"Mode": 0, "Token": "eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTczMjAwMTM0MiwiaWF0IjoxNzMyMDAxMzQyfQ.GdndSkjE3BbEBTIm7VqM4-zdBmTwOtlxY6yX7I2L7Sc", "ApiUrl": "http://fpsapiext-uat.nebula.prod", "SiteId": 1000, "Subscribers": "NSDemo1SW"}'
where SQ = 119 and ClassName = 'FPSJob' and JobName = 'FPSJob.nsDemo';