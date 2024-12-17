/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_CustinfoByImportData_Get`(
    IN _SiteId INT,
    IN _UserNameList JSON,
    IN _CustIdList JSON
/*
  Created: 20241217@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Fix show incorrect last activity IP when exporting
        Revisions:
                - 20241217@Zephyr.Nguyen: Fix show incorrect last activity IP when exporting
*/
)
BEGIN

    
    
    DROP TEMPORARY TABLE IF EXISTS `TempCustinfoByImportData`;
    CREATE TEMPORARY TABLE TempCustinfoByImportData (
        CustId INT NOT NULL,
        PRIMARY KEY (CustId)
    );

    DROP TEMPORARY TABLE IF EXISTS `TempLoginInfo`;
    CREATE TEMPORARY TABLE TempLoginInfo (
        CustId INT NOT NULL,
        LoginTime DATETIME,
        LoginIp VARCHAR(15),
        PRIMARY KEY (CustId)
    );
    
    DROP TEMPORARY TABLE IF EXISTS `TempUserNameByImportData`;
    CREATE TEMPORARY TABLE TempUserNameByImportData (
        UserName VARCHAR(30) CHARACTER SET ASCII NOT NULL
    );
    
    INSERT INTO TempCustinfoByImportData
    SELECT CustId FROM JSON_TABLE(_CustIdList, '$[*]' COLUMNS(CustId INT path "$")) AS Temp;
    
    INSERT INTO TempUserNameByImportData
    SELECT UserName FROM JSON_TABLE(_UserNameList, '$[*]' COLUMNS(UserName VARCHAR(30) CHARACTER SET ASCII path "$")) AS Temp;
    
    INSERT IGNORE INTO TempCustinfoByImportData
        SELECT
            C.CustId
        FROM
            Customer AS C
            INNER JOIN TempUserNameByImportData AS temp 
            on temp.UserName = C.UserName AND C.SiteId = _SiteId;

    INSERT INTO TempLoginInfo (CustId, LoginTime, LoginIp)
    SELECT CustId, LoginTime, LoginIp
    FROM (
        SELECT ll.CustId, ll.LoginTime, ll.LoginIp,
               ROW_NUMBER() OVER (PARTITION BY ll.CustId ORDER BY ll.LoginTime DESC) AS rn
        FROM LoginLog AS ll
        INNER JOIN TempCustinfoByImportData AS cs ON cs.CustId = ll.CustId
    ) AS ranked_logins
    WHERE rn = 1;

    
    SELECT
        SI.SiteName,
        C2.IsoCode,
        C.CustId,
        C.UserName,
        C.CurrencyId,
        C.UserLevel,
        A.UserName AS Agent,
        CBI.AccountName AS RealName,
        P.`Profile`->>'$.CountryCode' AS CountryCode,
        P.AreaCode,
        P.PhoneNo,
        P.Email,
        C.IsTest,
        C.IsKyc,
        C.IsRisk,
        C.`Status`,
        CAST(C.RegTime AS DATETIME) AS RegTime,
        IFNULL(TCI.TpUserName, CONCAT(SI.SiteName,'_', C.CustId)) AS SabaId,
        CRI.SignupUrl,
        CAST(P.`Profile`->'$.Birth_d' AS UNSIGNED) AS BirthDate,
        CAST(P.`Profile`->'$.Birth_m' AS UNSIGNED) AS BirthMonth,
        CAST(P.`Profile`->'$.Birth_y' AS UNSIGNED) AS BirthYear,
        Aff_VN.AffId AS AffiliateId,
        VL.LevelName,
        Aff_VN.AffCode AS AffiliateCode,
        IFNULL(CB.Bonus,0) AS BonusWallet,
        IFNULL(CW.Balance,0) AS SeamlessWallet,
        LI.LoginIp AS LastActivityIp,
        C.TagList,
        C.MemberType AS UserType
    FROM
        Customer AS C
            INNER JOIN
        TempCustinfoByImportData AS TCBI ON TCBI.CustId = C.CustId
            INNER JOIN
        Currency C2 on C.CurrencyId = C2.CurrencyId
            LEFT OUTER JOIN
        Customer AS A ON C.AgentId = A.CustId
            LEFT OUTER JOIN
        ServerInfo AS SI ON SI.SiteId = C.SiteId
            LEFT OUTER JOIN
        TpCustInfo AS TCI ON TCI.CustId = C.CustId AND TCI.TpId= 41
            LEFT OUTER JOIN
        CustProfile AS P ON C.CustId = P.CustId
            LEFT OUTER JOIN
        CustBankInfo AS CBI ON C.CustId = CBI.CustId
            LEFT OUTER JOIN
        CustRegInfo AS CRI ON C.CustId = CRI.CustId
            LEFT OUTER JOIN
        Affiliate_VN AS Aff_VN ON C.CustId = Aff_VN.CustId
            LEFT OUTER JOIN
        CustVip AS CV ON C.CustId = CV.CustId
            LEFT OUTER JOIN
        VipLevel AS VL ON IFNULL(CV.VipLevel, 1) = VL.`Level` AND C.SiteId = VL.SiteId
            LEFT OUTER JOIN
        CustBonus AS CB ON CB.CustId = C.CustId AND CB.`Status` = 1
            LEFT OUTER JOIN
        CustWallet AS CW ON CW.CustId = C.CustId
            LEFT OUTER JOIN
        AffiliateInfo AS AI ON AI.CustId = C.CustId
            LEFT OUTER JOIN
        TempLoginInfo AS LI ON C.CustId = LI.CustId
    WHERE
        C.SiteId = _SiteId;
    
    DROP TEMPORARY TABLE IF EXISTS `TempCustinfoByImportData`;
    DROP TEMPORARY TABLE IF EXISTS `TempLoginInfo`;
    DROP TEMPORARY TABLE IF EXISTS `TempUserNameByImportData`;
END$$
DELIMITER ;