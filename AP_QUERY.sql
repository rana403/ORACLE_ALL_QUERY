-- GET SUPPLIER INVOICE OR SUPPLIER LEDGER--------------------------
--=-=============================================================

  select * from KBG_AP_SUPPLIER_LEDGER_V where voucher like 'AP INV-200000220' and org_id=104 -- 'AP INV-180001317' 
  
  SELECT * FROM AP_INVOICES_ALL WHERE invoice_id=1405207
  
  SELECT * FROM AP_INVOICE_LINES_ALL WHERE invoice_id=1405207
  
  SELECT * FROM AP_INVOICE_DISTRIBUTIONS_ALL WHERE  invoice_id=1405207


AD.LINE_TYPE_LOOKUP_CODE = 'PREPAY'


--- EBS Supplier Ledger Details
--======================================

SELECT  A.BAL_SEG,
                  A. VENDOR_ID,
                  A.VENDOR_TYPE,
                 TO_CHAR(A.INVOICE_ID) INVOICE_ID,
                   TO_CHAR(A.SL ) Q_SL,
                   A.VENDOR_SITE_ID,
                   A.ACCOUNTING_DATE GL_DATE,
                   A.CLEARED_DATE,
                   (DECODE (A.PARTY_NAME, NULL, NULL, A.PARTY_NAME )
                   || DECODE (A.PARTY_NUM, NULL, NULL, '-'||A.PARTY_NUM))  
                    SUPPLIER,
                   A.VOUCHER VOUCHER_NUM,
                   A.INV_TYPE,
                   A.INVOICE_NUM,
                   A.INVOICE_DATE,
                    (DECODE (A.BANK_ACCOUNT, NULL, NULL,A.BANK_ACCOUNT )
                   || DECODE (A.INSTRUMENT_NUM, NULL, NULL,'-'|| A.INSTRUMENT_NUM))  
                           BANK_ACCOUNT_INSTRUMENT_NUM,
                     (DECODE (A.COST_CENTER, NULL, NULL, A.COST_CENTER )
                    || DECODE (A.PROJECT_NAME, NULL, NULL, '-'||A.PROJECT_NAME)
                    || DECODE (A.INTER_COMPANY, NULL, NULL,'-'|| A.INTER_COMPANY)
                    || DECODE (A.DFF_VALUE, NULL, NULL, '-'|| A.DFF_VALUE)           
                    || DECODE (A.DESCRIPTION, NULL, NULL, '-'|| A.DESCRIPTION))
               --     || DECODE (A.EXCHANGE_RATE, NULL, NULL, '-'||'EXCHANGE_RATE :'|| A.EXCHANGE_RATE))
                          DESCRIPTION,
                   A.PO_NUMBER,
                   A.TRANSECTION_DATE,
                   A.GL_CODE_AND_DESC,
                   (DECODE (A.GL_CODE_AND_DESC, NULL, NULL, A.GL_CODE_AND_DESC )
                   || DECODE (A.SUB_ACCOUNT, NULL, NULL,'-'|| A.SUB_ACCOUNT))  
                      GL_CODE_AND_DESCRIPTION,
                  SUM(NVL(A.DR_AMOUNT ,0) ) DR_AMOUNT, 
                   SUM(NVL(A.CR_AMOUNT ,0) ) CR_AMOUNT,
                   XX_INV_PKG.XXGET_ENAME(:P_USER_ID) USER_NAME
                   FROM 
                    XX_AP_SUPPLIER_LEDGER_V A
                   WHERE A.BAL_SEG=:P_BAL_SEG
                   AND A.VENDOR_ID=:P_SUPPLIER_NAME
                   AND A.ORG_ID=NVL(:P_ORG_ID,A.ORG_ID)
                   AND (:P_PO_NUMBER IS NULL OR A.PO_NUMBER=NVL(:P_PO_NUMBER,A.PO_NUMBER))
                  --AND A.PO_NUMBER=NVL(:P_PO_NUMBER,A.PO_NUMBER)
                  AND A.ACCOUNTING_DATE BETWEEN NVL(:P_DATE_FROM, A.ACCOUNTING_DATE) AND NVL(:P_DATE_TO, A.ACCOUNTING_DATE)
                --AND A.INVOICE_STATUS='APPROVED'
                  AND A.WF_STATUS  in ('MANUALLY APPROVED','WFAPPROVED','NOT REQUIRED')
          HAVING SUM(NVL(A.DR_AMOUNT ,0) )-SUM(NVL(A.CR_AMOUNT ,0) )<>'0'
         -- and A.VOUCHER = '200000220'
              --  AND A.INVOICE_POST_FLAG='Y'
GROUP BY 
A.BAL_SEG,
                A. VENDOR_ID,
                A.VENDOR_TYPE,
                TO_CHAR(A.INVOICE_ID) ,
                   TO_CHAR(A.SL ) ,
                   A.VENDOR_SITE_ID,
                   A.ACCOUNTING_DATE ,
                   A.CLEARED_DATE,
                   A.PARTY_NAME,
                   A.PARTY_NUM ,
                   A.VOUCHER ,
                   A.INV_TYPE,
                   A.INVOICE_NUM,
                   A.INVOICE_DATE,
                   A.BANK_ACCOUNT,
                   A.INSTRUMENT_NUM,
                   A.COST_CENTER,
                   A.PROJECT_NAME,
                   A.INTER_COMPANY,
                  A.DFF_VALUE,
                  A.DESCRIPTION ,
                  A.EXCHANGE_RATE,
                   A.PO_NUMBER,
                   A.TRANSECTION_DATE,
                   A.GL_CODE_AND_DESC,
                   A.GL_CODE_AND_DESC,
                   A.SUB_ACCOUNT ,
                   A.COMPANY ,
                   XX_INV_PKG.XXGET_ENAME(:P_USER_ID)    
                 -- order by  A.ACCOUNTING_DATE,VOUCHER             
UNION ALL
SELECT  A.BAL_SEG,
                  A. VENDOR_ID,
                  A.VENDOR_TYPE,
                 TO_CHAR(A.INVOICE_ID) INVOICE_ID,
                   TO_CHAR(A.SL ) Q_SL,
                   A.VENDOR_SITE_ID,
                   A.ACCOUNTING_DATE GL_DATE,
                   A.CLEARED_DATE,
                   (DECODE (A.PARTY_NAME, NULL, NULL, A.PARTY_NAME )
                   || DECODE (A.PARTY_NUM, NULL, NULL, '-'||A.PARTY_NUM))  
                    SUPPLIER,
                   A.VOUCHER VOUCHER_NUM,
                   A.INV_TYPE,
                   A.INVOICE_NUM,
                   A.INVOICE_DATE,
                    (DECODE (A.BANK_ACCOUNT, NULL, NULL,A.BANK_ACCOUNT )
                   || DECODE (A.INSTRUMENT_NUM, NULL, NULL,'-'|| A.INSTRUMENT_NUM))  
                           BANK_ACCOUNT_INSTRUMENT_NUM,
                     (DECODE (A.COST_CENTER, NULL, NULL, A.COST_CENTER )
                    || DECODE (A.PROJECT_NAME, NULL, NULL, '-'||A.PROJECT_NAME)
                    || DECODE (A.INTER_COMPANY, NULL, NULL,'-'|| A.INTER_COMPANY)
                    || DECODE (A.DFF_VALUE, NULL, NULL, '-'|| A.DFF_VALUE)           
                    || DECODE (A.DESCRIPTION, NULL, NULL, '-'|| A.DESCRIPTION))
               --     || DECODE (A.EXCHANGE_RATE, NULL, NULL, '-'||'EXCHANGE_RATE :'|| A.EXCHANGE_RATE))
                          DESCRIPTION,
                   A.PO_NUMBER,
                   A.TRANSECTION_DATE,
                   A.GL_CODE_AND_DESC,
                   (DECODE (A.GL_CODE_AND_DESC, NULL, NULL, A.GL_CODE_AND_DESC )
                   || DECODE (A.SUB_ACCOUNT, NULL, NULL,'-'|| A.SUB_ACCOUNT))  
                      GL_CODE_AND_DESCRIPTION,
                  SUM(NVL(A.DR_AMOUNT ,0) ) DR_AMOUNT, 
                   SUM(NVL(A.CR_AMOUNT ,0) ) CR_AMOUNT,
                   XX_INV_PKG.XXGET_ENAME(:P_USER_ID) USER_NAME
                   FROM 
                    XX_AP_SUPPLIER_LEDGER_V A
                   WHERE A.BAL_SEG=:P_BAL_SEG
                   AND A.VENDOR_ID=:P_SUPPLIER_NAME
                   AND A.ORG_ID=NVL(:P_ORG_ID,A.ORG_ID)
                   AND (:P_PO_NUMBER IS NULL OR A.PO_NUMBER=NVL(:P_PO_NUMBER,A.PO_NUMBER))
                  --AND A.PO_NUMBER=NVL(:P_PO_NUMBER,A.PO_NUMBER)
                  AND A.ACCOUNTING_DATE BETWEEN NVL(:P_DATE_FROM, A.ACCOUNTING_DATE) AND NVL(:P_DATE_TO, A.ACCOUNTING_DATE)
                --AND A.INVOICE_STATUS='APPROVED'
                  AND A.WF_STATUS  in ('MANUALLY APPROVED','WFAPPROVED','NOT REQUIRED')
          HAVING SUM(NVL(A.DR_AMOUNT ,0) )-SUM(NVL(A.CR_AMOUNT ,0) )='0'
         -- and A.VOUCHER = '200000220'
              --  AND A.INVOICE_POST_FLAG='Y'
