/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_TpBetRecordExtend_Get_V5`(
    IN YYYYMMDD varchar(8),
    IN SiteIdJson json,
    IN CurrencyIdJson json,
    IN TagJson json,
    IN VIPlevel int,
    IN TpId int,
    IN GameType int,
    IN TransId varchar(100),
    IN UserName varchar(30),
    IN TpUserName varchar(50),
    IN RefNo varchar(50),
    IN Category varchar(20),
    IN GameJson json,
    IN GameName varchar(100),
    IN Title varchar(100),
    IN MatchID varchar(40),
    IN BetType varchar(100),
    IN IP varchar(50),
    IN StartDate DATETIME,
    IN EndDate DATETIME,
    IN Stake decimal(20,6),
    IN WinlostAmount decimal(20,6),
    IN MemberTypeJson json

/*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: BetList Report
        Revisions:
                - 20241120@Levi.Vu: Added GameName condition
*/)
BEGIN
    SET @SiteIdJson = SiteIdJson;
    SET @CurrencyIdJson = CurrencyIdJson;
    SET @TagJson = TagJson;
    SET @VIPlevel = VIPlevel;
    SET @TpId = TpId;
    SET @GameType = GameType;
    SET @TransId = TransId;
    SET @UserName = UserName;
    SET @TpUserName = TpUserName;
    SET @RefNo = RefNo;
    SET @Category = Category;
    SET @Game = GameJson;
    SET @GameName = GameName;
    SET @Title = Title;
    SET @MatchID = MatchID;
    SET @BetType = BetType;
    SET @IP = IP;
    SET @StartDate = StartDate;
    SET @EndDate = EndDate;
    SET @Stake = Stake;
    SET @WinlostAmount = WinlostAmount;
    SET @MemberTypeJson = MemberTypeJson;

    SET @CMD = CONCAT("
        SELECT 
        TPRE.SiteId,
        SI.SiteName,
        TPRE.CurrencyId,
        TPRE.UserName,
        TPRE.TpUserName,
        TPRE.TpId,
        TPRE.TransId,
        TPRE.GameType,
        TPRE.TransTime,
        TPRE.SettledTime,
        TPRE.Stake,
        TPRE.ValidBet,
        TPRE.WinlostAmount,
        TPRE.ProviderID,
        TPRE.Currency,
        TPRE.RefNo,
        TPRE.GameID,
        TPRE.Provider,
        TPRE.Product,
        TPRE.Category,
        TPRE.Game,
        TPRE.Title,
        TPRE.MatchID,
        TPRE.BetType,
        TPRE.BetChoice,
        TPRE.Result,
        TPRE.Odds,
        TPRE.OddsType,
        TPRE.Platform,
        TPRE.Live,
        TPRE.IP,
        C.TagList,
        IFNULL(CV.VipLevel, 1) as VipLevel,
        VL.LevelName
    FROM
        TpBetRecordExtend_", YYYYMMDD , " AS TPRE
        INNER JOIN Customer AS C ON C.CustId = TPRE.CustId
        LEFT OUTER JOIN CustVip AS CV ON C.CustId = CV.CustId
        LEFT OUTER JOIN VipLevel AS VL ON IFNULL(CV.VipLevel, 1) = VL.`Level` AND C.SiteId = VL.SiteId
        LEFT JOIN ServerInfo AS SI ON SI.SiteId = TPRE.SiteId
    WHERE
        TPRE.SiteId IN (SELECT * FROM JSON_TABLE(?, '$[*]' COLUMNS(`SiteId` INT PATH '$')) AS SiteList)
        AND TPRE.CurrencyId IN (SELECT * FROM JSON_TABLE(?, '$[*]' COLUMNS(`CurrencyId` INT PATH '$')) AS CurrencyIdList)
        AND (? IS NULL OR (exists 
            (SELECT 1 FROM JSON_TABLE(C.TagList, '$[*]' COLUMNS(`TagId` INT path '$')) AS Temp2
             WHERE  TagId IN (SELECT TagId FROM JSON_TABLE(?, '$[*]' COLUMNS(`TagId` INT path '$')) AS Temp)) > 0))
        AND (? IS NULL OR ? = 0 OR CV.VipLevel = ? OR (? = 1 AND (CV.VipLevel = 1 OR CV.VipLevel IS NULL)))
        AND (? = 0 OR (TPRE.TpId = ?))
        AND (? = 0 OR (TPRE.GameType = ?))
        AND (? = '' OR (TPRE.TransId = ?))
        AND (? = '' OR (TPRE.UserName = ?))
        AND (? = '' OR (TPRE.TpUserName = ?))
        AND (? = '' OR (TPRE.RefNo = ?))
        AND (? = '' OR (TPRE.Category = ?)) 
        AND ((? IS NULL OR JSON_LENGTH(?) = 0) OR (TPRE.Game IN (SELECT * FROM JSON_TABLE(?, '$[*]' COLUMNS(`Game` varchar(20) PATH '$')) AS CategoryList)))
        AND (? = '' OR (TPRE.Title = ?))
        AND (? = '' OR (TPRE.MatchID = ?))
        AND (? = '' OR (TPRE.BetType = ?))
        AND (? = '' OR (TPRE.IP = ?))
        AND (? = '' OR (TPRE.Game = ?))
        AND ((TPRE.TransTime BETWEEN ? AND ?) OR (TPRE.SettledTime BETWEEN ? AND ?))
        AND (? = 0  OR (TPRE.Stake >= ?))
        AND (? = 0  OR (TPRE.WinlostAmount >= ?))
        AND C.MemberType IN (SELECT * FROM JSON_TABLE(?, '$[*]' COLUMNS(`MemberType` INT PATH '$')) AS MemberTypeList)
        ORDER BY TPRE.SettledTime DESC;"
    );

    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING 
    @SiteIdJson,
    @CurrencyIdJson,
    @TagJson, @TagJson,
    @VIPlevel, @VIPlevel, @VIPlevel, @VIPlevel,
    @TpId, @TpId,
    @GameType, @GameType,
    @TransId, @TransId,
    @UserName, @UserName,
    @TpUserName, @TpUserName,
    @RefNo, @RefNo,
    @Category, @Category,
    @Game, @Game, @Game,
    @Title, @Title,
    @MatchID, @MatchID,
    @BetType, @BetType,
    @IP, @IP,
    @GameName, @GameName,
    @StartDate, @EndDate, @StartDate, @EndDate,
    @Stake, @Stake,
    @WinlostAmount, @WinlostAmount,
    @MemberTypeJson;
    DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;
