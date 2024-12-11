/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_LobbyGames_Get`(
    IN _SiteId INT,
    IN _CurrencyId INT,
    IN _LobbyCategoryIds NVARCHAR(20),
    IN _LangId NVARCHAR(20)
    /*
  Created: 20241118@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Get LobbyGames 
        Revisions:
                - 20241118@Brian.Nguyen: Get LobbyGames
                - 20241119@Brian.Nguyen: Get LaunchDate Lobby Games
*/
)

BEGIN
	SELECT  LC.Id AS LobbyCategoryId,
			LC.Name AS LobbyCategory,
			TGI.TpId,
			TGI.TpGameType,
			TGI.GameId,
			TL.TpName,
			TPGI.TpGameIdNo,
            TPGI.CreateAt AS LaunchDate,
            TL.DisplayName AS DisplayText,
            TC.Name AS TpCategory,
			TPGI.Name AS GameName,			
			TGI.BetType
	FROM TpGameId AS TGI 
    INNER JOIN TpGameIdInfo AS TPGI ON TPGI.TpGameIdNo = TGI.No
	INNER JOIN TpList AS TL ON TL.Id = TGI.TpId
	INNER JOIN LobbyCategory AS LC ON LC.Id = TGI.ImgLobbyCategoryId
    INNER JOIN TpGameType AS TGT ON TGT.TpId = TL.Id AND TGT.Type = TGI.TpGameType
	INNER JOIN TpCategory AS TC ON TC.Id = TGT.CategoryId
    INNER JOIN TpGameTypeCurrency AS TGTC ON TGTC.TpGameType = TGI.TpGameType    
	WHERE TPGI.Lang = _LangId
	  AND JSON_CONTAINS(TGI.LobbyCategoryIds, _LobbyCategoryIds)
      AND TGTC.SiteId = _SiteId
      AND TGTC.CurrencyId = _CurrencyId
	  AND TGI.Status > 0
	ORDER BY  
	  TPGI.CreateAt DESC ,TGI.GameId DESC;
END$$
DELIMITER ;