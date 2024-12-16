/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_Tag_Get_V3`(
	IN `Status` INT,
    IN PageSize INT,
    IN StartIndex INT,
    INOUT PageNumber INT,
    OUT TotalPages INT,
    OUT RowCount INT
/*
  Created: 20241211@Johnny
        DB: TSDB-TSDB
        Task: Get correct by status
        Revisions:
                - 20241205@Johnny: Init sp
*/)
BEGIN
    SET RowCount=0;
    IF PageNumber = 0 THEN
        SELECT
            T.Id,
            T.TagName,
            T.Description,
            T.TagColour,
            T.`Status`,
            T.UpdateTime,
            T.Updator
        FROM Tag AS T
        WHERE T.`Status` = IF(`Status`=2,T.`Status`,`Status`)
        ORDER BY T.UpdateTime DESC;
    ELSE
        SELECT SQL_CALC_FOUND_ROWS
            T.Id,
            T.TagName,
            T.Description,
            T.TagColour,
            T.`Status`,
            T.UpdateTime,
            T.Updator
        FROM Tag AS T
        WHERE T.`Status` = IF(`Status`=2,T.`Status`,`Status`)
        
        ORDER BY T.CreateTime DESC
        LIMIT StartIndex , PageSize;
        
        SET RowCount = FOUND_ROWS();
        IF RowCount = 0 THEN 
            SET TotalPages = 0;
        ELSE
            SET TotalPages = CEIL(RowCount/PageSize);        
        END IF;
    END IF;
END$$
DELIMITER ;






