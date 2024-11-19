/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_LobbyGames_Get`(
    IN _SiteId INT,
    IN _CurrencyId INT,
    IN _LobbyCategoryIds NVARCHAR(20)
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
	SELECT  LHS.LobbyCategory AS LobbyCategoryId,
			LC.Name AS LobbyCategory,
			TGI.TpId,
			TGI.TpGameType,
			TGI.GameId,
			TL.TpName,
			LHS.TpGameIdNo,
            TPGI.CreateAt AS LaunchDate,
            TL.DisplayName AS DisplayText,
            TC.Name AS TpCategory,
			TGI.Name AS ProductName,
			LHS.CurrencyGameName,
			LHS.IconType,
			LHS.IconStartTime,
			LHS.IconEndTime,
			LHS.Sort,
			TGI.BetType
	FROM LobbyHeaderSetting AS LHS
	INNER JOIN TpGameId AS TGI ON TGI.No = LHS.TpGameIdNo
	INNER JOIN TpList AS TL ON TL.Id = TGI.TpId
	INNER JOIN LobbyCategory AS LC ON LC.Id = LHS.LobbyCategory
    INNER JOIN TpGameType AS TGT ON TGT.TpId = TL.Id
	INNER JOIN TpCategory AS TC ON TC.Id = TGT.CategoryId
    INNER JOIN TpGameIdInfo AS TPGI ON TPGI.TpGameIdNo = TGI.No
	WHERE LHS.SiteId = _SiteId
	  AND LHS.CurrencyId = _CurrencyId 
	  AND JSON_CONTAINS(TGI.LobbyCategoryIds, _LobbyCategoryIds);
END$$
DELIMITER ;