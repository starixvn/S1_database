/*<info serverAlias="TSDB-MonDB" databaseType="2"></info>*/
/*
  Created: 20241231@Luke
        DB: TSDB-MonDB
        Task: Job cleanup AuthToken
*/

CREATE INDEX ix_ExpiredTime ON TSDB.AuthToken(ExpiredTime);

DELIMITER $$
CREATE EVENT MonDB.auto_cleanup_AuthToken
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    SET @rows_affected = 1;
    SET @time_start = NOW();

    WHILE @rows_affected > 0 DO
        DELETE FROM TSDB.AuthToken
        WHERE ExpiredTime < @time_start
        LIMIT 5000;

        SET @rows_affected = ROW_COUNT(); 
    END WHILE;
END;
$$
DELIMITER ;