CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WithdrawalInfoAndAccountingForExport_Get`(
   IN _SiteIds json, 
   IN _CurrencyIds json,
   IN _StartDate varchar(10),
   IN _EndDate varchar(10),
   IN _TransId varchar(30),
   IN _UserName varchar(35)
   )
BEGIN
   
   
   
   SET @StartDate = CONVERT_TZ(STR_TO_DATE(_StartDate, '%Y-%c-%e'), '+08:00', @@session.time_zone);
   SET @EndDate = DATE_SUB(DATE_ADD(CONVERT_TZ(STR_TO_DATE(_EndDate, '%Y-%c-%e'), '+08:00', @@session.time_zone), INTERVAL 1 DAY), INTERVAL 1 MICROSECOND); 

SELECT WI.TransId,
       WI.CustId,
       WI.UserName,
       WI.SiteId,
       SI.SiteName,
       WI.CurrencyId,
       C.IsoCode,
       WI.Amount AS WithdrawalAmount,
       WI.ChargeFee AS WithdrawalChargeFee,
       DATE_FORMAT(CONVERT_TZ(WI.CreateTime, @@session.time_zone, '+08:00'),'%Y-%m-%d %H:%i:%S') AS CreateTime,
       WI.Operator,
       DATE_FORMAT(CONVERT_TZ(WI.UpdateTime, @@session.time_zone, '+08:00'),'%Y-%m-%d %H:%i:%S') AS UpdateTime,
       WBA.Seq AS AccountingSeq,
       BIS.BankCode AS AccountingBankCode,
       BDO.BankAccountName  AS AccountingAccountName,
       WBA.BankAccountNo AS AccountingAccountNo,
       WBA.Amount AS AccountingAmount,
       WBA.ChargeFee  AS AccountingChargeFee,
       WBA.Memo   AS AccountingMemo,
       AUC.UserName AS AccountingCreatorName,
       DATE_FORMAT(CONVERT_TZ(WBA.CreateTime, @@session.time_zone, '+08:00'),'%Y-%m-%d %H:%i:%S') AS AccountingCreateTime,
       AUO.UserName AS AccountingOperatorName,
       DATE_FORMAT(CONVERT_TZ(WBA.OperateTime, @@session.time_zone, '+08:00'),'%Y-%m-%d %H:%i:%S') AS AccountingOperateTime
FROM WithdrawalInfo AS WI
LEFT JOIN ServerInfo AS SI ON WI.SiteId = SI.SiteId
LEFT JOIN Currency AS C ON WI.CurrencyId = C.CurrencyId
LEFT JOIN WithdrawalBankAccounting AS WBA ON WI.TransId = WBA.TransId
LEFT JOIN AdminUser AS AUC ON WBA.Creator = AUC.UserId
LEFT JOIN AdminUser AS AUO ON WBA.Operator = AUO.UserId
INNER JOIN BankDetailOff AS BDO ON WBA.BankAccountNo = BDO.BankAccountNo 
       AND WI.SiteId = BDO.SiteId
INNER JOIN BankInfoSys BIS ON BDO.SysId = BIS.Id
WHERE WI.`Status`=6 
AND WI.WithdrawalType=2 
AND WI.SiteId IN (SELECT * FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT PATH "$")) AS SiteList)
AND WI.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyList)
AND WI.UpdateTime BETWEEN @StartDate AND @EndDate
AND WI.TransId=IFNULL(_TransId, WI.TransId)
AND WI.UserName = IFNULL(_UserName, WI.UserName)
ORDER BY  WI.TransId,WBA.Seq;

END