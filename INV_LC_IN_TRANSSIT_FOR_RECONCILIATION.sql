-- ===================================
-- DETAILS QUERY FOR LC IN TRANSIT Date: 11-OCT-2021  
--PARAMETER:  COMPANY: 103 for KBIL, DATE : SEP-18 = DATE FROM: 9/1/2018 , DATE TO : 9/30/2018 
--===================================

SELECT  TRANSACTION_ID,
   GL_DATE,
   PARTY_NAME,
   INVOICE_NUM,
   INVOICE_DATE,
   INVOICE_AMOUNT,
   VOUCHER,
   DESCRIPTION,
   SUM(nvl(DR_AMOUNT,0)) DR_AMOUNT,
   SUM(nvl(CR_AMOUNT,0)) CR_AMOUNT,
   PR_NO,
   DIST_GL_CODE,
   GL_CODE_AND_DESC,
   BAL_SEG,
   BAL_SEG_NAME,
   ORGANIZATION_ID,
   ORGANIZATION_CODE,
   ORGANIZATION_NAME,
   PO_NUMBER,
   RECEIPT_NUMBER,
   RECEIPT_DATE,
   SHIP_TO_ORG_ID,
   LC_ID,
   LC_NUMBER,
   LC_CHARGE_TYPE
   from (    SELECT 
 TRANSACTION_ID,
   GL_DATE,
   PARTY_NAME,
   INVOICE_NUM,
   INVOICE_DATE,
   INVOICE_AMOUNT,
   VOUCHER,
   DESCRIPTION,
   DR_AMOUNT,
   CR_AMOUNT,
   PR_NO,
   DIST_GL_CODE,
   GL_CODE_AND_DESC,
   BAL_SEG,
   BAL_SEG_NAME,
   ORGANIZATION_ID,
   ORGANIZATION_CODE,
   ORGANIZATION_NAME,
   PO_NUMBER,
   RECEIPT_NUMBER,
   RECEIPT_DATE,
   SHIP_TO_ORG_ID,
   LC_ID,
   LC_NUMBER,
   LC_CHARGE_TYPE,
   XX_GET_EMP_NAME_FROM_USER_ID(:P_USER_ID) USER_NAME
   FROM  XX_LCINTRANSIT_VK
  WHERE BAL_SEG=:P_COMPANY
      AND (:P_LC_ID IS NULL OR LC_ID=NVL(:P_LC_ID,LC_ID))
     AND  (:P_DATE_FROM  IS NULL OR GL_DATE BETWEEN :P_DATE_FROM  AND :P_DATE_TO) )
  group by    TRANSACTION_ID,
   GL_DATE,
   PARTY_NAME,
   INVOICE_NUM,
   INVOICE_DATE,
   INVOICE_AMOUNT,
   VOUCHER,
   DESCRIPTION,
   PR_NO,
   DIST_GL_CODE,
   GL_CODE_AND_DESC,
   BAL_SEG,
   BAL_SEG_NAME,
   ORGANIZATION_ID,
   ORGANIZATION_CODE,
   ORGANIZATION_NAME,
   PO_NUMBER,
   RECEIPT_NUMBER,
   RECEIPT_DATE,
   SHIP_TO_ORG_ID,
   LC_ID,
   LC_NUMBER,
   LC_CHARGE_TYPE
ORDER BY GL_DATE,LC_ID
