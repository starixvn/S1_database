/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Brian
        DB: TSDB-TSDB
        Task: Update Tp Lobby Games
*/

UPDATE `TSDB`.`TpGameId` SET `Name` = 'Win 3 Cards' WHERE (`GameId` = '2406') AND (`TpId` = '12') AND (`TpgameType` = '6');
UPDATE `TSDB`.`TpGameIdInfo` SET `Name` = 'Win 3 Cards' WHERE (`TpGameIdNo` = '184') and (`Lang` = 'en');
UPDATE `TSDB`.`TpGameIdInfo` SET `Name` = 'Win 3 Cards' WHERE (`TpGameIdNo` = '184') and (`Lang` = 'th');
UPDATE `TSDB`.`TpGameId` SET `Name` = ' Two Sides Pok Deng'WHERE (`GameId` = '2408') AND (`TpId` = '12') AND (`TpgameType` = '6');
UPDATE `TSDB`.`TpGameIdInfo` SET `Name` = 'Two Sides Pok Deng' WHERE (`TpGameIdNo` = '186') and (`Lang` = 'en');
UPDATE `TSDB`.`TpGameIdInfo` SET `Name` = 'Two Sides Pok Deng' WHERE (`TpGameIdNo` = '186') and (`Lang` = 'th');


