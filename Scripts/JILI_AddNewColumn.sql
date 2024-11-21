/*<info serverAlias="TSDB-TSDB" databaseType="2" executers="" isFunction="0" isNested="0"></info>*/

alter table BettransRng_JILI_202411 add GameRoundId varchar(100);

alter table BettransRng_JILI_202411 add IpAddress varchar(25);
alter table BettransRng_JILI_202411 add GameType varchar(50);

drop index ix_round on BettransRng_JILI_202411;
alter table BettransRng_JILI_202411 drop round;

-- PP


ALTER TABLE BettransRng_PP_202411 
ADD COLUMN UpdateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


ALTER TABLE BettransLC_PP_202411 
ADD COLUMN UpdateTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

