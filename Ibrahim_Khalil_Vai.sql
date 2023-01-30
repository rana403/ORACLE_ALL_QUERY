



--==============================================================================================================================
--Month and OU  WISE AP INvoice, GRN ,PO,LC Number--GRN Month ERV

SELECT    A.OU,A.ORGANIZATION_CODE,A.VENDOR_NAME,A.PO_NUMBER, AI.INVOICE_NUM, DOC_SEQUENCE_VALUE VOUCHER_NUMBER, 
AD.ACCOUNTING_DATE GL_DATE,AI.DESCRIPTION, AIL.LINE_TYPE_LOOKUP_CODE,
RECEIPT_NUMBER,RECEIPT_DATE,TRUNC(A.CREATION_DATE) RECEIPT_CREATION_DATE,PO_NUMBER,LC_NUMBER, DECODE (PE.DESCRIPTION, NULL, '', PE.DESCRIPTION) LC_CHARGE_TYPE,
NVL (AD.BASE_AMOUNT, AD.AMOUNT) AMOUNT
 FROM XX_PO_RECEIPT A, AP_INVOICE_LINES_ALL AIL,  
  AP_INVOICES_ALL AI, AP_INVOICE_DISTRIBUTIONS_ALL AD,PON_PRICE_ELEMENT_TYPES_TL PE
WHERE A.PO_HEADER_ID=AIL.PO_HEADER_ID
AND A.TRANSACTION_ID=AIL.RCV_TRANSACTION_ID
AND AI.INVOICE_ID= AIL.INVOICE_ID
AND A.ORG_ID=AI.ORG_ID
AND AI.INVOICE_ID= AD.INVOICE_ID
AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
AND AI.CANCELLED_DATE IS NULL
AND A.RECEIPT_DATE in ('Oct-18')--=:P_PERIOD-- ('Sep-18','Oct-18')
and ai.org_id=104
AND AD.INVOICE_LINE_NUMBER=LINE_NUMBER
  AND AIL.COST_FACTOR_ID = PE.PRICE_ELEMENT_TYPE_ID(+)
--AND B.ACCOUNTING_DATE NOT BETWEEN :P_DATE_FROM AND :P_DATE_TO_ONE
--AND AD.ACCOUNTING_DATE   BETWEEN '01-oct-2018' and '31-oct-2018'
--and GET_GL_CODE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID)='2010201'
AND AIL.LINE_TYPE_LOOKUP_CODE<>'MISCELLANEOUS'
and ad.LINE_TYPE_LOOKUP_CODE='ERV'
--AND INVOICE_NUM='KBD-80000489'
--and DOC_SEQUENCE_VALUE='190001534'
ORDER BY A.PO_HEADER_ID,AI.INVOICE_ID,AIL.LINE_NUMBER;


--Month and OU  WISE AP INvoice, GRN ,PO,LC Number---other GRN month ERV

SELECT    A.OU,A.ORGANIZATION_CODE,A.VENDOR_NAME,A.PO_NUMBER, AI.INVOICE_NUM, DOC_SEQUENCE_VALUE VOUCHER_NUMBER, 
AD.ACCOUNTING_DATE GL_DATE,AI.DESCRIPTION, AIL.LINE_TYPE_LOOKUP_CODE,
RECEIPT_NUMBER,RECEIPT_DATE,TRUNC(A.CREATION_DATE) RECEIPT_CREATION_DATE,PO_NUMBER,LC_NUMBER, DECODE (PE.DESCRIPTION, NULL, '', PE.DESCRIPTION) LC_CHARGE_TYPE,
NVL (AD.BASE_AMOUNT, AD.AMOUNT) AMOUNT
 FROM XX_PO_RECEIPT A, AP_INVOICE_LINES_ALL AIL,  
  AP_INVOICES_ALL AI, AP_INVOICE_DISTRIBUTIONS_ALL AD,PON_PRICE_ELEMENT_TYPES_TL PE
WHERE A.PO_HEADER_ID=AIL.PO_HEADER_ID
AND A.TRANSACTION_ID=AIL.RCV_TRANSACTION_ID
AND AI.INVOICE_ID= AIL.INVOICE_ID
AND A.ORG_ID=AI.ORG_ID
AND AI.INVOICE_ID= AD.INVOICE_ID
AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
AND AI.CANCELLED_DATE IS NULL
AND A.RECEIPT_DATE not in ('Oct-18')--=:P_PERIOD-- ('Sep-18','Oct-18')
and ai.org_id=104
AND AD.INVOICE_LINE_NUMBER=LINE_NUMBER
  AND AIL.COST_FACTOR_ID = PE.PRICE_ELEMENT_TYPE_ID(+)
--AND B.ACCOUNTING_DATE NOT BETWEEN :P_DATE_FROM AND :P_DATE_TO_ONE
AND AD.ACCOUNTING_DATE   BETWEEN '01-oct-2018' and '31-oct-2018'
--and GET_GL_CODE_FROM_CCID (AD.DIST_CODE_COMBINATION_ID)='2010201'
AND AIL.LINE_TYPE_LOOKUP_CODE<>'MISCELLANEOUS'
and ad.LINE_TYPE_LOOKUP_CODE='ERV'
--AND INVOICE_NUM='KBD-80000489'
--and DOC_SEQUENCE_VALUE='190001534'
ORDER BY A.PO_HEADER_ID,AI.INVOICE_ID,AIL.LINE_NUMBER;

--=====================================================================================================================================
   ---------------Asset invoice update proces where asset tracking flag is N   
         
 declare
cursor c1 is  

