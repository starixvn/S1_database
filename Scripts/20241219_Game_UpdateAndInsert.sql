/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241219@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Update status lobby game for vendor PP
*/

/*Active list game type games vendor PP*/
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '406') AND (`Status` = '0');
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '406') AND (`Status` = '0');
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '406') AND (`Status` = '0');
UPDATE `TSDB`.`TpGameId` SET `Status` = '1' WHERE (`No` = '406') AND (`Status` = '0');

/*Remove slot game Spaceman*/
DELETE FROM `TSDB`.`GameCasinoExtra` WHERE GameCasinoId IN (510408);
DELETE FROM `TSDB`.`GameCasinoInfo` WHERE GameCasinoId IN (510408);
DELETE FROM `TSDB`.`SlotGameStatus` WHERE SlotGameId IN (510408);
DELETE FROM `TSDB`.`SlotGameDetail` WHERE SlotGameId IN (510408);
DELETE FROM `TSDB`.`SlotGame` WHERE Id IN (510408);

/*Insert Game Spaceman For lobby PP*/
/*TpGameId*/
INSERT INTO `TSDB`.`TpGameId` (`No`, `TpId`, `TpGameType`, `GameId`, `BetType`, `Name`, `Entrance`, `Status`, `Desktop`, `H5`, `App`, `LobbyCategoryIds`, `ImgLobbyCategoryId`) 
VALUES ('417', '5', '7', '6798', '', 'Spaceman', '1', '1', '1', '1', '1', '[6]', '6');

/*TpGameIdInfo*/
INSERT INTO `TSDB`.`TpGameIdInfo` (`TpId`, `TpGameIdNo`, `Name`, `Lang`, `CreateAt`, `UpdateAt`) 
VALUES ('5', '417', 'Spaceman', 'en', NOW(), NOW()); 