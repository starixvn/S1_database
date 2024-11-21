/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241123@George.Phung
        DB: TSDB-TSDB
        Task: Hide Unused Menu realting to payment
        Revisions:
                - 20241123@George.Phung: Hide unused menu 
*/
UPDATE AdminMenu
SET Status = 0
WHERE Name = 'Accounting';

UPDATE AdminMenu
SET Status = 0
WHERE Name = 'Modify Payment Fee Log';

UPDATE AdminMenu
SET Status = 0
WHERE Name = 'Transfer Info Report';


