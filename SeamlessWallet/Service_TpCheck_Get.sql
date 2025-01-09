/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpCheck_Get`(
	IN TpId INT,
	IN TpUserName VARCHAR(50) CHARACTER SET ASCII,
	IN GUID VARCHAR(50)
/*
  Created: 
	DB: TSDB-TSDB
	Task: 

	Revisions:
		- 20250109@Kathy: write log
*/
)
BEGIN
	SET @starttime = CURRENT_TIMESTAMP(6);
	
	SELECT 
		C.`Status` AS CustStatus,
        IFNULL(STL.`Status`, TL.`Status`) AS TpStatus,
        TCI.`Status` AS TpCustStatus,
        OU.IP,
        OU.Token
	FROM
		TpList AS TL
			INNER JOIN    
		TpCustInfo AS TCI ON TL.Id = TCI.TpId
			INNER JOIN
		Customer AS C ON C.CustId = TCI.CustId
			INNER JOIN
		OnUser AS OU ON C.CustId = OU.CustId
			LEFT OUTER JOIN
        SiteTpList AS STL ON C.SiteId = STL.SiteId AND TL.Id = STL.TpId
	WHERE
		TCI.TpId = TpId
			AND TCI.TpUserName = TpUserName;
			
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_TpCheck_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
