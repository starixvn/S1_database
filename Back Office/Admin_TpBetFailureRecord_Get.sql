/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_TpBetFailureRecord_Get`( 
    IN _SiteId INT,
    IN _TpId INT, 
    IN _FromTransTime DATETIME,
    IN _ToTransTime DATETIME,
    IN _UserName VARCHAR(30),
    IN _TransId VARCHAR(64),
    IN _PageSize INT,
    IN _StartIndex INT,
    OUT _TotalPages INT,
    OUT _RowCount INT
/*
  Created: 20241219@Luke
        DB: TSDB-TSDB
        Task: Add DEALLOCATE stmt for non-standard SPs
        Revisions:
                - 20241219@Luke: Add DEALLOCATE stmt for non-standard SPs
*/)
BEGIN
    
    
    
    SET _RowCount = 0;
    SET @TpIdCondition = "";
    SET @SiteCondition = "";
    SET @UserCondition = "";
    SET @TransCondition = "";
    
    IF _TpId > 0 THEN
        SET @TpIdCondition = CONCAT(" AND TpBetFailureRecord.TpId = '",_TpId,"'");
    END IF;
    
    IF _SiteId > 0 THEN
        SET @SiteCondition = CONCAT(" AND TpBetFailureRecord.SiteId = '",_SiteId,"'");
    END IF;
    
    IF _UserName IS NOT NULL AND _UserName != '' THEN
        SET @UserCondition = CONCAT(" AND TpBetFailureRecord.UserName = '",_UserName,"'");
    END IF;
    
    IF _TransId IS NOT NULL AND _TransId != '' THEN
        SET @TransCondition = CONCAT(" AND TpBetFailureRecord.TransId = '",_TransId,"'");
    END IF;

    SET @cmd = CONCAT("
        SELECT SQL_CALC_FOUND_ROWS
            TpBetFailureRecord.Id,
            TpBetFailureRecord.SiteId,
            ServerInfo.SiteName,
            TpBetFailureRecord.TpId,
            TpList.TpName,
            TpBetFailureRecord.UserName,
            TpBetFailureRecord.TransId,
            TpBetFailureRecord.TransTime,
            TpBetFailureRecord.Info
        FROM 
            TpBetFailureRecord
                INNER JOIN
            ServerInfo ON ServerInfo.SiteId = TpBetFailureRecord.SiteId
                LEFT JOIN
            TpList ON TpBetFailureRecord.TpId = TpList.Id
        WHERE
            TpBetFailureRecord.TransTime BETWEEN '",_FromTransTime,"' AND '",_ToTransTime,"'
        ",@TpIdCondition,"
        ",@SiteCondition,"
        ",@UserCondition,"
        ",@TransCondition,"
        ORDER BY TpBetFailureRecord.TransTime DESC, TpBetFailureRecord.Id 
        LIMIT ",_StartIndex,",",_PageSize,";
    ");

    PREPARE stmt FROM @cmd;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    
    SELECT FOUND_ROWS() INTO _RowCount;
    IF _RowCount = 0 THEN 
        SET _TotalPages = 0;
    ELSE
        SET _TotalPages = CEIL(_RowCount / _PageSize);
    END IF;
END$$
DELIMITER ;
