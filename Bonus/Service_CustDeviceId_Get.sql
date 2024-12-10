/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_CustDeviceId_Get`(
    IN _CustIds json,
    IN _SiteId int
/*
  Created: 20241120@Loki.nguyen
        DB: TSDB-TSDB
        Task: Bonus FPS
        Revisions:
                - 20241127@Loki.nguyen: Change data flow get from Shield to FPS
*/)

BEGIN
     IF(_SiteID = 1) THEN
        SELECT CI.DeviceId,
			   CI.CustId,
               C.UserName,
               CI.UpdateTime
        FROM CustIovation CI
        INNER JOIN Customer C on CI.CustId = C.CustId
        WHERE CI.CustId IN (SELECT * FROM JSON_TABLE(_CustIds, '$[*]' COLUMNS(CustId int PATH "$")) AS tmp)	
        AND CI.DeviceId <> '';
    ELSE
        SELECT CF.DeviceId,
			   CF.CustId,
               C.UserName,
               CF.UpdateTime
        FROM CustFPS CF
        INNER JOIN Customer C on CF.CustId = C.CustId
		WHERE CF.CustId IN (SELECT * FROM JSON_TABLE(_CustIds, '$[*]' COLUMNS(CustId int PATH "$")) AS tmp)	
        AND CF.DeviceId <> 'NA';
    END IF;
END$$
DELIMITER ;