select distinct  'PO Match'  sl,ai.invoice_id,ai.org_id,gc.segment1,gc.segment2,gc.segment3,gc.segment6, -- get_flex_values_from_flex_id ( get_segment_value_from_ccid (ad.dist_code_combination_id, 1),1) bal_seg_name,
          ai.invoice_num,ail.line_number,ai.gl_date, fbc.book_type_code,ai. doc_sequence_value voucher,item_code,ad.po_distribution_id,pha.segment1 po_number,rsh.receipt_num receipt_number,rsh.creation_date receipt_date,
          wio.organization_code, wio.organization_name       --  xx_get_emp_name_from_user_id(:p_user_id) user_name       --    rsh.ship_to_org_id,
     from ap_invoices_all ai,
          ap_invoice_distributions_all ad,
          ap_invoice_lines_all ail,
          gl_code_combinations gc,
          ap_suppliers av,
          po_headers_all pha,
           rcv_shipment_headers rsh,
           wbi_inv_org_d wio,
           rcv_transactions rt,
           fa_book_controls fbc,
           wbi_xxkbgitem_mt_d wxmd
    where     ai.invoice_id = ad.invoice_id
          and ad.dist_code_combination_id = gc.code_combination_id
          and ail.invoice_id = ad.invoice_id
          and ail.line_number = ad.invoice_line_number
         and ail.po_header_id = pha.po_header_id
         and rt.transaction_id=ail.rcv_transaction_id
           and rt.shipment_header_id = rsh.shipment_header_id
         and rsh.ship_to_org_id = wio.organization_id
         and ai.set_of_books_id=fbc.set_of_books_id
           and rsh.ship_to_org_id is not null
        and ail.inventory_item_id=wxmd.inventory_item_id -- in ( select distinct  from   mtl_system_items_b where segment1='FA' )
        and item_segment_1='FA' 
         and ad.assets_tracking_flag='N'
          and nvl (ad.reversal_flag, 'N') <> 'Y'
          and ai.cancelled_date is null
         and ad.line_type_lookup_code='ACCRUAL'
          and nvl (ad.base_amount, ad.amount) <> 0
          and ad.match_status_flag = 'A'
       -- AND XX_GET_INVOICE_STATUS (AI.INVOICE_ID) NOT IN   ('Needs Revalidation', 'Never Validated', 'Unpaid')
          and ai.vendor_id = av.vendor_id
    --      AND AI.INVOICE_NUM='INV-CVAG-2018-015952, 6059'
--       and gc.segment1=nvl(:p_company,gc.segment1)  
       and wio.organization_code not in ('PWD','TRD','KRD','KBD','KAD','KOD','KLD','KWD','SBD','KSD')
 -- and  (:p_date_from  is null or ai.gl_date between :p_date_from  and :p_date_to) 
  order by to_date(gl_date);
  
 begin  
 
  for i in c1 loop

--FOR ASSET ASSET_TRACKING_FLAG DEFAULT Y  AND ASSETS_ADDITION_FLAG DEFAULT U  AND ASSET_BOOK_TYPE_CODE WILL BE NOT NULL  SUCH AS  'KSPL CORP BOOK'

update ap_invoice_distributions_all
set assets_tracking_flag='Y'
, assets_addition_flag='U'
, asset_book_type_code=i.book_type_code
where   assets_tracking_flag='N' and line_type_lookup_code='ACCRUAL'  
and invoice_id = i.invoice_id and  org_id=i.org_id and invoice_line_number=i.line_number;

--update po_distributions_all column  code_combination_id and  VARIANCE_ACCOUNT_ID if need  it will be assets clearing id code combination..

update  po_distributions_all 
set  code_combination_id =(select code_combination_id  from gl_code_combinations where segment1=i.segment1 and segment4 ='1010115' and segment2=i.segment2 and segment3=i.segment3 and segment6=i.segment6)
--VARIANCE_ACCOUNT_ID 
where po_distribution_id =i.po_distribution_id and  org_id=i.org_id;

end loop;
commit;
end;
------------------------------------------------------END Process   ----------------------------------------------------


--==============================================================================================================================

--MONTH AND OU  WISE  PAYMENT ,AP INVOICE ,GRN ,PO,LC NUMBER--IN GRN  MONTH
--====================================================================================

SELECT   DISTINCT  A.OU,A.ORGANIZATION_CODE,A.VENDOR_NAME,A.PO_NUMBER, AI.INVOICE_NUM, AI.DOC_SEQUENCE_VALUE VOUCHER_NUMBER, 
AD.ACCOUNTING_DATE GL_DATE,AI.DESCRIPTION, AIL.LINE_TYPE_LOOKUP_CODE,
RECEIPT_NUMBER,RECEIPT_DATE,TRUNC(A.CREATION_DATE) RECEIPT_CREATION_DATE,LC_NUMBER, DECODE (PE.DESCRIPTION, NULL, '', PE.DESCRIPTION) LC_CHARGE_TYPE,
 CK.DOC_SEQUENCE_VALUE PAY_VOUCHER_NUMBER,TRUNC (CK.CHECK_DATE) PAYMENT_GL_DATE,CK.BANK_ACCOUNT_NAME,CK.CHECK_NUMBER,ck.DOC_CATEGORY_CODE,
AI.INVOICE_AMOUNT, CK.AMOUNT PAYMENT_AMOUNT,
NVL (AD.BASE_AMOUNT, AD.AMOUNT) Dis_AMOUNT
 FROM XX_PO_RECEIPT A, AP_INVOICE_LINES_ALL AIL, AP_INVOICES_ALL AI, AP_INVOICE_DISTRIBUTIONS_ALL AD,PON_PRICE_ELEMENT_TYPES_TL PE,AP_INVOICE_PAYMENTS_ALL PM,AP_CHECKS_ALL CK
