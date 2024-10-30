/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS LoginNewAdminUser_Get;

DELIMITER //

CREATE PROCEDURE LoginNewAdminUser_Get(
    IN UserName varchar(30) CHARACTER SET ASCII,
    IN ReferenceId varchar(30) CHARACTER SET ASCII
)
/*
  Created: 20241028@Issac
	DB: TSDB-Siebog
	Task: sync log data to custom table

	Revisions:
		- 20241028@Issac: Initialize SP [RedmineID: #000000]
*/
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
END
//

DELIMITER ;