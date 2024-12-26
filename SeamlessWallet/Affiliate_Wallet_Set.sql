/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Affiliate_Wallet_Set`(
    IN CustId INT,
    IN UserName VARCHAR(30) CHARACTER SET ASCII,
    IN SiteId INT,
    IN Amount DECIMAL(18, 2),
    IN TYPE SMALLINT,
    IN Memo VARCHAR(200),
    IN RefTransId VARCHAR(50),
    OUT AfterAmount DECIMAL(18, 4)
/*
  Created: 20241226@Luke
        DB: TSDB-TSDB
        Task: Fix SPs upsert
        Revisions:
                - 20241226@Luke: Fix SPs upsert
*/)
BEGIN
    
    

    SET AfterAmount = Amount;

    SELECT
        Amount + CustWallet.Balance
    INTO AfterAmount FROM
        CustWallet
    WHERE
        CustWallet.CustId = CustId
    FOR UPDATE;

    IF AfterAmount >= 0 AND CustId > 0 THEN
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
    END IF;
END$$
DELIMITER ;
