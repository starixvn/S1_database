/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `LoginNewAdminUser_Get`(
		IN UserName varchar(30) CHARACTER SET ASCII,
		IN ReferenceId varchar(30) CHARACTER SET ASCII
/*
  Created: 20241217@issac.Le
        DB: TSDB-TSDB
        Task: Admin SSO Login
        Revisions:
                - 20241216@issac.le: Get admin user
*/
)
BEGIN
		
		SELECT 
			AdminUserV2.UserId,
			AdminUserV2.UserName,
			AdminUserV2.Userpwd,
			AdminUserV2.IsSuper,
			AdminUserV2.`Status`,
			AdminUserV2.`ReferenceID`
		FROM
			AdminUserV2
		WHERE
			TRIM(COALESCE(AdminUserV2.UserName, '')) != '' and AdminUserV2.UserName = UserName
			OR TRIM(COALESCE(AdminUserV2.ReferenceID , '')) != '' and AdminUserV2.ReferenceID = ReferenceId;
	END$$
DELIMITER ;
