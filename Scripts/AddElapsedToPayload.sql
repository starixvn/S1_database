/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241203@Los
        DB: TSDB-TSDB
        Task: Add Elapsed to Payload table
*/

ALTER TABLE Bettrans_SBSW_Payload_202412
ADD COLUMN Elapsed INT AFTER Response; 

ALTER TABLE BettransPK_MaxGame_Payload_202412
ADD COLUMN Elapsed INT AFTER Response; 