-- EBS TDS and VDS pending Report
--===============================
SELECT 1 SL, -- Supplier TAX Credit 
            AI.LEGAL_ENTITY_ID,
            AI.ORG_ID,
            AI.INVOICE_ID,
            TRUNC (AD.ACCOUNTING_DATE) ACCOUNTING_DATE,
            AI.PARTY_ID,
            AV.VENDOR_TYPE_LOOKUP_CODE,
            AV.ATTRIBUTE13,
            TO_CHAR (AV.VENDOR_ID) VENDOR_ID,
            AV.SEGMENT1,
            AV.VENDOR_NAME,
            INITCAP (AI.INVOICE_TYPE_LOOKUP_CODE),
            AI.INVOICE_NUM,
            DOC_SEQUENCE_VALUE,
            'AP INV-' || AI.DOC_SEQUENCE_VALUE VOUCHER,
            -- DECODE(XX_GET_AP_DFF_INFO(AI.INVOICE_ID) ,  NULL , NULL, ','|| XX_GET_AP_DFF_INFO(AI.INVOICE_ID)  )  || AD.DESCRIPTION   DESCRIPTION,
            XX_GET_AP_DFF_INFO (AI.INVOICE_ID) || ',' || AD.DESCRIPTION
               DESCRIPTION,
            GC.SEGMENT3 COST_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3) COST_CENTER,
            GC.SEGMENT5 SUB_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4) SUB_ACCOUNT,
            GC.SEGMENT6 PROJECT_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6) PROJECT_NAME,
            GC.SEGMENT7 INTER_COM_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7) INTER_COMPANY,
            GC.SEGMENT4 DIST_GL_CODE,
            GET_GL_CODE_DESC_FROM_CCID (AD.DIST_CODE_COMBINATION_ID)
               GL_CODE_AND_DESC,
            GC.SEGMENT1 BAL_SEG,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID, 1),
               1)
               BAL_SEG_NAME,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID, 1),
               1)
               COMPANY,
            ABS (LEAST (SUM (NVL (AD.BASE_AMOUNT, AD.AMOUNT)), 0)) CR_AMOUNT,
            GREATEST (SUM (NVL (AD.BASE_AMOUNT, AD.AMOUNT)), 0) DR_AMOUNT,
            0 SECURITY_AMOUNT,
            NULL BANK_ACCOUNT,
            NULL INSTRUMENT_NUM,
            PHA.SEGMENT1,
            TRUNC (AI.CREATION_DATE) TRANSECTION_DATE,
            AI.VENDOR_SITE_ID,
            AI.INVOICE_DATE,
            AI.CREATION_DATE,
            'INVOICE' INV_STATUS,
            AI.INVOICE_CURRENCY_CODE,
            AP_INVOICES_PKG.GET_APPROVAL_STATUS (AI.INVOICE_ID,
                                                 AI.INVOICE_AMOUNT,
                                                 AI.PAYMENT_STATUS_FLAG,
                                                 AI.INVOICE_TYPE_LOOKUP_CODE)
               INVOICE_STATUS,
            AI.WFAPPROVAL_STATUS WF_STATUS,
            NULL DFF_INFO,
            AI.EXCHANGE_RATE,
            AP_INVOICES_PKG.GET_POSTING_STATUS (AI.INVOICE_ID)
               INVOICE_POST_FLAG,
            NVL (AD.ATTRIBUTE_CATEGORY, AIL.ATTRIBUTE_CATEGORY),
            NVL (AD.ATTRIBUTE1, AIL.ATTRIBUTE1),
            AD.ATTRIBUTE2,
            AD.ATTRIBUTE3,
            AD.ATTRIBUTE4,
            AD.ATTRIBUTE5
       FROM AP_INVOICES_ALL AI,
            AP_SUPPLIERS AV,
            AP_INVOICE_DISTRIBUTIONS_ALL AD,
            GL_CODE_COMBINATIONS GC,
            PO_HEADERS_ALL PHA,
            AP_INVOICE_LINES_ALL AIL
      WHERE     AI.INVOICE_ID = AD.INVOICE_ID
            AND AI.VENDOR_ID = AV.VENDOR_ID
            AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
            -- AND AI.QUICK_PO_HEADER_ID = PHA.PO_HEADER_ID(+)
            AND AIL.INVOICE_ID = AD.INVOICE_ID
            AND AIL.LINE_NUMBER = AD.INVOICE_LINE_NUMBER
            AND AIL.PO_HEADER_ID = PHA.PO_HEADER_ID(+)
            AND XX_GET_INVOICE_STATUS (AI.INVOICE_ID) = 'Validated'
            AND AD.LINE_TYPE_LOOKUP_CODE NOT IN ('PREPAY')
            AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