GROUP BY 
A.BAL_SEG,
                A. VENDOR_ID,
                A.VENDOR_TYPE,
                TO_CHAR(A.INVOICE_ID) ,
                   TO_CHAR(A.SL ) ,
                   A.VENDOR_SITE_ID,
                   A.ACCOUNTING_DATE ,
                   A.CLEARED_DATE,
                   A.PARTY_NAME,
                   A.PARTY_NUM ,
                   A.VOUCHER ,
                   A.INV_TYPE,
                   A.INVOICE_NUM,
                   A.INVOICE_DATE,
                   A.BANK_ACCOUNT,
                   A.INSTRUMENT_NUM,
                   A.COST_CENTER,
                   A.PROJECT_NAME,
                   A.INTER_COMPANY,
                  A.DFF_VALUE,
                  A.DESCRIPTION ,
                  A.EXCHANGE_RATE,
                   A.PO_NUMBER,
                   A.TRANSECTION_DATE,
                   A.GL_CODE_AND_DESC,
                   A.GL_CODE_AND_DESC,
                   A.SUB_ACCOUNT ,
                   A.COMPANY ,
                   XX_INV_PKG.XXGET_ENAME(:P_USER_ID) 
        order by  A.ACCOUNTING_DATE,VOUCHER







--GET UNACCOUNTED TRANSACTION --> BEFORE CLOSING PERIOD 

SELECT * -- INVOICE_NUM
FROM AP_INVOICES_ALL
WHERE AP_INVOICES_PKG.GET_APPROVAL_STATUS
(INVOICE_ID,
INVOICE_AMOUNT,
PAYMENT_STATUS_FLAG,
INVOICE_TYPE_LOOKUP_CODE
) ='APPROVED'
AND AP_INVOICES_PKG.GET_POSTING_STATUS(INVOICE_ID)='N'
and INVOICE_DATE between '01-FEB-2021' and '15-FEB-2021'   


select * from GL_CODE_COMBINATIONS where segment4 =  2030105

select * from GL_CODE_COMBINATIONs_KFV where CONCATENATED_SEGMENTS = '102.03.0000.2030105.001.0000.000.000.000.000'


-- ACCOUNT WISE LEDGER

/*EBS GL Account Wise Ledger*/
SELECT D.BAL_SEG, D.BAL_SEG_NAME,B.LEDGER_ID,A.ACCOUNTING_DATE,
--DECODE(A.APPLICATION_ID, 200,'AP-'||DOC_SEQUENCE_VALUE, 222,'AR-'||DOC_SEQUENCE_VALUE, DOC_SEQUENCE_VALUE) VOUCHER_NUMBER
 DECODE(EVENT_TYPE_CODE, 'REFUND RECORDED','AP PAY','PAYMENT CREATED','AP PAY','PAYMENT CLEARED','AP PAY','PAYMENT CANCELLED','AP PAY','REFUND CANCELLED','AP PAY',
          'PREPAYMENT APPLIED','AP INV','PREPAYMENT CANCELLED','AP INV','CREDIT MEMO VALIDATED','AP INV','INVOICE CANCELLED','AP INV',
          'PREPAYMENT UNAPPLIED','AP INV','INVOICE VALIDATED','AP INV','PREPAYMENT VALIDATED','AP INV','CREDIT MEMO CANCELLED','AP INV',
          'CM_CREATE','AR INV','DM_CREATE','AR INV','INV_CREATE','AR INV','CM_UPDATE','AR INV','RECP_CREATE','AR RCV',
          'MISC_RECP_CREATE','AR RCV','MISC_RECP_REVERSE','AR RCV','RECP_REVERSE','AR RCV','RECP_UPDATE','AR RCV')||'-'|| DOC_SEQUENCE_VALUE VOUCHER_NUMBER
           ,EVENT_TYPE_CODE,A.AE_HEADER_ID, A.APPLICATION_ID,XX_PARTY_VENDOR_NAME_FUNCTION(A.APPLICATION_ID, PARTY_ID) PARTY_VENDOR_NAME,
      B.JE_CATEGORY_NAME,
           SEGMENT4,
XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) ACCOUNT_DESC, 
XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT,
PARTY_ID,
           XX_OPOSITE_HEAD_FUNCTION(:P_ACCOUNT_CODE, A.AE_HEADER_ID) OPOSITE_HEAD,
             DECODE( XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, b.event_id) ,  NULL , NULL, XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, b.event_id)||'.')
    ||   DECODE( XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID) ,  NULL , NULL, XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID)||'.' )
    ||   DECODE( XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME) ,  NULL , NULL,
    XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME)||'.' ) DFF_INFO,
           NVL(SUM(ACCOUNTED_DR),0) DR_AMT,NVL(SUM(ACCOUNTED_CR),0) CR_AMT 
           FROM XLA_AE_LINES A, XLA_AE_HEADERS B, GL_CODE_COMBINATIONS C, XX_BAL_SEG_INFO D
           WHERE C.CODE_COMBINATION_ID=A.CODE_COMBINATION_ID
           AND  A.AE_HEADER_ID=B.AE_HEADER_ID
           AND SEGMENT4=:P_ACCOUNT_CODE
           AND B.LEDGER_ID=D.LEDGER_ID
           AND A.ACCOUNTING_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
           AND A.ACCOUNTING_DATE>'31-AUG-2018'
           AND BAL_SEG=:P_BAL_SEG
AND SEGMENT5=NVL(:P_SUB_ACC,SEGMENT5)
           GROUP BY 
           D.BAL_SEG, D.BAL_SEG_NAME,B.LEDGER_ID,A.ACCOUNTING_DATE,
            DECODE(EVENT_TYPE_CODE, 'REFUND RECORDED','AP PAY','PAYMENT CREATED','AP PAY','PAYMENT CLEARED','AP PAY','PAYMENT CANCELLED','AP PAY','REFUND CANCELLED','AP PAY',
          'PREPAYMENT APPLIED','AP INV','PREPAYMENT CANCELLED','AP INV','CREDIT MEMO VALIDATED','AP INV','INVOICE CANCELLED','AP INV',
          'PREPAYMENT UNAPPLIED','AP INV','INVOICE VALIDATED','AP INV','PREPAYMENT VALIDATED','AP INV','CREDIT MEMO CANCELLED','AP INV',
          'CM_CREATE','AR INV','DM_CREATE','AR INV','INV_CREATE','AR INV','CM_UPDATE','AR INV','RECP_CREATE','AR RCV',
          'MISC_RECP_CREATE','AR RCV','MISC_RECP_REVERSE','AR RCV','RECP_REVERSE','AR RCV','RECP_UPDATE','AR RCV')||'-'|| DOC_SEQUENCE_VALUE
           ,EVENT_TYPE_CODE,A.AE_HEADER_ID, A.APPLICATION_ID,XX_PARTY_VENDOR_NAME_FUNCTION(A.APPLICATION_ID, PARTY_ID) ,
          B.JE_CATEGORY_NAME,
           SEGMENT4,XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) , PARTY_ID,
          XX_OPOSITE_HEAD_FUNCTION(:P_ACCOUNT_CODE, A.AE_HEADER_ID),
             DECODE( XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, b.event_id) ,  NULL , NULL, XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, b.event_id)||'.')
    ||   DECODE( XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID) ,  NULL , NULL, XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID)||'.' )
    ||   DECODE( XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME) ,  NULL , NULL,
    XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME)||'.' ) ,
XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4)
UNION ALL
select b.bal_seg, bal_seg_name,a.ledger_id, EFFECTIVE_DATE ACCOUNTING_DATE, to_char(DOC_SEQUENCE_VALUE) VOUCHER_NUMBER,null, null, null, null, null JE_CATEGORY_NAME,segment4,
XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) ACCOUNT_DESC, 
XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT,
 null, null, a.DESCRIPTION ,
 nvl(ACCOUNTED_DR,0) ACCOUNTED_DR, nvl(ACCOUNTED_CR,0) ACCOUNTED_CR
  from gl_je_lines a, xx_bal_seg_info b, gl_code_combinations c, GL_JE_HEADERS d
   where a.je_header_id=d.je_header_id
and a.ledger_id=b.ledger_id
and a.JE_HEADER_ID=d.JE_HEADER_ID
and a.code_combination_id=c.code_combination_id
--and a.PERIOD_NAME='Aug-18'
AND EFFECTIVE_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
and   SEGMENT4=:P_ACCOUNT_CODE
 AND BAL_SEG=:P_BAL_SEG
AND SEGMENT5=NVL(:P_SUB_ACC,SEGMENT5)
--AND JE_SOURCE='Manual'
--AND JE_SOURCE in ('Manual','Assets') 
AND d.JE_SOURCE in ('Inventory',
'Receivables', 
'Cash Management',
'Manual',
'Assets',
'Payables') 
--AND  ACCRUAL_REV_STATUS is null
AND ACCRUAL_REV_JE_HEADER_ID IS NOT NULL 
ORDER BY ACCOUNTING_DATE,VOUCHER_NUMBER



