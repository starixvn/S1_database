
/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241224@Liam.Pham 
        DB: TSDB-TSDB
        Task: add new payment provider
        Revisions:
                - 20241226@Liam.Pham : add LNW Pay provider
*/

INSERT INTO SitePayListV2 (SiteId, PayId, Setting, Status, LoginUrl, LoginAccount, LoginPassword, TransferPin, LoginPin, CorporateId)
VALUES ("1000", "67", '{"Prefix": "NV8", "PayName": "LNWPay", "QRToken": "1ac99a695bc6454a82ce10eddc40a8fe", "QRApiUrl": "https://lnwpay123.com/services", "AutoToken": "a2cc092dc664453586461efff7edbc4a", "TrueToken": "b0ec0d3de2a34ec78435bf9dddf63b52", "AutoApiUrl": "https://autopay321.com/services", "TrueApiUrl": "https://wallet321.com/services", "AutoPayoutToken": "", "AutoPayoutApiUrl": ""}
', "1", "", "", "", "", "", "")
ON DUPLICATE KEY UPDATE
  Setting = VALUES(Setting),
  Status = VALUES(Status),
  LoginUrl = VALUES(LoginUrl),
  LoginAccount = VALUES(LoginAccount),
  LoginPassword = VALUES(LoginPassword),
  TransferPin = VALUES(TransferPin),
  LoginPin = VALUES(LoginPin),
  CorporateId = VALUES(CorporateId);
  
  
START TRANSACTION;
INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, ExtraDataType, PayCode)
VALUES (67, 1, 'LNWPAY', 7, 1, 2, 1, 'Auto');
SET @FirstInsertedId = LAST_INSERT_ID();  

select @FirstInsertedId;

INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, ExtraDataType, PayCode)
VALUES (67, 34, 'LNWPAY', 2, 1, 2, 2, 'True');
SET @secondId = LAST_INSERT_ID();  
select @secondId;


INSERT INTO PayChannelV2 (PayID, GroupId, ChannelName, Type, Method, Mode, ExtraDataType, PayCode)
VALUES (67, 49, 'LNWPAY', 2, 1, 2, 3, 'QR');
SET @thirdId = LAST_INSERT_ID();  
select  @thirdId;

INSERT INTO PaySetting (SiteId, CurrencyId, ChannelId, PayCurrency, MinAmount, MaxAmount, AmountRule)
VALUES
(1000, 4, @FirstInsertedId, 'THB', 100, 200000, 1),  
(1000, 4, @secondId, 'THB', 100, 200000, 1),  
(1000, 4, @thirdId, 'THB', 100, 200000, 1);  
COMMIT;