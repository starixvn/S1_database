DELIMITER $$

CREATE EVENT TSDB.auto_gen_tables
ON SCHEDULE 
    EVERY 1 MONTH
    STARTS '2024-11-30 00:00:01'
DO
	/*
		2024-10-22@Luke: Initial
    */
BEGIN
    DECLARE __is_done INT DEFAULT FALSE;
    DECLARE __table_schema VARCHAR(20);
    DECLARE __table_name VARCHAR(100);
    DECLARE __create_interval VARCHAR(20);
    DECLARE __adjust_increment_start BOOLEAN;
    
    DECLARE cur CURSOR FOR SELECT table_schema, table_name, create_interval, adjust_increment_start FROM TSDB.auto_gen_tablelist;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET __is_done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO __table_schema, __table_name, __create_interval, __adjust_increment_start;
        IF __is_done THEN
            LEAVE read_loop;
        END IF;

        IF __create_interval = 'Daily' THEN
            SET @date = LAST_DAY(CURRENT_DATE) + INTERVAL 1 DAY;
            SET @table_schema = __table_schema;
            SET @base_table = CONCAT(__table_name, DATE_FORMAT(CURRENT_DATE, '_%Y%m%d'));
            WHILE @date <= LAST_DAY(CURRENT_DATE + INTERVAL 1 MONTH) DO
				SET @new_table = CONCAT(__table_name, DATE_FORMAT(@date, '_%Y%m%d'));
                
                IF NOT EXISTS (
					SELECT 1
                    FROM information_schema.tables
                    WHERE table_name = @new_table
						AND table_schema = @table_schema
                ) THEN
					SET @sql = CONCAT('CREATE TABLE ', @table_schema, '.', @new_table, ' LIKE ', @table_schema, '.', @base_table, ';');
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
				END IF;
                
                SET @date = @date + INTERVAL 1 DAY;
            END WHILE;
        ELSEIF __create_interval = 'Monthly' THEN
			SET @date = CURRENT_DATE + INTERVAL 1 MONTH;
            SET @table_schema = __table_schema;
            SET @base_table = CONCAT(__table_name, DATE_FORMAT(CURRENT_DATE, '_%Y%m'));
            SET @new_table = CONCAT(__table_name, DATE_FORMAT(@date, '_%Y%m'));
			IF NOT EXISTS (
				SELECT 1
				FROM information_schema.tables
				WHERE table_name = @new_table
					AND table_schema = @table_schema
			) THEN
				SET @sql = CONCAT('CREATE TABLE ', @table_schema, '.', @new_table, ' LIKE ', @table_schema, '.', @base_table, ';');
				PREPARE stmt FROM @sql;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;
	
				IF __adjust_increment_start = 1 THEN
					SET @auto_increment_start = CONCAT(DATE_FORMAT(@date, '%Y%m'), '000000001');
					SET @sql = CONCAT('ALTER TABLE ', __table_schema, '.', @new_table, ' AUTO_INCREMENT = ', @auto_increment_start, ';');	
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;                
				END IF;
			END IF;
        END IF;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;