-- AP INVOICE VOUCHER 

 SELECT SL,
 XX_GET_EMP_NAME_FROM_USER_ID(:P_USER_ID) USER_NAME,
         XX_GET_HR_OPERATING_UNIT (ORG_ID) UNIT,
         GET_FLEX_VALUES_FROM_FLEX_ID (BAL_SEG, 1) COMPANY_SHORT_NAME,
         INVOICE_ID,
         XX_GET_PARTY_NAME (PARTY_ID) SUPPLIER,
         XX_GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
        XX_GET_VENDOR_NUMBER_SITE_ID (INVOICE_ID)SUPPLIER_SITE,
         INVOICE_NUM,
         INVOICE_DATE,
         GL_DATE,
         XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) CREATED_BY,
         CREATION_DATE,
         XX_GET_RECEIPT_NUMBER_FROM_INV (INVOICE_ID) RECEIPT_NUM,
         GET_MAX_CHECK_NUM_FROM_INVOICE (INVOICE_ID) CHECK_NUMBER,
         GET_MAX_CHK_DATE_FROM_INVOICE (INVOICE_ID) CHECK_DATE,
         GET_MAX_ACCT_NAME_FROM_INVOICE (INVOICE_ID) BANK_ACCT_NUM,
         XX_GET_INVOICE_CURRENCY_CODE (INVOICE_ID) CURRENCY_CODE,
         VOUCHER,
         GL_CODE_AND_DESC,
         DESCRIPTION,
