/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241129@George.Phung
        DB: TSDB-TSDB
        Task: Separate Balance Adjustment (+) and (-) to use difference func keys
        Revisions:
                - 20241129@George.Phung: Change All Bank Logo image format from .png to .webp
*/
UPDATE BankInfoSys
SET BankLogo = REPLACE(BankLogo, '.png', '.webp')
WHERE BankLogo LIKE '%.png'