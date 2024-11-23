/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$

CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_HeaderMenu_Get`(
    IN _SiteId INT,
    IN _CurrencyId INT,
    IN StatusJson JSON
    /*
  Created: 20241118@Brian.Nguyen
        DB: TSDB-TSDB
        Task: Get HeaderMenu 
        Revisions:
                - 20241122@Brian.Nguyen: Get HeaderMenu
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
                TGI.Name AS GameName,
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
        WHERE LHS.SiteId = _SiteId
          AND LHS.CurrencyId = _CurrencyId 
          AND LHS.Status IN (SELECT * FROM JSON_TABLE(StatusJson, '$[*]' COLUMNS(`Status` INT PATH '$')) AS StatusList);
END$$
DELIMITER ;