DFF_INFO,
         DECODE (SIGN (SUM (DR_AMOUNT - CR_AMOUNT)), -1, 0, SUM (DR_AMOUNT - CR_AMOUNT)) DR_AMOUNT,
         DECODE (SIGN (SUM (CR_AMOUNT - DR_AMOUNT)), -1, 0, SUM (CR_AMOUNT - DR_AMOUNT)) CR_AMOUNT,
       ATTRIBUTE_CATEGORY,
      ATTRIBUTE1,
       ATTRIBUTE2,
      ATTRIBUTE3,
      ATTRIBUTE4,
      ATTRIBUTE5,
      RCV_TRANSACTION_ID,
     PO_DISTRIBUTION_ID
    FROM XX_AP_INVOICE_VOUCHER_V
   WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(GL_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR VOUCHER BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
     --    AND (:P_EMP_NUM IS NULL OR XX_GET_USER_NAME (CREATED_BY) = :P_EMP_NUM)
         --AND XX_GET_INVOICE_STATUS (INVOICE_ID) IN  ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
GROUP BY SL,
         ORG_ID,
         BAL_SEG,
         INVOICE_ID,
         PARTY_ID,
         VENDOR_ID,
         INVOICE_NUM,
         INVOICE_DATE,
         GL_DATE,
         CREATED_BY,
         CREATION_DATE,
         VOUCHER,
         GL_CODE_AND_DESC,
         DESCRIPTION, 
DFF_INFO,
ATTRIBUTE_CATEGORY,
   ATTRIBUTE1,
   ATTRIBUTE2,
   ATTRIBUTE3,
   ATTRIBUTE4,
   ATTRIBUTE5,
  RCV_TRANSACTION_ID,
  PO_DISTRIBUTION_ID
HAVING DECODE (SIGN (SUM (DR_AMOUNT - CR_AMOUNT)), -1, 0, SUM (DR_AMOUNT - CR_AMOUNT)) + DECODE (SIGN (SUM (CR_AMOUNT - DR_AMOUNT)), -1, 0, SUM (CR_AMOUNT - DR_AMOUNT)) >0
ORDER BY ORG_ID, VOUCHER ASC,DR_AMOUNT DESC

--===================================
--GRN CREATED BUT NOT INVOICES
--===================================
SELECT 
distinct PHA.org_id,
SUBSTR(XX_GET_HR_OPERATING_UNIT (PHA.ORG_ID),5) OPERATING_UNIT,
--XX_INV_PKG.XXGET_ORG_LOCATION (PHA.ORG_ID) ORG_ADDRESS,
--RT.ORGANIZATION_ID INV_ORG,
INVORG_NAME_FROM_ID (RT.ORGANIZATION_ID) INV_ORG_NAME,
     pha.ATTRIBUTE1 PO_TYPE,
      PHA.SEGMENT1 PO_NUMBER,
 TO_CHAR(TRUNC( PHA.APPROVED_DATE),'DD-MON-RRRR') PO_APPROVED_DATE,
          RH.RECEIPT_NUM GRN_NUMBER, 
  TO_CHAR(TRUNC( RT.CREATION_DATE),'DD-MON-RRRR') GRN_DATE,
       ASP.VENDOR_NAME,
      -- ASP.SEGMENT1 VENDOR_NO,
       --PHA.APPROVED_DATE  PO_APPROVED_DATE,
           PLA.ITEM_DESCRIPTION,
 --    (PLA.UNIT_PRICE* PLA.QUANTITY) PO_AMOUNT,
            NULL INVOICE_NUM,
            NULL INVOICE_DATE,
            NULL GL_DATE,
            NULL INVOICE_AMOUNT,
            NULL INV_VOUCHER_NO,
            NULL INV_CREATED_BY,
          NULL DIST_GL_CODE,
          NULL PAYMENT_VOUCHER,
          NULL PAY_CREATE_DATE,
          NULL PAYMENT_TYPE,
          NULL PAYMENT_STATUS,
          NULL PAY_AMOUNT,
         XX_ONT_GET_ENAME(:P_USER) PRINTED_BY 
 from PO_HEADERS_ALL PHA, PO_LINES_ALL PLA, PO_LINE_LOCATIONS_ALL PLL,PO_DISTRIBUTIONS_ALL PDA, AP_SUPPLIERS ASP,
 RCV_TRANSACTIONS RT,RCV_SHIPMENT_LINES RL, RCV_SHIPMENT_HEADERS RH
 WHERE PHA.PO_HEADER_ID =PLA.PO_HEADER_ID
 and PHA.po_header_id = PLA.po_header_id
 and PLA.po_line_id= pll.po_line_id
 and PHA.po_header_id= pll.po_header_id
 and PHA.PO_HEADER_ID= PLA.PO_HEADER_ID
 AND PLA.PO_LINE_ID= PDA.PO_LINE_ID
 AND PLA.QUANTITY <> 0
 AND PHA.PO_HEADER_ID= RT.PO_HEADER_ID
 AND PLA.PO_LINE_ID= RT.PO_LINE_ID
 AND PDA.GL_CANCELLED_DATE is NULL
 AND RT.TRANSACTION_TYPE= 'DELIVER'
    AND PDA.PO_DISTRIBUTION_ID NOT IN
      (SELECT PO_DISTRIBUTION_ID FROM PO_DISTRIBUTIONS_ALL PDA
       WHERE PO_DISTRIBUTION_ID IN (SELECT DISTINCT  PO_DISTRIBUTION_ID FROM AP_INVOICE_DISTRIBUTIONS_ALL))
 AND RH.SHIPMENT_HEADER_ID= RT.SHIPMENT_HEADER_ID
 AND RH.SHIPMENT_HEADER_ID= RL.SHIPMENT_HEADER_ID
 AND RL.SHIPMENT_LINE_ID= RT.SHIPMENT_LINE_ID
 AND ASP.VENDOR_ID= PHA.VENDOR_ID
   AND (:P_ORG_ID IS NULL OR PHA.ORG_ID = :P_ORG_ID)
  AND (:P_GRN_FROM_DT IS NULL OR TRUNC(RT.CREATION_DATE) BETWEEN :P_GRN_FROM_DT AND :P_GRN_TO_DT) 
  AND (:P_PO_NO IS NULL OR PHA.segment1 = :P_PO_NO) 
  AND (:P_GRN_NO IS NULL OR rh.receipt_num = :P_GRN_NO) 
  ORDER BY INV_ORG_NAME ,GRN_NUMBER ASC -- RT.ORGANIZATION_ID 
  
  --=========================================================================









--=================================================

--=================================================

SELECT MAX(JE_HEADER_ID )
--INTO V_JE_HEADER_ID
FROM GL_JE_HEADERS
WHERE JE_SOURCE = 'Payables'
AND JE_CATEGORY= 'Purchase Invoices';


SELECT GL_SL_LINK_ID
FROM GL_IMPORT_REFERENCES
WHERE JE_HEADER_ID = 194378;

SELECT DISTINCT AE_HEADER_ID
--INTO V_AE_HEADER_ID
FROM XLA_AE_LINES
WHERE GL_SL_LINK_ID IN (SELECT GL_SL_LINK_ID
FROM GL_IMPORT_REFERENCES
WHERE JE_HEADER_ID = 194378
);

SELECT ENTITY_ID
--INTO V_ENTITY_ID
FROM XLA_AE_HEADERS
WHERE AE_HEADER_ID = 31516317;

SELECT * --SOURCE_ID_INT_1
--INTO V_SOURCE_ID
FROM XLA_TRANSACTION_ENTITIES
WHERE ENTITY_ID = '3285708';
 --V_ENTITY_ID;



CREATE OR REPLACE FUNCTION GET_GRN_FROM_SHIPMNT_LINE_ID(P_SHIPMENT_LINE_ID IN NUMBER)
RETURN NUMBER
IS
V_GRN_NO NUMBER;
BEGIN
SELECT DISTINCT RH.RECEIPT_NUM INTO V_GRN_NO
FROM RCV_SHIPMENT_HEADERS RH, RCV_SHIPMENT_LINES RL 
 WHERE RH.SHIPMENT_HEADER_ID= RL.SHIPMENT_HEADER_ID
 AND RL.SHIPMENT_LINE_ID = P_SHIPMENT_LINE_ID;
 RETURN V_GRN_NO;
 EXCEPTION WHEN OTHERS THEN 
 RETURN NULL;
END;


select * from XLA_AE_LINES WHERE AE_HEADER_ID=20622651
 --20402010
 
select * from XLA_AE_LINES WHERE AE_HEADER_ID =20402010 


SELECT  DISTINCT  RH.RECEIPT_NUM, NVL(SUM(AL.BASE_AMOUNT),0)
FROM ap.ap_invoices_all aia, AP_INVOICE_LINES_ALL AL, RCV_SHIPMENT_LINES RL, RCV_SHIPMENT_HEADERS RH,
xla.xla_transaction_entities XTE,
xla.xla_events xev,
xla.xla_ae_headers XAH
WHERE aia.INVOICE_ID = xte.source_id_int_1
and AIA.INVOICE_ID= AL.INVOICE_ID
and AL.RCV_SHIPMENT_LINE_ID = RL.SHIPMENT_LINE_ID 
and RH.SHIPMENT_HEADER_ID = RL.SHIPMENT_HEADER_ID
AND xev.entity_id = xte.entity_id
AND xah.entity_id = xte.entity_id
AND XAH.AE_HEADER_ID= 20622575
GROUP BY  RH.RECEIPT_NUM
 

--=====================================
--SQL QUERY USING LINK BETWEEN  AP AND XLA TABLES
--=====================================
SELECT 
-- distinct aia.INVOICE_ID , XAH.AE_HEADER_ID, XX_GET_GRN_FROM_AE_HEADERID(AE_HEADER_ID),
--(select DISTINCT RH.RECEIPT_NUM FROM RCV_SHIPMENT_HEADERS RH, RCV_SHIPMENT_LINES RL, AP_INVOICE_LINES_ALL AL
--WHERE RH.SHIPMENT_HEADER_ID = RL.SHIPMENT_HEADER_ID
--and AL.RCV_SHIPMENT_LINE_ID = RL.SHIPMENT_LINE_ID 
--and AIA.INVOICE_ID= AL.INVOICE_ID
--AND RL.SHIPMENT_LINE_ID = 19001),
aia.invoice_id,
aia.INVOICE_NUM ,
AIA.DOC_SEQUENCE_VALUE,
aia.INVOICE_DATE ,
aia.INVOICE_AMOUNT ,
aia.INVOICE_CURRENCY_CODE ,
aia.PAYMENT_CURRENCY_CODE ,
aia.GL_DATE ,
xah.PERIOD_NAME ,
aia.PAYMENT_METHOD_CODE ,
xah.JE_CATEGORY_NAME
FROM ap_invoices_all aia, AP_INVOICE_LINES_ALL AL, 
xla.xla_transaction_entities XTE,
xla.xla_events xev,
xla.xla_ae_headers XAH,
xla.xla_ae_lines XAL,
GL_IMPORT_REFERENCES gir,
gl_je_headers gjh,
gl_je_lines gjl,
gl_code_combinations gcc
WHERE 1=1
and AIA.INVOICE_ID= AL.INVOICE_ID
and aia.INVOICE_ID = xte.source_id_int_1
AND xev.entity_id = xte.entity_id
AND xah.entity_id = xte.entity_id
and aia.invoice_id= 237080
--and XAH.AE_HEADER_ID =20622575 -- 16199209
AND xah.event_id = xev.event_id
AND XAH.ae_header_id = XAL.ae_header_id
AND XAH.je_category_name = 'Purchase Invoices'
AND XAH.gl_transfer_status_code = 'Y'
AND XAL.GL_SL_LINK_ID = gir.GL_SL_LINK_ID
AND gir.GL_SL_LINK_TABLE = xal.GL_SL_LINK_TABLE
AND gjl.JE_HEADER_ID = gjh.JE_HEADER_ID
AND gjh.JE_HEADER_ID = gir.JE_HEADER_ID
AND gjl.JE_HEADER_ID = gir.JE_HEADER_ID
AND gir.JE_LINE_NUM = gjl.JE_LINE_NUM


--=====================================
--SQL QUERY USING LINK BETWEEN INVENTORY , AP AND XLA TABLES
--=====================================
SELECT DISTINCT RH.RECEIPT_NUM,
-- distinct aia.INVOICE_ID , XAH.AE_HEADER_ID, XX_GET_GRN_FROM_AE_HEADERID(AE_HEADER_ID),
--(select DISTINCT RH.RECEIPT_NUM FROM RCV_SHIPMENT_HEADERS RH, RCV_SHIPMENT_LINES RL, AP_INVOICE_LINES_ALL AL
--WHERE RH.SHIPMENT_HEADER_ID = RL.SHIPMENT_HEADER_ID
--and AL.RCV_SHIPMENT_LINE_ID = RL.SHIPMENT_LINE_ID 
--and AIA.INVOICE_ID= AL.INVOICE_ID
--AND RL.SHIPMENT_LINE_ID = 19001),
aia.invoice_id,
aia.INVOICE_NUM ,
AIA.DOC_SEQUENCE_VALUE,
aia.INVOICE_DATE ,
aia.INVOICE_AMOUNT ,
aia.INVOICE_CURRENCY_CODE ,
aia.PAYMENT_CURRENCY_CODE ,
aia.GL_DATE ,
xah.PERIOD_NAME ,
aia.PAYMENT_METHOD_CODE ,
xah.JE_CATEGORY_NAME
FROM ap_invoices_all aia, AP_INVOICE_LINES_ALL AL, RCV_SHIPMENT_LINES RL, RCV_SHIPMENT_HEADERS RH,
xla.xla_transaction_entities XTE,
xla.xla_events xev,
xla.xla_ae_headers XAH
--xla.xla_ae_lines XAL,
--GL_IMPORT_REFERENCES gir,
--gl_je_headers gjh,
--gl_je_lines gjl,
--gl_code_combinations gcc
WHERE 1=1
and AIA.INVOICE_ID= AL.INVOICE_ID
and AL.RCV_SHIPMENT_LINE_ID = RL.SHIPMENT_LINE_ID 
and RH.SHIPMENT_HEADER_ID = RL.SHIPMENT_HEADER_ID
and aia.INVOICE_ID = xte.source_id_int_1
AND xev.entity_id = xte.entity_id
AND xah.entity_id = xte.entity_id
--and aia.invoice_id= 237080
and AE_HEADER_ID =20622575 -- 16199209


AND xah.event_id = xev.event_id
AND XAH.ae_header_id = XAL.ae_header_id
AND XAH.je_category_name = 'Purchase Invoices'
AND XAH.gl_transfer_status_code = 'Y'
AND XAL.GL_SL_LINK_ID = gir.GL_SL_LINK_ID
AND gir.GL_SL_LINK_TABLE = xal.GL_SL_LINK_TABLE
AND gjl.JE_HEADER_ID = gjh.JE_HEADER_ID
AND gjh.JE_HEADER_ID = gir.JE_HEADER_ID
AND gjl.JE_HEADER_ID = gir.JE_HEADER_ID
AND gir.JE_LINE_NUM = gjl.JE_LINE_NUM




--=======================================
--QUERY TO GET UNPAID INVOICES (ORACLE PAYABLES)
--======================================

select    aia.ORG_ID,aia.invoice_num,     
       aia.invoice_currency_code,
       DECODE(aia.PAYMENT_STATUS_FLAG,'N','UN-PAID','P','Partial Paid','Y','PAID') PAYMENT_STATUS_FLAG ,
       aia.invoice_date,
       aps.vendor_name,
       apss.vendor_site_code,
       aila.line_number,
       aia.invoice_amount,
       aila.amount line_amount,
       pha.segment1 po_number,
       aila.line_type_lookup_code,
       apt.name Term_name,     
       gcc.concatenated_segments distributed_code_combinations,
       aca.check_number,
       aipa.amount payment_amount,
       apsa.amount_remaining,
       aipa.invoice_payment_type,
       hou.name operating_unit,
       gl.name ledger_name  
  from apps.ap_invoices_all         aia,
       ap_invoice_lines_all         aila,
       ap_invoice_distributions_all aida,
       ap_suppliers aps,
       ap_supplier_sites_all apss,
       po_headers_all pha,
       gl_code_combinations_kfv gcc,
       ap_invoice_payments_all aipa,
       ap_checks_all aca,
       ap_payment_schedules_all apsa,
       ap_terms apt,
       hr_operating_units hou,
       gl_ledgers gl
 where aia.invoice_id = aila.invoice_id
 AND aps.vendor_id=apss.VENDOR_ID
   and aia.po_header_id=pha.po_header_id(+)
   and aida.dist_code_combination_id=gcc.code_combination_id
   and aipa.invoice_id(+)=aia.invoice_id
   and aca.check_id   (+)=aipa.check_id
   and apsa.invoice_id=aia.invoice_id
   and apt.term_id=aia.terms_id
   and hou.organization_id=aia.org_id
   and gl.ledger_id=aia.set_of_books_id
   and aia.ORG_ID=:P_ORG_ID
   and aila.invoice_id = aida.invoice_id
   and aila.line_number = aida.invoice_line_number
   and aia.vendor_id=aps.vendor_id
   and aia.PAYMENT_STATUS_FLAG<> 'Y'
   and  aia.invoice_date between '01-SEP-2018' and '30-sep-2018'
   and aia.VENDOR_SITE_ID=APSS.VENDOR_SITE_ID
  
--==========================================
-- GET OPOSIT ACCOUNT IN ONE LINE  QUERY AND FUNCTION 
--=========================================
--QUERY
SELECT DISTINCT LISTAGG (XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4), ',')
                      WITHIN GROUP (ORDER BY SEGMENT4) 
                       FROM(
                      SELECT DISTINCT SEGMENT4, XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) FROM 
                       XLA_AE_LINES XA, GL_CODE_COMBINATIONS XB
           WHERE  XA.CODE_COMBINATION_ID=XB.CODE_COMBINATION_ID
           AND XA.AE_HEADER_ID=27181884 --P_AE_HEADER_ID
           --AND SEGMENT4<> P_ACCOUNT_CODE
           )
           
 -- FUNCTION 
 --CREATE OR REPLACE FUNCTION APPS.XX_OPOSITE_HEAD_FUNCTION( P_ACCOUNT_CODE IN NUMBER, P_AE_HEADER_ID IN NUMBER )
