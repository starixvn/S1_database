/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_CustInfoByMultipleSiteId_Get`(
	IN _UserName VARCHAR(30) CHARACTER SET ASCII,
    IN _MultiSiteRequest JSON
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Get user by multiple siteId
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
	SELECT SI.SiteName,
               C.SiteId,
               C.CustId,
               C.UserName,
               C.CurrencyId,
               C.`Status`
        FROM Customer AS C
                 INNER JOIN
             ServerInfo AS SI ON C.SiteId = SI.SiteId
				 INNER JOIN
			 JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
			ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
        WHERE C.UserName = _UserName;
END$$
DELIMITER ;
