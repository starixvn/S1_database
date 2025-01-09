/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20250107@Los
        DB: TSDB-TSDB
        Task: Turn of gameId: 3723,3741,3742,3747
*/
UPDATE TpGameId
SET Status=0
WHERE TpId=5 AND TpGameType=16 AND GameId IN (3723,3741,3742,3747, 3709,3713)