WHERE A.PO_HEADER_ID=AIL.PO_HEADER_ID
AND A.TRANSACTION_ID=AIL.RCV_TRANSACTION_ID
AND AI.INVOICE_ID= AIL.INVOICE_ID
AND A.ORG_ID=AI.ORG_ID
AND AI.INVOICE_ID= AD.INVOICE_ID
AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
AND AI.CANCELLED_DATE IS NULL
AND A.RECEIPT_DATE in ('Oct-18') 
AND AI.ORG_ID=104
AND AD.INVOICE_LINE_NUMBER=LINE_NUMBER
AND AIL.COST_FACTOR_ID = PE.PRICE_ELEMENT_TYPE_ID(+)
AND AI.INVOICE_ID=PM.INVOICE_ID(+)
AND PM.CHECK_ID=CK.CHECK_ID(+) 
AND NVL (CK.STATUS_LOOKUP_CODE, 'XX') <> 'VOIDED'
 AND NVL (PM.REVERSAL_FLAG, 'N') <> 'Y'
--AND B.ACCOUNTING_DATE NOT BETWEEN :P_DATE_FROM AND :P_DATE_TO_ONE
AND AD.ACCOUNTING_DATE  NOT BETWEEN '01-oct-2018' and '31-oct-2018'
AND AIL.LINE_TYPE_LOOKUP_CODE='MISCELLANEOUS'
ORDER BY AI.DOC_SEQUENCE_VALUE


--Month and OU  WISE  Payment ,AP INvoice ,GRN ,PO,LC Number--NOT IN GRN  Month
--===============================================================================================

SELECT   DISTINCT  A.OU,A.ORGANIZATION_CODE,A.VENDOR_NAME,A.PO_NUMBER, AI.INVOICE_NUM, AI.DOC_SEQUENCE_VALUE VOUCHER_NUMBER, 
AD.ACCOUNTING_DATE GL_DATE,AI.DESCRIPTION, AIL.LINE_TYPE_LOOKUP_CODE,
RECEIPT_NUMBER,RECEIPT_DATE,TRUNC(A.CREATION_DATE) RECEIPT_CREATION_DATE,LC_NUMBER, DECODE (PE.DESCRIPTION, NULL, '', PE.DESCRIPTION) LC_CHARGE_TYPE,
 CK.DOC_SEQUENCE_VALUE PAY_VOUCHER_NUMBER,TRUNC (CK.CHECK_DATE) PAYMENT_GL_DATE,CK.BANK_ACCOUNT_NAME,CK.CHECK_NUMBER,ck.DOC_CATEGORY_CODE,
AI.INVOICE_AMOUNT, CK.AMOUNT PAYMENT_AMOUNT,
NVL (AD.BASE_AMOUNT, AD.AMOUNT) Dis_AMOUNT
 FROM XX_PO_RECEIPT A, AP_INVOICE_LINES_ALL AIL, AP_INVOICES_ALL AI, AP_INVOICE_DISTRIBUTIONS_ALL AD,PON_PRICE_ELEMENT_TYPES_TL PE,AP_INVOICE_PAYMENTS_ALL PM,AP_CHECKS_ALL CK
WHERE A.PO_HEADER_ID=AIL.PO_HEADER_ID
AND A.TRANSACTION_ID=AIL.RCV_TRANSACTION_ID
AND AI.INVOICE_ID= AIL.INVOICE_ID
AND A.ORG_ID=AI.ORG_ID
AND AI.INVOICE_ID= AD.INVOICE_ID
AND NVL (AD.REVERSAL_FLAG, 'N') <> 'Y'
AND AI.CANCELLED_DATE IS NULL
AND A.RECEIPT_DATE NOT IN ('Oct-18') 
AND AI.ORG_ID=104
AND AD.INVOICE_LINE_NUMBER=LINE_NUMBER
AND AIL.COST_FACTOR_ID = PE.PRICE_ELEMENT_TYPE_ID(+)
AND AI.INVOICE_ID=PM.INVOICE_ID(+)
AND PM.CHECK_ID=CK.CHECK_ID(+) 
AND NVL (CK.STATUS_LOOKUP_CODE, 'XX') <> 'VOIDED'
 AND NVL (PM.REVERSAL_FLAG, 'N') <> 'Y'
--AND B.ACCOUNTING_DATE NOT BETWEEN :P_DATE_FROM AND :P_DATE_TO_ONE
AND AD.ACCOUNTING_DATE BETWEEN '01-oct-2018' and '31-oct-2018'
AND AIL.LINE_TYPE_LOOKUP_CODE='MISCELLANEOUS'
ORDER BY AI.DOC_SEQUENCE_VALUE



--=================================================================================================================





--LOAN OPENING BALANCE TABLE  
--===============================
TABLE NAME: XX_BANK_OPENING_BALANCE

LOAN DATA VIEW NAME :XX_LOAN_VW_K

SELECT * FROM XX_LOAN_VW_K


--FOR SHIP NAME CREATE in CUSTOM TABLE
--=================================

select * from XXKSRM_SCRAP_SHIP

REPORT NAME: KSRM BATCHWISE PRODUCTION SHIP WISE

%%ShipName%%




--==============================
--FOR UPDATE ACCUMULATE CUSTOMER BALANCE RUN ONE LINE BELLOW PROCESS
--===============================
EXEC    AR_CUST_ACCUMU_BAl_TEMP_PRO;






