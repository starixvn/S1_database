/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_AllWhiteListIP_Get`(
  
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: get all IP
        Revisions:
                - 20250109@Kathy: Get all IP
*/
)
BEGIN

    SELECT SQ, IPFrom, IPTo, Memo, CreateTime, UpdateOperator
    FROM   WhitelistIP;
	
END$$
DELIMITER ;
