/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20250107@Los
        DB: TSDB-TSDB
        Task: Correct game name PPLC
*/
-- Mega Wheel -> Dragon Tiger
UPDATE TpGameIdInfo
SET Name= 'Dragon Tiger'
WHERE Tpid=5 AND TpGameIdNo=220 AND Name='Mega Wheel';

-- Roulette Green -> Mega Wheel
UPDATE TpGameIdInfo
SET Name= 'Mega Wheel'
WHERE Tpid=5 AND TpGameIdNo=221 AND Name='Roulette Green';

-- Roulette -> 	Roulette Green
UPDATE TpGameIdInfo
SET Name= 'Roulette Green'
WHERE Tpid=5 AND TpGameIdNo=222 AND Name='Roulette';