-- ======================
--FOR LC IN TRANSIT REPORT 
--======================

 SELECT * from  XX_LCINTRANSIT_TEMP --XX_LCINTRANSIT_VK


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


--=========================================================================================


--CREATE OR REPLACE PROCEDURE XX_LCINTRANSIT_TEMP_PRO
--IS 
BEGIN
delete XX_LCINTRANSIT_TEMP;
   MERGE INTO XX_LCINTRANSIT_TEMP LCTEM
      USING (     SELECT * from XX_LCINTRANSIT_VK       ) LCT
      ON (LCTEM.TRANSACTION_ID = LCT.TRANSACTION_ID)
      WHEN MATCHED THEN
         UPDATE
            SET    --LCTEM.TRANSACTION_ID=LCT.TRANSACTION_ID,
    LCTEM.GL_DATE=LCT.GL_DATE,
    LCTEM.PARTY_NAME=LCT.PARTY_NAME,
    LCTEM.INVOICE_NUM=LCT.INVOICE_NUM,
    LCTEM.INVOICE_DATE=LCT.INVOICE_DATE,
    LCTEM.INVOICE_AMOUNT=LCT.INVOICE_AMOUNT,
    LCTEM.VOUCHER=LCT.VOUCHER,
    LCTEM.DESCRIPTION=LCT.DESCRIPTION,
    LCTEM.DR_AMOUNT=LCT.DR_AMOUNT,
    LCTEM.CR_AMOUNT=LCT.CR_AMOUNT,
    LCTEM.PR_NO=LCT.PR_NO,
    LCTEM.DIST_GL_CODE=LCT.DIST_GL_CODE,
    LCTEM.GL_CODE_AND_DESC=LCT.GL_CODE_AND_DESC,
   LCTEM.BAL_SEG=LCT.BAL_SEG,
   LCTEM.BAL_SEG_NAME=LCT.BAL_SEG_NAME,
   LCTEM.ORGANIZATION_ID=LCT.ORGANIZATION_ID,
   LCTEM.ORGANIZATION_CODE=LCT.ORGANIZATION_CODE,
   LCTEM.ORGANIZATION_NAME=LCT.ORGANIZATION_NAME,
   LCTEM.PO_NUMBER=LCT.PO_NUMBER,
   LCTEM.RECEIPT_NUMBER=LCT.RECEIPT_NUMBER,
   LCTEM.RECEIPT_DATE=LCT.RECEIPT_DATE,
   LCTEM.SHIP_TO_ORG_ID=LCT.SHIP_TO_ORG_ID,
   LCTEM.LC_ID=LCT.LC_ID,
   LCTEM.LC_NUMBER=LCT.LC_NUMBER,
   LCTEM.LC_CHARGE_TYPE = LCT.LC_CHARGE_TYPE
      WHEN NOT MATCHED THEN
         INSERT ( LCTEM.TRANSACTION_ID,
    LCTEM.GL_DATE,
    LCTEM.PARTY_NAME,
    LCTEM.INVOICE_NUM,
    LCTEM.INVOICE_DATE,
    LCTEM.INVOICE_AMOUNT,
    LCTEM.VOUCHER,
    LCTEM.DESCRIPTION,
    LCTEM.DR_AMOUNT,
    LCTEM.CR_AMOUNT,
    LCTEM.PR_NO,
    LCTEM.DIST_GL_CODE,
    LCTEM.GL_CODE_AND_DESC,
   LCTEM.BAL_SEG,
   LCTEM.BAL_SEG_NAME,
   LCTEM.ORGANIZATION_ID,
   LCTEM.ORGANIZATION_CODE,
   LCTEM.ORGANIZATION_NAME,
   LCTEM.PO_NUMBER,
   LCTEM.RECEIPT_NUMBER,
   LCTEM.RECEIPT_DATE,
   LCTEM.SHIP_TO_ORG_ID,
   LCTEM.LC_ID,
   LCTEM.LC_NUMBER,
   LCTEM.LC_CHARGE_TYPE          )
         VALUES (  LCT.TRANSACTION_ID,
     LCT.GL_DATE,
     LCT.PARTY_NAME,
     LCT.INVOICE_NUM,
    LCT.INVOICE_DATE,
     LCT.INVOICE_AMOUNT,
     LCT.VOUCHER,
     LCT.DESCRIPTION,
     LCT.DR_AMOUNT,
     LCT.CR_AMOUNT,
     LCT.PR_NO,
     LCT.DIST_GL_CODE,
     LCT.GL_CODE_AND_DESC,
    LCT.BAL_SEG,
    LCT.BAL_SEG_NAME,
    LCT.ORGANIZATION_ID,
    LCT.ORGANIZATION_CODE,
    LCT.ORGANIZATION_NAME,
    LCT.PO_NUMBER,
    LCT.RECEIPT_NUMBER,
    LCT.RECEIPT_DATE,
    LCT.SHIP_TO_ORG_ID,
    LCT.LC_ID,
    LCT.LC_NUMBER,
     LCT.LC_CHARGE_TYPE);
     
     COMMIT;
    
--    exception 
--    when others then  null;
END;


--===================================================================

SELECT  QUANTITY  ,TO_CHAR(STATUS_DATE,'DD-MON-RRRR') STATUS_DATE
FROM MTL_TXN_REQUEST_LINES 
WHERE INVENTORY_ITEM_ID= 1054 --4271
AND  ORGANIZATION_ID  = 121
AND STATUS_DATE = (SELECT MAX(STATUS_DATE) STATUS_DATE FROM MTL_TXN_REQUEST_LINES WHERE  INVENTORY_ITEM_ID= 1054 --4271
AND  ORGANIZATION_ID  = 121  )




