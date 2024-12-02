/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_CustRecentlyViewed_Get`(
    IN _CustId INT
/*
  Created: 20241202@Luke
	DB: TSDB-TSDB
	Task: test deploy

	Revisions:
		- 20241202@Luke: test deploy
*/    
)
BEGIN
        
    

        SELECT
                *
        FROM
                CustRecentlyViewed 
        WHERE 
                CustId = _CustId
        ORDER BY 
                UpdateTime DESC
        LIMIT 15;

END$$
DELIMITER ;
