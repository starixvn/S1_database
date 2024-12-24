/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_UserList_Get_V3`(
    IN UserName VARCHAR(30) CHARACTER SET ASCII,
    IN SiteId INT,
    IN `Status` INT
/*
  Created: 20241216@issac.Le
        DB: TSDB-TSDB
        Task: Admin Permission
        Revisions:
                - 20241216@issac.le: Get account type
*/
)
BEGIN
    
    IF UserName IS NOT NULL THEN
        SELECT 
            AU.UserId,
            AU.UserName,
            AB.CurrencyList,
            S.SiteName,
            AR.Id as `Role`,
            AR.RoleName,
            AU.`Status`,
            AB.SiteId,
            AU.LoginTime,
            AB.UpdateTime,
            AU.AccountType
        FROM 
            AdminUserV2 AS AU
            INNER JOIN
            AdminBrand AS AB ON AB.UserId = AU.UserId AND AB.SiteId = SiteId 
            LEFT JOIN 
            ServerInfo AS S    ON S.SiteId = SiteId
            LEFT JOIN
            AdminRole AS AR ON JSON_CONTAINS(AB.`Role`,CAST(AR.Id AS JSON), '$')
        WHERE
            AU.UserName LIKE concat('%',UserName,'%') AND
            AB.`Status` = 1 AND
            AU.`Status` = `Status`;
    ELSE
        SELECT 
            AU.UserId,
            AU.UserName,
            AB.CurrencyList,
            S.SiteName,
            AR.Id as `Role`,
            AR.RoleName,
            AU.`Status`,
            AB.SiteId,
            AU.LoginTime,
            AB.UpdateTime,
            AU.AccountType
        FROM 
            AdminUserV2 AS AU
            INNER JOIN
            AdminBrand AS AB ON AB.UserId = AU.UserId AND AB.SiteId = SiteId 
            LEFT JOIN 
            ServerInfo AS S    ON S.SiteId = SiteId
            LEFT JOIN
            AdminRole AS AR ON JSON_CONTAINS(AB.`Role`,CAST(AR.Id AS JSON), '$')
        WHERE
            AB.`Status` = 1 AND
            AU.`Status` = `Status`;
    END IF;
END$$
DELIMITER ;


