/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_BonusWallet_Set_V4`(
    IN GameType INT,
    IN CustId INT,
    IN UserName VARCHAR(30),
    IN SiteId INT,
    IN Amount DECIMAL(18,4),
    IN `Type` SMALLINT,    
    IN Memo VARCHAR(200),
    IN RefTransId VARCHAR(100),
    OUT AfterBonus DECIMAL(18,4),
    INOUT BonusId INT
/*
  Created: 20250114@Kathy
        DB: TSDB-TSDB
        Task: load test
        Revisions:
                - 20241226@Kathy: load test
*/
)
BEGIN
    
    SET @starttime = CURRENT_TIMESTAMP(6);
	
    SET AfterBonus = Amount;
    
    IF BonusId IS NOT NULL AND BonusId > 0  THEN
        SELECT 
            CustBonus.Bonus + Amount,
            CustBonus.BonusId,
            CustBonus.PromoCategoryId
        INTO
            AfterBonus,
            BonusId,
            @PromoCategoryId
        FROM
            CustBonus
        WHERE
            CustBonus.BonusId = BonusId
                AND CustBonus.`Status` <> 4 
        FOR SHARE;
        
        IF row_count() = 0 THEN
            SET BonusId = -1; 
        END IF;
    ELSE    
        SELECT 
            CustBonus.Bonus + Amount,
            CustBonus.BonusId,
            CustBonus.PromoCategoryId
        INTO
            AfterBonus,
            BonusId,
            @PromoCategoryId
        FROM
            CustBonus
        INNER JOIN PromotionCategoryGameType 
            ON CustBonus.PromoCategoryId = PromotionCategoryGameType.PromotionCategoryId
            AND PromotionCategoryGameType.GameType = GameType
        WHERE
            CustBonus.CustId = CustId AND CustBonus.`Status` = 1
        FOR UPDATE;
        
        IF row_count() = 0 THEN
            SET BonusId = -1; 
        END IF;
        
    END IF;
    
    IF row_count() > 0 THEN
        SET @Direction = 2;
        
        IF Amount > 0 THEN
            SET @Direction = 1;
        END IF;
        
        SET @AfterBonus = 0;
        SET @Bonus = 0;
        
        IF AfterBonus < 0 THEN
            SET @Bonus = (ABS(Amount) + AfterBonus) * -1;
            SET @AfterBonus = 0;
        
            UPDATE CustBonus 
            SET 
                CustBonus.Bonus = 0
            WHERE
                CustBonus.BonusId = BonusId;
        ELSE
            SET @Bonus = Amount;
            SET @AfterBonus = AfterBonus;
            
            UPDATE CustBonus 
            SET 
                CustBonus.Bonus = CustBonus.Bonus + Amount
            WHERE
                CustBonus.BonusId = BonusId;
        END IF;
        
        INSERT INTO BonusLog
            (BonusId, CustId, UserName, SiteId, `Type`, PromoCategoryId, Direction, ChangeBonus, BeforeBonus, AfterBonus, Memo, RefTransId) 
        VALUES
            (BonusId, CustId, UserName, SiteId, `Type`, @PromoCategoryId, @Direction, ABS(@Bonus), @AfterBonus - @Bonus, @AfterBonus, Memo, RefTransId);
    END IF;
	
	INSERT INTO SPLog (spname, starttime, endtime) VALUES ('Service_BonusWallet_Set_V4', @starttime, CURRENT_TIMESTAMP(6));
END$$
DELIMITER ;

