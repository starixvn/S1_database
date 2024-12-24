/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_CustVerificationReward_Get_V3`(
	IN _CustId INT,
    IN _MultiSiteAndCuurency JSON,
    IN _StartDate DATETIME,
    IN _EndDate DATETIME,
    IN _PageSize INT,
    IN _StartIndex INT, 
    OUT _TotalPages INT,
    OUT _RowCount INT
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Get user that don't have in TPCustInfo
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
	SET _RowCount=0;
	SELECT SQL_CALC_FOUND_ROWS
        SI.SiteName,
        C.CustId,
        C.UserName,
        C.CurrencyId,
        TCI.TpUserName AS SabaID,
        A.UserName AS Agent,
        CY.IsoCode AS Currency,
        CP.PhoneVerified,
        CVR.PhoneReward,
        CVR.PhoneRewardTime,
        CP.EmailVerified,
        CVR.EmailReward,
        CVR.EmailRewardTime
    FROM
        CustVerificationReward AS CVR
            INNER JOIN
        Customer AS C ON C.CustId = CVR.CustId
            INNER JOIN
        CustProfile AS CP ON CP.CustId = CVR.CustId
            LEFT OUTER JOIN
        Customer AS A ON C.AgentId = A.CustId
            LEFT JOIN
        TpCustInfo AS TCI ON CP.CustId = TCI.CustId AND TpId = 41
            INNER JOIN
        Currency AS CY ON CY.CurrencyId=C.CurrencyId
            INNER  JOIN
        ServerInfo AS SI ON  SI.SiteId = CVR.SiteId
            INNER JOIN JSON_TABLE ( _MultiSiteAndCuurency, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
    WHERE (_CustId = 0 OR C.CustId = _CustId)
    AND (CVR.PhoneRewardTime BETWEEN _StartDate AND _EndDate OR CVR.EmailRewardTime BETWEEN _StartDate AND _EndDate)
    ORDER BY CVR.PhoneRewardTime, EmailRewardTime DESC
    LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;
END$$
DELIMITER ;