--CASE: WE REQUIRED TO UPDATE GRN DATE BECAUSE AT THE TIME OF GO LIVE SEPTEMBER 2018,  MANY DEEP SEA GRN WAS NOT COMPLETED WITHIN THAT MONTH. SUPPOSE IOT(Inter Org Transfer) DATE WAS SEPTEMBER 2018 BUT GRN WAS DECEMBER 2018. 

--NOTE:WE HAVE TO CONFIRM THAT THERE WILL NO DUPLICATE GRN DATA IN EXCEL SHEET,COZ SHIPMENT_HEADERS_ALL TABLE HAVE UNIQUE GRN NUMBER ACCORDING TO INV ORG

1. IN THAT CASE WE FIRST UPDATE RCV_SHIPMENT_HEADERS CREATION DATE ACCORDING TO XX_SHIPMENT_DATE_TEMP TABLE 
===================================================================================================
DECLARE 
CURSOR C1 IS
SELECT  A.SHIPMENT_HEADER_ID,A.SHIP_TO_ORG_ID,C.ATCTUAL_DELIVERY_DATE
FROM RCV_SHIPMENT_HEADERS A, XX_SHIPMENT_DATE_TEMP C
WHERE A.SHIP_TO_ORG_ID=C.ORGANIZATION_ID
AND  A.RECEIPT_NUM = C.RECEIPT_NUM
AND  A.SHIP_TO_ORG_ID = C.ORGANIZATION_ID
AND A.SHIP_TO_ORG_ID = 149
--and A.RECEIPT_NUM = 80000379
ORDER BY 1;
BEGIN 
 FOR I IN C1 LOOP
UPDATE RCV_SHIPMENT_HEADERS A
SET A.LAST_UPDATE_DATE=I.ATCTUAL_DELIVERY_DATE, 
A.CREATION_DATE= I.ATCTUAL_DELIVERY_DATE
WHERE 1=1
AND  A.SHIPMENT_HEADER_ID=I.SHIPMENT_HEADER_ID
 AND A.SHIP_TO_ORG_ID= I.SHIP_TO_ORG_ID
--AND A.RECEIPT_NUM= 80000379
AND A.SHIP_TO_ORG_ID = 149;
END LOOP C1;
EXCEPTION WHEN OTHERS THEN
 NULL;
END;
====================================================================================================
2. THEN CREATE A PROCEDURE AND UPDATE RCV_SHIPMENT_LINES INFORMATION DATE ACCORDING TO RCV_SHIPMENT_HEADERS CREATION DATE;
====================================================================================================
DECLARE 
 CURSOR C1 IS 
 
SELECT A.SHIPMENT_HEADER_ID,A.RECEIPT_NUM,A.SHIP_TO_ORG_ID,A.CREATION_DATE ACTUAL_DELIVERY_DATE,C.CREATION_DATE,C.LAST_UPDATE_DATE,C.PROGRAM_UPDATE_DATE
FROM RCV_SHIPMENT_HEADERS A , RCV_SHIPMENT_LINES C 
WHERE  A.SHIPMENT_HEADER_ID=C.SHIPMENT_HEADER_ID 
AND A.SHIP_TO_ORG_ID=C.TO_ORGANIZATION_ID
AND A.RECEIPT_NUM IN (SELECT  RECEIPT_NUM FROM XX_SHIPMENT_DATE_TEMP )
AND A.SHIP_TO_ORG_ID=166
--AND A.RECEIPT_NUM='80000002'
ORDER BY 1;


BEGIN 

 FOR I IN C1 LOOP
 
 UPDATE  RCV_SHIPMENT_LINES C 
SET  C.CREATION_DATE=I.ACTUAL_DELIVERY_DATE,
       C.LAST_UPDATE_DATE=I.ACTUAL_DELIVERY_DATE,
       C.PROGRAM_UPDATE_DATE=I.ACTUAL_DELIVERY_DATE
    --C.ATTRIBUTE10='LI'
    WHERE C.SHIPMENT_HEADER_ID=I.SHIPMENT_HEADER_ID
    AND C.TO_ORGANIZATION_ID= I.SHIP_TO_ORG_ID;
 
UPDATE XX_SHIPMENT_DATE_TEMP
SET UPDATE_CHECK='LI'
WHERE RECEIPT_NUM=I.RECEIPT_NUM;

END LOOP C1;

EXCEPTION WHEN OTHERS THEN
 NULL;
END;

===================================================================================================================

3. THEN CREATE A PROCEDURE AND UPDATE RCV_TRANSACTIONS INFORMATION DATE ACCORDING TO RCV_SHIPMENT_HEADERS CREATION DATE;
====================================================================================================================
DECLARE 
  CURSOR C1 IS 
  
  SELECT  A.SHIPMENT_HEADER_ID,A.SHIP_TO_ORG_ID,A.CREATION_DATE ACTUAL_DELIVERY_DATE,
C.CREATION_DATE,C.PROGRAM_UPDATE_DATE,C.TRANSACTION_DATE,C.LAST_UPDATE_DATE,C.CURRENCY_CONVERSION_DATE 
 FROM  RCV_SHIPMENT_HEADERS A, RCV_TRANSACTIONS C 
 WHERE A.SHIPMENT_HEADER_ID=C.SHIPMENT_HEADER_ID 
 AND  A.SHIP_TO_ORG_ID=C.ORGANIZATION_ID
 AND  A.RECEIPT_NUM IN (SELECT  RECEIPT_NUM FROM XX_SHIPMENT_DATE_TEMP )
 AND  A.SHIP_TO_ORG_ID=166;
