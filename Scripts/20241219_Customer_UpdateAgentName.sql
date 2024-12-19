/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241219@Zephyr
        DB: TSDB-TSDB
        Task: Update Agent Name
*/

update Customer
set UserName = 'nsDemoTHB'
where CustId = 1;