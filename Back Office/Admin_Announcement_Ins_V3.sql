/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_Announcement_Ins_V3`(
	IN SiteId int, 
    IN StartTime datetime, 
    IN EndTime datetime, 
    IN Subject json,
    IN Content json, 
    IN Status tinyint, 
    IN Creator varchar(30), 
    IN CreatorId int, 
    IN IsTest tinyint, 
    IN Seq int, 
    OUT Id int
/*
  Created: 20241204@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Update Add Announcement SP
        Revisions:
                - 20241205@Zephyr.Nguyen: Update Add Announcement SP
*/)
BEGIN
    INSERT INTO TSDB.Announcement(SiteId, StartTime, EndTime, `Subject`, `Content`, `Status`, Creator, CreatorId, IsTest, Seq, LastUpdateTime, LastUpdater, LastUpdaterId)
    VALUES (SiteId, StartTime, EndTime, `Subject`, `Content`, `Status`, Creator, CreatorId, IsTest, Seq, NOW(), Creator, CreatorId);
    
    SET Id = LAST_INSERT_ID();
END$$
DELIMITER ;






