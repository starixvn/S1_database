/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Common_AuthToken_Ins`(
	IN Token varchar(30), 
	IN PermissionData json, 
	IN Expiry int,
	IN GUID VARCHAR(50)
/*
  Created: 20241225@Luke
        DB: TSDB-TSDB
        Task: Remove Delete block
        Revisions:
                - 20241225@Luke: Remove Delete block
*/
)
BEGIN
    SET @starttime = CURRENT_TIMESTAMP(6);
	/*
    SELECT NOW() INTO @Time;
    
    DELETE FROM TSDB.AuthToken 
    WHERE
        AuthToken.ExpiredTime < @Time;
	*/
    
    INSERT INTO AuthToken (Token, PermissionData, ExpiredTime)
    VALUES(Token, PermissionData, DATE_ADD(NOW(), INTERVAL Expiry MINUTE));
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Common_AuthToken_Ins', @starttime, CURRENT_TIMESTAMP(6), GUID);
    
END$$
DELIMITER ;
