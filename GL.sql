--=========================================
--Traial Balance of KSRM
--=========================================


SELECT ACCOUNT, SUM(BEGIN_BALANCE) BEGIN_BALANCE, SUM(PERIOD_DR) PERIOD_DR, SUM(PERIOD_CR) PERIOD_CR
FROM 
          (
SELECT   CC.SEGMENT5  ACCOUNT, 
                 SUM(NVL(BEGIN_BALANCE_DR,0) - NVL(BEGIN_BALANCE_CR,0)) BEGIN_BALANCE,
                 NULL PERIOD_DR,
                 NULL PERIOD_CR
FROM      GL_BALANCES BAL,
              GL_CODE_COMBINATIONS CC,
              GL_PERIOD_STATUSES GLPS  
WHERE  BAL.ACTUAL_FLAG = 'A'
 AND       BAL.CURRENCY_CODE =NVL( :P_LEDGER_CURRENCY,'BDT')
 AND       BAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
 AND       BAL.LEDGER_ID = GLPS.LEDGER_ID 
 AND       BAL.PERIOD_NAME = GLPS.PERIOD_NAME 
 AND       GLPS.APPLICATION_ID = 101  
 AND       CC.CHART_OF_ACCOUNTS_ID = NVL(:P_CHART_OF_ACCOUNTS_ID,101)
 AND       CC.TEMPLATE_ID IS NULL
 AND       CC.SUMMARY_FLAG = 'N'
 AND        GLPS.effective_period_num = (select effective_period_num from gl_period_statuses
                                                           where period_name = :P_PERIOD_NAME_FROM
                                                           and set_of_books_id = :P_LEDGER_ID
                                                           and application_id = 101)    
 AND       BAL.LEDGER_ID = :P_LEDGER_ID
 &P_WHERE_CLAUSE 
GROUP BY CC.SEGMENT5
HAVING SUM(NVL(BEGIN_BALANCE_DR,0) - NVL(BEGIN_BALANCE_CR,0)) <> 0 OR SUM(BAL.PERIOD_NET_DR) <> 0  OR SUM(BAL.PERIOD_NET_CR) <> 0
UNION ALL
SELECT   CC.SEGMENT5  ACCOUNT, 
                 NULL BEGIN_BALANCE,
                 SUM(DECODE(PERIOD_NET_DR, 0, NULL, PERIOD_NET_DR)) PERIOD_DR,
                 SUM(DECODE(PERIOD_NET_CR, 0, NULL, PERIOD_NET_CR)) PERIOD_CR
FROM      GL_BALANCES BAL,
              GL_CODE_COMBINATIONS CC,
              GL_PERIOD_STATUSES GLPS  
WHERE  BAL.ACTUAL_FLAG = 'A'
 AND       BAL.CURRENCY_CODE = NVL( :P_LEDGER_CURRENCY,'BDT')
 AND       BAL.CODE_COMBINATION_ID = CC.CODE_COMBINATION_ID
 AND       BAL.LEDGER_ID = GLPS.LEDGER_ID 
 AND       BAL.PERIOD_NAME = GLPS.PERIOD_NAME 
 AND       GLPS.APPLICATION_ID = 101  
 AND       CC.CHART_OF_ACCOUNTS_ID = NVL(:P_CHART_OF_ACCOUNTS_ID,101)
 AND       CC.TEMPLATE_ID IS NULL
 AND       CC.SUMMARY_FLAG = 'N'
AND        GLPS.effective_period_num BETWEEN (select effective_period_num from gl_period_statuses
                                                                       where period_name = :P_PERIOD_NAME_FROM
                                                                       and set_of_books_id = :P_LEDGER_ID
                                                                       and application_id = 101) 
                                                      AND
                                                                       (select effective_period_num from gl_period_statuses
                                                                       where period_name = :P_PERIOD_NAME_TO
                                                                       and set_of_books_id = :P_LEDGER_ID
                                                                       and application_id = 101)
 AND       BAL.LEDGER_ID = :P_LEDGER_ID
 &P_WHERE_CLAUSE 
GROUP BY CC.SEGMENT5
HAVING SUM(NVL(BEGIN_BALANCE_DR,0) - NVL(BEGIN_BALANCE_CR,0)) <> 0 OR SUM(BAL.PERIOD_NET_DR) <> 0  OR SUM(BAL.PERIOD_NET_CR) <> 0
)
GROUP BY ACCOUNT
ORDER BY  1


--========================

select * from gl_je_categories_v

