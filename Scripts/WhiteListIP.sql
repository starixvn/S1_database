/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
   Created: 20250109@Kathy
        DB: TSDB-TSDB
        Task: modify datatype table WhiteListIP
        Revisions:
                
*/

ALTER TABLE TSDB.WhitelistIP MODIFY IPFrom VARCHAR(39);

ALTER TABLE TSDB.WhitelistIP MODIFY IPTo VARCHAR(39);