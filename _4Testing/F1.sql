/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS DBA_sp_Sync_General_Log;

DELIMITER $$

CREATE 
	DEFINER = 'vndba'@'%'
PROCEDURE DBA_sp_Sync_General_Log()
/*
  Created: 20241025@Sol
	DB: TSDB-MonDB
	Task: sync log data to custom table

	Revisions:
		- 20241024@Sol: Initialize SP [RedmineID: #000000]
*/
BEGIN

  -- insert data to new table
  INSERT INTO MonDB.s1_general_log(event_time,user_host,thread_id,server_id,command_type,argument)
  SELECT event_time,user_host,thread_id,server_id,command_type,argument 
  FROM mysql.general_log
  WHERE event_time > (SELECT IFNULL(MAX(event_time), '2024-10-20') FROM MonDB.s1_general_log);

  -- TRUNCATE table general_log
  TRUNCATE TABLE mysql.general_log;
   
END
$$

DELIMITER ;