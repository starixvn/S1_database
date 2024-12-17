/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_AdminUser_Ins_V2`(
    IN UserName VARCHAR(30) CHARACTER SET ASCII,
    IN Userpwd VARCHAR(50),
    IN Operator VARCHAR(50),
    IN AccountType TINYINT,
    OUT SEQ int
/*
  Created: 20241217@issac.Le
        DB: TSDB-TSDB
        Task: Admin Permission
        Revisions:
                - 20241216@issac.le: Get account type
*/
)
BEGIN

    INSERT INTO AdminUserV2 (UserName,Userpwd,UpdateOperator,AccountType) VALUES (UserName,Userpwd,Operator,AccountType);
    SET SEQ = LAST_INSERT_ID();
END$$
DELIMITER ;
