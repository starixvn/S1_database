/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpSeamlessBonus_GetByTransID`(
    IN TpId INT,
    IN TransId VARCHAR(100),
    IN GUID VARCHAR(50),
    OUT CustId INT,
    OUT BonusId INT
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
	
    SET CustId = 0, BonusId = 0;
   
    SELECT 
        TpSeamlessBonus.CustId, 
        TpSeamlessBonus.BonusId
    INTO 
        CustId, 
        BonusId 
    FROM
        TpSeamlessBonus
    WHERE
        TpSeamlessBonus.TpId = TpId
            AND TpSeamlessBonus.TransId = TransId;
			
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Service_TpSeamlessBonus_GetByTransID', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;

