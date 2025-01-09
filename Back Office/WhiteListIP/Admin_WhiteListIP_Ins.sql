/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WhiteListIP_Ins`(
	IN IPFrom VARCHAR(39),
	IN IPTo VARCHAR(39),
	IN Memo VARCHAR(500),
	IN UpdateOperator VARCHAR(30)
  
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: INSERT IP
        Revisions:
                - 20250109@Kathy: INSERT IP
*/
)
BEGIN

    INSERT INTO WhitelistIP (IPFrom, IPTo, Memo, UpdateOperator)
    VALUES (IPFrom, IPTo, Memo, UpdateOperator);
	
END$$
DELIMITER ;
