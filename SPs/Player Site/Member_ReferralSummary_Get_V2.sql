/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER ;;
CREATE DEFINER=`dbo`@`%` PROCEDURE `Member_ReferralSummary_Get_V2`(
    IN CustId INT,
    OUT ReferralCount INT,
    OUT AmountCount INT,
    OUT AmountSum DECIMAL(18,4),    
    OUT ConditionCount INT,
    OUT HasReferral INT
)
/*
  Created: 20241115@Johnny
        DB: TSDB-TSDB
        Task: Get summary referral by custId 
        Revisions:
                - 20241115@Johnny: only get for new referral
*/


BEGIN
    SELECT SUM(RML.ReferralAmount) INTO @ReferralAmount FROM ReferralMLog AS RML WHERE RML.CustId = CustId AND RML.Type = 2;
    
       SELECT R.`Status` INTO @HasReferral 
         FROM Referral AS R 
    LEFT JOIN Customer AS C ON R.SiteId = C.SiteId AND R.CurrencyId = C.CurrencyId
        WHERE C.CustId = CustId;

    SELECT 
        C.AgentId,
        COUNT(C.CustId) AS ReferralCount,
        COUNT(RL.CustId) AS AmountCount,
        @ReferralAmount AS AmountSum,
        COUNT(IF(C.ActStatus=2,1,NULL)) AS ConditionCount,
        IF(@HasReferral>0,1,0) AS HasReferral
    INTO
        @AgentId,
        ReferralCount,
        AmountCount,
        AmountSum,
        ConditionCount,
        HasReferral
    FROM
        Customer C
        LEFT JOIN
        ReferralLog AS RL ON RL.CustId = C.CustId
    WHERE
        C.AgentId = CustId AND RL.Type = 2
    GROUP BY AgentId;
END ;;
DELIMITER ;
