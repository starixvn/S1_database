/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `TpCurrency_Get`(
	IN TpId INT,
    IN CurrencyId INT,
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
		TpCurrency.TpCurrencyId, TpCurrency.ExchangeRate
	FROM
		TpCurrency
	WHERE
		TpCurrency.TpId = TpId
			AND TpCurrency.CurrencyId = CurrencyId;
			
	INSERT INTO SPLog (spname, starttime, endtime, GUID) VALUES ('TpCurrency_Get', @starttime, CURRENT_TIMESTAMP(6), GUID);
END$$
DELIMITER ;
