/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_AdminUserBySite_Get`(
    IN UserId INT,
    IN SiteId INT
/*
  Created: 20241216@issac.Le
        DB: TSDB-TSDB
        Task: Admin Permission
        Revisions:
                - 20241216@issac.le: Get account type
*/
)
BEGIN
  
    SELECT 
        AU.UserId,
        AU.UserName,
        AU.IsSuper,
        AU.`Status`,
        AU.CreateTime,
        AU.LoginTime,
        AB.`Role`,
        AB.CurrencyList,
        AB.SiteId,
        AU.AccountType
    FROM
        AdminUserV2 AU
        INNER join 
        AdminBrand AB ON AB.UserId = AU.UserId AND AB.SiteId = SiteId
    WHERE
        AU.UserId = UserId AND 
        AB.`Status` = 1;
END$$
DELIMITER ;



