/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241210@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Update Category Id for SabaPlay
        Revisions:
                - 20241210@Brian.Nguyen : Update Category Id for SabaPlay
*/
UPDATE `TSDB`.`TpGameType` SET `CategoryId` = '2' WHERE (`Type` = '119') AND (`TpId` = '66');