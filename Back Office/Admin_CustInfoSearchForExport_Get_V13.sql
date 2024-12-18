/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_CustInfoSearchForExport_Get_V13`(
    IN _SiteId INT, 
    IN _CurrencyList JSON,
    IN _StatusList JSON,
    IN _Identity TINYINT,
    IN _UserName VARCHAR(30) CHARACTER SET ASCII,
    IN _TagList JSON,
    IN _AccountName VARCHAR(50),
    IN _AffiliateName VARCHAR(30),
    IN _TpUserName VARCHAR(50) CHARACTER SET ASCII,
    IN _LoginIp VARCHAR(15) CHARACTER SET ASCII,
    IN _VipList JSON,
    IN _BankAccountNumber VARCHAR(50),
    IN _EWalletAccountNumber VARCHAR(100),
    IN _CryptoAddress VARCHAR(260),
    IN _Email VARCHAR(100) CHARACTER SET ASCII,
    IN _PhoneNo VARCHAR(50) CHARACTER SET ASCII,
    IN _TransType INT,
    IN _TransId VARCHAR(30) CHARACTER SET ASCII, 
    IN _ShieldLevel INT,
    IN _IovationLevel INT,
    IN _DeviceId VARCHAR(100),
    IN _AffCode VARCHAR(20) CHARACTER SET ASCII, 
    IN _UserTypes JSON,
    IN _DateType INT,
    IN _StartDate DATETIME,
    IN _EndDate DATETIME,
    IN _ExcludeTag INT
/*
  Created: 20241217@Zephyr.Nguyen
        DB: TSDB-TSDB
        Task: Fix show incorrect last activity IP when exporting
        Revisions:
                - 20241217@Zephyr.Nguyen: Fix show incorrect last activity IP when exporting
*/)
BEGIN
    
    
    
    
    
    
    DROP TEMPORARY TABLE IF EXISTS `TempCustSearchForExport`;
    CREATE TEMPORARY TABLE TempCustSearchForExport (
        CustId INT NOT NULL,
        PRIMARY KEY (CustId)
    );
    DROP TEMPORARY TABLE IF EXISTS `TempCurrencyIdForExport`;
    CREATE TEMPORARY TABLE TempCurrencyIdForExport (
        CurrencyId TINYINT NOT NULL
    );

    DROP TEMPORARY TABLE IF EXISTS `TempStatusForExport`;
    CREATE TEMPORARY TABLE TempStatusForExport (
        Status TINYINT NOT NULL
    );

    DROP TEMPORARY TABLE IF EXISTS TempLoginInfo;
    CREATE TEMPORARY TABLE TempLoginInfo (
        CustId INT NOT NULL,
        LoginTime DATETIME,
        LoginIp VARCHAR(15),
        PRIMARY KEY (CustId)
    );
    
    INSERT INTO TempCurrencyIdForExport
    SELECT CurrencyId FROM JSON_TABLE(_CurrencyList, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS Temp;

    INSERT INTO TempStatusForExport
    SELECT `Status` FROM JSON_TABLE(_StatusList, '$[*]' COLUMNS(`Status` INT path "$")) AS Temp;

    IF _DateType = 1 THEN 
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            Customer AS TC
        WHERE
            TC.RegTime BETWEEN _StartDate AND _EndDate ;
    ELSEIF _DateType = 2 THEN 
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            CustTaskTime AS CTT 
        WHERE
            CTT.TaskTime BETWEEN _StartDate AND _EndDate AND CTT.TaskId = 2;
    ELSEIF _DateType = 3 THEN 
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            Customer AS TC
        WHERE
            TC.LastTagUpdateTime BETWEEN _StartDate AND _EndDate
            AND TC.SiteId = _SiteId
            AND TC.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
            AND TC.Status IN (SELECT * FROM TempStatusForExport);
    END IF;

    IF _Identity = 1 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            Customer AS TC
        LEFT JOIN Affiliate_VN V on TC.CustId = V.CustId
        WHERE
            JSON_LENGTH(TC.AllAgentId) = 1
        AND V.CustId IS NULL
        AND TC.SiteId = _SiteId
        AND TC.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
        AND TC.Status IN (SELECT * FROM TempStatusForExport);
    ELSEIF _Identity = 2 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            Customer AS TC
        LEFT JOIN Affiliate_VN V on TC.CustId = V.CustId
        WHERE
            JSON_LENGTH(TC.AllAgentId) > 1
        AND V.CustId IS NULL
        AND TC.SiteId = _SiteId
        AND TC.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
        AND TC.Status IN (SELECT * FROM TempStatusForExport);
    ELSEIF _Identity = 3 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            V.CustId
        FROM
            Customer AS TC
                INNER JOIN
            Affiliate_VN V on TC.CustId = V.CustId
        AND TC.SiteId = _SiteId
        AND TC.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
        AND TC.Status IN (SELECT * FROM TempStatusForExport);
    END IF;

    IF _UserName IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            Customer AS TC
        WHERE
            TC.UserName LIKE CONCAT('%', _UserName, '%')
        AND TC.SiteId = _SiteId;
    END IF;

    IF JSON_LENGTH(_TagList) > 0 AND  _ExcludeTag = 0 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TC.CustId
        FROM
            Customer AS TC
        WHERE
            EXISTS (SELECT 1
                    FROM JSON_TABLE(TC.TagList, '$[*]' COLUMNS(`TagId` INT path "$")) AS Temp2
                    WHERE TagId IN (SELECT TagId FROM JSON_TABLE(_TagList, '$[*]' COLUMNS(`TagId` INT path "$")) AS Temp)) > 0;
    END IF;

    IF _AccountName IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustBankInfo.CustId
        FROM
            CustBankInfo
        WHERE
            CustBankInfo.AccountName LIKE CONCAT('%', _AccountName, '%')
        AND CustBankInfo.SiteId = _SiteId;
    END IF;

    IF _AffiliateName IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            AffiliateInfo.CustId
        FROM
            AffiliateInfo
        WHERE
            AffiliateInfo.AffiliateName = _AffiliateName;
    END IF;

    IF _TpUserName IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TpCustInfo.CustId
        FROM
            TpCustInfo
        WHERE
            TpCustInfo.TpUserName = _TpUserName ;
    END IF;

    IF _LoginIp IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            LoginLog.CustId
        FROM
            LoginLog
        WHERE
            LoginLog.LoginIp = _LoginIp
        AND LoginLog.SiteId = _SiteId;
    END IF;

    IF _Email IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustProfile.CustId
        FROM
            CustProfile
        WHERE
            CustProfile.Email = _Email ;
    END IF;

    IF _PhoneNo IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustProfile.CustId
        FROM
            CustProfile
        WHERE
            CustProfile.PhoneNo = _PhoneNo
        AND CustProfile.SiteId = _SiteId;
    END IF;

    IF _BankAccountNumber IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustBankDetail.CustId
        FROM
            CustBankDetail
                INNER JOIN
            Customer AS C ON CustBankDetail.CustId = C.CustId
        WHERE
            CustBankDetail.AccountNo = _BankAccountNumber
        AND C.SiteId = _SiteId;

        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustBankInfoLog.CustId
        FROM
            CustBankInfoLog
        WHERE
            CustBankInfoLog.AccountNum = _BankAccountNumber
        AND CustBankInfoLog.SiteId = _SiteId;
    END IF;

    IF _EWalletAccountNumber IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustEWalletDetail.CustId
        FROM
            CustEWalletDetail
                INNER JOIN
            Customer AS C ON CustEWalletDetail.CustId = C.CustId
        WHERE
            CustEWalletDetail.AccountNo = _EWalletAccountNumber
            AND C.SiteId = _SiteId;

        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            EWalletinfoLog.CustId
        FROM
            EWalletinfoLog
         WHERE
            EWalletinfoLog.AccountNum = _EWalletAccountNumber
            AND EWalletinfoLog.SiteId = _SiteId;
    END IF;

    IF _CryptoAddress IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustCryptoWalletDetail.CustId
        FROM
            CustCryptoWalletDetail
                INNER JOIN
            Customer AS C ON CustCryptoWalletDetail.CustId = C.CustId
        WHERE
            CustCryptoWalletDetail.Address = _CryptoAddress
            AND C.SiteId = _SiteId;
            
    END IF;

    IF _AffCode IS NOT NULL THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            Affiliate_VN.CustId
        FROM
            Affiliate_VN
        WHERE
            Affiliate_VN.AffCode = _AffCode ;
    END IF;

    IF _Transtype = 1 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            WithdrawalInfo.CustId
        FROM
            WithdrawalInfo
        WHERE
            WithdrawalInfo.TransId = _TransId
        AND WithdrawalInfo.SiteId = _SiteId
        AND WithdrawalInfo.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
        LIMIT 1;
    ELSEIF _TransType = 2 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            DepositInfo.CustId
        FROM
            DepositInfo
        WHERE
            DepositInfo.TransId = _TransId
        AND DepositInfo.SiteId = _SiteId
        AND DepositInfo.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
        LIMIT 1;
    ELSEIF _TransType = 3 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            TpTransferInfo.CustId
        FROM
            TpTransferInfo
        WHERE
            TpTransferInfo.TransId = _TransId
        AND TpTransferInfo.SiteId = _SiteId
        LIMIT 1;
    END IF;

    IF _ShieldLevel <> 0 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustShieldRiskInfo.CustId
        FROM
            CustShieldRiskInfo
        WHERE((_ShieldLevel = 1 AND CustShieldRiskInfo.DeviceScore < 75) OR (_ShieldLevel = 2 AND CustShieldRiskInfo.DeviceScore >= 75))
        AND CustShieldRiskInfo.SiteId = _SiteId
        AND CustShieldRiskInfo.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport);
    END IF;

    IF _IovationLevel <> 0 THEN
        INSERT IGNORE INTO TempCustSearchForExport
        SELECT
            CustIovation.CustId
        FROM
            CustIovation
        WHERE
            CustIovation.Iovation =
        CASE
            WHEN _IovationLevel = 1 THEN 'D'
            WHEN _IovationLevel = 2 THEN 'R'
            WHEN _IovationLevel = 3 THEN 'A'
        END;
    END IF;

    IF _DeviceId IS NOT NULL THEN
        IF _SiteId = 1 THEN
            INSERT IGNORE INTO TempCustSearchForExport
            SELECT
                CustIovation.CustId
            FROM
                CustIovation
            WHERE
                CustIovation.DeviceId = _DeviceId;
        ELSE
            INSERT IGNORE INTO TempCustSearchForExport
            SELECT
                CustShieldRiskInfo.CustId
            FROM
                CustShieldRiskInfo
            WHERE
                CustShieldRiskInfo.ShieldId = _DeviceId;
        END IF;
    END IF;
    
    INSERT INTO TempLoginInfo (CustId, LoginTime, LoginIp)
    SELECT CustId, LoginTime, LoginIp
    FROM (
        SELECT ll.CustId, ll.LoginTime, ll.LoginIp,
               ROW_NUMBER() OVER (PARTITION BY ll.CustId ORDER BY ll.LoginTime DESC) AS rn
        FROM LoginLog AS ll
        INNER JOIN TempCustSearchForExport AS cs ON cs.CustId = ll.CustId
    ) AS ranked_logins
    WHERE rn = 1;

    WITH VipList AS
    (
        SELECT `VipLevel` FROM JSON_TABLE(_VipList, '$[*]' COLUMNS(`VipLevel` INT path "$")) AS Temp
    )
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
	    LI.LoginIp as LastActivityIp,
        C.TagList,
        C.MemberType AS UserType
    FROM
        Customer AS C
            INNER JOIN
        TempCustSearchForExport AS TCF ON TCF.CustId = C.CustId
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
    WHERE C.SiteId = _SiteId
    AND C.CurrencyId IN (SELECT * FROM TempCurrencyIdForExport)
    AND C.Status IN (SELECT * FROM TempStatusForExport)
    AND (NOT EXISTS(SELECT 1 FROM VipList)
            OR (CV.VipLevel IS NULL AND 1 IN (SELECT VipLevel FROM VipList))
            OR (CV.VipLevel IS NOT NULL AND CV.VipLevel IN (SELECT VipLevel FROM VipList)))
    AND (JSON_LENGTH(_TagList) = 0 OR 
        (_ExcludeTag = 0 AND EXISTS (SELECT 1 FROM JSON_TABLE(C.TagList, '$[*]' COLUMNS(`TagId` INT path "$")) AS Temp2 
            WHERE TagId IN (SELECT TagId FROM JSON_TABLE(_TagList, '$[*]' COLUMNS(`TagId` INT path "$")) AS Temp)) > 0) OR 
        (_ExcludeTag = 1 AND EXISTS (SELECT 1 FROM JSON_TABLE(C.TagList, '$[*]' COLUMNS(`TagId` INT path "$")) AS Temp2
            WHERE TagId IN (SELECT TagId FROM JSON_TABLE(_TagList, '$[*]' COLUMNS(`TagId` INT path "$")) AS Temp)) = 0))
    AND C.MemberType IN (SELECT UserType FROM JSON_TABLE(_UserTypes, '$[*]' COLUMNS(`UserType` INT path "$")) AS SelectUserTypeList)
    ORDER BY C.CustId;

    DROP TEMPORARY TABLE IF EXISTS `TempCustSearchForExport`;
    DROP TEMPORARY TABLE IF EXISTS `TempCurrencyIdForExport`;
    DROP TEMPORARY TABLE IF EXISTS `TempStatusForExport`;
    DROP TEMPORARY TABLE IF EXISTS `TempLoginInfo`;
END$$
DELIMITER ;