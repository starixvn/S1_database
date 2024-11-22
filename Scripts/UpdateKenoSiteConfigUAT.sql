/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241122@Los
        DB: TSDB-TSDB
        Task: Update Keno in SiteConfig table UAT
*/

UPDATE TpList SET TpName='RNGKeno' WHERE Id=71;
UPDATE SiteConfig SET ConfigValue='{"OperatorPwd":"s1hb8uik","OperatorKey":"ck03ijvk","GameType":"Keno","ApiUrl":"http://owapi1.playonesit.com:7052"}' WHERE ConfigKey='RNGKeno';
UPDATE TpGameType SET TypeName='RNG Keno'  WHERE Tpid=71;