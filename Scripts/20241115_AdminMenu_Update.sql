/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241115@Johnny
        DB: TSDB-TSDB
        Task: Hide menu for phase 1
*/
-- Hide Referral Management, BonusCode Management, Reward Program, Block Crypto Wallet, Referral Report, FPS Device Report
Update TSDB.AdminMenu
Set Status = 0
Where Id in (48,77,102,142,155,162)