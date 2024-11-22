/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
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
	 DROP TEMPORARY TABLE IF EXISTS Search_Table;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS Search_Table AS 
    (
        SELECT S.SiteId, S.CurrencyId, S.SlotGameId
        FROM SlotGameStatus AS S
        INNER JOIN SlotGame AS SG ON SG.Id = S.SlotGameId
        INNER JOIN TpCurrency AS TC ON S.CurrencyId = TC.CurrencyId AND  SG.TpId = TC.TpId
        WHERE S.SiteId = SiteId AND S.CurrencyId = CurrencyId 
        AND S.`Status`IN (SELECT * FROM JSON_TABLE(StatusJson, '$[*]' COLUMNS(`Status` INT PATH '$')) AS StatusList)
    );

    SELECT 
        SG.Id AS SlotGameId,
        SG.TpId,
        STL.TpName,
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
                GROUP_CONCAT(DISTINCT SD.CategoryId ORDER BY SD.CategoryId  SEPARATOR ','),
                ']'),'[]') AS SlotGameCategory 
    FROM
        SlotGame AS SG
            INNER JOIN
            Search_Table AS Search ON SG.Id = Search.SlotGameId        
            INNER JOIN
            GameCasinoInfo AS GCI ON SG.Id = GCI.GameCasinoId
            INNER JOIN 
            GameCasinoExtra AS GCE ON SG.Id = GCE.GameCasinoId 
            INNER JOIN 
            TpList AS TL ON SG.TpId = TL.Id
            LEFT JOIN 
            SlotGameDetail AS SD ON SG.Id = SD.SlotGameId 
            AND  SD.SiteId = Search.SiteId AND SD.CurrencyId = Search.CurrencyId AND SD.`Status` = 1
            LEFT JOIN
            SiteTpList AS STL ON SG.TpId = STL.TpId AND STL.SiteId = SiteId
    WHERE
            (STL.`Status` = 1 OR (STL.`Status` IS NULL AND TL.`Status` = 1))
      AND   SG.Device IN (0 , DeviceType)
    GROUP BY SlotGameId;
END$$
DELIMITER ;