/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Balance_Get`(
	IN CustId INT,
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
	
	SELECT IFNULL(Balance, 0) AS Balance
	FROM Customer AS CT LEFT OUTER JOIN
	CustWallet AS CW ON CT.CustId = CW.CustId
	WHERE CT.CustId = CustId;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Balance_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
