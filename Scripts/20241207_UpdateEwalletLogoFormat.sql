/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Liam.Pham 
        DB: TSDB-TSDB
        Task: Change All EWallet Logo image format from .png to .webp
        Revisions:
                - 20241207@Liam.Pham : Change All EWallet Logo image format from .png to .webp
*/
UPDATE EWalletInfoSys
SET EWalletLogo = CONCAT(LEFT(EWalletLogo, LENGTH(EWalletLogo) - 4), '.webp')
WHERE LOWER(RIGHT(EWalletLogo, 4)) = '.png'