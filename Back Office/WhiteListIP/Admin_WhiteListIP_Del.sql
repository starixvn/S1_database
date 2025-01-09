/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WhiteListIP_Del`(
  IN SQ INT
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: delete IP
        Revisions:
                - 20250109@Kathy: delete IP
*/
)
BEGIN

   DELETE
   FROM   WhitelistIP w
   WHERE  w.SQ = SQ;
	
END$$
DELIMITER ;
