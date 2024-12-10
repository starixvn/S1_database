/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_Provider_Get`(
/*
  Created: 20241123@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Get provider list 
        Revisions:
                - 20241123@Brian.Nguyen: Get  provider list
*/)
BEGIN  
    SELECT Id, TpName, DisplayName
    FROM TpList
    WHERE Status = 1 
    ORDER BY Sort;
END$$
DELIMITER ;