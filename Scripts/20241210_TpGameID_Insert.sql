/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241210@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Insert lobby game for SBSW
        Revisions:
                - 20241210@Brian.Nguyen : Insert lobby game for SBSW
*/
/*TpGameId*/
INSERT INTO `TSDB`.`TpGameId` (`No`, `TpId`, `TpGameType`, `GameId`, `BetType`, `Name`, `Entrance`, `Status`, `Desktop`, `H5`, `App`, `LobbyCategoryIds`, `ImgLobbyCategoryId`) 
VALUES 
('374', '41', '69', '3', '', 'Football', '1', '1', '1', '1', '1', '[1]', '1'),
('375', '41', '69', '4', '', 'Ice Hockey', '1', '1', '1', '1', '1', '[1]', '1'),
('376', '41', '69', '7', '', 'Snooker/Pool', '1', '1', '1', '1', '1', '[1]', '1'),
('377', '41', '69', '8', '', 'Baseball', '1', '1', '1', '1', '1', '[1]', '1'),
('378', '41', '69', '10', '', 'Golf', '1', '1', '1', '1', '1', '[1]', '1'),
('379', '41', '69', '11', '', 'Motorsports', '1', '1', '1', '1', '1', '[1]', '1'),
('380', '41', '69', '14', '', 'Water Polo', '1', '1', '1', '1', '1', '[1]', '1'),
('381', '41', '69', '16', '', 'Boxing/MMA', '1', '1', '1', '1', '1', '[1]', '1'),
('382', '41', '69', '18', '', 'Table Tennis', '1', '1', '1', '1', '1', '[1]', '1'),
('383', '41', '69', '24', '', 'Handball', '1', '1', '1', '1', '1', '[1]', '1'),
('384', '41', '69', '25', '', 'Darts', '1', '1', '1', '1', '1', '[1]', '1'),
('385', '41', '69', '26', '', 'Rugby', '1', '1', '1', '1', '1', '[1]', '1'),
('386', '41', '69', '33', '', 'Cycling', '1', '1', '1', '1', '1', '[1]', '1'),
('388', '41', '69', '44', '', 'Muay Thai', '1', '1', '1', '1', '1', '[1]', '1'),
('389', '41', '69', '45', '', 'Beach Volleyball', '1', '1', '1', '1', '1', '[1]', '1'),
('390', '41', '69', '47', '', 'Kabaddi', '1', '1', '1', '1', '1', '[1]', '1'),
('391', '41', '69', '56', '', 'Lotto', '1', '1', '1', '1', '1', '[8]', '8'),
('392', '41', '69', '58', '', 'Bandy', '1', '1', '1', '1', '1', '[1]', '1'),
('393', '41', '69', '99', '', 'Other Sports', '1', '1', '1', '1', '1', '[1]', '1'),
('394', '41', '70', '164', '', 'Happy 5', '1', '1', '1', '1', '1', '[8]', '8'),
('395', '41', '71', '180', '', 'Virtual Soccer', '1', '1', '1', '1', '1', '[1]', '1'),
('396', '41', '71', '186', '', 'Virtual Tennis', '1', '1', '1', '1', '1', '[1]', '1'),
('397', '41', '71', '190', '', 'Virtual Soccer League', '1', '1', '1', '1', '1', '[1]', '1'),
('398', '41', '71', '191', '', 'Virtual Soccer Nation', '1', '1', '1', '1', '1', '[1]', '1'),
('399', '41', '71', '192', '', 'Virtual Soccer World Cup', '1', '1', '1', '1', '1', '[1]', '1'),
('400', '41', '71', '193', '', 'Virtual Basketball', '1', '1', '1', '1', '1', '[1]', '1'),
('401', '41', '71', '194', '', 'Virtual Soccer Asian Cup', '1', '1', '1', '1', '1', '[1]', '1'),
('402', '41', '71', '196', '', 'Virtual Soccer Champions Cup', '1', '1', '1', '1', '1', '[1]', '1'),
('403', '41', '71', '197', '', 'Virtual Soccer Euro Cup', '1', '1', '1', '1', '1', '[1]', '1'),
('404', '41', '71', '993', '', 'Saba Basketball', '1', '1', '1', '1', '1', '[1]', '1'),
('405', '41', '71', '97', '', 'Saba Pingoal', '1', '1', '1', '1', '1', '[1]', '1');

/*TpGameIdInfo*/
INSERT INTO `TSDB`.`TpGameIdInfo` (`TpId`, `TpGameIdNo`, `Name`, `Lang`, `CreateAt`, `UpdateAt`) 
VALUES 
('41', '374', 'Football', 'en', NOW(), NOW()),
('41', '375', 'Ice Hockey', 'en', NOW(), NOW()),
('41', '376', 'Snooker/Pool', 'en', NOW(), NOW()),
('41', '377', 'Baseball', 'en', NOW(), NOW()),
('41', '378', 'Golf', 'en', NOW(), NOW()),
('41', '379', 'Motorsports', 'en', NOW(), NOW()),
('41', '380', 'Water Polo', 'en', NOW(), NOW()),
('41', '381', 'Boxing/MMA', 'en', NOW(), NOW()),
('41', '382', 'Table Tennis', 'en', NOW(), NOW()),
('41', '383', 'Handball', 'en', NOW(), NOW()),
('41', '384', 'Darts', 'en', NOW(), NOW()),
('41', '385', 'Rugby', 'en', NOW(), NOW()),
('41', '386', 'Cycling', 'en', NOW(), NOW()),
('41', '388', 'Muay Thai', 'en', NOW(), NOW()),
('41', '389', 'Beach Volleyball', 'en', NOW(), NOW()),
('41', '390', 'Kabaddi', 'en', NOW(), NOW()),
('41', '391', 'Lotto', 'en', NOW(), NOW()),
('41', '392', 'Bandy', 'en', NOW(), NOW()),
('41', '393', 'Other Sports', 'en', NOW(), NOW()),
('41', '394', 'Happy 5', 'en', NOW(), NOW()),
('41', '395', 'Virtual Soccer', 'en', NOW(), NOW()),
('41', '396', 'Virtual Tennis', 'en', NOW(), NOW()),
('41', '397', 'Virtual Soccer League', 'en', NOW(), NOW()),
('41', '398', 'Virtual Soccer Nation', 'en', NOW(), NOW()),
('41', '399', 'Virtual Soccer World Cup', 'en', NOW(), NOW()),
('41', '400', 'Virtual Basketball', 'en', NOW(), NOW()),
('41', '401', 'Virtual Soccer Asian Cup', 'en', NOW(), NOW()),
('41', '402', 'Virtual Soccer Champions Cup', 'en', NOW(), NOW()),
('41', '403', 'Virtual Soccer Euro Cup', 'en', NOW(), NOW()),
('41', '404', 'Saba Basketball', 'en', NOW(), NOW()),
('41', '405', 'Saba Pingoal', 'en', NOW(), NOW());                

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			