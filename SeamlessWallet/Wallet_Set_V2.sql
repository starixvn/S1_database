/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Wallet_Set_V2`(
    IN CustId INT,
    IN UserName VARCHAR(30) CHARACTER SET ASCII,
    IN SiteId INT,
    IN Amount DECIMAL(18, 4),
    IN TYPE SMALLINT, 
    IN Memo VARCHAR(200),
    IN RefTransId VARCHAR(100),
    OUT Is1stDepoist TINYINT,
    OUT AfterAmount DECIMAL(18, 4),
    IN GUID VARCHAR(50)
/*
  Created: 20241226@Luke
        DB: TSDB-TSDB
        Task: Add DEALLOCATE stmt for non-standard SPs
        Revisions:
                - 20241226@Luke: Add DEALLOCATE stmt for non-standard SPs
*/)
BEGIN
    
    SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET AfterAmount = Amount;
    SET Is1stDepoist = FALSE;
    SELECT Amount + CustWallet.Balance INTO AfterAmount FROM CustWallet WHERE CustWallet.CustId=CustId FOR UPDATE;
    SELECT TRUE INTO Is1stDepoist FROM Customer WHERE Customer.CustId=CustId AND Customer.ActStatus=1 FOR UPDATE;


    IF (Amount > 0 OR AfterAmount >= 0) AND CustId > 0 THEN
        SET @Direction = 2;

        IF Amount > 0 THEN
            SET @Direction = 1;
        END IF;

        SELECT NOW() INTO @Time;

        
        
        
        CALL FinancialLog_Ins(CustId, UserName, SiteId,`Type`, @Direction, ABS(Amount), AfterAmount - Amount, AfterAmount, Memo, RefTransId);
        
        UPDATE Customer AS C SET C.LastFinancialTime = @Time WHERE C.CustId = CustId;

        IF EXISTS(SELECT 1 FROM CustWallet cw WHERE cw.CustId = CustId) THEN
			UPDATE CustWallet cw SET cw.Balance = AfterAmount WHERE cw.CustId = CustId;
		ELSE
			INSERT INTO CustWallet(CustId, SiteId, Balance) VALUE(CustId, SiteId, AfterAmount);
        END IF;

         IF `TYPE` BETWEEN 101 AND 2000 OR `TYPE` IN (1, 2, 3) THEN
            INSERT INTO CustTransSummary
            (CustId,
            Site,
            DepositSum,
            DepositCnt,
            WithdrawlSum,
            WithdrawlCnt)
            VALUES
            (CustId,
            SiteId,
            IF(`TYPE` BETWEEN 1 AND 1000, Amount, 0),
            IF(`TYPE` BETWEEN 1 AND 1000, 1, 0),
            IF(`TYPE` BETWEEN 1001 AND 2000, IF(`TYPE` BETWEEN 1002 AND 1003 , ABS(Amount) * -1, ABS(Amount)), 0),
            IF(`TYPE` BETWEEN 1001 AND 2000, IF(`TYPE` BETWEEN 1002 AND 1003 , 0, 1), 0))

            ON DUPLICATE KEY
            UPDATE CustTransSummary.DepositSum = IF(`TYPE` BETWEEN 1 AND 1000, CustTransSummary.DepositSum + Amount, CustTransSummary.DepositSum),
            CustTransSummary.DepositCnt = IF(`TYPE` BETWEEN 1 AND 1000, CustTransSummary.DepositCnt + 1, CustTransSummary.DepositCnt),
            CustTransSummary.WithdrawlSum = IF(`TYPE` BETWEEN 1001 AND 2000, CustTransSummary.WithdrawlSum + IF(`TYPE` BETWEEN 1002 AND 1003 , ABS(Amount) * -1, ABS(Amount)), CustTransSummary.WithdrawlSum),
            CustTransSummary.WithdrawlCnt = IF(`TYPE` BETWEEN 1001 AND 2000, CustTransSummary.WithdrawlCnt + IF(`TYPE` BETWEEN 1002 AND 1003 , -1, 1), CustTransSummary.WithdrawlCnt);
        END IF;

        IF Is1stDepoist AND (`TYPE` BETWEEN 101 AND 1000 OR `TYPE` = 1) THEN
            UPDATE Customer SET Customer.ActStatus = 2 WHERE Customer.CustId = CustId AND Customer.ActStatus = 1;
        END IF;
    END IF;
	
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Wallet_Set_V2', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
