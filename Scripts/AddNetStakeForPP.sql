/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: add netstake for PP
*/

ALTER TABLE TSDB.BettransRng_PP_202501 ADD NetStake decimal(18,2);
ALTER TABLE TSDB.BettransRng_PP_202502 ADD NetStake decimal(18,2);
ALTER TABLE TSDB.BettransLC_PP_202501 ADD NetStake decimal(18,2);
ALTER TABLE TSDB.BettransLC_PP_202502 ADD NetStake decimal(18,2);