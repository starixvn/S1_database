/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Brian
        DB: TSDB-TSDB
        Task: update status game PP
*/
UPDATE `TSDB`.`TpGameId`
SET Status = 0
WHERE TpId = 5;