RETURN VARCHAR2 IS v_out varchar2(3000);
BEGIN
 SELECT DISTINCT LISTAGG (XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4), ',')
                      WITHIN GROUP (ORDER BY SEGMENT4) INTO V_OUT
                       FROM(
                      SELECT DISTINCT SEGMENT4, XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) FROM 
                       XLA_AE_LINES XA, GL_CODE_COMBINATIONS XB
           WHERE  XA.CODE_COMBINATION_ID=XB.CODE_COMBINATION_ID
           AND XA.AE_HEADER_ID=P_AE_HEADER_ID
           AND SEGMENT4<> P_ACCOUNT_CODE);
RETURN v_out;
exception
when others then
return NULL;
end;
/

--=======================================
-- GET  MORE GRN NUMBER AGAINST A INVOICE IN A LINE  QUERY AND FUNCTION
--======================================
--QUERY
SELECT DISTINCT RECEIPT_NUMBER
           FROM AP_INVOICE_LINES_V
          WHERE INVOICE_ID = 1273132 --P_INVOICE_ID

--FUNCTION 
--CREATE OR REPLACE FUNCTION APPS.XX_GET_RECEIPT_NUMBER_FROM_INV (P_INVOICE_ID NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT        AP_INVOICE_LINES_V.RECEIPT_NUMBER%TYPE;
      V_RESULT_LIST   VARCHAR2 (2000) := NULL;

      CURSOR P_CURSOR
      IS
         SELECT DISTINCT RECEIPT_NUMBER
           FROM AP_INVOICE_LINES_V
          WHERE INVOICE_ID = P_INVOICE_ID;
   BEGIN
      OPEN P_CURSOR;

      LOOP
         FETCH P_CURSOR INTO V_RESULT;

         EXIT WHEN P_CURSOR%NOTFOUND;

         IF (V_RESULT_LIST IS NOT NULL)
         THEN
            V_RESULT_LIST := V_RESULT_LIST || ', ';
         END IF;

         V_RESULT_LIST := V_RESULT_LIST || V_RESULT;
      END LOOP;

      CLOSE P_CURSOR;

      RETURN (V_RESULT_LIST);
   END;



--========================================
--How to find a AP invoice is validated or not 
--=========================================

SELECT i.invoice_id,
       i.invoice_amount,
       DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(i.invoice_id, i.invoice_amount,i.payment_status_flag,i.invoice_type_lookup_code),
               'NEVER APPROVED', 'Never Validated',
               'NEEDS REAPPROVAL', 'Needs Revalidation',
               'CANCELLED', 'Cancelled', 
               'Validated') INVOICE_STATUS
  FROM ap_invoices_all i
 --WHERE i.invoice_num = :Invoice_Number;



--====================================
-- AKG INVOICE VOUCHER
--====================================


select  UNIT,
             COMPANY_SHORT_NAME,
             INVOICE_ID,
             SUPPLIER,
             VENDOR_NUM,
             INVOICE_NUM,
             INVOICE_DATE,
             GL_DATE,
             CREATED_BY,
             CREATION_DATE,
             EXCHANGE_RATE,
             INVOICE_AMOUNT,
             VOUCHER,
             RECEIPT_NUM,
             CHECK_NUMBER,
             CHECK_DATE,
             BANK_ACCT_NUM,
             CURRENCY_CODE,
             GL_CODE_AND_DESC,
             DESCRIPTION,
             cost_center,
decode(sign(amount),-1,0,amount) DR_AMOUNT,
decode(sign(amount),-1,abs(amount),0) CR_AMOUNT
from(select UNIT, 
             COMPANY_SHORT_NAME,
             INVOICE_ID,
             SUPPLIER,
             VENDOR_NUM,
             INVOICE_NUM,
             INVOICE_DATE,
             GL_DATE,
             CREATED_BY,
             CREATION_DATE,
             EXCHANGE_RATE,
             INVOICE_AMOUNT,
             VOUCHER,
             RECEIPT_NUM,
             CHECK_NUMBER,
             CHECK_DATE,
             BANK_ACCT_NUM,
             CURRENCY_CODE,
             GL_CODE_AND_DESC,
             DESCRIPTION,
             cost_center,
             sum(decode(DR_AMOUNT,0,CR_AMOUNT*-1,DR_AMOUNT)) AMOUNT
         --,CASE WHEN (sum(decode(DR_AMOUNT,0,CR_AMOUNT*-1,DR_AMOUNT)))< 0 ELSE 0 DR_AMOUNT CR_AMOUNT  
         from ( SELECT 1 SL,
          'DST' SOURCE,
          APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
          APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME,
          AI.INVOICE_ID,
          apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
          apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
          AI.CREATION_DATE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE VOUCHER,
          apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
          apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
          apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
          apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
          apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (AD.DIST_CODE_COMBINATION_ID)GL_CODE_AND_DESC,
          AD.DESCRIPTION,
--          GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0),
--          (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))),
         DECODE (SIGN (SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))) DR_AMOUNT,
         DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) CR_AMOUNT,
         apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID,2)cost_center
     FROM apps.AP_INVOICES_ALL AI,
          apps.AP_INVOICE_DISTRIBUTIONS_ALL AD,
          apps.GL_CODE_COMBINATIONS GC
    WHERE     AI.INVOICE_ID = AD.INVOICE_ID
          AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND AD.LINE_TYPE_LOOKUP_CODE NOT IN ('AWT', 'PREPAY', 'ERV')
          AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
          AND NVL (AD.BASE_AMOUNT, AD.AMOUNT) <> 0
         AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
  GROUP BY AI.ORG_ID,
          GC.SEGMENT1,
          AI.INVOICE_ID,
          AI.PARTY_ID,
          AI.VENDOR_ID,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          AI.CREATED_BY,
          AI.CREATION_DATE,
          AI.INVOICE_CURRENCY_CODE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE ,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (
          AD.DIST_CODE_COMBINATION_ID),
          AD.DESCRIPTION,
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID,2)
   UNION ALL
   SELECT 2 SL,
          'ERV' SOURCE,
          APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
          APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME,
          AI.INVOICE_ID,
          apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
          apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
          AI.CREATION_DATE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE VOUCHER,
          apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
          apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
          apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
          apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
          apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (FP.RATE_VAR_GAIN_CCID)GL_CODE_AND_DESC,
          AD.DESCRIPTION,
          --GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0),
          --(0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))),
          DECODE (SIGN (SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))) DR_AMOUNT,
          DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) CR_AMOUNT,
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID ( FP.RATE_VAR_GAIN_CCID,2)cost_center
     FROM apps.AP_INVOICES_ALL AI,
          apps.AP_INVOICE_DISTRIBUTIONS_ALL AD,
          apps.GL_CODE_COMBINATIONS GC,
          apps.FINANCIALS_SYSTEM_PARAMS_ALL FP
    WHERE     AI.INVOICE_ID = AD.INVOICE_ID
          AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND AI.ORG_ID = FP.ORG_ID
          AND NVL (AD.LINE_TYPE_LOOKUP_CODE, 'AKG') = 'ERV'
          AND AI.CANCELLED_DATE IS NULL
          AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
          AND NVL (AD.BASE_AMOUNT, AD.AMOUNT) <> 0
          AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
GROUP BY     
          AI.ORG_ID,
          GC.SEGMENT1,
          AI.INVOICE_ID,
          AI.PARTY_ID,
          AI.VENDOR_ID,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          AI.CREATED_BY,
          AI.CREATION_DATE,
          AI.INVOICE_CURRENCY_CODE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE ,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (FP.RATE_VAR_GAIN_CCID),
          AD.DESCRIPTION,
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (
             FP.RATE_VAR_GAIN_CCID,
             2)
   UNION ALL
   SELECT 3 SL,
          'RND'SOURCE,
          APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
          APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME,
          AI.INVOICE_ID,
          apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
          apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
          AI.CREATION_DATE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE VOUCHER,
          apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
          apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
          apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
          apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
          apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (SP.ROUNDING_ERROR_CCID)GL_CODE_AND_DESC,
          AI.DESCRIPTION,
