/*<info serverAlias="TSDB-Siebog" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `Admin_ResetCustBankInfo_Set`;

DELIMITER //
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_ResetCustBankInfo_Set`
(
    IN CustId int

    ----------------------------------------------------
    /*
      Created: 20241101@Zephyr
      DB: TSDB-Siebog
      Task: fix real name null when reseting bank info

      Revisions:
        - 20241101@Zephyr: Update SP [RedmineID: #000000]
    */
)
BEGIN
    
    DELETE FROM Siebog.OnUser 
    WHERE OnUser.CustId = CustId;

    DELETE FROM Siebog.CustBankDetail
    WHERE CustBankDetail.CustId = CustId;
END
//

DELIMITER ;