DELIMITER $$

CREATE EVENT Siebog.auto_gen_tables
ON SCHEDULE 
    EVERY 1 MONTH
    STARTS '2024-10-31 00-00-00'
DO
	/*
		2024-10-22@Luke: Initial
    */
BEGIN
    DECLARE __is_done INT DEFAULT FALSE;
    DECLARE __table_schema VARCHAR(20);
    DECLARE __table_name VARCHAR(100);
    DECLARE __table_definition TEXT;
    DECLARE __create_interval VARCHAR(20);
    
    DECLARE cur CURSOR FOR SELECT table_schema, table_name, table_definition, create_interval FROM Siebog.auto_gen_tablelist;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET __is_done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO __table_schema, __table_name, __table_definition, __create_interval;
        IF __is_done THEN
            LEAVE read_loop;
        END IF;

        IF __create_interval = 'Daily' THEN
            SET @date = LAST_DAY(CURRENT_DATE) + INTERVAL 1 DAY;
            WHILE @date <= LAST_DAY(CURRENT_DATE + INTERVAL 1 MONTH) DO
                SET @sql = REPLACE(__table_definition, '__table_name', CONCAT(__table_schema, '.', __table_name, DATE_FORMAT(@date, '_%Y%m%d')));
                PREPARE stmt FROM @sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;
                SET @date = @date + INTERVAL 1 DAY;
            END WHILE;
        ELSEIF __create_interval = 'Monthly' THEN
			SET @date = CURRENT_DATE + INTERVAL 1 MONTH;
            SET @auto_increment_start = CONCAT(DATE_FORMAT(CURRENT_DATE + INTERVAL 1 MONTH, '%Y%m'), '000000001');
            SET @sql = REPLACE(REPLACE(__table_definition, '__table_name', CONCAT(__table_schema, '.', __table_name, DATE_FORMAT(@date, '_%Y%m'))), '__auto_increment_start', @auto_increment_start);
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;

