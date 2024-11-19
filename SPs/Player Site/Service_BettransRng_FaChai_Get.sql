CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BettransRng_FaChai_Get`(
    IN YYYYMM varchar(6), 
    IN TransId VARCHAR(200)
/*
  Created: 20241031@Luke
	DB: TSDB-TSDB
	Task: Get FaChai bet ticket info from TicketNo

	Revisions:
		- 20241031@Luke: Initial
        - 20241119@Los: Initial
*/
)
BEGIN
    SET @TicketNo = TransId ;
    SET @CMD = CONCAT("Select FC.`SQ`,
						FC.`TicketType`,
						FC.`RecordID`, 
						FC.`MemberAccount`, 
						FC.`TicketStatus`, 
						IF(FC.`TicketType` = 4, ABS(FC.`ValidBet`), 0) AS Bet, 
						FC.`Win` - ABS(FC.`Bet`) AS Win, 
						FC.`Ts`, 
						FC.`GameID`, 
						FC.`ValidBet`
          FROM BettransRng_FaChai_", YYYYMM, " AS FC  WHERE  FC.`TicketNo` = ? ") ;
    PREPARE stmt FROM @CMD;
    EXECUTE stmt USING @TicketNo;
    DEALLOCATE PREPARE stmt;
END