/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241129@George.Phung
        DB: TSDB-TSDB
        Task: Separate Balance Adjustment (+) and (-) to use difference func keys
        Revisions:
                - 20241129@George.Phung: Change All Bank Logo image format from .png to .webp
                - 20241129@George.Phung: Change All Bank Logo image format from .png to .webp, stronger
*/
UPDATE BankInfoSys
SET BankLogo = CONCAT(LEFT(BankLogo, LENGTH(BankLogo) - 4), '.webp')
WHERE LOWER(RIGHT(BankLogo, 4)) = '.png'