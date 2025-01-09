/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_PagedWhiteListIP_Get`(
	IN KeyWord varchar(500),
	IN StartDate datetime,
	IN EndDate datetime,
	IN StartIndex int,
	IN PageSize int,
	OUT TotalPages int,
	OUT RowCount int
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: get IP
        Revisions:
                - 20250109@Kathy: Get IP
*/
)
BEGIN

	SET RowCount = 0;

    SELECT SQL_CALC_FOUND_ROWS
			w.SQ,
            w.IPFrom,
			w.IPTo,
			w.Memo,
            w.CreateTime,
            w.UpdateOperator
        FROM
            WhitelistIP AS w
        WHERE
            (w.IPFrom LIKE CONCAT ('%', KeyWord, '%') 
				OR w.IPTo LIKE CONCAT ('%', KeyWord, '%') 
				OR w.Memo LIKE CONCAT ('%', KeyWord, '%')
			)
            AND w.CreateTime BETWEEN StartDate AND EndDate
        LIMIT StartIndex , PageSize;

    SET RowCount = FOUND_ROWS();
    IF RowCount = 0 THEN
        SET TotalPages = 0;
    ELSE
        SET TotalPages = CEIL(RowCount/PageSize);
    END IF;
	
END$$
DELIMITER ;