--          GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0),
--          (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0))),
         DECODE (SIGN (SUM (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)- (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)- (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0))))) DR_AMOUNT,
         DECODE (SIGN (SUM (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)) - (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)) - (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)))) CR_AMOUNT,
         apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (SP.ROUNDING_ERROR_CCID,2)cost_center
     FROM apps.AP_INVOICES_ALL AI,
          apps.AP_INVOICE_DISTRIBUTIONS_ALL AD,
          apps.AP_PREPAY_APP_DISTS PD,
          apps.GL_CODE_COMBINATIONS GC,
          apps.AP_SYSTEM_PARAMETERS_ALL SP
    WHERE     AI.ORG_ID = SP.ORG_ID
          AND AI.INVOICE_ID = AD.INVOICE_ID
          AND AD.INVOICE_DISTRIBUTION_ID = PD.INVOICE_DISTRIBUTION_ID
          AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND AI.CANCELLED_DATE IS NULL
          AND PD.REVERSED_PREPAY_APP_DIST_ID IS NULL
          AND PD.PREPAY_DIST_LOOKUP_CODE = 'FINAL PAYMENT ROUNDING'
          AND AD.LINE_TYPE_LOOKUP_CODE NOT IN ('AWT', 'PREPAY', 'ERV')
          AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
          AND NVL (PD.BASE_AMOUNT, PD.AMOUNT) <> 0
          AND NOT EXISTS
                     (SELECT 1
                        FROM apps.AP_PREPAY_APP_DISTS REV
                       WHERE PD.PREPAY_APP_DIST_ID =
                                REV.REVERSED_PREPAY_APP_DIST_ID)
         AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')                      
    GROUP BY AI.ORG_ID,
          GC.SEGMENT1,
          AI.INVOICE_ID,
          AI.PARTY_ID,
          AI.VENDOR_ID,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          AI.CREATED_BY,
          AI.CREATION_DATE,
          AI.INVOICE_CURRENCY_CODE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE ,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (SP.ROUNDING_ERROR_CCID),
          AI.DESCRIPTION, 
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (
             SP.ROUNDING_ERROR_CCID,
             2)
   UNION ALL
   SELECT AW.SL SL,
          'AWT' SOURCE,
          AW.UNIT,
          DS.COMPANY_SHORT_NAME,
          AW.INVOICE_ID,
          AW.SUPPLIER,
          AW.VENDOR_NUM,
          AW.INVOICE_NUM,
          AW.INVOICE_DATE,
          AW.GL_DATE,
          AW.CREATED_BY,
          AW.CREATION_DATE,
          AW.EXCHANGE_RATE,
          AW.INVOICE_AMOUNT,
          AW.VOUCHER,
          AW.RECEIPT_NUM,
          AW.CHECK_NUMBER,
          AW.CHECK_DATE,
          AW.BANK_ACCT_NUM,
          AW.CURRENCY_CODE,
          AW.GL_CODE_AND_DESC,
          AW.DESCRIPTION,
          AW.DR_AMOUNT,
          AW.CR_AMOUNT,
          AW.cost_center
     FROM (SELECT 4 SL,
                  APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
                  AI.INVOICE_ID,
                  apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
                  apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
                  AI.INVOICE_NUM,
                  AI.INVOICE_DATE, 
                  AI.GL_DATE,
                  apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
                  AI.CREATION_DATE,
                  AI.EXCHANGE_RATE,
                  AI.INVOICE_AMOUNT,
                  AI.DOC_SEQUENCE_VALUE VOUCHER,
                  apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
                  apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
                  apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
                  apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
                  apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
                  apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (AD.DIST_CODE_COMBINATION_ID)GL_CODE_AND_DESC,
                  AD.DESCRIPTION,
                  DECODE (SIGN (SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))) DR_AMOUNT,
                  DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) CR_AMOUNT,
                  AD.AWT_RELATED_ID,
                  apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID,2)cost_center
             FROM apps.AP_INVOICES_ALL AI, apps.AP_INVOICE_DISTRIBUTIONS_ALL AD
            WHERE     AI.INVOICE_ID = AD.INVOICE_ID
                  AND AD.LINE_TYPE_LOOKUP_CODE = 'AWT'
                  AND AI.CANCELLED_DATE IS NULL
                  AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
                  AND NVL (AD.BASE_AMOUNT, AD.AMOUNT) <> 0
                  AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
                  AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
                  AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
                  AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
                  AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
                  AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                     ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
 GROUP BY    AI.ORG_ID,
                  AI.INVOICE_ID,
                  AI.PARTY_ID,
                  AI.VENDOR_ID,
                  AI.INVOICE_NUM,
                  AI.INVOICE_DATE,
                  AI.GL_DATE,
                  AI.CREATED_BY,
                  AI.CREATION_DATE,
                  AI.INVOICE_CURRENCY_CODE,
                  AI.EXCHANGE_RATE,
                  AI.INVOICE_AMOUNT,
                  AI.DOC_SEQUENCE_VALUE ,
                  apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (AD.DIST_CODE_COMBINATION_ID),
                  AD.DESCRIPTION,
                  AD.AWT_RELATED_ID,
                  apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (
                     AD.DIST_CODE_COMBINATION_ID,
                     2) ) AW,
          (SELECT APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME, AID.INVOICE_DISTRIBUTION_ID
             FROM apps.AP_INVOICE_DISTRIBUTIONS_ALL AID, apps.GL_CODE_COMBINATIONS GC
            WHERE     AID.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
                  AND NVL (AID.REVERSAL_FLAG, 'N') <> 'Y'
                  AND NVL (AID.BASE_AMOUNT, AID.AMOUNT) <> 0) DS
    WHERE AW.AWT_RELATED_ID = DS.INVOICE_DISTRIBUTION_ID
   UNION ALL
   SELECT 5 SL,
          'PRE'SOURCE,
          APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
          APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME,
          AI.INVOICE_ID,
          apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
          apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
          AI.CREATION_DATE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE VOUCHER,
          apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
          apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
          apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
          apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
          apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (AD.DIST_CODE_COMBINATION_ID)GL_CODE_AND_DESC,
          AD.DESCRIPTION,
--          GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0),
--          (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))),
           DECODE (SIGN (SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))) DR_AMOUNT,
           DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) CR_AMOUNT,
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID,2)cost_center
     FROM apps.AP_INVOICES_ALL AI,
          apps.AP_INVOICE_DISTRIBUTIONS_ALL AD,
          apps.GL_CODE_COMBINATIONS GC
    WHERE     AI.INVOICE_ID = AD.INVOICE_ID
          AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND AD.LINE_TYPE_LOOKUP_CODE = 'PREPAY'
          AND AI.CANCELLED_DATE IS NULL
          AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
          AND NVL (AD.BASE_AMOUNT, AD.AMOUNT) <> 0
          AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
  GROUP BY AI.ORG_ID,
          GC.SEGMENT1,
          AI.INVOICE_ID,
          AI.PARTY_ID,
          AI.VENDOR_ID,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          AI.CREATED_BY,
          AI.CREATION_DATE,
          AI.INVOICE_CURRENCY_CODE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE ,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (
             AD.DIST_CODE_COMBINATION_ID),
          AD.DESCRIPTION,
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (
             AD.DIST_CODE_COMBINATION_ID,
             2)
   UNION ALL
   SELECT 6 SL,
          'PAY'SOURCE,
          APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
          APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME,
          AI.INVOICE_ID,
          apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
          apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
          AI.CREATION_DATE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE VOUCHER,
          apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
          apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
          apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
          apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
          apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (AI.ACCTS_PAY_CODE_COMBINATION_ID)GL_CODE_AND_DESC,
          AI.DESCRIPTION,
--          (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))),
--          GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0),
          DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) DR_AMOUNT,
          DECODE (SIGN (SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))) CR_AMOUNT,
    --DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) CR_AMOUNT
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AI.ACCTS_PAY_CODE_COMBINATION_ID,2)cost_center
     FROM apps.AP_INVOICES_ALL AI,
          apps.AP_INVOICE_DISTRIBUTIONS_ALL AD,
          apps.GL_CODE_COMBINATIONS GC
    WHERE     AI.INVOICE_ID = AD.INVOICE_ID
          AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND AI.CANCELLED_DATE IS NULL
          AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
          AND NVL (AD.BASE_AMOUNT, AD.AMOUNT) <> 0
          AND AD.LINE_TYPE_LOOKUP_CODE NOT IN ('AWT', 'PREPAY')
         AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
    GROUP BY AI.ORG_ID,
          GC.SEGMENT1,
          AI.INVOICE_ID,
          AI.PARTY_ID,
          AI.VENDOR_ID,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          AI.CREATED_BY,
          AI.CREATION_DATE,
          AI.INVOICE_CURRENCY_CODE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (
             AI.ACCTS_PAY_CODE_COMBINATION_ID),
          AI.DESCRIPTION, 
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (
             AI.ACCTS_PAY_CODE_COMBINATION_ID,
             2)
   UNION ALL
   SELECT 6 SL,
          'PRE'SOURCE,
          APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
          APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME,
          AI.INVOICE_ID,
          apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
          apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
          AI.CREATION_DATE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE VOUCHER,
          apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
          apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
          apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
          apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
          apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC ( AI.ACCTS_PAY_CODE_COMBINATION_ID)GL_CODE_AND_DESC,
          AI.DESCRIPTION,
