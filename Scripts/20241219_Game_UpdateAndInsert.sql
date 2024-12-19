/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241219@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Update status lobby game for vendor PP
*/

/*Active list game type games vendor PP*/
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '406') AND (`Status` = '0');
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '407') AND (`Status` = '0');
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '408') AND (`Status` = '0');
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '409') AND (`Status` = '0');