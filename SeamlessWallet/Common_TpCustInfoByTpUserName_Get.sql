/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Common_TpCustInfoByTpUserName_Get`(
    IN TpId INT,
    IN TpUserName VARCHAR(50) CHARACTER SET ASCII,
	IN GUID VARCHAR(50)
	
/*
  Created: 
	DB: TSDB-TSDB
	Task: 

	Revisions:
		- 20250109@Kathy: write log
*/
)
BEGIN
        
    
    SET @starttime = CURRENT_TIMESTAMP(6);
    
        
	SELECT 
		TC.CustId,
		C.CurrencyId,
		TC.UserName,
		TC.TpUserName,
		TC.TpPwd,
		TC.SiteId,
		TC.TpCustId,
		TCurr.TpCurrencyId,
		C.MemberType,
		C.IsTest
	FROM
		Customer AS C
			INNER JOIN
		TpCustInfo AS TC ON C.CustId = TC.CustId AND TC.TpId = TpId
			INNER JOIN
		TpCurrency AS TCurr ON C.CurrencyId = TCurr.CurrencyId AND TCurr.TpId = TpId
	WHERE TC.TpId = TpId
	AND TC.TpUserName = TpUserName;
		
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('Common_TpCustInfoByTpUserName_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