--          (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0))),
--          GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0),
          DECODE (SIGN (SUM (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)) - (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)) - (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)))) DR_AMOUNT,
          DECODE (SIGN (SUM (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)- (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0)- (0 - (LEAST (NVL (PD.BASE_AMOUNT, PD.AMOUNT), 0))))) CR_AMOUNT,
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AI.ACCTS_PAY_CODE_COMBINATION_ID,2)cost_center
     FROM apps.AP_INVOICES_ALL AI,
          apps.AP_INVOICE_DISTRIBUTIONS_ALL AD,
          apps.AP_PREPAY_APP_DISTS PD,
          apps.GL_CODE_COMBINATIONS GC
    WHERE     AI.INVOICE_ID = AD.INVOICE_ID
          AND AD.INVOICE_DISTRIBUTION_ID = PD.INVOICE_DISTRIBUTION_ID
          AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND AI.CANCELLED_DATE IS NULL
          AND PD.REVERSED_PREPAY_APP_DIST_ID IS NULL
          AND AD.LINE_TYPE_LOOKUP_CODE NOT IN ('AWT', 'PREPAY', 'ERV')
          AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
          AND NVL (PD.BASE_AMOUNT, PD.AMOUNT) <> 0
          AND NOT EXISTS
                     (SELECT 1
                        FROM apps.AP_PREPAY_APP_DISTS REV
                       WHERE PD.PREPAY_APP_DIST_ID =
                                REV.REVERSED_PREPAY_APP_DIST_ID)
         AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')                      
   GROUP BY AI.ORG_ID,
          GC.SEGMENT1,
          AI.INVOICE_ID,
          AI.PARTY_ID,
          AI.VENDOR_ID,
          AI.INVOICE_NUM,
          AI.INVOICE_DATE,
          AI.GL_DATE,
          AI.CREATED_BY,
          AI.CREATION_DATE,
          AI.INVOICE_CURRENCY_CODE,
          AI.EXCHANGE_RATE,
          AI.INVOICE_AMOUNT,
          AI.DOC_SEQUENCE_VALUE ,
          apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (
          AI.ACCTS_PAY_CODE_COMBINATION_ID),
          AI.DESCRIPTION, 
          apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AI.ACCTS_PAY_CODE_COMBINATION_ID,2) 
  UNION ALL
   SELECT AW.SL SL,
          'AWT'SOURCE,
          AW.UNIT,
          DS.COMPANY_SHORT_NAME,
          AW.INVOICE_ID,
          AW.SUPPLIER,
          AW.VENDOR_NUM,
          AW.INVOICE_NUM,
          AW.INVOICE_DATE,
          AW.GL_DATE,
          AW.CREATED_BY,
          AW.CREATION_DATE,
          AW.EXCHANGE_RATE,
          AW.INVOICE_AMOUNT,
          AW.VOUCHER,
          AW.RECEIPT_NUM,
          AW.CHECK_NUMBER,
          AW.CHECK_DATE,
          AW.BANK_ACCT_NUM,
          AW.CURRENCY_CODE,
          AW.GL_CODE_AND_DESC,
          AW.DESCRIPTION,
          AW.DR_AMOUNT,
          AW.CR_AMOUNT,
          AW.cost_center
     FROM (SELECT 6 SL,
                  APPS.XXAKG_COM_PKG.GET_HR_OPERATING_UNIT (AI.ORG_ID) UNIT,
                  AI.INVOICE_ID,
                  apps.XXAKG_AP_PKG.GET_PARTY_NAME (PARTY_ID) SUPPLIER,
                  apps.XXAKG_AP_PKG.GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
                  AI.INVOICE_NUM,
                  AI.INVOICE_DATE,
                  AI.GL_DATE,
                 apps.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID (AI.CREATED_BY) CREATED_BY,
                 AI.CREATION_DATE,
                 AI.EXCHANGE_RATE,
                 AI.INVOICE_AMOUNT,
                 AI.DOC_SEQUENCE_VALUE VOUCHER,
                 apps.XXAKG_AP_PKG.GET_RECEIPT_NUMBER_FROM_INV (AI.INVOICE_ID) RECEIPT_NUM,
                 apps.XXAKG_AP_PKG.GET_MAX_CHECK_NUM_FROM_INVOICE (AI.INVOICE_ID) CHECK_NUMBER,
                 apps.XXAKG_AP_PKG.GET_MAX_CHK_DATE_FROM_INVOICE (AI.INVOICE_ID) CHECK_DATE,
                 apps.XXAKG_AP_PKG.GET_MAX_ACCT_NAME_FROM_INVOICE (AI.INVOICE_ID) BANK_ACCT_NUM,
                 apps.XXAKG_AP_PKG.GET_INVOICE_CURRENCY_CODE (AI.INVOICE_ID) CURRENCY_CODE,
                 apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC ( AI.ACCTS_PAY_CODE_COMBINATION_ID)GL_CODE_AND_DESC,
                 AI.DESCRIPTION,
--                  (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))                     DR_AMOUNT,
--                  GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0) CR_AMOUNT,
                DECODE (SIGN (SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))), -1, 0, SUM (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)) - (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)))) DR_AMOUNT,
                DECODE (SIGN (SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))), -1, 0, SUM (GREATEST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0)- (0 - (LEAST (NVL (AD.BASE_AMOUNT, AD.AMOUNT), 0))))) CR_AMOUNT,
                AD.AWT_RELATED_ID,
                apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID (AI.ACCTS_PAY_CODE_COMBINATION_ID,2)cost_center
             FROM apps.AP_INVOICES_ALL AI, apps.AP_INVOICE_DISTRIBUTIONS_ALL AD
            WHERE     AI.INVOICE_ID = AD.INVOICE_ID
                  AND AD.LINE_TYPE_LOOKUP_CODE = 'AWT'
                  AND AI.CANCELLED_DATE IS NULL
                  AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
                  AND NVL (AD.BASE_AMOUNT, AD.AMOUNT) <> 0
                   AND (:P_ORG_ID IS NULL OR AI.ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(AI.CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR AI.DOC_SEQUENCE_VALUE BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
         AND (:P_EMP_NUM IS NULL OR apps.XXAKG_COM_PKG.GET_USER_NAME (AI.CREATED_BY) = :P_EMP_NUM)
         AND apps.XXAKG_AP_PKG.GET_INVOICE_STATUS (AI.INVOICE_ID) IN
                ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
 GROUP BY   AI.ORG_ID,
                  AI.INVOICE_ID,
                  AI.PARTY_ID,
                  AI.VENDOR_ID,
                  AI.INVOICE_NUM,
                  AI.INVOICE_DATE,
                  AI.GL_DATE,
                  AI.CREATED_BY,
                  AI.CREATION_DATE,
                  AI.INVOICE_CURRENCY_CODE,
                  AI.EXCHANGE_RATE,
                  AI.INVOICE_AMOUNT,
                  AI.DOC_SEQUENCE_VALUE ,
                  apps.XXAKG_COM_PKG.GET_GL_CODE_DESC_FROM_CCID_IC (
                  AI.ACCTS_PAY_CODE_COMBINATION_ID),
                  AI.DESCRIPTION,AD.AWT_RELATED_ID,
                  apps.XXAKG_COM_PKG.GET_SEGMENT_VALUE_FROM_CCID ( AI.ACCTS_PAY_CODE_COMBINATION_ID,2)) AW,
          (SELECT APPS.XXAKG_COM_PKG.GET_FLEX_VALUES_FROM_FLEX_ID (GC.SEGMENT1, 1) COMPANY_SHORT_NAME, AID.INVOICE_DISTRIBUTION_ID
             FROM apps.AP_INVOICE_DISTRIBUTIONS_ALL AID, apps.GL_CODE_COMBINATIONS GC
            WHERE     AID.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
                  AND NVL (AID.REVERSAL_FLAG, 'N') <> 'Y'
                  AND NVL (AID.BASE_AMOUNT, AID.AMOUNT) <> 0) DS
    WHERE AW.AWT_RELATED_ID = DS.INVOICE_DISTRIBUTION_ID)
    GROUP BY UNIT, 
             COMPANY_SHORT_NAME,
             INVOICE_ID,
             SUPPLIER,
             VENDOR_NUM,
             INVOICE_NUM,
             INVOICE_DATE,
             GL_DATE,
             CREATED_BY,
             CREATION_DATE,
             EXCHANGE_RATE,
             INVOICE_AMOUNT,
             VOUCHER,
             RECEIPT_NUM,
             CHECK_NUMBER,
             CHECK_DATE,
             BANK_ACCT_NUM,
             CURRENCY_CODE,
             GL_CODE_AND_DESC,
             DESCRIPTION,
             cost_center)
ORDER BY AMOUNT DESC



