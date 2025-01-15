/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WhiteListIP_Udp`(
	IN SQ INT,
	IN IPFrom VARCHAR(39),
	IN IPTo VARCHAR(39),
	IN Memo VARCHAR(500),
	IN UpdateOperator VARCHAR(30)
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: update IP
        Revisions:
                - 20250109@Kathy: update IP
*/
)
BEGIN

    UPDATE WhitelistIP w
    SET    w.IPFrom = IPFrom
			, w.IPTo = IPTo
			, w.Memo = Memo
			, w.UpdateOperator = UpdateOperator
    WHERE  w.SQ = SQ;
	
END$$
DELIMITER ;
