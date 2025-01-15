/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WhiteListIP_Get`(
  IN SQ INT
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: get all IP
        Revisions:
                - 20250109@Kathy: Get IP
*/
)
BEGIN

    SELECT w.SQ, w.IPFrom, w.IPTo, w.Memo, w.CreateTime, w.UpdateOperator
    FROM   WhitelistIP w
    WHERE  w.SQ = SQ ;
	
END$$
DELIMITER ;