--AND A.RECEIPT_NUM='80000002';
--and  c.SHIPMENT_HEADER_ID=186037 

BEGIN 

 FOR I IN C1 LOOP
 
 UPDATE  RCV_TRANSACTIONS C 
SET  C.CREATION_DATE=I.ACTUAL_DELIVERY_DATE,
      C.PROGRAM_UPDATE_DATE=I.ACTUAL_DELIVERY_DATE,
      C.TRANSACTION_DATE=I.ACTUAL_DELIVERY_DATE,
      C.LAST_UPDATE_DATE=I.ACTUAL_DELIVERY_DATE,
      --C.ATTRIBUTE9=I.ATCTUAL_DELIVERY_DATE,
      C.CURRENCY_CONVERSION_DATE =I.ACTUAL_DELIVERY_DATE
    WHERE C.SHIPMENT_HEADER_ID=I.SHIPMENT_HEADER_ID
    AND C.ORGANIZATION_ID= I.SHIP_TO_ORG_ID;
    
 
END LOOP C1;

EXCEPTION WHEN OTHERS THEN
 NULL;
END;

--======================================================================================================================








--===========================================================
-- GET MORE GRN NUMBER IN ONE LINE WHICH IS CAPTURED IN A INVOICE
--===========================================================
--select XX_GET_LC_NUMBER_FROM_INV(1364914) from dual
--===================================================================================
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

--============================================================================================
-- GET LC NUMBER AGAINST INVOICE
--============================================================================================
--CREATE OR REPLACE FUNCTION APPS.XX_GET_LC_NUMBER_FROM_INV (P_INVOICE_ID NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT        XX_LC_DETAILS.LC_NUMBER%TYPE;
      V_RESULT_LIST   VARCHAR2 (2000) := NULL;

      CURSOR P_CURSOR
      IS
       SELECT distinct LC_NUMBER
    FROM   AP_INVOICE_LINES_V PH, XX_LC_DETAILS LC           
       WHERE PH.PO_HEADER_ID= LC.PO_HEADER_ID   
       AND INVOICE_ID = P_INVOICE_ID;
   BEGIN
      OPEN P_CURSOR;

      LOOP
         FETCH P_CURSOR INTO V_RESULT;

         EXIT WHEN P_CURSOR%NOTFOUND;

         IF (V_RESULT_LIST IS NOT NULL)
         THEN
            V_RESULT_LIST := V_RESULT_LIST;
         END IF;

         V_RESULT_LIST := V_RESULT_LIST ||','|| V_RESULT;
      END LOOP;

      CLOSE P_CURSOR;

      RETURN (V_RESULT_LIST);
   END;
/

--===========================================================================================
--CREATE OR REPLACE FUNCTION APPS.XX_GET_PO_NUMBER_FROM_INV (P_INVOICE_ID NUMBER)
      RETURN VARCHAR2
   IS
      V_RESULT        AP_INVOICE_LINES_V.PO_NUMBER%TYPE;
      V_RESULT_LIST   VARCHAR2 (2000) := NULL;

      CURSOR P_CURSOR
      IS
         SELECT DISTINCT PO_NUMBER
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
/


--=======================================================================================
-- GET QUANTITY AND LAST GRN DATE FROM SUB QUERY
--=======================================================================================
SELECT  QUANTITY  ,TO_CHAR(STATUS_DATE,'DD-MON-RRRR') STATUS_DATE
FROM MTL_TXN_REQUEST_LINES 
WHERE INVENTORY_ITEM_ID= 1851 --4271
AND  ORGANIZATION_ID  = 121
AND STATUS_DATE = (SELECT MAX(STATUS_DATE) STATUS_DATE FROM MTL_TXN_REQUEST_LINES WHERE  INVENTORY_ITEM_ID= 1851 --4271
AND  ORGANIZATION_ID  = 121  )

--==================================== OPM DATA DELETE SR BY IBRAHIM VHAI============================================================================================



--Perform the following action plan on the TEST instance. The scripts will remove all records so you will need to re-run the processes starting with Landed Cost Adjustment Import Process:

--1. Please make sure that the start and end of your period are entered for the transaction dates in the scripts.
--2. Make sure that Extract Lines are deleted before extract headers, otherwise lines would not get deleted.

--3. It is not necessary to delete cm_cmpt_dtl and cm_acst_led records as running ACP would do it. However it does not hurt to execute the delete as well.

--A)delete record from

DELETE
FROM gmf_lc_actual_cost_adjs
WHERE adj_transaction_id IN
(SELECT adj_transaction_id
FROM gmf_lc_adj_transactions
WHERE legal_entity_id IN (&legal_entity)
and rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions
WHERE TRANSACTION_DATE >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')
)
);

--Note that at least one customer found that not all the duplicate data was deleted with the above script, so they ran the following instead:

Delete from gmf.gmf_lc_actual_cost_adjs where period_id = &period_id;

select * from gmf.gmf_lc_actual_cost_adjs where period_id = &period_id;


--B)

DELETE
FROM gmf_lc_adj_transactions
WHERE legal_entity_id IN (&legal_entity)
and rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions
WHERE TRANSACTION_DATE >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')
);


--4. Verify and confirm there are no duplicate records now, and migrate to production as you see fit.

Best regards,
Anca
Note that at least one customer found that not all the duplicate data was deleted with the above script, so they ran the following instead:

Delete
from gmf.gmf_lc_adj_transactions
where legal_entity_id = &legal_entity
and transaction_date >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
and transaction_date <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')


select * 
from gmf.gmf_lc_adj_transactions
where legal_entity_id = &legal_entity
and transaction_date >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
and transaction_date <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')


