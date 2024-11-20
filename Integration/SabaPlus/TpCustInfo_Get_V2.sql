/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DROP PROCEDURE IF EXISTS `TpCustInfo_Get_V2`;
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `TpCustInfo_Get_V2`(
	IN TpId INT,
	IN CustId INT
/*
  Created: 
	DB: TSDB-TSDB
	Task: get bet PP

	Revisions:
		- 20241106@Kathy: get CurrencyId
*/
)
BEGIN
	SELECT 
		TC.TpId,
		TC.CustId,
		TC.SiteId,
		TC.UserName,
		TC.TpUserName,
		TC.TpPwd,
        TC.TpCustId,
        TCY.TpCurrencyId,
        TCY.CurrencyId,
        TCY.ExchangeRate,
		C.IsTest,
        C.ActStatus,
		TC.`Status`,
        C.`Status` AS CStatus,
        C.MemberType
	FROM
		TpCurrency AS TCY
			INNER JOIN
		Customer AS C ON C.CurrencyId = TCY.CurrencyId
			RIGHT OUTER JOIN
		TpCustInfo AS TC ON TC.CustId = C.CustId AND TC.TpId = TCY.TpId
	WHERE
		TC.TpId = TpId AND TC.CustId = CustId;
END ;;
DELIMITER ;