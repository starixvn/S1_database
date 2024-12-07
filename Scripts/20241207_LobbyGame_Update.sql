/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Brian
        DB: TSDB-TSDB
        Task: update name game CSGO -> CS2
*/
UPDATE `TSDB`.`TpGameId` SET `Name` = 'CS2' WHERE (`No` = '10');