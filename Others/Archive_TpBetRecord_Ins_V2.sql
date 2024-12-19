/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Archive_TpBetRecord_Ins_V2`(
    IN TpId INT,
    IN TransId VARCHAR(100),
    IN GameType INT,
    IN CustId INT,
    IN UserName VARCHAR(30),
    IN CurrencyId INT,
    IN SiteId INT,
    IN TpUserName VARCHAR(50),
    IN TransTime DateTime ,
    IN SettledTime DateTime ,
    IN Stake decimal(20,6),
    IN ValidBet decimal(20,6),
    IN Revenue decimal(20,6),
    IN WinlostAmount decimal(20,6),
    IN SettlementType INT,
    IN TicketStatus INT,
    IN OriginalState VARCHAR(10),
    IN TicketKey BIGINT,
    IN BonusId INT,
    IN GameID VARCHAR(50),
    IN CreateTime DateTime,
    IN ProgressiveBet DECIMAL(20,6),
    IN ProgressiveWin DECIMAL(20,6),
    IN UpdateBonus BIT,
    IN UpdateTime DateTime
/*
  Created: 20241219@Luke
        DB: TSDB-TSDB
        Task: Add DEALLOCATE stmt for non-standard SPs
        Revisions:
                - 20241219@Luke: Add DEALLOCATE stmt for non-standard SPs
*/)
BEGIN      
        
        
        SET @TpId=TpId;
        SET @TransId=TransId;
        SET @GameType=GameType;
        SET @CustId=CustId;
        SET @UserName=UserName;
        SET @CurrencyId=CurrencyId;
        SET @SiteId=SiteId;
        SET @TpUserName=TpUserName;
        SET @TransTime = TransTime;
        SET @SettledTime = SettledTime;    
        SET @Stake=Stake;
        SET @ValidBet=ValidBet;
        SET @Revenue=Revenue;
        SET @WinlostAmount=WinlostAmount;    
        SET @SettlementType=SettlementType;
        SET @TicketStatus=TicketStatus;
        SET @OriginalState=OriginalState;
        SET @TicketKey=TicketKey;
        SET @BonusId=BonusId;
        SET @GameID=GameID;
        SET @CreateTime =CreateTime;
        SET @ProgressiveBet=ProgressiveBet;
        SET @ProgressiveWin=ProgressiveWin;
        SET @UpdateBonus = UpdateBonus;
        SET @UpdateTime = UpdateTime;
        
        SET @SettledTableName = concat("TpBetRecord_", DATE_FORMAT(@SettledTime, '%Y%m')); 
        
        IF (MONTH(@SettledTime) != MONTH(NOW())) THEN 
            SET @Exist = NULL;
            SET @CheckCmd = concat("SELECT 1 INTO @Exist FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'TSDB' AND TABLE_NAME=? ;");
            PREPARE checkcmd FROM @CheckCmd;
            EXECUTE checkcmd USING @SettledTableName;
			DEALLOCATE PREPARE checkcmd;
            IF (@Exist IS NULL)THEN 
                SET @NowTableName = concat("TpBetRecord_", DATE_FORMAT(NOW(), '%Y%m')); 
                SET @CreateCmd = concat("CREATE TABLE ", @SettledTableName ," LIKE ", @NowTableName ,";");   
                PREPARE createcmd FROM @CreateCmd;
                EXECUTE createcmd;
				DEALLOCATE PREPARE createcmd;
            END IF;
        END IF;
            
        SET @cmd = concat("INSERT INTO ", @SettledTableName ,
        " (
        TpId,
        TransId,
        GameType,
        CustId,
        UserName,
        CurrencyId,
        SiteId,
        TpUserName,
        TransTime,
        SettledTime,
        Stake,
        ValidBet,
        Revenue,
        WinlostAmount,
        SettlementType,
        TicketStatus,
        OriginalState,
        TicketKey,
        BonusId,
        GameID,
        CreateTime,
        ProgressiveBet,
        ProgressiveWin,
        UpdateTime
        ) 
        VALUES 
        (
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?
        )
        ON DUPLICATE KEY UPDATE 
        TpUserName = ?,
        TransTime = ?,
        SettledTime = ?,
        Stake = ?,
        ValidBet = ?,
        Revenue = ?,
        WinlostAmount = ?,
        SettlementType = ?,
        TicketStatus = ?,
        OriginalState = ?,
        TicketKey = ?,
        BonusId = IF(? = 1, ?, BonusId),
        GameID = ?,
        CreateTime = IF(? = 1, ?, CreateTime),
        ProgressiveBet = ?,
        ProgressiveWin = ?,
        UpdateTime = ?
        ;");        
        PREPARE stmt FROM @cmd;
        EXECUTE stmt USING
        @TpId,
        @TransId,
        @GameType,
        @CustId,
        @UserName,
        @CurrencyId,
        @SiteId,
        @TpUserName,
        @TransTime,
        @SettledTime,
        @Stake,
        @ValidBet,
        @Revenue,
        @WinlostAmount,
        @SettlementType,
        @TicketStatus,
        @OriginalState,
        @TicketKey,
        @BonusId,
        @GameID,
        @CreateTime,
        @ProgressiveBet,
        @ProgressiveWin,
        @UpdateTime,
        @TpUserName,
        @TransTime,
        @SettledTime,
        @Stake,
        @ValidBet,
        @Revenue,
        @WinlostAmount,
        @SettlementType,
        @TicketStatus,
        @OriginalState,
        @TicketKey,
        @UpdateBonus, @BonusId,
        @GameID,
        @UpdateBonus, @CreateTime,
        @ProgressiveBet,
        @ProgressiveWin,
        @UpdateTime
        ;
        SELECT ROW_COUNT();
        DEALLOCATE PREPARE stmt;
         
END$$
DELIMITER ;
