/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Los
        DB: TSDB-TSDB
        Task: Update Lottery in SiteConfig table UAT
*/

UPDATE SiteConfig SET ConfigValue='{"OperatorPwd":"huij8u39","OperatorKey":"chii0lcy","GameType":"Lottery","ApiUrl":"http://owapi1.playonesit.com:7054"}' WHERE ConfigKey='Lottery';
UPDATE TpList SET TpName='Lottery', DisplayName='Lottery' WHERE Id=72;
UPDATE `TSDB`.`TpGameId` SET `TpId` = '72', `TpGameType` = '125', `GameId` = '0', `Name` = 'Lottery' WHERE (`No` = '15'); 