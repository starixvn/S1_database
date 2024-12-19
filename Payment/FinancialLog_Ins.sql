/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `FinancialLog_Ins`(
    CustId int ,
    UserName varchar(30),
    SiteId int,
    `Type` smallint ,
    Direction tinyint ,
    ChangeAmount decimal(18,4),
    BeforeAmount decimal(18,4),
    AfterAmount decimal(18,4),
    Memo varchar(200),
    RefTransId varchar(100) CHARACTER SET ASCII
/*
  Created: 20241219@Luke
        DB: TSDB-TSDB
        Task: Add DEALLOCATE stmt for non-standard SPs
        Revisions:
                - 20241219@Luke: Add DEALLOCATE stmt for non-standard SPs
*/)
BEGIN
    
    
    
    SET @CustId=CustId;
    SET @UserName=UserName;
    SET @SiteId=SiteId;
    SET @`Type`=`Type`;
    SET @Direction=Direction;
    SET @ChangeAmount=ChangeAmount;
    SET @BeforeAmount=BeforeAmount;
    SET @AfterAmount=AfterAmount;
    SET @Memo=Memo;
    SET @RefTransId=RefTransId;
    
    SET @cmd = concat("INSERT INTO FinancialLog_", DATE_FORMAT(NOW(),'%Y%m'), "       
    (
        CustId,
        UserName,
        SiteId,
        `Type`,
        Direction,
        ChangeAmount,
        BeforeAmount,
        AfterAmount,
        Memo,
        RefTransId
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
        ?
    )");
    
   PREPARE stmt FROM @cmd;
   EXECUTE stmt USING 
         @CustId,
         @UserName,
         @SiteId,
         @`Type`,
         @Direction,
         @ChangeAmount,
         @BeforeAmount,
         @AfterAmount,
         @Memo,
         @RefTransId;
	DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;
