/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Levi
        DB: TSDB-TSDB
        Task: update column HotMatchInfo
*/

ALTER TABLE `TSDB`.`HotMatchInfo` 
ADD COLUMN `Tpid` INT NULL AFTER `CreateTime`,
ADD COLUMN `GameId` INT NULL AFTER `Tpid`;