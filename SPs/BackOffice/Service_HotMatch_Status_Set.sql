/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_HotMatch_Status_Set`(
/*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: Hot match
        Revisions:
                - 20241120@Levi.Vu: Update HotMatch status by EndTime
*/)

BEGIN
     UPDATE HotMatchInfo SET STATUS = 0 where NOW() > EndTime;
END$$
DELIMITER ;

