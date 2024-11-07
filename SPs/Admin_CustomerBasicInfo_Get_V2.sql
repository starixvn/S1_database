/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_CustomerBasicInfo_Get_V2`(
    IN _CustId int
/*
  Created: 20241107@Luke
	DB: TSDB-TSDB
	Task: Initial

	Revisions:
		- 20241030@Luke: Initial
*/
)
BEGIN

    
    
    
    
    
    
    
    
    SET @TempLastDepositTime = null;
    SET @TempFirstDepositTime = null;
    SET @PhoneVerifyTime = null;
    SET @EmailVerifyTime = null;
    
    SELECT DT.Last, DT.First
    INTO @TempLastDepositTime,
         @TempFirstDepositTime
    FROM (SELECT MAX(D.FlowEndTime) AS Last,
                 MIN(D.FlowEndTime) AS First
          FROM DepositInfo AS D
          WHERE D.CustId = _CustId
            AND D.`Status` = 3) AS DT;

    SELECT TaskTime INTO @PhoneVerifyTime
    FROM CustTaskTime AS CTT
    WHERE CTT.CustId = _CustId
      AND CTT.TaskId = 3;
      
    SELECT TaskTime INTO @EmailVerifyTime
    FROM CustTaskTime AS CTT
    WHERE CTT.CustId = _CustId
      AND CTT.TaskId = 4;

    SELECT *
    INTO
        @SiteId,
        @SiteName,
        @CustId,
        @UserName,
        @CurrencyId,
        @CurrencyName,
        @VipLevel,
        @UserLevel,
        @Agent,
        @UserLang,
        @ActStatus,
        @IsTest,
        @IsKyc,
        @IsRisk,
        @PhoneVerified,
        @EmailVerified,
        @Status,
        @EnableRebate,
        @LastLoginTime ,
        @RegTime,
        @Email,
        @FirstDepositTime,
        @AccountName,
        @SabaId,
        @AreaCode,
        @PhoneNo,
        @BirthDay,
        @BirthMonth,
        @BirthYear,
        @CustDepositCnt,
        @CustWithdrawalCnt,
        @AffId,
        @AffCode,
        @AffPlayerName,
        @AffiliateCode,
        @LastDepositTime,
        @TagList,
        @AddressCountry,
        @AddressState,
        @AddressPostCode,
        @AddressCity,
        @AddressLineFirst,
        @AddressLineSecond,
        @PhoneRewardTime,
        @EmailRewardTime,
        @Exclusive,
        @Identity,
        @UserType,
        @EnableTurnoverRewardPoint
    FROM
    (SELECT
        C.SiteId,
        S.SiteName,
        C.CustId,
        C.UserName,
        C.CurrencyId,
        C2.IsoCode,
        IFNULL(CV.VipLevel, 1),
        C.UserLevel,
        A.UserName AS Agent,
        C.UserLang,
        C.ActStatus,
        C.IsTest,
        C.IsKyc,
        C.IsRisk,
        P.PhoneVerified,
        P.EmailVerified,
        IFNULL(CTMS.`Status` ,C.`Status`),
        C.EnableRebate,
        C.LastLoginTime,
        C.RegTime,
        P.Email,
        @TempFirstDepositTime,
        CBI.AccountName,
        TCI.TpUserName,
        P.AreaCode,
        P.PhoneNo,
        P.`Profile`->>'$.Birth_d' AS Birth_d,
        P.`Profile`->>'$.Birth_m' AS Birth_m,
        P.`Profile`->>'$.Birth_y' AS Birth_y,
        CTS.DepositCnt,
        CTS.WithdrawlCnt,
        Aff_VN.AffId AS AffId,
        Aff_VN.AffCode AS AffCode,
        AI.UserName AS AffPlayerName,
        AI.AffiliateCode AS AffiliateCode,
        @TempLastDepositTime,
        C.TagList,
        P.`Address`->>'$.Country' AS AddressCountry,
        P.`Address`->>'$.State' AS AddressState,
        P.`Address`->>'$.PostCode' AS AddressPostCode,
        P.`Address`->>'$.City' AS AddressCity,
        P.`Address`->>'$.LineFirst' AS AddressLineFirst,
        P.`Address`->>'$.LineSecond' AS AddressLineSecond,
        CVR.PhoneRewardTime,
        CVR.EmailRewardTime,
        IFNULL(CV.Exclusive, 0),
        CASE WHEN JSON_LENGTH(C.AllAgentId) > 1 THEN 2
                 WHEN Aff_VN.CustId IS NOT NULL THEN 3
                 ELSE 1
            END AS Identity,
        C.MemberType AS UserType,
        C.EnableTurnoverRewardPoint
    FROM
        Customer AS C
            INNER JOIN
        ServerInfo AS S ON C.SiteId = S.SiteId
            INNER JOIN
        Currency C2 ON C.CurrencyId = C2.CurrencyId
            LEFT OUTER JOIN
        Customer AS A ON C.AgentId = A.CustId
            LEFT OUTER JOIN
        CustProfile AS P ON C.CustId = P.CustId
            LEFT OUTER JOIN
        CustBankInfo AS CBI ON C.CustId = CBI.CustId
            LEFT OUTER JOIN
        CustTransSummary AS CTS ON C.CustId = CTS.CustId
            LEFT OUTER JOIN
        Affiliate_VN AS Aff_VN ON C.CustId = Aff_VN.CustId
            LEFT OUTER JOIN
        CustVip AS CV ON C.CustId = CV.CustId
            LEFT OUTER JOIN
        AffiliateInfo AS AI ON C.CustId = AI.CustId
			LEFT OUTER JOIN
		TpCustInfo AS TCI ON TCI.CustId = C.CustId AND TCI.TpId = 41
            LEFT JOIN
        CustVerificationReward CVR ON C.CustId = CVR.CustId
			LEFT JOIN 
		CustTemporaryStatus AS CTMS ON CTMS.CustId = C.CustId
    WHERE
        C.CustId = _CustId) AS Temp;

    IF ROW_COUNT() > 0 THEN

        SET @PointLevel = 0;
		SET @LevelName = '';
        
		SELECT LevelName
        INTO @LevelName
        FROM VipLevel
		WHERE SiteId = @SiteId AND Level = @VipLevel;
        
        SELECT
            MAX(PointLevelInfo.PointLevel)
        INTO
            @PointLevel
        FROM
            PointLevelInfo
        WHERE
            @IsKyc >= PointLevelInfo.IsKyc
            AND @CustDepositCnt >= PointLevelInfo.DepositCnt
            AND @CustWithdrawalCnt >= PointLevelInfo.WithdrawalCnt
            AND PointLevelInfo.CurrencyId = @CurrencyId
            AND PointLevelInfo.SiteId = @SiteId;

        SET @PointLevel = IFNULL(@PointLevel, 1);

        SET @PointLevel  = IF(@IsRisk = 0,
            IF(@UserLevel > @PointLevel, @UserLevel, @PointLevel),
            IF(@UserLevel > @PointLevel, @PointLevel, @UserLevel));

        SELECT
            @SiteId AS SiteId,
            @SiteName AS SiteName,
            @CustId AS CustId,
            @UserName AS UserName,
            @CurrencyId AS CurrencyId,
            @CurrencyName AS CurrencyName,
            @VipLevel AS VipLevel,
            @LevelName AS LevelName,
            @UserLevel AS UserLevel,
            @PointLevel AS PointLevel,
            @Agent AS Agent,
            @UserLang AS UserLang,
            @ActStatus AS ActStatus,
            @IsTest AS IsTest,
            @IsKyc AS IsKyc,
            @IsRisk AS IsRisk,
            @PhoneVerified AS PhoneVerified,
            @EmailVerified AS EmailVerified,
            @Status AS `Status`,
            @EnableRebate AS EnableRebate,
            CAST(@LastLoginTime AS DATETIME) AS LastLoginTime,
            CAST(@RegTime AS DATETIME) AS RegTime,
            @Email AS Email,
            CAST(@FirstDepositTime AS DATETIME) AS FirstDepositTime,
            @AccountName AS AccountName,
            @SabaId AS SabaId,
            @AreaCode AS AreaCode,
            @PhoneNo AS PhoneNo,
            @BirthDay AS BirthDay,
            @BirthMonth AS BirthMonth,
            @BirthYear AS BirthYear,
            @AffId AS AffId,
            @AffCode AS AffCode,
            @AffPlayerName AS AffPlayerName,
            @AffiliateCode AS AffiliateCode,
            CAST(@LastDepositTime AS DATETIME) AS LastDepositTime,
            @TagList AS TagList,
            IF(@AddressCountry='null',null,@AddressCountry) AS AddressCountry,
            IF(@AddressState='null',null,@AddressState) AS AddressState,
            IF(@AddressPostCode='null',null,@AddressPostCode) AS AddressPostCode,
            IF(@AddressCity='null',null,@AddressCity) AS AddressCity,
            IF(@AddressLineFirst='null',null,@AddressLineFirst) AS AddressLineFirst,
            IF(@AddressLineSecond='null',null,@AddressLineSecond) AS AddressLineSecond,
            CAST(@PhoneRewardTime AS DATETIME) AS PhoneRewardTime,
            CAST(@EmailRewardTime AS DATETIME) AS EmailRewardTime,
            CAST(@PhoneVerifyTime AS DATETIME) AS PhoneVerifyTime,
            CAST(@EmailVerifyTime AS DATETIME) AS EmailVerifyTime,
            @Exclusive AS Exclusive,
            @Identity AS Identity,
            @UserType AS MemberType,
            @EnableTurnoverRewardPoint AS EnableTurnoverRewardPoint;
    END IF;

END$$
DELIMITER ;
