/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_Favorite_Set`(
	IN CustId int,
    IN IsRemove bool,
    IN GameInfo varchar(50)
 
    /*
  Created: 20241209@Brian.Nguyen
        DB: TSDB-TSDB
        Task: set game Favorite 
        Revisions:
                - 20241122@Brian.Nguyen: set game Favorite
                - 20241216@Brian.Nguyen: remove Siebog
*/
)
 
BEGIN
	IF IsRemove THEN
		SET @JSONLength = -1;
        SELECT 
			JSON_LENGTH(Favorite)
		INTO 
			@JSONLength
		FROM 
			CustFavorite
        WHERE
			CustFavorite.CustId = CustId AND json_search(Favorite, 'one', GameInfo) IS NOT NULL;
		
		IF @JSONLength = 1 THEN
			DELETE FROM CustFavorite WHERE CustFavorite.CustId = CustId;
		ELSEIF @JSONLength >= 2 THEN 
			UPDATE CustFavorite
			SET Favorite = JSON_REMOVE(Favorite, replace(json_search(Favorite, 'one', GameInfo), '"', ''))
			WHERE 
				CustFavorite.CustId = CustId 
				AND json_search(Favorite, 'one', GameInfo) IS NOT NULL
			;
		END IF;
    ELSE
		INSERT INTO 
			CustFavorite(CustId, Favorite) 
		VALUES(CustId, CONCAT('["', GameInfo, '"]'))
        ON DUPLICATE KEY UPDATE
			CustFavorite.Favorite = IF(JSON_SEARCH(Favorite, 'one', GameInfo) IS NULL, JSON_MERGE_PRESERVE(IFNULL(Favorite,'[]'), CONCAT('["', GameInfo, '"]')), CustFavorite.Favorite)
        ;
    END IF;
END$$
DELIMITER ;