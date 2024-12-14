/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Brian.Nguyen
        DB: TSDB-TSDB
        Task: remove game not offer
*/
/*Remove slot game not offer*/
DELETE FROM `TSDB`.`GameCasinoExtra` WHERE GameCasinoId IN (510012, 510145, 510013, 6710022);
DELETE FROM `TSDB`.`GameCasinoInfo` WHERE GameCasinoId IN (510012, 510145, 510013, 6710022);
DELETE FROM `TSDB`.`SlotGameStatus` WHERE SlotGameId IN (510012, 510145, 510013, 6710022);
DELETE FROM `TSDB`.`SlotGameDetail` WHERE SlotGameId IN (510012, 510145, 510013, 6710022);
DELETE FROM `TSDB`.`SlotGame` WHERE Id IN (510012, 510145, 510013, 6710022);

/*Remove lobby game not offer*/
DELETE FROM `TSDB`.`TpGameId` WHERE `No` IN ('391','173','174');
DELETE FROM `TSDB`.`TpGameIdInfo` WHERE `TpGameIdNo` IN ('391','173','174');
