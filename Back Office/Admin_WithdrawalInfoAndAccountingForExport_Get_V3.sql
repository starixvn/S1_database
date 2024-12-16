CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_WithdrawalInfoAndAccountingForExport_Get_V3`(
   IN _SiteIds json, 
   IN _CurrencyIds json,
   IN _StartDate DATETIME,
   IN _EndDate DATETIME,
   IN _TransId varchar(30) CHARACTER SET ASCII,
   IN _UserName varchar(35)
   )
BEGIN
   
   
   
   
   
SELECT WI.TransId,
       WI.CustId,
       WI.UserName,
       WI.SiteId,
       SI.SiteName,
       WI.CurrencyId,
       C.IsoCode,
       WI.Amount AS WithdrawalAmount,
       WI.ChargeFee AS WithdrawalChargeFee,
       WI.CreateTime,
       WI.Operator,
       WI.FlowEndTime,
       WBA.Seq AS AccountingSeq,
       BIS.BankCode AS AccountingBankCode,
       BDO.BankAccountName AS AccountingAccountName,
       WBA.BankAccountNo AS AccountingAccountNo,
       WBA.Amount AS AccountingAmount,
       WBA.ChargeFee AS AccountingChargeFee,
       WBA.Memo AS AccountingMemo,
       AUC.UserName AS AccountingCreatorName,
       WBA.CreateTime AS AccountingCreateTime,
       AUO.UserName AS AccountingOperatorName,
       WBA.OperateTime AS AccountingOperateTime
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
AND WI.FlowEndTime BETWEEN _StartDate AND _EndDate
AND ((_TransId IS NULL AND 1=1) OR (_TransId IS NOT NULL AND WI.TransId=_TransId))
AND ((_UserName IS NULL AND 1=1) OR (_UserName IS NOT NULL AND WI.UserName = _UserName))
ORDER BY  WI.TransId,WBA.Seq;

END