--C)

DELETE
FROM gmf_xla_extract_lines
WHERE header_id IN
(SELECT header_id
FROM gmf_xla_extract_headers
WHERE legal_entity_id IN (&legal_entity)
AND entity_code = 'PURCHASING'
AND TRANSACTION_DATE >= to_date('01-09-2018 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date('30-09-2018 23:59:59', 'DD-MM-YYYY HH24:MI:SS'));


DELETE
FROM gmf_xla_extract_headers
WHERE legal_entity_id IN  (&legal_entity)
AND entity_code = 'PURCHASING'
AND TRANSACTION_DATE >= to_date('01-09-2018 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date('30-09-2018 23:59:59', 'DD-MM-YYYY HH24:MI:SS');


--D)

DELETE FROM CM_ACST_LED WHERE period_id IN(&period_id);

select *   FROM CM_ACST_LED WHERE period_id IN(&period_id);


--E)

DELETE FROM CM_CMPT_DTL WHERE period_id IN(&period_id);


--F)

COMMIT; 

-------------------------sr query------------------no need to delete part

Select *
FROM gmf_lc_actual_cost_adjs
WHERE adj_transaction_id IN
(SELECT adj_transaction_id
FROM gmf_lc_adj_transactions
WHERE legal_entity_id IN (26281)
and rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions
WHERE TRANSACTION_DATE >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')))


Select *
FROM gmf_lc_adj_transactions
WHERE legal_entity_id IN (26281)
and rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions
WHERE TRANSACTION_DATE >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS'));


select *  from GMF_LC_ADJ_TRANSACTIONS where CHARGE_LINE_TYPE_CODE is null   and ORGANIZATION_ID=144 order by 2

select * from rcv_transactions where TRANSACTION_ID=288535

select * from rcv_shipment_headers where SHIPMENT_HEADER_ID=373089

select * from po_headers_all where po_header_id=260009--40000237--80000001--SP|MECH|ROLL|031193--2,016,000.00---(6,000.00)

select *  from GMF_LC_ADJ_TRANSACTIONS where CHARGE_LINE_TYPE_CODE is null   and ORGANIZATION_ID=144 and  rcv_transaction_id=288535 order by 2


-------------


select *  from GMF_LC_ADJ_TRANSACTIONS where CHARGE_LINE_TYPE_CODE is null   and ORGANIZATION_ID=144 order by 2

select * from rcv_transactions where TRANSACTION_ID in (283042,283043)

select * from rcv_shipment_headers where SHIPMENT_HEADER_ID=347112

select * from rcv_shipment_headers where RECEIPT_NUM=80000225 and SHIP_TO_ORG_ID=166

select * from po_headers_all where po_header_id=260009--40000237--80000001--SP|MECH|ROLL|031193--2,016,000.00---(6,000.00)

select *  from GMF_LC_ADJ_TRANSACTIONS where CHARGE_LINE_TYPE_CODE is null   and ORGANIZATION_ID=166 and  rcv_transaction_id in (283042,283043) order by 2

select *  from GMF_LC_ADJ_headers_v where  ORGANIZATION_ID=166 and  rcv_transaction_id in (283042,283043) and component_type='ITEM PRICE' order by 2

select *  from GMF_LC_ACTUAL_COST_ADJS where adj_transaction_id in   (1156149,156187,156277,156315)

select *  from GMF_LC_lot_COST_ADJS where adj_transaction_id in   (114349,114310,114433,114395)

select * from mtl_material_transactions where TRANSACTION_ID in (114349)

select  transaction_id from GMF_XLA_EXTRACT_HEADERS where SOURCE_DOCUMENT_ID  in (114349,114310,114433,114395)

select * from mtl_material_transactions  where TRANSACTION_ID in (114310,114395,292797)

select * from mtl_material_transactions  where  RCV_TRANSACTION_ID in (283042,283043)


select *    FROM CM_CMPT_DTL WHERE period_id IN(&period_id);

select * from CM_ACST_LED  where COST_AMT like '%356395.53%'

select * from CM_ACST_LED  where COST_AMT like '%9978830%'

select * from CM_ACST_LED  where TRANSLINE_ID in   (156581,156608,156662,156688)

select *  from GMF_LC_ACTUAL_COST_ADJS where adj_transaction_id in   (156581,156608,156662,156688)

select *  from GMF_LC_ACTUAL_COST_ADJS where TRANS_AMOUNT   like '%35639%'

select *  from GMF_LC_ADJ_TRANSACTIONS where adj_transaction_id in   (156671,156698,8526)

select * from pm_matl_dtl

select *  from GMF_LC_ADJ_TRANSACTIONS where CHARGE_LINE_TYPE_CODE is null   and ORGANIZATION_ID=166 and  rcv_transaction_id in (301665,301666) order by 2


select * from rcv_shipment_headers where SHIPMENT_HEADER_ID=427141

select * from rcv_transactions where SHIPMENT_HEADER_ID=427141



-------------------


Hi Ibrahim,

Development updated the following:
****. Delete LCM related data for a given period using the scripts in the following Note 2240796.1 :
Please do this on a test instance:
1. Run the following:

DELETE
FROM gmf_lc_actual_cost_adjs
WHERE adj_transaction_id IN
(SELECT adj_transaction_id
FROM gmf_lc_adj_transactions
WHERE legal_entity_id =26281
and rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions
WHERE TRANSACTION_DATE >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')
)
);

Note that at least one customer found that not all the duplicate data was deleted with the above script, so they ran the following instead:

