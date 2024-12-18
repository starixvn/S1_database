/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Service_TpList_ByTpId_Get`(
    IN _TpId INT
/*
  Created: 20241218@George.Phung
        DB: TSDB-TSDB
        Task: Get Tp Site List by Tp Id
        Revisions:
                - 20241218@George.Phung: Currently get ALL site
*/
)
BEGIN
    SELECT 
        SiteId,
        TL.Id AS TpId,
        TL.TpName AS TpName,
        TL.Setting AS Setting,
        TL.`Status` AS `Status`,
        TL.`TicketKey` AS `TicketKey`
    FROM ServerInfo
        JOIN TpList as TL
    WHERE TL.Id = _TpId
        AND TL.Status = 1;
END $$
DELIMITER ;