/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_SocialDataList_Get`(
    IN _SiteId int, 
    IN _CurrencyId tinyint
/*
  Created: 20241127@Johnny
        DB: TSDB-TSDB
        Task: Hide th_en tab
        Revisions:
                - 20241115@Johnny: init sp
*/)

BEGIN
    SELECT sc.LangId AS LangId,
               sc.Sort AS Sort,
               sc.Id AS Id,
               sc.ChannelName AS ChannelName,
               sc.Title AS Title,
               sc.MainPageStatus AS MainPageStatus,
               sc.ContactPageStatus AS ContactPageStatus,
               sc.FooterStatus AS FooterStatus,
               sc.AppPageStatus AS AppPageStatus,
               sc.link AS Link,
               sc.AndroidLink AS AndroidLink,
               sc.IosLink AS IosLink,
               sc.LinkType AS LinkType,
               sc.LastUpdateUser AS LastUpdateUser,
               sc.LastUpdateTime AS LastUpdateTime
        FROM SocialChannel sc
        WHERE sc.SiteId = _SiteId
        AND sc.CurrencyId = _CurrencyId
        AND sc.LangId != 'th_en';

END;;
DELIMITER ;