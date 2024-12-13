/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241212@Brian.
        DB: TSDB-TSDB
        Task: Update status new for slot game and lobby game
*/

/*Update Fun Slot Game to Normal not support Demo type*/
UPDATE `TSDB`.`SlotGame`
SET `Fun` = 2, CreateAt = '2024-11-01 00:00:00'
where TpId IN (5,14,32,55,66,67,68,69) AND `Fun` != 2;

/*Update CreateAt Lobby Game*/
UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-11-01 00:00:00'
where TpId IN (5,12,15,18,32,55,66,73,72,71,61,41);

/*Update New Game For Slot Game*/
UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (5) AND GameId In (6916, 6915, 6914, 6913, 6912);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (32) AND GameId In (5169, 5168, 5167, 5166, 5165);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (55) AND GameId In (11338, 11339, 11340, 11341, 11342);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (14) AND GameId In (6135, 6134, 6133, 6132, 6131);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (66) AND GameId In (8902, 8903, 8904, 8905, 8906);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (67) AND GameId In (10045, 10046, 10047, 10048, 10049);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (68) AND GameId In (7625, 7626, 7627, 7628, 7629);

UPDATE `TSDB`.`SlotGame`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (69) AND GameId In (11130, 11131, 11132, 11133, 11134);

/*Update Mew Game For Lobby Game*/

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (5) AND TpGameIdNo In (255, 256, 257, 258, 259, 406, 407, 408, 409);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (12) AND TpGameIdNo In (182, 183, 184, 185, 186);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (15) AND TpGameIdNo In (204, 205, 206, 207, 208);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (18) AND TpGameIdNo In (204, 205, 206, 207, 208);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (32) AND TpGameIdNo In (411, 412, 413, 410);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (55) AND TpGameIdNo In (150, 151, 152, 153, 154, 142, 146, 144, 145, 143);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (66) AND TpGameIdNo In (361, 362, 363, 364, 365, 369, 370, 371, 372, 373);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (73) AND TpGameIdNo In (276, 277, 278, 279, 280);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (72) AND TpGameIdNo In (316, 317, 318, 319, 320);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (71) AND TpGameIdNo In (291, 292, 293, 294, 295);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (61) AND TpGameIdNo In (174, 175, 176, 177, 178);

UPDATE `TSDB`.`TpGameIdInfo`
SET CreateAt = '2024-12-12 00:00:00'
where TpId IN (41) AND TpGameIdNo In (11, 394);

/*Update status inactive for lobby game Lottery, Table Game, Keno */
UPDATE `TSDB`.`TpGameId`
SET Status = 0
where TpId IN (71,72,73);

/*Insert Game For Max Play*/
/*TpGameId*/
INSERT INTO `TSDB`.`TpGameId` (`No`, `TpId`, `TpGameType`, `GameId`, `BetType`, `Name`, `Entrance`, `Status`, `Desktop`, `H5`, `App`, `LobbyCategoryIds`, `ImgLobbyCategoryId`) 
VALUES 
('414', '73', '126', '0', '', 'Table Game', '1', '1', '1', '1', '1', '[6]', '6'),
('415', '72', '125', '0', '', 'Lottery', '1', '1', '1', '1', '1', '[8]', '8'),
('416', '71', '124', '0', '', 'RNG Keno', '1', '1', '1', '1', '1', '[8]', '8');

/*TpGameIdInfo*/
INSERT INTO `TSDB`.`TpGameIdInfo` (`TpId`, `TpGameIdNo`, `Name`, `Lang`, `CreateAt`, `UpdateAt`) 
VALUES 
('73', '414', 'Table Game', 'en', NOW(), NOW()),
('72', '415', 'Lottery', 'en', NOW(), NOW()),
('71', '416', 'RNG Keno', 'en', NOW(), NOW());                
                        