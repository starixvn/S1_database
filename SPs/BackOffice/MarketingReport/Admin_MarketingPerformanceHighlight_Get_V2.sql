/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_MarketingPerformanceHighlight_Get_V2`(
    IN _MultiSiteRequest json, 
    IN _StartDate datetime, 
    IN _EndDate datetime
/*
  Created: 20241121@George.Phung
        DB: TSDB-TSDB
        Task: Marketing Performance Report
        Revisions:
                - 20241121@George.Phung: fix marketing report deposit user = 0 
*/
)
BEGIN
       
       
       DROP TEMPORARY TABLE IF EXISTS `TempMarketingPerformanceHighlight`;
       CREATE TEMPORARY TABLE TempMarketingPerformanceHighlight (
           SiteId INT NOT NULL,
           TotalUsers INT NOT NULL DEFAULT 0,
           TotalDepositUsers INT NOT NULL DEFAULT 0,
           DepositUsers INT NOT NULL DEFAULT 0,
           ActiveUsers INT NOT NULL DEFAULT 0,
           NRU INT NOT NULL DEFAULT 0,
           ActiveNRU INT NOT NULL DEFAULT 0,
           NoBetUsers INT NOT NULL DEFAULT 0,
           
           
           OutOfRangeUsers INT NOT NULL DEFAULT 0,
           PRIMARY KEY (SiteId)
    );        
        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, TotalUsers)
        SELECT C.SiteId, COUNT(1)
        FROM TSDB.Customer AS C
        INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
            ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
        GROUP BY C.SiteId
       ON DUPLICATE KEY UPDATE TotalUsers = VALUES(TotalUsers);

        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, TotalDepositUsers)
        SELECT DI.SiteId, COUNT(1)
        FROM DepositInfo AS DI
        INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
            ON DI.SiteId = SC.SiteId AND DI.CurrencyId = SC.CurrencyId
        WHERE Status = 3 
        and FirstDeposit = 1 
        and CreateTime IS NOT NULL
        GROUP BY DI.SiteId
        ON DUPLICATE KEY UPDATE TotalDepositUsers = VALUES(TotalDepositUsers);

        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, DepositUsers)
        SELECT PS.SiteId, COUNT(DISTINCT(CustId))
        FROM TSDB.PaymentSummary AS PS
                INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
            ON PS.SiteId = SC.SiteId AND PS.CurrencyId = SC.CurrencyId
        WHERE Time between _StartDate AND _EndDate
        and SummaryType = 1 
        and FirstDepositAmount > 0
        GROUP BY PS.SiteId
        ON DUPLICATE KEY UPDATE DepositUsers = VALUES(DepositUsers);

        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, ActiveUsers)
        SELECT TBRS.SiteId, COUNT(distinct(CustId))
        FROM TSDB.TpBetRecordSummary AS TBRS
                INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
            ON TBRS.SiteId = SC.SiteId AND TBRS.CurrencyId = SC.CurrencyId
        where Time between _StartDate and _EndDate
        GROUP BY TBRS.SiteId
        ON DUPLICATE KEY UPDATE ActiveUsers = VALUES(ActiveUsers);

        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, NRU)
        SELECT C.SiteId, COUNT(C.CustId)
        FROM Customer AS C
                INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
           ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
        WHERE C.RegTime BETWEEN _StartDate and _EndDate
        GROUP BY C.SiteId
        ON DUPLICATE KEY UPDATE NRU = VALUES(NRU);
        
        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, ActiveNRU)
        SELECT C.SiteId, COUNT(distinct(C.CustId))
        FROM Customer AS C
        INNER JOIN TSDB.TpBetRecordSummary AS TBRS ON TBRS.CustId = C.CustId AND TBRS.Time BETWEEN _StartDate and _EndDate
        INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
           ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
        WHERE C.RegTime BETWEEN _StartDate and _EndDate 
        GROUP BY C.SiteId
        ON DUPLICATE KEY UPDATE ActiveNRU = VALUES(ActiveNRU);

        
        
        

        
        
        
        
        
        
        
        
        
        INSERT INTO TempMarketingPerformanceHighlight (SiteId, OutOfRangeUsers)
        SELECT C.SiteId, COUNT(C.CustId)
        FROM Customer AS C
        INNER JOIN JSON_TABLE ( _MultiSiteRequest, '$[*]' COLUMNS
                                    ( SiteId     INT PATH "$.SiteId",
                                      CurrencyId INT PATH "$.CurrencyId")
                          ) AS SC
           ON C.SiteId = SC.SiteId AND C.CurrencyId = SC.CurrencyId
        WHERE C.RegTime > _EndDate
        GROUP BY C.SiteId
        ON DUPLICATE KEY UPDATE OutOfRangeUsers = VALUES(OutOfRangeUsers);  
        
        
        
    
        SELECT SiteId,
               TotalUsers,
               TotalDepositUsers,
               DepositUsers,
               ActiveUsers,
               NRU,
               ActiveNRU,
               NoBetUsers,
               ActiveUsers AS HasBetUsers,
               OutOfRangeUsers,
               (TotalUsers - OutOfRangeUsers) AS BasedOnReportTotalUsers
          FROM TempMarketingPerformanceHighlight; 
        
        DROP TEMPORARY TABLE IF EXISTS `TempMarketingPerformanceHighlight`;
END$$
DELIMITER ;