--            AND GC.SEGMENT4 IN ('4040104', '4040101', '4040102', '4040103', '4030301')
   AND GC.SEGMENT4 IN ('4040101','4040104')
  AND GC.SEGMENT4 = NVL(:P_GL_CODE,GC.SEGMENT4)
  -- AND AI.VENDOR_ID  = '4001' --Change by Ibrahim Khalil existing was 5002 for excepit tax authority vendor  will show in this report.
               --AND   TRUNC (AD.ACCOUNTING_DATE)  between '01-JUN-2022' and '30-JUN-2022'
               AND   TRUNC (AD.ACCOUNTING_DATE)  between :P_DATE_FROM AND :P_DATE_TO 
            --   AND GC.SEGMENT1 = 103 --BAL_SEG,
             AND GC.SEGMENT1 = NVL(:BAL_SEG, GC.SEGMENT1)
             AND AV.VENDOR_ID= :P_VENDOR_ID
              -- AND   AI.DOC_SEQUENCE_VALUE = 210010875
               --AND   AI.INVOICE_NUM = 'FERRO-PO-40011367'
               AND NVL (AD.ATTRIBUTE1, AIL.ATTRIBUTE1) IS  NULL
   GROUP BY AI.LEGAL_ENTITY_ID,
            AD.LINE_TYPE_LOOKUP_CODE,
            INVOICE_AMOUNT,
            PHA.SEGMENT1,
            AI.CREATION_DATE,
            AI.VENDOR_SITE_ID,
            AI.INVOICE_DATE,
            GC.SEGMENT1,
            AI.ORG_ID,
            AI.INVOICE_ID,
            AD.ACCOUNTING_DATE,
            AI.PARTY_ID,
            AV.VENDOR_TYPE_LOOKUP_CODE,
            AV.ATTRIBUTE13,
            AV.VENDOR_ID,
            AV.SEGMENT1,
            AV.VENDOR_NAME,
            AI.INVOICE_TYPE_LOOKUP_CODE,
            AI.INVOICE_NUM,
            AI.DOC_SEQUENCE_VALUE,
            AD.DESCRIPTION,
            GC.SEGMENT5,
            GC.SEGMENT4,
            GC.SEGMENT3,
            GC.SEGMENT6,
            GC.SEGMENT7,
            --   GC.SEGMENT8,
            AD.DIST_CODE_COMBINATION_ID,
            --    AD.INVOICE_DISTRIBUTION_ID,
            AI.INVOICE_CURRENCY_CODE,
            AD.ATTRIBUTE_CATEGORY,
            AD.ATTRIBUTE1,
            AD.ATTRIBUTE2,
            AD.ATTRIBUTE3,
            AD.ATTRIBUTE4,
            AP_INVOICES_PKG.GET_APPROVAL_STATUS (AI.INVOICE_ID,
                                                 AI.INVOICE_AMOUNT,
                                                 AI.PAYMENT_STATUS_FLAG,
                                                 AI.INVOICE_TYPE_LOOKUP_CODE),
            AI.WFAPPROVAL_STATUS,
            AI.EXCHANGE_RATE,
            NVL (AD.ATTRIBUTE_CATEGORY, AIL.ATTRIBUTE_CATEGORY),
            NVL (AD.ATTRIBUTE1, AIL.ATTRIBUTE1),
            AD.ATTRIBUTE2,
            AD.ATTRIBUTE3,
            AD.ATTRIBUTE4,
            AD.ATTRIBUTE5,
            AP_INVOICES_PKG.GET_POSTING_STATUS (AI.INVOICE_ID)                           
   UNION ALL  
            SELECT 2 SL, -- TAX Authority  TAX Debit 
            AI.LEGAL_ENTITY_ID,
            AI.ORG_ID,
            AI.INVOICE_ID,
            TRUNC (AD.ACCOUNTING_DATE) ACCOUNTING_DATE,
            AI.PARTY_ID,
            AV.VENDOR_TYPE_LOOKUP_CODE,
            AV.ATTRIBUTE13,
            TO_CHAR (AV.VENDOR_ID) VENDOR_ID,
            AV.SEGMENT1,
            AV.VENDOR_NAME,
            INITCAP (AI.INVOICE_TYPE_LOOKUP_CODE),
            AI.INVOICE_NUM,
            DOC_SEQUENCE_VALUE,
            'AP INV-' || AI.DOC_SEQUENCE_VALUE VOUCHER,
            -- DECODE(XX_GET_AP_DFF_INFO(AI.INVOICE_ID) ,  NULL , NULL, ','|| XX_GET_AP_DFF_INFO(AI.INVOICE_ID)  )  || AD.DESCRIPTION   DESCRIPTION,
            XX_GET_AP_DFF_INFO (AI.INVOICE_ID) || ',' || AD.DESCRIPTION
               DESCRIPTION,
            GC.SEGMENT3 COST_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3) COST_CENTER,
            GC.SEGMENT5 SUB_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4) SUB_ACCOUNT,
            GC.SEGMENT6 PROJECT_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6) PROJECT_NAME,
            GC.SEGMENT7 INTER_COM_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7) INTER_COMPANY,
            GC.SEGMENT4 DIST_GL_CODE,
            GET_GL_CODE_DESC_FROM_CCID (AD.DIST_CODE_COMBINATION_ID)
               GL_CODE_AND_DESC,
            GC.SEGMENT1 BAL_SEG,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID, 1),
               1)
               BAL_SEG_NAME,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID, 1),
               1)
               COMPANY,
            ABS (LEAST (SUM (NVL (AD.BASE_AMOUNT, AD.AMOUNT)), 0)) CR_AMOUNT,
            GREATEST (SUM (NVL (AD.BASE_AMOUNT, AD.AMOUNT)), 0) DR_AMOUNT,
            0 SECURITY_AMOUNT,
            NULL BANK_ACCOUNT,
            NULL INSTRUMENT_NUM,
            PHA.SEGMENT1,
            TRUNC (AI.CREATION_DATE) TRANSECTION_DATE,
            AI.VENDOR_SITE_ID,
            AI.INVOICE_DATE,
            AI.CREATION_DATE,
            'INVOICE' INV_STATUS,
            AI.INVOICE_CURRENCY_CODE,
            AP_INVOICES_PKG.GET_APPROVAL_STATUS (AI.INVOICE_ID,
                                                 AI.INVOICE_AMOUNT,
                                                 AI.PAYMENT_STATUS_FLAG,
                                                 AI.INVOICE_TYPE_LOOKUP_CODE)
               INVOICE_STATUS,
            AI.WFAPPROVAL_STATUS WF_STATUS,
            NULL DFF_INFO,
            AI.EXCHANGE_RATE,
            AP_INVOICES_PKG.GET_POSTING_STATUS (AI.INVOICE_ID)
               INVOICE_POST_FLAG,
            NVL (AD.ATTRIBUTE_CATEGORY, AIL.ATTRIBUTE_CATEGORY),
            NVL (AD.ATTRIBUTE1, AIL.ATTRIBUTE1),
            AD.ATTRIBUTE2,
            AD.ATTRIBUTE3,
            AD.ATTRIBUTE4,
            AD.ATTRIBUTE5
       FROM AP_INVOICES_ALL AI,
            AP_SUPPLIERS AV,
            AP_INVOICE_DISTRIBUTIONS_ALL AD,
            GL_CODE_COMBINATIONS GC,
            PO_HEADERS_ALL PHA,
            AP_INVOICE_LINES_ALL AIL
      WHERE     AI.INVOICE_ID = AD.INVOICE_ID
            AND AI.VENDOR_ID = AV.VENDOR_ID
            AND AD.DIST_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
            -- AND AI.QUICK_PO_HEADER_ID = PHA.PO_HEADER_ID(+)
            AND AIL.INVOICE_ID = AD.INVOICE_ID
            AND AIL.LINE_NUMBER = AD.INVOICE_LINE_NUMBER
            AND AIL.PO_HEADER_ID = PHA.PO_HEADER_ID(+)
            AND XX_GET_INVOICE_STATUS (AI.INVOICE_ID) = 'Validated'
            AND AD.LINE_TYPE_LOOKUP_CODE NOT IN ('PREPAY')
            AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
