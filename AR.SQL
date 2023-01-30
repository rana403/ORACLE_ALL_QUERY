-- QUERY 1: FOR COMPLETE TRANSACTION
SELECT   *
  FROM   RA_CUSTOMER_TRX_ALL RCTA,
         RA_CUST_TRX_LINE_GL_DIST_ALL RCTG,
         XLA_TRANSACTION_ENTITIES XTE,
         XLA_EVENTS XE
 WHERE       RCTA.CUSTOMER_TRX_ID = RCTG.CUSTOMER_TRX_ID
         AND RCTA.CUSTOMER_TRX_ID = XTE.SOURCE_ID_INT_1
         AND XTE.ENTITY_ID = XE.ENTITY_ID
         
         
 --QUERY 2: AFTER CREATE ACCOUNTING RUN

SELECT   *
  FROM   RA_CUST_TRX_LINE_GL_DIST_ALL RCTG,
         XLA_DISTRIBUTION_LINKS XDL,
         XLA_AE_LINES XAL,
         XLA_AE_HEADERS XAH
 WHERE       RCTG.CUST_TRX_LINE_GL_DIST_ID = XDL.SOURCE_DISTRIBUTION_ID_NUM_1
         AND XAL.AE_HEADER_ID = XDL.AE_HEADER_ID
         AND XAH.AE_HEADER_ID = XDL.AE_HEADER_ID
         
         
 --QUERY 3 : AFTER RUN TRANSFER TO GL

SELECT   *
  FROM   XLA_AE_LINES XAL,
         GL_JE_LINES GJL,
         GL_IMPORT_REFERENCES GIR,
         GL_JE_HEADERS GJH
 WHERE       XAL.GL_SL_LINK_ID = GJL.GL_SL_LINK_ID
         AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
         AND GIR.JE_HEADER_ID = GJL.JE_HEADER_ID
         AND GIR.JE_HEADER_ID = GJH.JE_HEADER_ID
         
         
         






 SELECT                                          --count(b.ae_header_id) cnt,
        A.EVENT_TYPE_CODE,
         A.EVENT_ID,
         A.ENTITY_ID,
         TO_CHAR (A.ACCOUNTING_DATE, 'MON-RR') PERIOD,
         A.ACCOUNTING_ENTRY_STATUS_CODE,
         A.GL_TRANSFER_STATUS_CODE,
         A.JE_CATEGORY_NAME,
         A.DOC_SEQUENCE_ID,
         A.DOC_SEQUENCE_VALUE,
         A.LEDGER_ID,
         B.AE_HEADER_ID,
         B.GL_SL_LINK_ID,
         B.ACCOUNTING_CLASS_CODE,
         B.PARTY_ID,
         B.PARTY_SITE_ID,
         NVL (B.ENTERED_DR, 0) ent_dr,
         NVL (B.ENTERED_CR, 0) ent_cr,
         NVL (B.ACCOUNTED_DR, 0) AC_DR,
         NVL (B.ACCOUNTED_CR, 0) AC_CR,
         B.CURRENCY_CODE,
         B.CURRENCY_CONVERSION_RATE,
         B.GAIN_OR_LOSS_FLAG,
         GLCC.SEGMENT1 LE,
         GLCC.SEGMENT2 OU,
         GLCC.SEGMENT3 CC,
         GLCC.SEGMENT4 GL,
         GLCC.SEGMENT5 SL,
         GLCC.SEGMENT6 PROJCT,
         GLCC.SEGMENT7 IC,
         --497074
         gl_flexfields_pkg.get_description_sql (Glcc.chart_of_accounts_id, --- chart of account id
                                                4,      -- Position of segment
                                                glcc.segment4 -- Segment value
                                                             )
            ACCOUNT_DESC,
        -- EAM_FLEX_SL_DESC (glcc.segment4, glcc.segment5) SL_DESC,
         xte.SOURCE_ID_INT_1,
         TRANSACTION_NUMBER INVOICE_NUMBER
         ,(SELECT  RECEIPT_NUMBER
            FROM AR_CASH_RECEIPTS_ALL
           WHERE CASH_RECEIPT_ID = XTE.SOURCE_ID_INT_1
           AND ROWNUM=1)
            RECEIPT_NUMBER,
         (SELECT  'V-'||JH.DOC_SEQUENCE_VALUE||' L-'||JE_LINE_NUM
            FROM GL_IMPORT_REFERENCES JI, GL_JE_HEADERS JH
           WHERE     JI.GL_SL_LINK_ID = B.GL_SL_LINK_ID
                 AND JI.JE_HEADER_ID = JH.JE_HEADER_ID
                 AND JI.gl_sl_link_table = B.gl_sl_link_table
                 AND ROWNUM=1)
            GL_VOU_WITH_LINE,
            (SELECT CUSTOMER_NAME||' -'||CUSTOMER_NUMBER FROM XX_AR_CUSTOMER_SITE_V CC WHERE CUSTOMER_ID=B.PARTY_ID
            AND SHIP_TO_ORG_ID=B.PARTY_SITE_ID
             AND ROWNUM=1) CUSTOMER,
             GL_TRANSFER_STATUS_CODE
    FROM XLA_AE_HEADERS A,
         xla_ae_lines B,
         gl_code_combinations glcc,
         xla_transaction_entities_upg xte
   WHERE     a.APPLICATION_ID = 222
   AND EVENT_TYPE_CODE='CM_UPDATE'
         AND a.ACCOUNTING_DATE  BETWEEN '01-NOV-2018'  AND '30-NOV-2018'
        -- AND PARTY_ID=18138
         AND a.entity_id = xte.entity_id
         AND A.AE_HEADER_ID = B.AE_HEADER_ID
         AND B.code_combination_id = glcc.code_combination_id
         AND A.BALANCE_TYPE_CODE = 'A'
         AND (:P_STATUS IS NULL OR GL_TRANSFER_STATUS_CODE=:P_STATUS)
         --AND ACCOUNTING_ENTRY_STATUS_CODE='I'
         AND (:P_LEDGER IS NULL OR A.LEDGER_ID = :P_LEDGER)
         AND A.LEDGER_ID = XTE.LEDGER_ID
         ORDER BY A.ACCOUNTING_DATE,A.AE_HEADER_ID
        -- AND TRANSACTION_NUMBER='190000013'
         --AND EVENT_TYPE_CODE = :P_TY



