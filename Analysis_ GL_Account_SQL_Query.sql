--Detail GL Account Analysis SQL Query in Oracle Apps r12

select JE_NAME,
a.LAST_UPDATE_DATE creation_date,
       JE_CATEGORY,
       MRN_NO,
       a.DESCRIPTION,DOC_SEQUENCE_VALUE,EFFECTIVE_DATE,CURRENCY_CODE,VENDOR_NAME, VENDOR_SITE_CODE,
       INVOICE_NUM,PO,(SELECT MAX(AP.INVOICE_TYPE_LOOKUP_CODE) FROM AP_INVOICES_ALL AP
                    WHERE INVOICE_NUM = A.INVOICE_NUM) INVOICE_TYPE_LOOKUP_CODE,
                    INVOICE_DATE,GL_DATE,ENTERED_DR,ENTERED_CR,DR Func_Debit,CR Func_Credit,BAL,
       JE_SOURCE,PERIOD,NAME,A.CODE_COMBINATION_ID,
       GCC.SEGMENT1 company,apps.gl_flexfields_pkg.get_description_sql(5446,1,segment1)COMPANY_DESCRIPTION,
       GCC.SEGMENT2 LOCATION,apps.gl_flexfields_pkg.get_description_sql(5446,2,segment2) LOCATION_DESCRIPTION,
       GCC.SEGMENT3 CITY,apps.gl_flexfields_pkg.get_description_sql(5446,3,segment3) CITY_DESCRIPTION,
       GCC.SEGMENT4 COSTCENTER,apps.gl_flexfields_pkg.get_description_sql(5446,4,segment4) COSTCENTRE_DESCRIPTION,
       GCC.SEGMENT5 ACCOUNT,apps.gl_flexfields_pkg.get_description_sql(5446,5,segment5) ACCOUNT_DESCRIPTION,
       GCC.SEGMENT8 FUTURE1,apps.gl_flexfields_pkg.get_description_sql(5446,8,segment8) FUTURE1_DESCRIPTION,
       GCC.SEGMENT9 FUTURE2,apps.gl_flexfields_pkg.get_description_sql(5446,9,segment9) FUTURE2_DESCRIPTION