Delete from gmf.gmf_lc_actual_cost_adjs where period_id = &period_id;


B)

DELETE
FROM gmf_lc_adj_transactions
WHERE legal_entity_id=26281
and rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions
WHERE TRANSACTION_DATE >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')
);

Note that at least one customer found that not all the duplicate data was deleted with the above script, so they ran the following instead:

Delete
from gmf.gmf_lc_adj_transactions
where legal_entity_id = 26281
and transaction_date >= to_date ('01-09-2018 00:00:00' , 'DD-MM-YYYY HH24:MI:SS')
and transaction_date <= to_date ('30-09-2018 23:59:59' , 'DD-MM-YYYY HH24:MI:SS')


C)

DELETE
FROM gmf_xla_extract_lines
WHERE header_id IN
(SELECT header_id
FROM gmf_xla_extract_headers
WHERE legal_entity_id=26281
AND entity_code = 'PURCHASING'
AND TRANSACTION_DATE >= to_date('01-09-2018 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date('30-09-2018 23:59:59', 'DD-MM-YYYY HH24:MI:SS'));


DELETE
FROM gmf_xla_extract_headers
WHERE legal_entity_id =26281
AND entity_code = 'PURCHASING'
AND TRANSACTION_DATE >= to_date('01-09-2018 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
AND TRANSACTION_DATE <= to_date('30-09-2018 23:59:59', 'DD-MM-YYYY HH24:MI:SS');


D)

DELETE FROM CM_ACST_LED WHERE period_id IN(&period_id);


E)

DELETE FROM CM_CMPT_DTL WHERE period_id IN(&period_id);


F)

COMMIT;



2. Run Landed Cost Adjustments Import Process.

3. Run Actual Cost Process and verify the item cost.

Regards,
Anca 


--------------------


Hi,

Development update:

1. Get data from CM_CMPT_DTL and CM_ACST_LED using the following query
outputs for a sample item.

Substitute proper inventory_item_id (for Item RM|SCRP|SHED|000003) and
period_id (for Period SEP-18 and Cost Type KSRM_ACT)

--CM_CMPT_DTL data
SELECT m.cost_cmpntcls_code, d.*
FROM cm_cmpt_dtl d, cm_cmpt_mst m
WHERE m.cost_cmpntcls_id = d.cost_cmpntcls_id
AND d.inventory_item_id = < USER INPUT >
AND d.period_id = < USER INPUT >;

--CM_ACST_LED data
SELECT * from cm_acst_led
WHERE cmpntcost_id IN
(
SELECT d.cmpntcost_id
FROM cm_cmpt_dtl d
WHERE d.inventory_item_id = < USER INPUT >
AND d.period_id = < USER INPUT >
);

2. Also get these additional query outputs with reference to the po_header_id
against which the Item RM|SCRP|SHED|000003 was received. Replace po_header_id
with suitable value in place of 1.

SELECT * FROM po_headers_all WHERE po_header_id = 1;

SELECT * FROM po_lines_all WHERE po_header_id = 1;

SELECT * FROM po_line_locations_all WHERE po_header_id = 1;

SELECT * FROM po_distributions_all WHERE po_header_id = 1;

SELECT * FROM po_releases_all WHERE po_header_id =1;

SELECT * FROM rcv_parameters
WHERE organization_id IN(
SELECT organization_id
FROM rcv_transactions WHERE po_header_id = 1);

SELECT * FROM rcv_shipment_headers
WHERE shipment_header_id IN(
SELECT shipment_header_id FROM rcv_transactions
WHERE po_header_id = 1);

SELECT * FROM rcv_shipment_lines
WHERE shipment_header_id IN(
SELECT shipment_header_id FROM rcv_transactions
WHERE po_header_id = 1);

SELECT * FROM rcv_transactions WHERE po_header_id = 1;

SELECT * FROM gmf_rcv_accounting_txns WHERE po_header_id = 1;

SELECT * FROM mtl_material_transactions
WHERE rcv_transaction_id IN(
SELECT transaction_id
FROM rcv_transactions
WHERE po_header_id = 1);

SELECT * FROM gmf_lc_adj_headers_v
WHERE rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions WHERE po_header_id = 1)
ORDER BY rcv_transaction_id, adjustment_num;

SELECT * FROM gmf_lc_adj_headers_v glah
WHERE glah.rcv_transaction_id IN
(SELECT transaction_id
FROM rcv_transactions WHERE po_header_id = 1)
AND (glah.component_type IN ('CHARGE','TAX') OR (glah.component_type = 'ITEM
PRICE' AND NVL(glah.prior_unit_landed_cost,0) <> 0))
AND (glah.component_type IN ('CHARGE','TAX') OR (NVL(glah.landed_cost,0) -
NVL(glah.prior_landed_cost,0) <> 0 ))
AND ((NVL(glah.unit_landed_cost,0) - NVL(glah.prior_unit_landed_cost,0) <>
0) OR (glah.lc_adjustment_flag = 0));

SELECT * FROM gmf_lc_adj_transactions
WHERE rcv_transaction_id IN(
SELECT transaction_id
FROM rcv_transactions WHERE po_header_id = 1)
ORDER BY rcv_transaction_id, adjustment_num;

SELECT * FROM gmf_lc_actual_cost_adjs
WHERE adj_transaction_id IN(
SELECT adj_transaction_id
FROM gmf_lc_adj_transactions
WHERE rcv_transaction_id IN(
SELECT transaction_id
FROM rcv_transactions
WHERE po_header_id = 1));

SELECT * FROM gmf_period_statuses;

SELECT * FROM gmf_organization_definitions;


Regards,
Anca 