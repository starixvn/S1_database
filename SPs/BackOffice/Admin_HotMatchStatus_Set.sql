/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="app_srv" isFunction="0" isNested="0"></info>*/
DELIMITER $$
CREATE DEFINER=`dbo`@`%` PROCEDURE `Admin_HotMatchStatus_Set`(IN _MatchId int,
                                                            IN _Status tinyint,
                                                            IN _UpdateUser varchar(30))
                                                            /*
  Created: 20241120@Levi.Vu
        DB: TSDB-TSDB
        Task: Hot match
        Revisions:
                - 20241120@Levi.Vu: set hot Match Status 
*/
BEGIN
    UPDATE HotMatchInfo
       SET Status = _Status,
           LastUpdateTime = now(),
           LastUpdateUser = _UpdateUser
    WHERE MatchId = _MatchId;
END$$
 
DELIMITER ;