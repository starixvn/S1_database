/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS 'Siebog'.'PlayerWinLoss_Get';

DELIMITER //

CREATE DEFINER=`dbo`@`%` PROCEDURE `Siebog`.`PlayerWinLoss_Get`
(
  IN StartTime datetime,
  IN EndTime datetime,
  IN TimeZone varchar(30),
  IN ReferenceIds JSON
)
BEGIN
  WITH LicenseeIds AS 
      (
    SELECT s.SiteId, s.ReferenceID
    FROM ServerInfo s
    WHERE
      JSON_LENGTH(ReferenceIds) > 0 AND EXISTS
        (SELECT 1 FROM JSON_TABLE(ReferenceIds, '$[*]' COLUMNS(refId INT PATH '$')) AS jt WHERE jt.refId = s.ReferenceID)
              OR JSON_LENGTH(ReferenceIds) = 0 AND s.ReferenceID IS NOT NULL
      )
  SELECT 
    tbr.SiteId,
    tl.DisplayName,
    tgt.TypeName,
    tbr.GameType,
    sum(tbr.WinlostAmount) AS WinLoss,
    DATE(CONVERT_TZ(tbr.SettledTime , '+00:00', TimeZone)) AS Date,
          ls.ReferenceID
  FROM TpBetRecord tbr 
      INNER JOIN LicenseeIds ls ON tbr.SiteId = ls.SiteId
  LEFT JOIN TpList tl ON tbr.TpId = tl.Id 
  LEFT JOIN TpGameType tgt ON tbr.GameType = tgt.Type 
  WHERE tbr.SettlementType != 0 AND tbr.TicketStatus != 0
    AND tbr.SettledTime >= StartTime
    AND tbr.SettledTime < EndTime
  GROUP BY tbr.SiteId, tl.DisplayName, tgt.TypeName, tbr.GameType, Date, ls.ReferenceID;
END 
//

DELIMITER ;