DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_SlotGame_Get`(
    IN SiteId INT,
    IN CurrencyId INT,
    IN DeviceType INT,
    IN StatusJson JSON
 
    /*
  Created: 20241122@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Get SlotGame 
        Revisions:
                - 20241122@Brian.Nguyen: Get SlotGame
*/
)
 
BEGIN
	 SELECT 
		SG.Id AS SlotGameId,
        TL.DisplayName AS TpName,
		SG.TpId,
		SG.TypeId,
		SG.GameId,
		SG.AppId,
		CONVERT_TZ(SG.CreateAt, @@session.time_zone, '+00:00') AS LaunchDate,        
		GCE.Reel AS Reels,
		GCE.RTP,
		GCE.PayLine AS Paylines,
		IF(TL.Fun = 0, FALSE, IF(SG.Fun = 1, TRUE, FALSE)) AS PlayFree,
		CONCAT('{',
				GROUP_CONCAT('"', GCI.lang, '": "', GCI.`name`, '"'),
				'}') AS `Name`,
		IFNULL(
		CONCAT('[',
				GROUP_CONCAT(DISTINCT SD.CategoryId ORDER BY SD.CategoryId SEPARATOR ','),
				']'),'[]') AS SlotGameCategory 
	FROM
		SlotGame AS SG
	INNER JOIN
		SlotGameStatus AS S ON SG.Id = S.SlotGameId
	INNER JOIN
		TpCurrency AS TC ON S.CurrencyId = TC.CurrencyId AND SG.TpId = TC.TpId
	INNER JOIN
		GameCasinoInfo AS GCI ON SG.Id = GCI.GameCasinoId
	INNER JOIN 
		GameCasinoExtra AS GCE ON SG.Id = GCE.GameCasinoId 
	INNER JOIN 
		TpList AS TL ON SG.TpId = TL.Id
	LEFT JOIN 
		SlotGameDetail AS SD ON SG.Id = SD.SlotGameId 
	 AND SD.SiteId = SiteId 
	 AND SD.CurrencyId = CurrencyId 
	 AND SD.`Status` = 1
	LEFT JOIN
		SiteTpList AS STL ON SG.TpId = STL.TpId AND STL.SiteId = SiteId
	WHERE
		S.SiteId = SiteId
		AND S.CurrencyId = CurrencyId 
		AND EXISTS (SELECT 1 FROM JSON_TABLE(StatusJson, '$[*]' COLUMNS(`Status` INT PATH '$')) AS StatusList WHERE StatusList.`Status` = S.`Status`)
		AND (STL.`Status` = 1 OR (STL.`Status` IS NULL AND TL.`Status` = 1))
		AND SG.Device IN (0, DeviceType)
	GROUP BY 
		SG.Id;
END$$
DELIMITER ;