from
(
SELECT  JE_NAME,
LAST_UPDATE_DATE,
        JE_CATEGORY,
        MRN_NO,
        DESCRIPTION,
        DOC_SEQUENCE_VALUE,
        EFFECTIVE_DATE,
        CURRENCY_CODE,
        VENDOR_NAME,
        VENDOR_SITE_CODE,
        INVOICE_NUM,
        PO,
        INVOICE_DATE,
        GL_DATE ,
        SUM(nvl(ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(ENTERED_DR,0) ) ENTERED_CR,
        SUM(nvl(DR,0) ) DR,
        SUM(nvl(CR,0) ) CR,
        SUM(bal) bal,
        JE_SOURCE,
        PERIOD,
        NAME,
        CODE_COMBINATION_ID,
        CODE_COMINATION,
        PFROM_DATE,
        PTO_DATE,
        TYPE,
        DES
 FROM(
SELECT   JEH.NAME JE_NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        nvl((select receipt_num from rcv_shipment_headers
where shipment_header_id=(select shipment_header_id from rcv_transactions
where transaction_id=(SELECT MAX(RCV_TRANSACTION_ID) FROM AP_INVOICE_distributions_ALL
WHERE INVOICE_ID=AIA.INVOICE_ID
AND AMOUNT=XAL.ACCOUNTED_DR))),(select receipt_num from rcv_shipment_headers
where shipment_header_id=(select shipment_header_id from rcv_transactions
where transaction_id=(SELECT MAX(RCV_TRANSACTION_ID) FROM AP_INVOICE_distributionS_ALL
WHERE INVOICE_ID=AIA.INVOICE_ID)))) MRN_NO,
        AIA.DESCRIPTION,
        AIA.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        POV.VENDOR_NAME,
        PSSA.VENDOR_SITE_CODE,
        AIA.INVOICE_NUM,
         (select segment1 from po_headers_all
        where po_header_id=(select max(po_header_id) from ap_invoice_lines_all
        where invoice_id=aia.invoice_id)) PO,
        AIA.INVOICE_DATE,
        AIA.GL_DATE ,
       nvl(XAL.ENTERED_DR,0)  ENTERED_DR,
     nvl(XAL.ENTERED_CR,0)  ENTERED_CR,
       nvl(XAL.ACCOUNTED_DR,0)  DR,
        nvl(XAL.ACCOUNTED_CR,0)  CR,
       nvl(XAL.ACCOUNTED_DR,0) -nvl(XAL.ACCOUNTED_CR,0)  bal,
       JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'AP_INVOICE' NAME,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9 CODE_COMINATION,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        GL_CODE_COMBINATIONS GCC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        GL_IMPORT_REFERENCES GIR,
        XLA.XLA_AE_LINES XAL,
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA.XLA_AE_HEADERS XAH
        ,AP_INVOICES_ALL AIA,
        ap_supplier_sites_all PSSA,
        PO_VENDORS POV--,
       -- fnd_flex_values_vl a,
        --fnd_flex_values_vl b
WHERE   JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND JEH.STATUS='P'
        AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME)>=nvl(TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND XEH.ENTITY_CODE='AP_INVOICES'
        AND   TO_DATE('01'||'-'|| JEL.PERIOD_NAME)<=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        and jeh.LAST_UPDATE_DATE>:creation
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND AIA.VENDOR_ID=PSSA.VENDOR_ID
        AND AIA.VENDOR_SITE_ID=PSSA.VENDOR_SITE_ID
        AND XAL.AE_HEADER_ID=XAH.AE_HEADER_ID
        AND XAH.ENTITY_ID=XEH.ENTITY_ID
        AND AIA.INVOICE_ID=XEH.SOURCE_ID_INT_1
        AND POV.VENDOR_ID=AIA.VENDOR_ID
     --   AND (SELECT DISTINCT SEGMENT1 FROM PO_HEADERS_ALL
--WHERE PO_HEADER_ID IN (SELECT PO_HEADER_ID FROM PO_DISTRIBUTIONS_ALL
--WHERE PO_DISTRIBUTION_ID IN(SELECT PO_DISTRIBUTION_ID FROM AP_INVOICE_DISTRIBUTIONS_ALL
--WHERE INVOICE_ID=AIA.INVOICE_ID))) IS NOT NULL
)
GROUP BY JE_NAME,
LAST_UPDATE_DATE,
        JE_CATEGORY,
         MRN_NO,
        DESCRIPTION,
        DOC_SEQUENCE_VALUE,
        EFFECTIVE_DATE,
        CURRENCY_CODE,
        VENDOR_NAME,
        VENDOR_SITE_CODE,
        INVOICE_NUM,
         PO,
        INVOICE_DATE,
        GL_DATE ,
        JE_SOURCE,
        PERIOD,
        NAME,
        CODE_COMBINATION_ID,
        CODE_COMINATION,
        PFROM_DATE,
        PTO_DATE,
        TYPE,
        DES
        union all
------------------------------AP_PAYMENT----------------------------------
SELECT  JEH.NAME JE_NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        null MRN_NO,
        JEL.DESCRIPTION,
        AIA.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        POV.VENDOR_NAME,
        AIA.VENDOR_SITE_CODE,
        TO_CHAR(AIA.CHECK_NUMBER),
        NULL PO,
        AIA.CHECK_DATE,
        AIA.CHECK_DATE GL_DATE,
        SUM(nvl(XAL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(XAL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(nvl(XAL.ACCOUNTED_DR,0) ) DR,
        SUM(nvl(XAL.ACCOUNTED_CR,0) ) CR,
        SUM(nvl(XAL.ACCOUNTED_DR,0) )-SUM(nvl(XAL.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'AP_PAYMENT' NAME,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9  CODE_COMINATION,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        GL_CODE_COMBINATIONS GCC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        GL_IMPORT_REFERENCES GIR,
        XLA.XLA_AE_LINES XAL,
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA.XLA_AE_HEADERS XAH
        ,AP_CHECKS_ALL AIA,
        PO_VENDORS POV
        WHERE  JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND JEH.STATUS='P'
        AND XEH.ENTITY_CODE='AP_PAYMENTS'
        and jeh.LAST_UPDATE_DATE>:creation
        AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND XAL.AE_HEADER_ID=XAH.AE_HEADER_ID
        AND XAH.ENTITY_ID=XEH.ENTITY_ID
        AND AIA.CHECK_ID=XEH.SOURCE_ID_INT_1
        AND POV.VENDOR_ID=AIA.VENDOR_ID
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        JEL.DESCRIPTION,
        AIA.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        POV.VENDOR_NAME,
        AIA.VENDOR_SITE_CODE,
        JE_SOURCE,
        AIA.CHECK_NUMBER,
        AIA.CHECK_DATE,
            AIA.CHECK_DATE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY'),
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9  
UNION all
---------------------------General_Ledger------------------------------
SELECT 
        JEH.NAME JE_NAME,
        jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
         null MRN_NO,
        JEL.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        vendor_name(jeh.ACCRUAL_REV_JE_HEADER_ID,:from_date,:to_date) VENDOR_NAME,
        null  VENDOR_SITE_CODE,
        TO_CHAR(JEH.DOC_SEQUENCE_VALUE),
        NULL PO,
        JEH.CREATION_DATE,
        JEH.DEFAULT_EFFECTIVE_DATE GL_DATE,
        SUM(nvl(JEL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(JEL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(nvl(JEL.ACCOUNTED_DR,0) )DR,
        SUM(nvl(JEL.ACCOUNTED_CR,0) ) CR,
        SUM(nvl(jel.ACCOUNTED_DR,0) )-SUM(nvl(jel.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'GL-Manual' NAME,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE  ,
        NULL DES    
FROM
        GL_CODE_COMBINATIONS GCC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB   
WHERE 
        JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        and jeh.LAST_UPDATE_DATE>:creation
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND JEH.STATUS='P'
        AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND JEH.JE_HEADER_ID NOT IN (SELECT GIR.JE_HEADER_ID FROM  GL_IMPORT_REFERENCES GIR)
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        JEL.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        JE_SOURCE,
        JEL.EFFECTIVE_DATE,
         jeh.ACCRUAL_REV_JE_HEADER_ID,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') ,
        JEH.DOC_SEQUENCE_VALUE,
        JEH.CREATION_DATE,
            JEH.DEFAULT_EFFECTIVE_DATE,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9
union all
SELECT 
        JEH.NAME JE_NAME,
        jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        (select receipt_num from rcv_shipment_headers
where shipment_header_id=(select shipment_header_id from rcv_transactions
where transaction_id=jel.REFERENCE_5)) MRN_NO,
        (select ITEM_DESCRIPTION from po_lines_all
where po_header_id=(select po_header_id from rcv_transactions where transaction_id=jel.REFERENCE_5)
and po_line_id=(select po_line_id from rcv_transactions where transaction_id=jel.REFERENCE_5)) DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        (select vendor_name from po_vendors
       where vendor_id=( select VENDOR_ID from rcv_transactions
        where TRANSACTION_ID=jel.REFERENCE_5)) VENDOR_NAME,
        (select city from po_vendor_sites_all
       where vendor_site_id=( select VENDOR_site_id from rcv_transactions
        where TRANSACTION_ID=jel.REFERENCE_5)) VENDOR_SITE_CODE,
        TO_CHAR(JEH.DOC_SEQUENCE_VALUE),
        NULL PO,
        JEH.CREATION_DATE,
        JEH.DEFAULT_EFFECTIVE_DATE GL_DATE,
        SUM(nvl(JEL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(JEL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(nvl(JEL.ACCOUNTED_DR,0) )DR,
        SUM(nvl(JEL.ACCOUNTED_CR,0) ) CR,
        SUM(nvl(jel.ACCOUNTED_DR,0) )-SUM(nvl(jel.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'Purchasing_India' NAME,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE  ,
        NULL DES    
FROM
        GL_CODE_COMBINATIONS GCC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        GL_IMPORT_REFERENCES GIR  
WHERE 
        JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        and jeh.LAST_UPDATE_DATE>:creation
        AND JEH.STATUS='P'
        and JEH.JE_SOURCE='Purchasing India'
        AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM      
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        JEL.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        jel.REFERENCE_5,
        JE_SOURCE,
        JEL.EFFECTIVE_DATE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') ,
        JEH.DOC_SEQUENCE_VALUE,
        JEH.CREATION_DATE,
            JEH.DEFAULT_EFFECTIVE_DATE,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9
        UNION all
     -------------------------------AR_RECEIPT------------------------------------
SELECT  JEH.NAME JE_NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
         null MRN_NO,
        RE.COMMENTS,
        RE.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        RC.CUSTOMER_NAME,
         HL.CITY  VENDOR_SITE_CODE,
        RE.RECEIPT_NUMBER,
        NULL PO,
        XAL.ACCOUNTING_DATE RECEIPT_DATE,
        RE.RECEIPT_DATE GL_DATE,
        SUM(nvl(XAL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(XAL.ENTERED_CR,0) ) ENTERED_CR, 
        SUM(NVL(XAL.ACCOUNTED_DR,0)) DEBIT,
        SUM(NVL(XAL.ACCOUNTED_CR,0)) CREDIT,
        SUM(nvl(XAL.ACCOUNTED_DR,0) )-SUM(nvl(XAL.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'AR_RECEIPT' NAME ,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9 ,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        AR_CASH_RECEIPTS_ALL  RE,
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA_AE_LINES XAL,
        XLA_AE_HEADERS XAH,
        GL_CODE_COMBINATIONS GCC,
        GL_IMPORT_REFERENCES GIR,
        AR_CUSTOMERS RC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        hz_cust_site_uses_all HCSU,
        hz_cust_acct_sites_all HCSU1,
        hz_party_sites HPS,
        HZ_LOCATIONS HL
WHERE
        RE.CASH_RECEIPT_ID=XEH.SOURCE_ID_INT_1
        AND XAL.LEDGER_ID=XEH.LEDGER_ID
        AND XEH.ENTITY_ID=XAH.ENTITY_ID
        and jeh.LAST_UPDATE_DATE>:creation
        AND XAH.AE_HEADER_ID=XAL.AE_HEADER_ID
        AND GCC.CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID
       AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND XEH.ENTITY_CODE='RECEIPTS'
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        and RE.CUSTOMER_SITE_USE_ID=HCSU.SITE_USE_ID
        AND HCSU.CUST_ACCT_SITE_ID=HCSU1.CUST_ACCT_SITE_ID
        AND RE.PAY_FROM_CUSTOMER=HCSU1.CUST_ACCOUNT_ID
        AND HCSU1.PARTY_SITE_ID=HPS.PARTY_SITE_ID
        AND HPS.LOCATION_ID=HL.LOCATION_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND JEH.STATUS='P'
        AND NVL(RE.PAY_FROM_CUSTOMER,11)=RC.CUSTOMER_ID(+)
        AND JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND NVL(XAL.ACCOUNTED_DR,0)-NVL(XAL.ACCOUNTED_CR,0)<>0
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        RE.COMMENTS,
        RE.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        RC.CUSTOMER_NAME,
      HL.CITY,
        RE.RECEIPT_NUMBER,
        XAL.ACCOUNTING_DATE,
         RE.RECEIPT_DATE,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY'),
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9  
UNION all
-------------------------------AR_TRANSACTION-------------------------------
SELECT  JEH_NAME JE_NAME,
LAST_UPDATE_DATE,
        JE_CATEGORY,
         MRN_NO,
        DESCRIPTION,
        DOC_SEQUENCE_VALUE,
        EFFECTIVE_DATE,
        CURRENCY_CODE,
  CUSTOMER_NAME, VENDOR_SITE_CODE,TRX_NUMBER,PO,TRX_DATE,GL_DATE,ENTERED_DR,ENTERED_DR,DR, CR, bal,JE_SOURCE,PERIOD,NAME,CODE_COMBINATION_ID,CODE_COMINATION,
  PFROM_DATE,PTO_DATE,TYPE,
  (SELECT MAX(RCTL.DESCRIPTION)
   FROM RA_CUSTOMER_TRX_LINES_ALL RCTL
   WHERE RCTL.CUSTOMER_TRX_ID=CUSTOMER_TRX_ID) dES
FROM
(SELECT JEH.NAME JEH_NAME,

jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
         null MRN_NO,
        JEL.DESCRIPTION,
        RE.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        RC.CUSTOMER_NAME,
        hl.city  VENDOR_SITE_CODE,
        RE.TRX_NUMBER,
         NULL PO,
        RE.TRX_DATE,
        RE.TRX_DATE GL_DATE,
        SUM(nvl(XAL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(XAL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(NVL(XAL.ACCOUNTED_DR,0)) DR,
        SUM(NVL(XAL.ACCOUNTED_CR,0)) CR,
        SUM(nvl(XAL.ACCOUNTED_DR,0) )-SUM(nvl(XAL.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'AR_TRANSACTION' NAME ,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9 CODE_COMINATION,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        RCTP.TYPE    ,
        RE.CUSTOMER_TRX_ID
FROM
        RA_CUSTOMER_TRX_ALL RE,
        RA_CUST_TRX_TYPES_ALL RCTP,
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA_AE_LINES XAL,
        XLA_AE_HEADERS XAH,
        GL_CODE_COMBINATIONS GCC,
        GL_IMPORT_REFERENCES GIR,
        AR_CUSTOMERS RC ,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
         hz_cust_site_uses_all HCSU,
        hz_cust_acct_sites_all HCSU1,
        hz_party_sites HPS,
        HZ_LOCATIONS HL
WHERE   RE.CUSTOMER_TRX_ID=XEH.SOURCE_ID_INT_1
        AND XAL.LEDGER_ID=XEH.LEDGER_ID
        AND XEH.ENTITY_ID=XAH.ENTITY_ID
        AND XAH.AE_HEADER_ID=XAL.AE_HEADER_ID
        and jeh.LAST_UPDATE_DATE>:creation
        AND RCTP.CUST_TRX_TYPE_ID=re.CUST_TRX_TYPE_ID
        AND RCTP.ORG_ID=RE.ORG_ID
        AND GCC.CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID
         AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND XEH.ENTITY_CODE='TRANSACTIONS'
        AND JEH.STATUS='P' 
        AND RC.CUSTOMER_ID=RE.BILL_TO_CUSTOMER_ID
         and RE.BILL_TO_SITE_USE_ID=HCSU.SITE_USE_ID
        AND HCSU.CUST_ACCT_SITE_ID=HCSU1.CUST_ACCT_SITE_ID
        AND RE.SOLD_TO_CUSTOMER_ID=HCSU1.CUST_ACCOUNT_ID
        AND HCSU1.PARTY_SITE_ID=HPS.PARTY_SITE_ID
        AND HPS.LOCATION_ID=HL.LOCATION_ID
        AND JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        JEL.DESCRIPTION,
        RE.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        RC.CUSTOMER_NAME,
        hl.city,
        RCTP.TYPE,
        RE.TRX_NUMBER,
        RE.CUSTOMER_TRX_ID,
        RE.TRX_DATE,
        RE.TRX_DATE,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY'),
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9)
UNION all
--  inventory----------------------
select
JE_NAME,
LAST_UPDATE_DATE,
 JE_CATEGORY,
   MRN_NO,
  DESCRIPTION1,
  DOC_SEQUENCE_VALUE,
  EFFECTIVE_DATE,
   CURRENCY_CODE,
     VENDOR_NAME,
      VENDOR_SITE_CODE,
       doc_value,
         PO,
        --CBA.BANK_ACCOUNT_NUM,
       ACCOUNTING_DATE,
       GL_DATE,
        SUM(nvl(ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(ENTERED_CR,0) ) ENTERED_CR,
        SUM(NVL(ACCOUNTED_DR,0)),
        SUM(NVL(ACCOUNTED_CR,0)),
        SUM(nvl(ACCOUNTED_DR,0) )-SUM(nvl(ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        PERIOD,
        NAME ,
        CODE_COMBINATION_ID,
        code,
      PFROM_DATE,
       PTO_DATE,
         TYPE,
         DES from (SELECT  JEH.NAME JE_NAME,
         jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        (select receipt_num from rcv_shipment_headers
where shipment_header_id=(select shipment_header_id from rcv_transactions
where transaction_id=rcv.transaction_id)) MRN_NO,
       (select ITEM_DESCRIPTION from po_lines_all
where po_header_id=(select po_header_id from rcv_transactions where transaction_id=rcv.transaction_id)
and po_line_id=(select po_line_id from rcv_transactions where transaction_id=rcv.transaction_id)) DESCRIPTION1,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        (select VENDOR_NAME from po_vendors
        where vendor_id=rcv.vendor_id) VENDOR_NAME,
      (select VENDOR_SITE_code from po_vendor_sites_all
        where VENDOR_SITE_ID=rcv.VENDOR_SITE_ID) VENDOR_SITE_CODE,
         (select max(invoice_num) from ap_invoices_all
        where invoice_id=(select max(invoice_id) from ap_invoice_lines_all
        where PO_HEADER_ID=(select distinct po_header_id from rcv_transactions where transaction_id=rcv.transaction_id)
        and po_line_id=(select distinct  po_line_id from rcv_transactions where transaction_id=rcv.transaction_id))) doc_value,
         (select segment1 from po_headers_all where po_header_id=(select po_header_id from rcv_transactions where transaction_id=rcv.transaction_id)) PO,
        --CBA.BANK_ACCOUNT_NUM,
        XAL.ACCOUNTING_DATE,
        XAL.ACCOUNTING_DATE GL_DATE,
       XAL.ENTERED_DR,
       XAL.ENTERED_CR,
       XAL.ACCOUNTED_DR,
       XAL.ACCOUNTED_CR,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'CASH_MANAGEMENT' NAME ,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9  code,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA_AE_LINES XAL,
        XLA_AE_HEADERS XAH,
        GL_CODE_COMBINATIONS GCC,
        GL_IMPORT_REFERENCES GIR,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        rcv_transactions rcv
WHERE
        XAL.LEDGER_ID=XEH.LEDGER_ID
        AND XEH.ENTITY_ID=XAH.ENTITY_ID
        AND XAH.AE_HEADER_ID=XAL.AE_HEADER_ID
        AND GCC.CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID
        AND XEH.ENTITY_CODE='RCV_ACCOUNTING_EVENTS'
        and xeh.SOURCE_ID_INT_1=rcv.transaction_id
       -- and rcv.transaction_id=2009
        AND JEH.STATUS='P'
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        and jeh.LAST_UPDATE_DATE>:creation
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
      AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME)))
GROUP BY JE_NAME,
LAST_UPDATE_DATE,
        JE_CATEGORY,
        MRN_NO,
        DEscription1,
       DOC_SEQUENCE_VALUE,
        EFFECTIVE_DATE,
         VENDOR_NAME,
          VENDOR_SITE_CODE,
       CURRENCY_CODE,
        doc_value,
        PO,
        --CBA.BANK_ACCOUNT_NUM,
         ACCOUNTING_DATE,
         gl_DATE,
        JE_SOURCE,
         TYPE,
        PERIOD,
        NAME,
  CODE_COMBINATION_ID,code, PFROM_DATE,
       PTO_DATE
        UNION all
        SELECT  JEH.NAME JE_NAME,
        jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
          (select receipt_num from rcv_shipment_headers
where shipment_header_id=(select shipment_header_id from rcv_transactions
where to_char(transaction_id)=nvl(to_char(mmt.Rcv_transaction_id),to_char(mmt.TRANSACTION_REFERENCE)))) MRN_NO,
       MSI.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        (select VENDOR_NAME from po_vendors
        where vendor_id=(select vendor_id from rcv_transactions
where to_char(TRANSACTION_ID)=nvl(to_char(mmt.Rcv_transaction_id),to_char(mmt.TRANSACTION_REFERENCE)))) VENDOR_NAME,
        null  VENDOR_SITE_CODE,
        TO_CHAR(jeh.DOC_SEQUENCE_VALUE),
         (select segment1 from po_headers_all where po_header_id=(select po_header_id from rcv_transactions where to_char(transaction_id)=nvl(to_char(mmt.Rcv_transaction_id),to_char(mmt.TRANSACTION_REFERENCE)))) PO,
        --CBA.BANK_ACCOUNT_NUM,
        XAL.ACCOUNTING_DATE,
        XAL.ACCOUNTING_DATE GL_DATE,
        SUM(nvl(XAL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(XAL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(NVL(XAL.ACCOUNTED_DR,0)),
        SUM(NVL(XAL.ACCOUNTED_CR,0)),
        SUM(nvl(XAL.ACCOUNTED_DR,0) )-SUM(nvl(XAL.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'INVENTORY' NAME ,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9 ,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA_AE_LINES XAL,
        XLA_AE_HEADERS XAH,
        GL_CODE_COMBINATIONS GCC,
        GL_IMPORT_REFERENCES GIR,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        MTL_MATERIAL_TRANSACTIONS MMT,
        MTL_SYSTEM_ITEMS_B MSI,
        XLA_EVENTS XE
WHERE
        XAL.LEDGER_ID=XEH.LEDGER_ID
        AND XEH.ENTITY_ID=XAH.ENTITY_ID
        AND XAH.AE_HEADER_ID=XAL.AE_HEADER_ID
        AND GCC.CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID
        AND XEH.ENTITY_CODE='MTL_ACCOUNTING_EVENTS'
        and jeh.LAST_UPDATE_DATE>:creation
        AND MMT.TRANSACTION_ID=XEH.SOURCE_ID_INT_1
      AND MSI.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
      AND MSI.ORGANIZATION_ID=MMT.ORGANIZATION_ID
        AND JEH.STATUS='P'
        AND XE.EVENT_ID=XAH.EVENT_ID
         AND XE.PROCESS_STATUS_CODE='P'
         AND XE.EVENT_STATUS_CODE='P'
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND XAH.ACCOUNTING_ENTRY_STATUS_CODE='F'
        AND XAL.APPLICATION_ID=XAH.APPLICATION_ID
       AND XE.APPLICATION_ID=XAH.APPLICATION_ID
       AND XEH.ENTITY_ID=XE.ENTITY_ID
        AND XEH.APPLICATION_ID=XE.APPLICATION_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        and NVL(XAL.ACCOUNTED_DR,0)-NVL(XAL.ACCOUNTED_CR,0)<>0
        AND JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
      AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
       MSI.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
      mmt.Rcv_transaction_id,mmt.TRANSACTION_REFERENCE,
        jeh.CURRENCY_CODE,
        TO_CHAR(jeh.DOC_SEQUENCE_VALUE),
        --CBA.BANK_ACCOUNT_NUM,
        XAL.ACCOUNTING_DATE,
          XAL.ACCOUNTING_DATE,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY'),
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||
        GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||
        GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9
        union all
        SELECT  JEH.NAME JE_NAME,
        jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
         null MRN_NO,
        fma.DESCRIPTION,
        gir.SUBLEDGER_DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        POV.VENDOR_NAME,
        null VENDOR_SITE_CODE,
        TO_CHAR(fma.INVOICE_NUMBER),
        fma.PO_NUMBER PO,
        jeh.DEFAULT_EFFECTIVE_DATE,
        jeh.DEFAULT_EFFECTIVE_DATE GL_DATE,
        SUM(nvl(XAL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(XAL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(nvl(XAL.ACCOUNTED_DR,0) ) DR,
        SUM(nvl(XAL.ACCOUNTED_CR,0) ) CR,
        SUM(nvl(XAL.ACCOUNTED_DR,0) )-SUM(nvl(XAL.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'Assets' NAME,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9  CODE_COMINATION,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        GL_CODE_COMBINATIONS GCC,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB,
        GL_IMPORT_REFERENCES GIR,
        XLA.XLA_AE_LINES XAL,
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA.XLA_AE_HEADERS XAH,
        FA_ADDITIONS_B fab,
        FA_MASS_ADDITIONS fma,
        PO_VENDORS POV
        WHERE  JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND JEH.STATUS='P'
        AND XEH.ENTITY_CODE='DEPRECIATION'
        AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        and jeh.LAST_UPDATE_DATE>:creation
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND XAL.AE_HEADER_ID=XAH.AE_HEADER_ID
        AND XAH.ENTITY_ID=XEH.ENTITY_ID
        AND fab.ASSET_ID=XEH.SOURCE_ID_INT_1
        and fab.ASSET_ID=fma.ASSET_NUMBER
        AND POV.VENDOR_ID=fma.PO_VENDOR_ID
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        fma.DESCRIPTION,
        gir.SUBLEDGER_DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        POV.VENDOR_NAME,
        null,
        JE_SOURCE,
        fma.INVOICE_NUMBER,
        fma.PO_NUMBER,
        jeh.DEFAULT_EFFECTIVE_DATE,
           jeh.DEFAULT_EFFECTIVE_DATE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY'),
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9  
        union all
-----------------------------CASH_MANAGEMENT-----------------------------
SELECT  JEH.NAME JE_NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
         null MRN_NO,
        JEL.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        nvl(CB.BANK_NAME,gcc.SEGMENT4) VENDOR_NAME,
        null  VENDOR_SITE_CODE,
        TO_CHAR(CCF.TRXN_REFERENCE_NUMBER),
         NULL PO,
        --CBA.BANK_ACCOUNT_NUM,
        XAL.ACCOUNTING_DATE,
        CCF.CASHFLOW_DATE GL_DATE,
        SUM(nvl(XAL.ENTERED_DR,0) ) ENTERED_DR,
        SUM(nvl(XAL.ENTERED_CR,0) ) ENTERED_CR,
        SUM(NVL(XAL.ACCOUNTED_DR,0)),
        SUM(NVL(XAL.ACCOUNTED_CR,0)),
        SUM(nvl(XAL.ACCOUNTED_DR,0) )-SUM(nvl(XAL.ACCOUNTED_CR,0) ) bal,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY') PERIOD,
        'CASH_MANAGEMENT' NAME ,
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'|| GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9 ,
        decode(:FROM_DATE,null,'ALL',:FROM_DATE) PFROM_DATE,
        decode(:TO_DATE,null,'ALL',:TO_DATE) PTO_DATE,
        NULL TYPE,
        NULL DES
FROM
        XLA.XLA_TRANSACTION_ENTITIES XEH,
        XLA_AE_LINES XAL,
        XLA_AE_HEADERS XAH,
        GL_CODE_COMBINATIONS GCC,
        CE_CASHFLOWS CCF,
        CE_BANK_ACCOUNTS CBA,
        CE_BANK_ACCT_USES_ALL CBU,
        CE_BANKS_V CB,
        GL_IMPORT_REFERENCES GIR,
        GL_JE_LINES JEL,
        GL_JE_HEADERS JEH,
        GL_JE_BATCHES JEB
WHERE
        XAL.LEDGER_ID=XEH.LEDGER_ID
        AND XEH.ENTITY_ID=XAH.ENTITY_ID
        AND XAH.AE_HEADER_ID=XAL.AE_HEADER_ID
        AND GCC.CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID
        AND XEH.SOURCE_ID_INT_1=CCF.CASHFLOW_ID
        AND XEH.ENTITY_CODE='CE_CASHFLOWS'
        AND CCF.CASHFLOW_BANK_ACCOUNT_ID=CBU.BANK_ACCT_USE_ID(+)
        AND CBU.BANK_ACCOUNT_ID=CBA.BANK_ACCOUNT_ID(+)
        AND CBA.BANK_ID=CB.BANK_PARTY_ID(+)
        and jeh.LAST_UPDATE_DATE>:creation
        AND JEH.STATUS='P'
        AND XAL.GL_SL_LINK_ID =GIR.GL_SL_LINK_ID
        AND JEL.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
        AND GIR.JE_LINE_NUM=JEL.JE_LINE_NUM
        AND GIR.JE_HEADER_ID=JEH.JE_HEADER_ID
        AND JEH.JE_HEADER_ID=JEL.JE_HEADER_ID
        AND JEB.JE_BATCH_ID=JEH.JE_BATCH_ID
      AND TO_DATE('01'||'-'|| JEL.PERIOD_NAME) >=nvl( TO_DATE('01'||'-'||:FROM_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
        AND  TO_DATE('01'||'-'|| JEL.PERIOD_NAME) <=nvl(TO_DATE('01'||'-'||:TO_DATE),TO_DATE('01'||'-'|| JEL.PERIOD_NAME))
GROUP BY JEH.NAME,
jeh.LAST_UPDATE_DATE,
        JEH.JE_CATEGORY,
        JEL.DESCRIPTION,
        jeh.DOC_SEQUENCE_VALUE,
        JEL.EFFECTIVE_DATE,
        jeh.CURRENCY_CODE,
        nvl(CB.BANK_NAME,gcc.SEGMENT4),
        TO_CHAR(CCF.TRXN_REFERENCE_NUMBER),
        --CBA.BANK_ACCOUNT_NUM,
        XAL.ACCOUNTING_DATE,
         CCF.CASHFLOW_DATE,
        JE_SOURCE,
        TO_CHAR(JEL.EFFECTIVE_DATE,'MON-YY'),
        GCC.CODE_COMBINATION_ID,GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||
        GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||
        GCC.SEGMENT6||'.'|| GCC.SEGMENT7||'.'|| GCC.SEGMENT8||'.'|| GCC.SEGMENT9
 )a,GL_CODE_COMBINATIONS GCC
where a.JE_SOURCE=nvl(:p_source,a.JE_SOURCE)
AND A.CODE_COMBINATION_ID=GCC.CODE_COMBINATION_ID
and gcc.segment1=nvl(:p_company,gcc.segment1)
and gcc.segment2=nvl(:p_location,gcc.segment2)
and gcc.segment3=nvl(:p_lob,gcc.segment3)
and gcc.segment4=nvl(:p_cost_centre,gcc.segment4)
and gcc.segment5=nvl(:p_account,gcc.segment5)
and gcc.segment6=nvl(:p_sub_account,gcc.segment6)
and gcc.segment7=nvl(:p_project,gcc.segment7)
order by gl_date