--===============================================
--KSRM INVOICE VOUCHER QUERY
--===============================================

  SELECT SL,
 XX_GET_EMP_NAME_FROM_USER_ID(:P_USER_ID) USER_NAME,
         XX_GET_HR_OPERATING_UNIT (ORG_ID) UNIT,
         GET_FLEX_VALUES_FROM_FLEX_ID (BAL_SEG, 1) COMPANY_SHORT_NAME,
         INVOICE_ID,
         XX_GET_PARTY_NAME (PARTY_ID) SUPPLIER,
         XX_GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
        XX_GET_VENDOR_NUMBER_SITE_ID (INVOICE_ID)SUPPLIER_SITE,
         INVOICE_NUM,
         INVOICE_DATE,
         GL_DATE,
         XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) CREATED_BY,
         CREATION_DATE,
         XX_GET_RECEIPT_NUMBER_FROM_INV (INVOICE_ID) RECEIPT_NUM,
         GET_MAX_CHECK_NUM_FROM_INVOICE (INVOICE_ID) CHECK_NUMBER,
         GET_MAX_CHK_DATE_FROM_INVOICE (INVOICE_ID) CHECK_DATE,
         GET_MAX_ACCT_NAME_FROM_INVOICE (INVOICE_ID) BANK_ACCT_NUM,
         XX_GET_INVOICE_CURRENCY_CODE (INVOICE_ID) CURRENCY_CODE,
         VOUCHER,
         GL_CODE_AND_DESC,
         DESCRIPTION,
         DECODE (SIGN (SUM (DR_AMOUNT - CR_AMOUNT)), -1, 0, SUM (DR_AMOUNT - CR_AMOUNT)) DR_AMOUNT,
         DECODE (SIGN (SUM (CR_AMOUNT - DR_AMOUNT)), -1, 0, SUM (CR_AMOUNT - DR_AMOUNT)) CR_AMOUNT, DFF_INFO
    FROM XX_AP_INVOICE_VOUCHER_V
   WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(CREATION_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR VOUCHER BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
     --    AND (:P_EMP_NUM IS NULL OR XX_GET_USER_NAME (CREATED_BY) = :P_EMP_NUM)
         --AND XX_GET_INVOICE_STATUS (INVOICE_ID) IN  ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
GROUP BY SL,
         ORG_ID,
         BAL_SEG,
         INVOICE_ID,
         PARTY_ID,
         VENDOR_ID,
         INVOICE_NUM,
         INVOICE_DATE,
         GL_DATE,
         CREATED_BY,
         CREATION_DATE,
         VOUCHER,
         GL_CODE_AND_DESC,
         DESCRIPTION, DFF_INFO
HAVING DECODE (SIGN (SUM (DR_AMOUNT - CR_AMOUNT)), -1, 0, SUM (DR_AMOUNT - CR_AMOUNT)) + DECODE (SIGN (SUM (CR_AMOUNT - DR_AMOUNT)), -1, 0, SUM (CR_AMOUNT - DR_AMOUNT)) >0
ORDER BY org_id, sl, voucher


--==============================================
--EBS P2P Status Summary Report
--XXP2PSUMMARY
--Date:  17-FEB-2019
--P_ORG_ID = 103 , 
--=============================================

select distinct aia.org_id,
SUBSTR(XX_GET_HR_OPERATING_UNIT (AIA.ORG_ID),5) OPERATING_UNIT,
XX_ONT_GET_ENAME(:P_USER) PRINTED_BY ,
XX_INV_PKG.XXGET_ORG_LOCATION (AIA.ORG_ID) ORG_ADDRESS,
aia.invoice_num,
 aia.invoice_date,
 aia.gl_date,
 aia.invoice_amount, 
 aia.doc_sequence_value inv_voucher_no,
 XX_GET_EMP_NAME_FROM_USER_ID (AIA.CREATED_BY) INV_CREATED_BY,
 ( SELECT concatenated_segments
 FROM gl_code_combinations_kfv
 WHERE code_combination_id = aida.dist_code_combination_id
 ) dist_gl_code,
 aps.vendor_name,
 aps.segment1 vendor_no,
 apss.vendor_site_code,
 poh.segment1 po_number,
 poh.creation_date po_date,
 (
  SELECT SUM ( (pla.unit_price * pla.quantity)) price
   FROM po_lines_all pla, po_headers_all pha
   WHERE pla.po_header_id = pha.po_header_id
   and pha.org_id = aia.org_id
   and pha.SEGMENT1 =poh.SEGMENT1
         ) po_amount,
 rsh.receipt_num GRN_Number, 
 rsh.creation_date GRN_date,
 (
 SELECT concatenated_segments
 FROM gl_code_combinations_kfv
 WHERE code_combination_id = pda.code_combination_id
 ) dist_po_code,
 aia.doc_sequence_value voucher_no,
 (
 SELECT segment1||'.'||segment2||'.'||segment3||'.'||segment4
 FROM mtl_system_items_b
 WHERE inventory_item_id = pol.item_id
 AND organization_id = pll.SHIP_TO_ORGANIZATION_ID
 ) item_code,
  (
 SELECT description
 FROM mtl_system_items_b
 WHERE inventory_item_id = pol.item_id
 AND organization_id = pll.SHIP_TO_ORGANIZATION_ID
 ) item_description,
 aida.accounting_date
 /* ,(
 select SERVICE_TAX_REGNO
 FROM JAI_CMN_VENDOR_SITES
 WHERE vendor_id = aia.vendor_id
 AND vendor_site_id = aia.vendor_site_id
 ) st_reg_no,
 (
 SELECT pan_no
 FROM JAI_AP_TDS_VENDOR_HDRS
 where vendor_id = aia.vendor_id
 AND vendor_site_id = aia.vendor_site_id
 ) pan_no,
 -- jtl.UNROUND_TAXABLE_AMT_TRX_CURR,
 -- jtl. */
,ACA.CHECK_NUMBER INSTRUMENT_NO
,ACA.CHECK_DATE INSTURMENT_DATE
,ACA.VENDOR_NAME PAY_PARTY_NAME
,ACA.DOC_SEQUENCE_VALUE PAYMENT_VOUCHER
,ACA.CREATION_DATE PAY_CREATE_DATE
,ACA.DOC_CATEGORY_CODE PAYMENT_TYPE
,ACA.STATUS_LOOKUP_CODE PAYMENT_STATUS
--,CF.CASHFLOW_STATUS_CODE CASH_STATUS
,ACA.CURRENCY_CODE PAY_CURRENCY_CODE
,ACA.AMOUNT PAY_AMOUNT
,ACA.CLEARED_AMOUNT 
,ACA.CLEARED_DATE
,ACA.BANK_ACCOUNT_NAME
--,CF.CLEARED_DATE
--,CF.CLEARED_AMOUNT
from ap_invoices_All aia,
 ap_invoice_lines_all aila,
 ap_suppliers aps,
 ap_supplier_sites_all apss,
 ap_invoice_distributions_all aida,
 po_headers_all poh,
 po_lines_all pol,
 po_line_locations_All pll,
 po_distributions_All pda,
 rcv_transactions rt,
 rcv_shipment_headers rsh,
AP_INVOICE_PAYMENTS_ALL AIPA, -- newly added
AP_CHECKS_ALL ACA-- newly added
-- , jai_tax_lines jtl
where aia.invoice_id = aila.invoice_id
AND aila.org_id = aia.org_id
AND aila.po_header_id = poh.po_header_id
AND aila.po_line_id = pol.po_line_id
AND aila.invoice_id =aida.invoice_id
AND aia.vendor_id = aps.vendor_id
AND aia.vendor_site_id = apss.vendor_site_id
AND aia.vendor_id = apss.vendor_id
AND apss.org_id = aia.org_id
AND aida.invoice_line_number = aila.line_number
and aida.org_id= aila.org_id
AND poh.po_header_id = pol.po_header_id
AND pll.po_header_id = poh.po_header_id
AND pll.po_line_id = pol.po_line_id
AND pll.line_location_id = pda.line_location_id
AND pll.po_header_id = pda.po_header_id
AND pll.po_line_id = pda.po_line_id
AND pol.org_id = pda.org_id
AND poh.org_id = pll.org_id
AND aila.rcv_transaction_id = rt.transaction_id
AND rt.shipment_header_id = rsh.shipment_header_id
AND AIA.INVOICE_ID=AIPA.INVOICE_ID(+)
AND AIPA.CHECK_ID=ACA.CHECK_ID(+)
--AND ACA.BANK_ACCOUNT_ID=CF.CASHFLOW_BANK_ACCOUNT_ID(+)
AND (:P_ORG_ID IS NULL OR AIA.ORG_ID = :P_ORG_ID) --AP org id
AND (:P_VENDOR_NO IS NULL OR aps.segment1 = :P_VENDOR_NO) --aps.segment1 for supplier/vendor name
AND (:P_INV_FROM_DT IS NULL OR TRUNC(aia.invoice_date) BETWEEN :P_INV_FROM_DT AND :P_INV_TO_DT) --AP INV Creation from date, to date
AND (:P_FROM_INV_VOU IS NULL OR aia.doc_sequence_value BETWEEN :P_FROM_INV_VOU AND :P_TO_INV_VOU) --AP  INV voucher from - to 
AND (:P_PO_NO IS NULL OR poh.segment1 = :P_PO_NO) 
AND (:P_GRN_NO IS NULL OR rsh.receipt_num = :P_GRN_NO)