--            AND GC.SEGMENT4 IN ('4040104', '4040101', '4040102', '4040103', '4030301')
   AND GC.SEGMENT4 IN ('4040101','4040104')
   AND GC.SEGMENT4 = NVL(:P_GL_CODE,GC.SEGMENT4)
  --AND AI.VENDOR_ID  = '4001' --Change by Ibrahim Khalil existing was 5002 for excepit tax authority vendor  will show in this report.
               --AND   TRUNC (AD.ACCOUNTING_DATE)  between '01-JUN-2022' and '30-JUN-2022'
                AND   TRUNC (AD.ACCOUNTING_DATE)  between :P_DATE_FROM AND :P_DATE_TO --'01-JUN-2022' and '30-JUN-2022'
              -- AND GC.SEGMENT1 = 103 --BAL_SEG,
               AND GC.SEGMENT1 = NVL(:BAL_SEG, GC.SEGMENT1)
                AND AV.VENDOR_ID= :P_VENDOR_ID
                   AND NVL (AD.ATTRIBUTE1, AIL.ATTRIBUTE1) IS NOT NULL
   GROUP BY AI.LEGAL_ENTITY_ID,
            AD.LINE_TYPE_LOOKUP_CODE,
            INVOICE_AMOUNT,
            PHA.SEGMENT1,
            AI.CREATION_DATE,
            AI.VENDOR_SITE_ID,
            AI.INVOICE_DATE,
            GC.SEGMENT1,
            AI.ORG_ID,
            AI.INVOICE_ID,
            AD.ACCOUNTING_DATE,
            AI.PARTY_ID,
            AV.VENDOR_TYPE_LOOKUP_CODE,
            AV.ATTRIBUTE13,
            AV.VENDOR_ID,
            AV.SEGMENT1,
            AV.VENDOR_NAME,
            AI.INVOICE_TYPE_LOOKUP_CODE,
            AI.INVOICE_NUM,
            AI.DOC_SEQUENCE_VALUE,
            AD.DESCRIPTION,
            GC.SEGMENT5,
            GC.SEGMENT4,
            GC.SEGMENT3,
            GC.SEGMENT6,
            GC.SEGMENT7,
            --   GC.SEGMENT8,
            AD.DIST_CODE_COMBINATION_ID,
            --    AD.INVOICE_DISTRIBUTION_ID,
            AI.INVOICE_CURRENCY_CODE,
            AD.ATTRIBUTE_CATEGORY,
            AD.ATTRIBUTE1,
            AD.ATTRIBUTE2,
            AD.ATTRIBUTE3,
            AD.ATTRIBUTE4,
            AP_INVOICES_PKG.GET_APPROVAL_STATUS (AI.INVOICE_ID,
                                                 AI.INVOICE_AMOUNT,
                                                 AI.PAYMENT_STATUS_FLAG,
                                                 AI.INVOICE_TYPE_LOOKUP_CODE),
            AI.WFAPPROVAL_STATUS,
            AI.EXCHANGE_RATE,
            NVL (AD.ATTRIBUTE_CATEGORY, AIL.ATTRIBUTE_CATEGORY),
            NVL (AD.ATTRIBUTE1, AIL.ATTRIBUTE1),
            AD.ATTRIBUTE2,
            AD.ATTRIBUTE3,
            AD.ATTRIBUTE4,
            AD.ATTRIBUTE5,
            AP_INVOICES_PKG.GET_POSTING_STATUS (AI.INVOICE_ID)
            ORDER BY   INVOICE_NUM
        

