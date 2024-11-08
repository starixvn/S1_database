/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER='dbo'@'%' PROCEDURE TSDB.Column_MaxLength_Get(
    IN __table_name VARCHAR(200),
    IN __column_name VARCHAR(200)
 /*
  Created: 20241108@Luke
	DB: TSDB-TSDB
	Task: get column maxlength

	Revisions:
		- 20241108@Luke: get column maxlength
*/       
)
BEGIN
	SELECT IFNULL(CHARACTER_MAXIMUM_LENGTH, 0) AS MaxLength
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'TSDB'
		AND TABLE_NAME = __table_name
        AND COLUMN_NAME = __column_name
	LIMIT 1;
END
$$
DELIMITER ;

