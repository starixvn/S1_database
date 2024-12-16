/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241216@George.Phung
        DB: TSDB-TSDB
        Task: Reset UAT TpWager Timer for Finance Worker
        Revisions:
                - 20241216@George.Phung: Reset UAT TpWager Timer
                - 20241216@George.Phung: Add Table Game 73
*/

UPDATE 
    BetDetail.TpWagerTimer 
    SET StartTime = '2024-11-22 23:59:59'
    WHERE Type = 4 AND TpId IN (
        5,
        12,
        14,
        15,
        18,
        32,
        55,
        61,
        66,
        67,
        68,
        69,
        71,
        72,
        73
    )
