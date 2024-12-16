CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_BettingMonitorSetting_Get`(
    IN _SiteId INT,
    IN _CurrencyIds JSON,
    IN _TpIds JSON,
    IN _CategoryIds JSON,
    IN _GameTypes JSON,
    IN _StartIndex INT,
    IN _PageSize INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
)
BEGIN

		SELECT SQL_CALC_FOUND_ROWS
			TBMS.SiteId,
			TBMS.CurrencyId,
			C.IsoCode AS Currency,
			TBMS.TpId,
            TL.TpName,
			TGT.CategoryId,
			TC.Name AS CategoryName, 
			TBMS.GameType,
			TGT.TypeName AS GameTypeName,
			TBMS.Frequency,
			TBMS.Status,
			TBMS.LastUpdateUser,
			TBMS.LastUpdateTime
		FROM
			TpBettingMonitorSetting AS TBMS
		INNER JOIN 
			TpGameType AS TGT ON TGT.TpId = TBMS.TpId AND TGT.Type = TBMS.GameType
		INNER JOIN 
			TpCategory AS TC ON TC.Id = TGT.CategoryId
		INNER JOIN 
			Currency AS C ON C.CurrencyId = TBMS.CurrencyId
        INNER JOIN
            TpList AS TL ON TBMS.TpId = TL.Id    
		WHERE TBMS.SiteId = _SiteId 
		  AND TBMS.CurrencyId IN (SELECT * FROM JSON_TABLE(_CurrencyIds, '$[*]' COLUMNS(`CurrencyId` INT PATH "$")) AS CurrencyIdList)
          AND TGT.CategoryId IN (SELECT * FROM JSON_TABLE(_CategoryIds, '$[*]' COLUMNS(`CategoryId` INT PATH "$")) AS CategoryIdList)
		  AND TBMS.TpId IN (SELECT * FROM JSON_TABLE(_TpIds, '$[*]' COLUMNS(`TpId` INT PATH "$")) AS TpIdList)
		  AND TBMS.GameType IN (SELECT * FROM JSON_TABLE(_GameTypes, '$[*]' COLUMNS(`GameType` INT PATH "$")) AS GameTypeList)
		ORDER BY TBMS.CurrencyId ASC
		LIMIT _StartIndex , _PageSize;
          
		SET _RowCount = FOUND_ROWS();
		IF _RowCount = 0 THEN 
			SET _TotalPages = 0;
		ELSE
			SET _TotalPages = CEIL(_RowCount/_PageSize);
		END IF;
    
END