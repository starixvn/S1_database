/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241125@Zephyr
        DB: TSDB-TSDB
        Task: Crate FPS Ticket for New Site
*/

INSERT INTO SiteTicketKey (SiteId, TpId, WorkerType, TicketKey, Memo, CreateTime, UpdateTime)
VALUES (1000, 999,  1,  1,  'FPS Transaction',  UTC_TIMESTAMP(), UTC_TIMESTAMP());

INSERT INTO SiteTicketKey (SiteId, TpId, WorkerType, TicketKey, Memo, CreateTime, UpdateTime)
VALUES (1000, 999,  2,  1,  'FPS RiskLevel',  UTC_TIMESTAMP(), UTC_TIMESTAMP());