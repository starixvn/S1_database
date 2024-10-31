/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_FaChai_Get`(
    IN YYYYMM varchar(6), 
    IN TransId VARCHAR(64)
/*
  Created: 20241031@Luke
	DB: TSDB-TSDB
	Task: Cancel FaChai bet ticket

	Revisions:
		- 20241031@Luke: Initial
*/
)
BEGIN
    SET @RecordID = TransId ;
    SET @CMD = CONCAT("Select FC.`SQ`, FC.`RecordID`, FC.`MemberAccount`, FC.`TicketStatus`, FC.`Currency`, FC.`Bet`, FC.`Win`, FC.`NetWin`, FC.`Ts`, FC.`GameID`
          FROM BettransRng_FaChai_", YYYYMM, " AS FC  WHERE  FC.`RecordID` = ? ") ;
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @RecordID;
    DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;

