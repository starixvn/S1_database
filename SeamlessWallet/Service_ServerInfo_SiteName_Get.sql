/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_ServerInfo_SiteName_Get`(
     IN _SiteName VARCHAR(50)
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
        ServerInfo.SiteId,
        ServerInfo.SiteName
    FROM
        ServerInfo
    WHERE
        ServerInfo.SiteName = _SiteName
    LIMIT 1;
	
	INSERT INTO SPLog (spname, starttime, endtime) VALUES ('Service_ServerInfo_SiteName_Get', @starttime, CURRENT_TIMESTAMP(6));
END$$
DELIMITER ;