--================================
--UN PAID INVOICE  FOR AR
--================================

SELECT hca.account_number,
       hp.party_name,
       rcta.trx_number,
       rcta.trx_date,
       SUM (rctla.extended_amount),
       CASE
          WHEN TRUNC (SYSDATE - rcta.trx_date) BETWEEN 30 AND 60
          THEN
             rcta.trx_number
       END
          "Pending for 30 - 60 days",
       CASE
          WHEN TRUNC (SYSDATE - rcta.trx_date) BETWEEN 60 AND 120
          THEN
             rcta.trx_number
       END
          "Pending for 60 - 120 days",
       CASE
          WHEN TRUNC (SYSDATE - rcta.trx_date) > 120 THEN rcta.trx_number
       END
          "Pending for more than 120 days"
FROM hz_parties hp,
     hz_cust_accounts hca,
     ra_customer_trx_all rcta,
     ra_customer_trx_lines_all rctla
WHERE     hp.party_id = hca.party_id
      --AND rcta.org_id = 204    
AND hca.cust_account_id = rcta.sold_to_customer_id
      AND rcta.customer_trx_id = rctla.customer_trx_id
     -- AND hca.account_number = 3896
     and  rcta.trx_date between '01-Oct-2019' and '30-Oct-2019'
GROUP BY hca.account_number, hp.party_name, rcta.trx_number, rcta.trx_date



--Query to find out Customer Master Information. Customer Name, Account Number, Adress etc.

select p.PARTY_NAME,ca.ACCOUNT_NUMBER,loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code,
loc.country,ca.CUST_ACCOUNT_ID
from apps.ra_customer_trx_all I,
apps.hz_cust_accounts CA,
apps.hz_parties P,
apps.hz_locations Loc,
apps.hz_cust_site_uses_all CSU,
apps.hz_cust_acct_sites_all CAS,
apps.hz_party_sites PS
where I.COMPLETE_FLAG ='Y'
and I.bill_TO_CUSTOMER_ID= CA.CUST_ACCOUNT_ID
and ca.PARTY_ID=p.PARTY_ID
and I.bill_to_site_use_id=csu.site_use_id
and csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
and cas.PARTY_SITE_ID=ps.party_site_id
and ps.location_id=loc.LOCATION_ID

