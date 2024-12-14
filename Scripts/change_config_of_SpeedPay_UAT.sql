/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241207@Liam.Pham 
        DB: TSDB-TSDB
        Task: change config of SpeedPay for UAT
        Revisions:
                - 20241207@Liam.Pham : change config of SpeedPay for UAT
*/

UPDATE SitePayListV2 
SET Setting = '{"THB":"{\\"Key\\":\\"H54J62R5V562T45Y6TRS2VY56T2S2VY6\\",\\"MerchantId\\":\\"NOVA88TES\\",\\"ApiUrl\\":\\"https://public.allpay888.com\\"}","PayName":"SpeedPay"}'
WHERE PayId = 52;
