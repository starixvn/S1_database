/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_DepositStatusTime_Get_V5`(
    IN _SiteIds JSON,
    IN _CurrencyIds JSON, 
    IN _Statuses JSON,
    IN _TransId varchar(30),
    IN _StartDate DATETIME,
    IN _EndDate DATETIME,
    IN _StartIndex INT,
    IN _PageSize INT,
    IN _CustId INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
/*
  Created: 20241231@Issac
        DB: TSDB-TSDB
        Task: Update Report
        Revisions:
                - 20241231@Issac: Return StatementTime
*/
)
BEGIN
    
    
      SELECT SQL_CALC_FOUND_ROWS
             DI.`Status`,
             DI.TransId, 
             DI.DepositType,
             DI.UserName,
             DI.CustId,
             C.IsoCode,
             DI.CreateTime,
             DI.DepositTime,
             DI.UpdateTime,
             SI.SiteName,
             DI.SiteId,
             DI.DepositId,
             IF(DI.`Status` = 3, DI.FlowEndTime, NULL) AS ApprovedTime,
             (  SELECT DIL.Operator
                  FROM DepositLog AS DIL
                 WHERE DIL.`Action` = 3 
                   AND DIL.DepositId = DI.DepositId 
              ORDER BY CreateTime DESC LIMIT 1) AS ApprovedBy,
             DI.Operator,
             DI.StatementTime
         FROM DepositInfo AS DI 
    LEFT JOIN Currency AS C ON DI.CurrencyId = C.CurrencyId
    LEFT JOIN ServerInfo AS SI ON DI.SiteId = SI.SiteId
        WHERE DI.SiteId IN (SELECT SiteId FROM JSON_TABLE(_SiteIds, '$[*]' COLUMNS(`SiteId` INT path "$")) AS SiteList)
          AND DI.CurrencyId IN (SELECT CurrencyId FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT path "$")) AS CurrencyList)
          AND DI.`Status` IN (SELECT `Status` FROM JSON_TABLE(_Statuses, '$[*]' COLUMNS(`Status` INT path "$")) AS StatusList)
          AND (_TransId = '' OR DI.TransId = _TransId)
          AND DI.CreateTime BETWEEN _StartDate AND _EndDate
          AND (_CustId = 0 OR (_CustId > 0 AND DI.CustId = _CustId))
     ORDER BY DI.DepositId DESC
        LIMIT _StartIndex , _PageSize;

    SET _RowCount = FOUND_ROWS();
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount/_PageSize);
    END IF;

END$$
DELIMITER ;