/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Extend data length
	Revisions:
        - 20241119@Los: Initial
*/
ALTER TABLE BettransPK_MaxGame_Payload_202412 MODIFY environment VARCHAR(50) DEFAULT NULL;
ALTER TABLE BettransPK_MaxGame_Payload_202501 MODIFY environment VARCHAR(50) DEFAULT NULL; 
ALTER TABLE Bettrans_SBSW_Payload_202412 MODIFY environment VARCHAR(50) DEFAULT NULL;
ALTER TABLE Bettrans_SBSW_Payload_202501 MODIFY environment VARCHAR(50) DEFAULT NULL; 

 