/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS Member_TpList_GetByCategory;

DELIMITER $$

CREATE 
	DEFINER = 'dbo'@'%'
PROCEDURE Member_TpList_GetByCategory(
    IN CurrencyId Tinyint,
    IN SiteId INT,
    IN TpCategoryId Tinyint
/*
  Created: 20241216@Kathy
	DB: TSDB-TSDB
	Task: get vendor

	Revisions:
		- 20241216@Kathy: get vendor
*/
)
BEGIN
    IF CurrencyId = 0 THEN
        SELECT DISTINCT
            tp.Id AS TpId,
            tp.TpName AS TpName,
            IF(tp.Fun = 1, TRUE, FALSE) AS PlayFree,
            DisplayName AS DisplayText,
            t.`Type` AS TpGameType
        FROM
            TpList AS  tp
            INNER JOIN TpGameType AS t ON  tp.Id = t.TpId
            LEFT OUTER JOIN
            SiteTpList AS st ON tp.Id = st.TpId AND st.SiteId = SiteId
        WHERE
            (st.`Status` = 1 OR (st.`Status` IS NULL AND tp.`Status` = 1))
            AND t.CategoryId = TpCategoryId
        ;
    ELSE
        SELECT DISTINCT
            tp.Id AS TpId,
            tp.TpName AS TpName,
            IF(tp.Fun = 1, TRUE, FALSE) AS PlayFree,
            DisplayName AS DisplayText,
            t.`Type` AS TpGameType
        FROM
            TpList AS  tp
            INNER JOIN TpGameType AS t ON tp.Id = t.TpId 
            INNER JOIN TpCurrency AS c ON tp.Id = c.TpId
            LEFT OUTER JOIN
            SiteTpList AS st ON tp.Id = st.TpId AND st.SiteId IS NULL
        WHERE
            (st.`Status` = 1 OR (st.`Status` IS NULL AND tp.`Status` = 1))
            AND t.CategoryId = TpCategoryId
            AND c.CurrencyId = CurrencyId
       
       UNION
        SELECT DISTINCT
            tl.Id AS TpId,
            tl.TpName AS TpName,
            IF(tl.Fun = 1, TRUE, FALSE) AS PlayFree,
            tl.DisplayName AS DisplayText,
            t.`Type` AS TpGameType
        FROM (
          SELECT tl.Id, tl.TpName, tl.Fun, tl.DisplayName, tl.Status
          FROM TpList tl 
          WHERE NOT EXISTS (SELECT DISTINCT tgt.TpId FROM TpGameType tgt WHERE tgt.TpId = tl.Id AND tgt.CategoryId = TpCategoryId)
        ) tl
        INNER JOIN TpGameType AS t 
          ON tl.Id = t.TpId 
        INNER JOIN TpCurrency tc 
          ON tl.Id = tc.TpId
        INNER JOIN (
          SELECT DISTINCT sg.TpId
          FROM SlotGame sg
          WHERE sg.CategoryId = TpCategoryId
        ) sg 
          ON tl.Id = sg.TpId
         WHERE tl.Status = 1
            AND tc.CurrencyId = CurrencyId ;

    END IF
    ;
END
$$

DELIMITER ;