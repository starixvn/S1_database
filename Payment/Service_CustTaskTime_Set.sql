/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
    DELIMITER $$
 
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_CustTaskTime_Set`(
	IN _CustId INT,
    IN _TaskId INT,
    IN _TaskTime DATETIME
/*
  Created: 20241119@Liam
        DB: TSDB-TSDB
        Task: correct logic sp
         Revisions:
                - 20241119@Liam: correct logic sp
*/ 
)
BEGIN
	INSERT INTO CustTaskTime (CustId, TaskId, TaskTime)
    	VALUES(_CustId,_TaskId,_TaskTime);
END$$
DELIMITER ;