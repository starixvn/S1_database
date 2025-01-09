/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_CustBonus_Get`(
    IN CustId INT,
    IN GameType INT,
	IN GUID VARCHAR(50)
/*
  Created: 
	DB: TSDB-Siebog
	Task: 

	Revisions:
		- 20250109@Kathy: write log
*/
)
BEGIN
    SET @starttime = CURRENT_TIMESTAMP(6);
        
    SELECT 
        C.BonusId,
        IFNULL(C.Bonus, 0) AS Bonus,
        C.PromoCategoryId AS PromoCategoryId
    FROM CustBonus AS C
    INNER JOIN PromotionCategoryGameType AS P
    ON C.PromoCategoryId = P.PromotionCategoryId AND P.GameType = GameType
    WHERE
        C.CustId = CustId
        AND C.`Status` IN (0, 1)
        AND C.Bonus > 0;
           
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_CustBonus_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
