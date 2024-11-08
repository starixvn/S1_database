/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Common_BankInfoPay_Get_V4`(
    IN _SiteId INT,
    IN _DepositType TINYINT
 /*
  Created: 20241108@George
	DB: TSDB-TSDB
	Task: Initial

	Revisions:
		- 20241108@George: Initial
*/       
)
BEGIN

    DROP TEMPORARY TABLE IF EXISTS `Tmp_BankInfo`;
    CREATE TEMPORARY TABLE Tmp_BankInfo (
        SysId INT NOT NULL,
        ChannelId INT NOT NULL,
        CurrencyId INT NOT NULL,
        SysBankName VARCHAR(100),
        SysBankCode VARCHAR(20),
        BankLogo VARCHAR(45),
        BankName VARCHAR(100),
        BankCode VARCHAR(30),
        PRIMARY KEY (ChannelId, SysId)
    );

    INSERT INTO Tmp_BankInfo
    (
        SysId,
        CurrencyId,
        SysBankName,
        SysBankCode,
        BankLogo,
        BankName,
        BankCode,
        ChannelId
    )
    SELECT
        BIP.SysId,
        BIS.CurrencyId,
        BIS.BankName,
        BIS.BankCode,
        BIS.BankLogo,
        BIP.BankName,
        BIP.BankCode,
        BIP.ChannelId
    FROM BankInfoPayV2 AS BIP
    INNER JOIN BankInfoSys AS BIS ON BIP.SysId = BIS.Id
    LEFT JOIN SiteBankInfoPayV2 AS SBIP
        ON SBIP.PayId = BIP.PayId AND SBIP.SysId = BIP.SysId AND SBIP.ChannelId = BIP.ChannelId AND SBIP.SiteId = _SiteId
    WHERE BIS.Status = 1
        AND (SBIP.Status = 1 OR (SBIP.Status IS NULL AND BIP.Status = 1))
    ;

    SELECT
        TBI.SysId,
        PS.CurrencyId,
        TBI.SysBankCode,
        TBI.SysBankName,
        TBI.BankLogo,
        PC.PayId,
        TBI.BankCode,
        TBI.BankName,
        PC.Method,
        PS.ChannelId,
        PC.ChannelName,
        PC.GroupId,
        PG.GroupName,
        PC.`Mode`,
        PC.ExtraDataType,
        PS.PointLevel,
        PC.PayCode,
        PL.PayName,
        PS.Sort AS SSort,
        IF(TBI.BankCode IS NULL, 0, 1) AS SelBank,
        PS.MinAmount,
        PS.MaxAmount,
        PS.AmountShow,
        PS.AmountRule,
        PS.PayCurrency AS PayCurrencyId
    FROM PayList AS PL
    INNER JOIN PayChannelV2 AS PC ON PC.PayId = PL.Id
    INNER JOIN PayGroup AS PG ON PC.GroupId = PG.Id
    INNER JOIN PaySetting AS PS ON PC.Id = PS.ChannelId
    INNER JOIN SitePayListV2 AS SPL ON PL.Id = SPL.PayId AND SPL.SiteId = PS.SiteId
    LEFT JOIN Tmp_BankInfo AS TBI ON PC.Id = TBI.ChannelId AND PS.CurrencyId = TBI.CurrencyId
    WHERE PS.SiteId = _SiteId
        AND PC.Method = 1
        AND PL.Status = 1
        AND SPL.Status = 1
        AND PS.Status = 1
        AND PC.Type = _DepositType
    ;

END$$
DELIMITER ;
