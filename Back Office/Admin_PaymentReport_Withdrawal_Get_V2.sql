/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_PaymentReport_Withdrawal_Get_V2`(
    IN _PayIds JSON,
    IN _Types JSON,
    IN _UserNames JSON,
    IN _StartTime DATETIME,
    IN _EndTime DATETIME,
    IN _MultiSiteAndCurrencyIds JSON
    /*
  Created: 20241231@Loki.Nguyen
        DB: TSDB-TSDB
        Task: Add PayIds to filter
        Revisions:
                - 20241231@Loki.Nguyen: Add PayIds to filter
*/)

BEGIN
    SELECT
        WI.CurrencyId,
        SI.SiteName,
        WI.TransId,
        PL.Id AS PayId,
        PL.PayName,
        WI.WithdrawalType,
        WI.Amount,
        WI.CreateTime,
        WI.FlowEndTime
    FROM WithdrawalInfo AS WI
    INNER JOIN Customer AS C ON WI.CustId = C.CustId
    INNER JOIN PayList AS PL ON PL.Id = WI.WithdrawalInfo ->'$.PayId'
    INNER JOIN JSON_TABLE ( _MultiSiteAndCurrencyIds, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
    INNER JOIN ServerInfo AS SI ON C.SiteId = SI.SiteId                      
    WHERE  WI.Status = 6
        AND C.IsTest = 0
        AND WI.FlowEndTime BETWEEN _StartTime AND _EndTime
        AND EXISTS (SELECT 1 FROM JSON_TABLE(_Types, '$[*]' COLUMNS(`Type` INT PATH '$')) AS WithdrawalTypeList WHERE WithdrawalTypeList.`Type` = WI.WithdrawalType)
        AND EXISTS (SELECT 1 FROM JSON_TABLE(_PayIds, '$[*]' COLUMNS(`Id` INT PATH '$')) AS PayIdList WHERE PayIdList.`Id` = PL.Id)
        AND (_UserNames IS NULL OR EXISTS (SELECT 1 FROM JSON_TABLE(_UserNames, '$[*]' COLUMNS(`UserName` INT PATH '$')) AS UserNameList WHERE UserNameList.`UserName` =  C.UserName))
    ;
    
END$$
DELIMITER ;