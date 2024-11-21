/*<info serverAlias="TSDB-TSDB" databaseType="2"></info>*/
/*
  Created: 20241125@George.Phung
        DB: TSDB-TSDB
        Task: Separate Balance Adjustment (+) and (-) to use difference func keys
        Revisions:
                - 20241125@George.Phung: Separate Balance Adjustment (+) and (-) to use difference func keys
                - 20241125@George.Phung: Insert Bank Financial Reasons
*/
UPDATE ReasonGroup
SET FuncKey = 'FunKey/MainWallet/BalancePlus'
WHERE MethodType = 5 and AdjustType = 1;
UPDATE ReasonGroup
SET FuncKey = 'FunKey/MainWallet/BalanceMinus'
WHERE MethodType = 5 and AdjustType = 2;
DELETE FROM BankFinancialReason
WHERE FuncKey = 'FuncKey/MainWallet';
INSERT INTO BankFinancialReason
(
    FuncKey,
    MethodType,
    ReasonId,
    Description,
    CreateTime,
    Creator,
    UpdateTime,
    Updator
)
VALUES
(
    'FunKey/MainWallet/BalancePlus',
    5,
    1,
    'Deposit',
    NOW(),
    60,
    NOW(),
    60
),
(
    'FunKey/MainWallet/BalancePlus',
    5,
    3,
    'Others',
    NOW(),
    60,
    NOW(),
    60
),
(
    'FunKey/MainWallet/BalanceMinus',
    5,
    2,
    'Withdrawal',
    NOW(),
    60,
    NOW(),
    60
),
(
    'FunKey/MainWallet/BalanceMinus',
    5,
    3,
    'Others',
    NOW(),
    60,
    NOW(),
    60
);