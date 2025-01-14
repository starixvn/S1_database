
/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20250114@Liam.Pham
        DB: TSDB-TSDB
        Task: Add new payment provider 
        Revisions:
                - 20250114@Liam.Pham : add a game wallet for the UAT environment only
*/
-- for UAT testing 
INSERT INTO BankInfoSys (Id,CurrencyId, BankCode, BankName, BankLogo, BankSite, BIN, Status, Sort)
VALUES (567,4, 'FAKERTHB', 'Mock bank only for testing environment', 'MockLogo.webp', 'https://mockbank.test/env', '', 1, 100);


INSERT INTO PayList (PayName, Status)  
VALUES ('GameWallet', 1); 
SET @PayId = LAST_INSERT_ID(); 

INSERT INTO SitePayListV2 (SiteId, PayId, Setting, Status)  
VALUES (1000, @PayId, '{"DepositUrl": "https://depositapi.gamewalletuat.com/","PayName": "GameWallet","Key": "57cd25750f854473b7750170838b7e14","MerchantCode":"nova88solutions","WithdrawalUrl":"https://api.gamewalletuat.com"}', 1);

-- deposit 
INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, ExtraDataType, PayCode)
VALUES (@PayId, 1, 'GameWallet', 7, 1, 2, 1, 'Onl');
SET @FirstInsertedId = LAST_INSERT_ID();  
select @FirstInsertedId;

INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, ExtraDataType, PayCode)
VALUES (@PayId, 34, 'GameWallet', 2, 1, 2, 0, 'True');
SET @secondId = LAST_INSERT_ID();  
select @secondId;

INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, ExtraDataType, PayCode)
VALUES (@PayId, 49, 'GameWallet', 2, 1, 2, 0, 'QR');
SET @thirdId = LAST_INSERT_ID();  
select  @thirdId;

-- banks for internet banking method 
INSERT INTO BankInfoPayV2 (PayId, SysId, ChannelId, BankName, BankCode, Status)VALUES
(@PayId, 12, @FirstInsertedId, 'Ayudhya Bank', 'BOA' ,1),
(@PayId, 9, @FirstInsertedId, 'Krung Thai Bank', 'KTB' ,1),
(@PayId, 11, @FirstInsertedId, 'Bangkok bank', 'BBL' ,1),
(@PayId, 8, @FirstInsertedId, 'Kasikorn Bank', 'KBANK' ,1),
(@PayId, 10, @FirstInsertedId, 'Siam Commercial Bank', 'SCB' ,1),
(@PayId, 567,@FirstInsertedId, 'Mock bank only for testing enviroment', 'FAKERTHB' ,1); -- for testing 
-- banks for QR method 
INSERT INTO BankInfoPayV2 (PayId, SysId, ChannelId, BankName, BankCode, Status)VALUES
(@PayId, 12, @thirdId, 'Ayudhya Bank', 'BOA' ,1),
(@PayId, 9,  @thirdId, 'Krung Thai Bank', 'KTB' ,1),
(@PayId, 11, @thirdId, 'Bangkok bank', 'BBL' ,1),
(@PayId, 8,  @thirdId, 'Kasikorn Bank', 'KBANK' ,1),
(@PayId, 10, @thirdId, 'Siam Commercial Bank', 'SCB' ,1),
(@PayId, 53, @thirdId, 'TMB BANK PUBLIC COMPANY LTD.', 'TMB' ,1),
(@PayId, 19, @thirdId, 'KIATNAKIN BANK PCL', 'KKB' ,1);


INSERT INTO PaySetting (SiteId, CurrencyId, ChannelId, PayCurrency, MinAmount, MaxAmount, AmountRule)
VALUES
(1000, 4, @FirstInsertedId, 'THB', 100, 200000, 1),  
(1000, 4, @secondId, 'THB', 100, 200000, 1),  
(1000, 4, @thirdId, 'THB', 100, 200000, 1);  

-- withdrawal
INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, PayCode)
VALUES (@PayId, 1, 'GameWallet', 1, 2, 2,'');
SET @paychannelWithdrawalId = LAST_INSERT_ID();  
select  @paychannelWithdrawalId;

INSERT INTO PaySetting (SiteId, CurrencyId, ChannelId, PayCurrency, MinAmount, MaxAmount, AmountRule)  VALUES
(1000, 4, @paychannelWithdrawalId, 'THB', 100,200000,1);

INSERT INTO BankInfoPayV2 (PayId, SysId, ChannelId, BankName, BankCode, Status)VALUES
(@PayId, 12, @paychannelWithdrawalId, 'Ayudhya Bank', 'BOA' ,1),
(@PayId, 9, @paychannelWithdrawalId, 'Krung Thai Bank', 'KTB' ,1),
(@PayId, 11,@paychannelWithdrawalId, 'Bangkok bank', 'BBL' ,1),
(@PayId, 8, @paychannelWithdrawalId, 'Kasikorn Bank', 'KBANK' ,1),
(@PayId, 10, @paychannelWithdrawalId, 'Siam Commercial Bank', 'SCB' ,1),
(@PayId, 53, @paychannelWithdrawalId, 'TMB BANK PUBLIC COMPANY LTD.', 'TMB' ,1),
(@PayId, 19, @paychannelWithdrawalId, 'KIATNAKIN BANK PCL', 'KKB' ,1),
(@PayId, 567,@paychannelWithdrawalId , 'Mock bank only for testing enviroment', 'FAKERTHB' ,1); -- for testing 
