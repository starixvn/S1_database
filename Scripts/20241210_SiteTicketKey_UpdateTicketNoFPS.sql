/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241210@Zephyr
        DB: TSDB-TSDB
        Task: update ticket no for fps
*/

update SiteTicketKey 
set TicketKey = 1
where SiteId = 1000 and TpId = 999 and WorkerType = 1 and Memo = 'FPS Transaction';
 
update SiteTicketKey 
set TicketKey = 1
where SiteId = 1000 and TpId = 999 and WorkerType = 2 and Memo = 'FPS RiskLevel';