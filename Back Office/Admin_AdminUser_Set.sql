/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_AdminUser_Set`(
	IN UserId INT,
	IN Operator VARCHAR(50),
    IN AccountType TINYINT
/*
  Created: 20250113@issac.Le
        DB: TSDB-TSDB
        Task: Update AccountType
        Revisions:
                - 20250113@issac.le: Add account type
*/
)
BEGIN
	
    UPDATE 
		AdminUserV2
	SET
		AdminUserV2.UpdateOperator = Operator,
        AdminUserV2.AccountType = AccountType,
        AdminUserV2.UpdateTime = now()
	WHERE
		AdminUserV2.UserId = UserId;
END$$
DELIMITER ;
