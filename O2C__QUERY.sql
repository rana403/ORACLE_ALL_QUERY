
--==================================
-- O2C  TRAINING  INFO
--==================================

--- SELECT * FROM MTL_ONHAND_QUANTITIES_DETAIL

--  ENTER ORDERE 
===============

SELECT * FROM OE_ORDER_HEADERS_ALL WHERE ORDER_NUMBER = '2181010000002'

SELECT FLOW_STATUS_CODE  FROM OE_ORDER_HEADERS_ALL WHERE ORDER_NUMBER = '2181010000002' --> INITIALLY IT WILL BE "ENTERD"

SELECT * FROM OE_ORDER_LINES_ALL WHERE HEADER_ID= 15009

SELECT FLOW_STATUS_CODE FROM OE_ORDER_LINES_ALL WHERE HEADER_ID= 15009 --> INITIALLY IT WILL BE "ENTERD"


--  BOOK THE  ORDERE 
===============


select * from ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID IN(142,
165)


SELECT * FROM OE_ORDER_HEADERS_ALL WHERE ORDER_NUMBER = '2181010000002'

SELECT FLOW_STATUS_CODE  FROM OE_ORDER_HEADERS_ALL WHERE ORDER_NUMBER = '2181010000002' --> IT WILL BE "BOOKED"

SELECT * FROM OE_ORDER_LINES_ALL WHERE HEADER_ID= 15009

SELECT FLOW_STATUS_CODE FROM OE_ORDER_LINES_ALL WHERE HEADER_ID= 15009 -->  --> IT WILL BE "AWETING _SHIPPING"

SELECT * FROM WSH_DELIVERY_DETAILS WHERE SOURCE_HEADER_ID = 15009

STEP-1
--=========

SELECT CUSTOMER_ID,SUM(SHIPPED_QUANTITY) SHIPPED_QUANTITY,  UNIT_PRICE , SUM(SHIPPED_QUANTITY)*UNIT_PRICE AMOUNT FROM WSH_DELIVERY_DETAILS
 WHERE 1=1 --SOURCE_HEADER_ID = 15009 
 GROUP BY UNIT_PRICE,CUSTOMER_ID
 
 Step-2
 --====
 CREATE OR REPLACE VIEW MAX_AMOUNT
 (CUSTOMER_ID,
 SHIPPED_QUANTITY,
 UNIT_PRICE,
 AMOUNT
 )
 AS 
 (SELECT CUSTOMER_ID,SUM(SHIPPED_QUANTITY) SHIPPED_QUANTITY,  UNIT_PRICE , SUM(SHIPPED_QUANTITY)*UNIT_PRICE AMOUNT FROM WSH_DELIVERY_DETAILS
 WHERE 1=1 --SOURCE_HEADER_ID = 15009 
 GROUP BY UNIT_PRICE,CUSTOMER_ID)
 
 Step-3
 --------
 
 SELECT AMOUNT FROM MAX_AMOUNT
 
 SELECT CUSTOMER_ID, AMOUNT FROM MAX_AMOUNT WHERE AMOUNT=(SELECT MAX(AMOUNT) FROM MAX_AMOUNT )
 

SELECT DELIVERY_DETAIL_ID, RELEASED_STATUS FROM WSH_DELIVERY_DETAILS WHERE SOURCE_HEADER_ID = 15009 ---> RELEASED_STATUS WILL SHOW  "R" --> R means ready to release

SELECT *  FROM WSH_DELIVERY_DETAILS WHERE DELIVERY_DETAIL_ID=499040 --WHERE 4181010015152


SELECT * FROM WSH_DELIVERY_ASSIGNMENTS WHERE DELIVERY_DETAIL_ID  IN (
10009,
10010,
10011,
10012,
10013,
10014)


--RELEASE THE ORDER
--=============




--==================================
--ACCOUNTING EVENT AFTER DRAFT ACCOUNTING 
--==================================
IN MATERIAL TRANSACTIONS TABLE 
D= Draft accounted,
N= New or not accounted 
Null = Final accounted


-- What does XLA_AE_HEADERS.ACCOUNTING_ENTRY_STATUS_CODE represent?
 
1. If the ACCOUNTING_ENTRY_STATUS_CODE is 'F',  then the event is accounted successfully.

2. If the ACCOUNTING_ENTRY_STATUS_CODE is 'N', then event is still not processed.

3. If the ACCOUNTING_ENTRY_STATUS_CODE is 'I',  then event has failed.

4. If the ACCOUNTING_ENTRY_STATUS_CODE is 'R', then event is in error.

5. If the ACCOUNTING_ENTRY_STATUS_CODE is 'D',  then event is Draft Accounting Entry.



XLA_AE_LINES and GL_IMPORT_REFERENCES

select * from XLA_AE_LINES , GL_IMPORT_REFERENCES 
where GL_IMPORT_REFERENCES.gl_sl_link_id = XLA_AE_LINES.gl_sl_link_id
and GL_JE_BATCHES.group_id = XLA_AE_HEADERS.group_id




select * from RCV_SHIPMENT_HEADERS 


--ORDER MANAGEMENT BASE TABLE 


-- IR ISO TABLES 
select * from oe_order_headers_all where ORDER_NUMBER = 2210100001384  and  org_id= 108 -- ISO NUMBER : 2188010000007  + --ORIG_SYS_DOCUMENT_REF =  IR NUMBER

SELECT * FROM oe_order_LINES_all where HEADER_ID = 1342817

select * from wsh_delivery_details where TRACKING_NUMBER = 21222000496    --- OD NUMBER 

select * from WSH_NEW_DELIVERIES where  NAME IN (4211020032901,4211020066875)  --- CHALLAN NO 4181010001055

select * from MTL_MATERIAL_TRANSACTIONS WHERE TRUNC(CREATION_DATE)  BETWEEN '26-JUN-2021' and '26-JUN-2021'  and ORGANIZATION_ID= 222 and INVENTORY_ITEM_ID IN (536149,
209)
--and created_by= 1578



select A.TRANSACTION_ID,A.TRANSACTION_SOURCE_ID,A.Primary_quantity,A.CREATION_DATE,  A.INVENTORY_ITEM_ID, A.TRANSACTION_TYPE_ID, b.TRANSACTION_TYPE_NAME,  A.TRANSACTION_DATE, A.SOURCE_LINE_ID, A.SHIPMENT_NUMBER 
  from MTL_MATERIAL_TRANSACTIONS A, MTL_TRANSACTION_TYPES B
   WHERE A.TRANSACTION_TYPE_ID= B.TRANSACTION_TYPE_ID
   and TRUNC(A.CREATION_DATE)  BETWEEN '26-JUN-2021' and '26-JUN-2021'  and ORGANIZATION_ID= 222 and INVENTORY_ITEM_ID IN (536149,
209)
and A.TRANSACTION_SOURCE_ID = 1266961
--and created_by= 1578


 CREATED_BY, XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) CREATED_BY

select * from ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE= 'KLO'

SELECT b.* FROM OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b
where a.HEADER_ID = b.HEADER_ID   
and a.ORDER_NUMBER = 2210100001384  
and  a.org_id= 108 














select * from oe_order_lines_all

3.qp_list_headers
4.qp_list_lines
5. qp_pricing_attributes
6.OE_PRICE_ADJUSTMENTS
7.OE_ORDER_HOLDS_ALL
8.OE_ORDER_CREDIT_CHECK_RULES
9.wsh_delivery_details
10.wsh_delivery_assignments
11.WSH_NEW_DELIVERIES

Order Management Price List tables 

1.qp_list_headers
2.qp_list_lines  
 3.qp_pricing_attributes
 
 
 select QLH.NAME,QLH.DESCRIPTION,QLH.START_DATE_ACTIVE,QLL.OPERAND,QLL.ARITHMETIC_OPERATOR,
OOLA.ordered_quantity,oola.order_quantity_uom,oola.ordered_item,ooha.order_number
from apps.qp_list_headers QLH ,
apps.qp_list_lines QLL,
apps.qp_pricing_attributes qpa,
apps.oe_order_lines_all oola,
apps.oe_order_headers_all ooha
WHERE QLH.list_HEADER_ID=QLL.list_HEADER_ID
and qpa.LIST_LINE_ID=qll.LIST_LINE_ID
and qpa.list_HEADER_ID=qlh.list_HEADER_ID
and to_char(oola.INVENTORY_ITEM_ID) =QPA.PRODUCT_ATTR_VALUE
and oola.header_id=ooha.header_id
and ooha.order_number=:P_ORDER_NUMBER

select distinct CUSTOMER_CATEGORY_CODE  from apps.ar_customers 

select *  from apps.ar_customers 

select * FROM apps.wsh_delivery_details 

select distinct SOURCE_HEADER_TYPE_NAME FROM apps.wsh_delivery_details --- KSPL-DEFERRED SALES

Query 2

SELECT distinct
ooh.order_number,
wdd.SOURCE_HEADER_TYPE_NAME,
ac.customer_name,
ooh.org_id,
ooh.ORDERED_DATE,
ooh.FLOW_STATUS_CODE SO_Status,
ool.line_number,
msi.SEGMENT1 Item_Name,
ool.ordered_quantity,
wdd.shipped_quantity,
rctl.QUANTITY_invoiced,
wda.delivery_id shipment_number,
rct.TRX_NUMBER Invoice_Num,
rct.TRX_date Invoice_Date,
rct.STATUS_TRX,
decode(rct.COMPLETE_FLAG,'Y','Completed','In Complete') Inv_Status,
ool.UNIT_SELLING_price*ool.ordered_quantity line_total
from apps.oe_order_headers_all ooh,
apps.ar_customers ac,
apps.wsh_delivery_details wdd,
apps.oe_order_lines_all ool,
apps.wsh_delivery_assignments wda,
apps.hz_cust_accounts hca,
apps.ra_customer_trx_lines_all rctl,
apps.ra_customer_trx_all rct,
apps.mtl_system_items msi
where
ooh.header_id=ool.header_id
and ooh.sold_to_org_id=hca.cust_account_id
and ooh.header_id=wdd.source_header_id
and ool.line_id=wdd.source_line_id
and hca.cust_account_id=ac.customer_id
and msi.INVENTORY_ITEM_ID=ool.INVENTORY_ITEM_ID
and msi.ORGANIZATION_ID=ool.SHIP_FROM_ORG_ID
and wda.delivery_detail_id=wdd.delivery_detail_id
and ooh.org_id=:P_ORG_ID
and rct.CUSTOMER_TRX_ID = rctl.CUSTOMER_TRX_ID
and rctl.LINE_TYPE = 'LINE'
and rctl.interface_line_attribute1 = to_char(ooh.ORDER_NUMBER)
and  rctl.interface_line_attribute3=to_char(wda.delivery_id)
--and wdd.SOURCE_HEADER_TYPE_NAME = 'KSPL-DEFERRED SALES'
--and rctl.QUANTITY_invoiced = ool.ORDERED_QUANTITY
--and ooh.order_number=:P_order_number
order by ool.line_number




/*  =============================================
OD REPORT KSRM
===============================================  */
SELECT 
A.OD_NUMBER,
A.OD_DATE,
A.CUSTOMER_ID,
(SELECT DISTINCT CUSTOMER_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE CUSTOMER_ID=A.SOLD_TO_ORG_ID) CUSTOMER_NAME,
A.CUSTOMER_ID CUSTOMER_NO,
A.INVOICE_TO_ORG_ID,
(SELECT DISTINCT ADDRESS FROM wbi_ont_party_location_d WHERE SHIP_TO_ORG_ID=A.INVOICE_TO_ORG_ID) CUS_BILL_TO_ADD,
A.SHIP_FROM_ORG_ID DLV_FROM_ORG_ID, 
(SELECT DISTINCT ORGANIZATION_CODE  FROM WBI_INV_ORG_D WHERE ORGANIZATION_ID=A.SHIP_FROM_ORG_ID) DELIVERY_FROM,
A.CONTACT_PERSON CONTACT_PERSON,
A.CONTACT_PERSON_NO CONTACT_PERSON_NO,
TO_DATE(A.SCHEDULE_SHIP_DATE,'DD/MM/RRRR') SCHEDULE_DLV_DATE,
A.SHIP_TO_ORG_ID,
NVL(A.SHIPPING_INSTRUCTIONS,(SELECT DISTINCT ADDRESS FROM wbi_ont_party_location_d WHERE SHIP_TO_ORG_ID=A.SHIP_TO_ORG_ID)) SHIP_TO_ADD,
A.SO_NUMBER,
TO_DATE(A.SO_DATE,'DD/MM/RRRR') SO_DATE,
------------------------------------------------
NVL((SELECT X.QUOTE_NUMBER
FROM 
aso_quote_headers_all X,
oe_order_headers_all Y
WHERE 
X.order_id = Y.header_id
AND X.quote_header_id = Y.source_document_id
AND Y.ORDER_NUMBER=A.SO_NUMBER) ,NULL) REF_QUOTE_NO,
------------------------------------------------
---''REF_QUOTE_NO,
A.SHIPPING_INSTRUCTIONS SHIPPING_INSTRUCTION,
A.PACKING_INSTRUCTIONS  PACKING_INSTRUCTION,
A.FOB_CODE VEHICLE_TYPE,
A.FREIGHT_TERMS_CODE  FREIGHT_TERM,
--------------------------------------------------------------
A.INVENTORY_ITEM_ID,
A.ORDERED_ITEM ITEM_CODE,
A.ITEM_DESCRIPTION,
(SELECT ITEM_SUBGROUP FROM WBI_INV_ITEMS_D WHERE INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND ORGANIZATION_ID=A.SHIP_FROM_ORG_ID ) ITEM_SIZE,
'' ITEM_LENGTH,
'' PCS,
A.REQUESTED_QUANTITY QTY,
A.REQUESTED_QUANTITY_UOM UOM,
------------------------------------------------------------------------------------------------
'' TOTAL_QTY_IN_WORD,
''NOTE,
A.SALESREP_ID,
(SELECT DISTINCT SALESREP_NAME FROM XX_SALESREP_ROLE_TERRITORY_V1 WHERE SALESREP_ID=A.SALESREP_ID) SALES_PERSON_NAME,
A.CONTACT_REMARKS REMARKS,
A.SOLD_FROM_ORG_ID  OPERATING_UNIT,  
(SELECT DISTINCT OPERATING_UNIT_NAME  FROM WBI_INV_ORG_D WHERE ORGANIZATION_ID=A.SHIP_FROM_ORG_ID AND OPERATING_UNIT=A.SOLD_FROM_ORG_ID) OPERATING_UNIT_NAME
------------------------------------------------------------------------------------------------
FROM  XX_ONT_TRANSACTIONS_V A
WHERE 
--A.RELEASED_STATUS='R' AND 
A.OD_NUMBER IS NOT NULL
AND A.OD_NUMBER=:P_OD_NUMBER


/*

SELECT 
A.OD_NUMBER,
A.OD_DATE,
A.CUSTOMER_ID,
(SELECT DISTINCT CUSTOMER_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE CUSTOMER_ID=A.SOLD_TO_ORG_ID) CUSTOMER_NAME,
A.CUSTOMER_ID CUSTOMER_NO,
A.INVOICE_TO_ORG_ID,
(SELECT DISTINCT ADDRESS FROM wbi_ont_party_location_d WHERE SHIP_TO_ORG_ID=A.INVOICE_TO_ORG_ID) CUS_BILL_TO_ADD,
A.SHIP_FROM_ORG_ID DLV_FROM_ORG_ID, 
(SELECT DISTINCT ORGANIZATION_CODE  FROM WBI_INV_ORG_D WHERE ORGANIZATION_ID=A.SHIP_FROM_ORG_ID) DELIVERY_FROM,
A.CONTACT_PERSON CONTACT_PERSON,
A.CONTACT_PERSON_NO CONTACT_PERSON_NO,
TO_DATE(A.SCHEDULE_SHIP_DATE,'DD/MM/RRRR') SCHEDULE_DLV_DATE,
A.SHIP_TO_ORG_ID,
NVL(A.SHIPPING_INSTRUCTIONS,(SELECT DISTINCT ADDRESS FROM wbi_ont_party_location_d WHERE SHIP_TO_ORG_ID=A.SHIP_TO_ORG_ID)) SHIP_TO_ADD,
A.SO_NUMBER,
TO_DATE(A.SO_DATE,'DD/MM/RRRR') SO_DATE,
''REF_QUOTE_NO,
A.SHIPPING_INSTRUCTIONS SHIPPING_INSTRUCTION,
A.PACKING_INSTRUCTIONS  PACKING_INSTRUCTION,
A.FOB_CODE VEHICLE_TYPE,
A.FREIGHT_TERMS_CODE  FREIGHT_TERM,
---------------------------------------------------------------------------------
A.INVENTORY_ITEM_ID,
A.ORDERED_ITEM ITEM_CODE,
A.ITEM_DESCRIPTION,
(SELECT ITEM_SUBGROUP FROM WBI_INV_ITEMS_D WHERE INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND ORGANIZATION_ID=A.SHIP_FROM_ORG_ID ) ITEM_SIZE,
'' ITEM_LENGTH,
'' PCS,
A.REQUESTED_QUANTITY QTY,
A.REQUESTED_QUANTITY_UOM UOM,
------------------------------------------------------------------------------------------------
'' TOTAL_QTY_IN_WORD,
''NOTE,
A.SALESREP_ID,
(SELECT DISTINCT SALESREP_NAME FROM XX_SALESREP_ROLE_TERRITORY_V1 WHERE SALESREP_ID=A.SALESREP_ID) SALES_PERSON_NAME,
A.CONTACT_REMARKS REMARKS,
A.SOLD_FROM_ORG_ID  OPERATING_UNIT,  
(SELECT DISTINCT OPERATING_UNIT_NAME  FROM WBI_INV_ORG_D WHERE ORGANIZATION_ID=A.SHIP_FROM_ORG_ID AND OPERATING_UNIT=A.SOLD_FROM_ORG_ID) OPERATING_UNIT_NAME
------------------------------------------------------------------------------------------------
FROM  XX_ONT_TRANSACTIONS_V A
WHERE 
A.RELEASED_STATUS='R'
AND A.OD_NUMBER IS NOT NULL
AND A.OD_NUMBER=:P_OD_NUMBER
*/

--========================== AR CUSTOMER BALENCE KSRM=====================================
--===================================================================================

--XX_AR_CUSTOMER_LEDGER_V

DROP VIEW APPS.XX_AR_CUSTOMER_LEDGER_V;

/* Formatted on 4/12/2018 10:19:22 AM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW APPS.XX_AR_CUSTOMER_LEDGER_V
(
   SL,
   CUSTOMER_TRX_ID,
   LEGAL_ENTITY_ID,
   ORG_ID,
   ORGANIZATION_NAME,
   VOUCHER,
   INVOICE_NO,
   INVOICE_DATE,
   CUSTOMER_ID,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   ADDRESS,
   INVENTORY_ITEM_ID,
   DESCRIPTION,
   INV_TYPE,
   GL_DATE,
   ACCOUNT_CLASS,
   COST_CODE,
   COST_CENTER,
   SUB_CODE,
   SUB_ACCOUNT,
   PROJECT_CODE,
   PROJECT_NAME,
   INTER_COM_CODE,
   INTER_COMPANY,
   DIST_GL_CODE,
   GL_CODE_AND_DESC,
   BAL_SEG,
   BAL_SEG_NAME,
   QUANTITY_INVOICED,
   UNIT_SELLING_PRICE,
   AMOUNT,
   DR_AMOUNT,
   CR_AMOUNT,
   CURRENCY_CODE,
   EXCHANGE_RATE,
   SO_NUMBER,
   CHALLAN_NO,
   PRODUCT_CATEGORY,
   INV_DESC,
   UOM_CODE,
   CUSTOMER_SITE_USE_ID,
   BANK_ACCOUNT,
   STATUS,
   CUST_CATEGORY,
   TRANSECTION_DATE,
   FU1,
   FU2,
   FU3,
   FU4,
   FU5,
   ENTITY_ID,
   BUSINESS_CLASS_CODE,
   AE_HEADER_ID,
   AE_LINE_NUM,
   ITEM_DESC
)
AS
     SELECT 1 SL,
            A.CUSTOMER_TRX_ID,
            --   C.CUSTOMER_TRX_LINE_ID,
            A.LEGAL_ENTITY_ID,
            A.ORG_ID,
            OU.NAME ORGANIZATION_NAME,
            'AR INV-' || A.DOC_SEQUENCE_VALUE VOUCHER,
            A.TRX_NUMBER INVOICE_NO,
            A.TRX_DATE INVOICE_DATE,
            A.BILL_TO_CUSTOMER_ID CUSTOMER_ID,
            B.CUSTOMER_NUMBER,
            B.PARTY_NAME CUSTOMER_NAME,
            (   DECODE (B.ADDRESS1, NULL, NULL, B.ADDRESS1 || ', ')
             || DECODE (B.ADDRESS2, NULL, NULL, B.ADDRESS2 || ', ')
             || DECODE (B.ADDRESS3, NULL, NULL, B.ADDRESS3 || ', ')
             || DECODE (B.ADDRESS4, NULL, NULL, B.ADDRESS4 || ', ')
             || DECODE (B.city, NULL, NULL, B.city || ', ')
             || DECODE (B.COUNTRY, NULL, NULL, B.COUNTRY))
               ADDRESS,
            LISTAGG (C.INVENTORY_ITEM_ID, ' , ')
               WITHIN GROUP (ORDER BY A.TRX_NUMBER)
               INVENTORY_ITEM_ID,
            LISTAGG (C.DESCRIPTION, ' , ') WITHIN GROUP (ORDER BY A.TRX_NUMBER)
               DESCRIPTION,
            C.LINE_TYPE INV_TYPE,
            D.GL_DATE,
            D.ACCOUNT_CLASS,
            GC.SEGMENT3 COST_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3) COST_CENTER,
            GC.SEGMENT5 SUB_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4) SUB_ACCOUNT,
            GC.SEGMENT6 PROJECT_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6) PROJECT_NAME,
            GC.SEGMENT7 INTER_COM_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7) INTER_COMPANY,
            GC.SEGMENT4 DIST_GL_CODE,
            GET_GL_CODE_DESC_FROM_CCID (D.CODE_COMBINATION_ID) GL_CODE_AND_DESC,
            GC.SEGMENT1 BAL_SEG,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (D.CODE_COMBINATION_ID, 1),
               1)
               BAL_SEG_NAME,
            SUM (
               CASE
                  --WHEN D.AMOUNT > 0 AND C.UOM_CODE IS NOT NULL
                  WHEN C.ATTRIBUTE13 IS NULL AND C.UOM_CODE IS NOT NULL
                  THEN
                     NVL (QUANTITY_INVOICED, ABS (QUANTITY_CREDITED))
                  ELSE
                     0
               END)
               QUANTITY_INVOICED,
            --QUANTITY_INVOICED,
            SUM (UNIT_SELLING_PRICE),
            SUM (D.AMOUNT),
            SUM (GREATEST (NVL (D.ACCTD_AMOUNT, D.AMOUNT), 0)) DR_AMOUNT,
            SUM (ABS (LEAST (NVL (D.ACCTD_AMOUNT, D.AMOUNT), 0))) CR_AMOUNT,
            A.INVOICE_CURRENCY_CODE CURRENCY_CODE,
            A.EXCHANGE_RATE,
            C.INTERFACE_LINE_ATTRIBUTE1 SO_NUMBER,
            C.INTERFACE_LINE_ATTRIBUTE3 CHALLAN_NO,
            IT.DESCRIPTION PRODUCT_CATEGORY,
            NVL (CTT.DESCRIPTION, CTT.NAME) INV_DESC,            --DESCRIPTION
            --   LISTAGG( C.UOM_CODE,' , ') WITHIN GROUP (ORDER BY A.TRX_NUMBER) UOM_CODE,
            DECODE (C.UOM_CODE, NULL, 'MT', C.UOM_CODE) UOM_CODE,
            --  D.CUST_TRX_LINE_GL_DIST_ID,
            --      LISTAGG(  D.CUST_TRX_LINE_GL_DIST_ID,' , ') WITHIN GROUP (ORDER BY A.TRX_NUMBER)  CUST_TRX_LINE_GL_DIST_ID,
            A.BILL_TO_SITE_USE_ID CUSTOMER_SITE_USE_ID,
            NULL BANK_ACCOUNT,
            A.STATUS_TRX STATUS,
            B.CUST_CATEGORY,
            TRUNC (A.CREATION_DATE) TRANSECTION_DATE,
            NULL FU1,
            NULL FU2,
            NULL FU3,
            NULL FU4,
            NULL FU5,
            NULL,                                             --XTE.ENTITY_ID,
            NULL,                                   --XAL.BUSINESS_CLASS_CODE,
            NULL,                                         -- XAL.AE_HEADER_ID,
            NULL,                                           -- XAL.AE_LINE_NUM
            /*
              CASE
                         WHEN C.ATTRIBUTE13 IS NULL AND C.UOM_CODE IS NOT NULL
                         THEN
                            LISTAGG (C.DESCRIPTION, ' , ')
                      WITHIN GROUP (ORDER BY A.TRX_NUMBER)
                         ELSE
                            NULL
                      END
                      */
            (SELECT LISTAGG (C.DESCRIPTION, ' , ') WITHIN GROUP (ORDER BY 1)
               FROM RA_CUSTOMER_TRX_LINES_ALl C
              WHERE     customer_trx_id = A.CUSTOMER_TRX_ID
                    AND UNIT_STANDARD_PRICE <> 0
                    AND UNIT_STANDARD_PRICE IS NOT NULL)
               ITEM_DESC
       FROM RA_CUSTOMER_TRX_ALL A,
            XX_AR_CUSTOMER_SITE_V B,
            RA_CUSTOMER_TRX_LINES_ALL C,
            RA_CUST_TRX_LINE_GL_DIST_ALL D,
            GL_CODE_COMBINATIONS GC,
            HR_OPERATING_UNITS OU,
            RA_CUST_TRX_TYPES_ALL CTT,
            WBI_INV_ITEMS_D IT
      WHERE     A.ORG_ID = B.ORG_ID
            AND A.BILL_TO_SITE_USE_ID = B.SITE_USE_ID
            AND A.BILL_TO_CUSTOMER_ID = B.CUSTOMER_ID
            AND B.SITE_USE_CODE = 'BILL_TO'
            AND B.PRIMARY_FLAG = 'Y'
            AND A.CUSTOMER_TRX_ID = C.CUSTOMER_TRX_ID
            AND A.CUSTOMER_TRX_ID = D.CUSTOMER_TRX_ID
            AND C.CUSTOMER_TRX_LINE_ID = D.CUSTOMER_TRX_LINE_ID
            AND D.CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
            AND A.ORG_ID = OU.ORGANIZATION_ID
            AND D.ACCOUNT_CLASS NOT IN ('REC')
            AND A.CUST_TRX_TYPE_ID = CTT.CUST_TRX_TYPE_ID
            AND A.ORG_ID = CTT.ORG_ID
            AND A.ORG_ID = IT.ORGANIZATION_ID(+)
            AND C.INVENTORY_ITEM_ID = IT.INVENTORY_ITEM_ID(+)
            AND (UNIT_SELLING_PRICE <> '0' OR UNIT_SELLING_PRICE IS NULL)
   GROUP BY A.CUSTOMER_TRX_ID,
            -- C.CUSTOMER_TRX_LINE_ID,
            A.LEGAL_ENTITY_ID,
            A.ORG_ID,
            OU.NAME,
            'AR INV-' || A.DOC_SEQUENCE_VALUE,
            A.TRX_NUMBER,
            A.TRX_DATE,
            A.BILL_TO_CUSTOMER_ID,
            B.CUSTOMER_NUMBER,
            B.PARTY_NAME,
            (   DECODE (B.ADDRESS1, NULL, NULL, B.ADDRESS1 || ', ')
             || DECODE (B.ADDRESS2, NULL, NULL, B.ADDRESS2 || ', ')
             || DECODE (B.ADDRESS3, NULL, NULL, B.ADDRESS3 || ', ')
             || DECODE (B.ADDRESS4, NULL, NULL, B.ADDRESS4 || ', ')
             || DECODE (B.city, NULL, NULL, B.city || ', ')
             || DECODE (B.COUNTRY, NULL, NULL, B.COUNTRY)),
            --  LISTAGG(C.INVENTORY_ITEM_ID,' , ') WITHIN GROUP (ORDER BY A.TRX_NUMBER) ,
            --   LISTAGG(C.DESCRIPTION,' , ') WITHIN GROUP (ORDER BY A.TRX_NUMBER) ,
            C.LINE_TYPE,
            D.GL_DATE,
            D.ACCOUNT_CLASS,
            GC.SEGMENT3,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3),
            GC.SEGMENT5,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4),
            GC.SEGMENT6,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6),
            GC.SEGMENT7,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7),
            GC.SEGMENT4,
            GET_GL_CODE_DESC_FROM_CCID (D.CODE_COMBINATION_ID),
            GC.SEGMENT1,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (D.CODE_COMBINATION_ID, 1),
               1),
            --QUANTITY_INVOICED,
            A.INVOICE_CURRENCY_CODE,
            A.EXCHANGE_RATE,
            C.INTERFACE_LINE_ATTRIBUTE1,
            C.INTERFACE_LINE_ATTRIBUTE3,
            IT.DESCRIPTION,
            NVL (CTT.DESCRIPTION, CTT.NAME),                     --DESCRIPTION
            --    C.UOM_CODE,
            --   D.CUST_TRX_LINE_GL_DIST_ID,
            A.BILL_TO_SITE_USE_ID,
            NULL,
            A.STATUS_TRX,
            B.CUST_CATEGORY,
            TRUNC (A.CREATION_DATE),
            --  C.UOM_CODE,
            DECODE (C.UOM_CODE, NULL, 'MT', C.UOM_CODE)
   --  C.ATTRIBUTE13
   UNION ALL
     ---------------------Receipts Part---------------------------------------
     SELECT 2 SL,
            A.CASH_RECEIPT_ID CUSTOMER_TRX_ID,
            --   D.CASH_RECEIPT_HISTORY_ID CUSTOMER_TRX_LINE_ID,
            A.LEGAL_ENTITY_ID,
            A.ORG_ID,
            OU.NAME ORGANIZATION_NAME,
            'AR RCV-' || A.DOC_SEQUENCE_VALUE VOUCHER,
            A.RECEIPT_NUMBER INVOICE_NO,
            A.RECEIPT_DATE INVOICE_DATE,
            A.PAY_FROM_CUSTOMER CUSTOMER_ID,
            B.CUSTOMER_NUMBER,
            B.PARTY_NAME CUSTOMER_NAME,
            (   DECODE (ADDRESS1, NULL, NULL, ADDRESS1 || ', ')
             || DECODE (ADDRESS2, NULL, NULL, ADDRESS2 || ', ')
             || DECODE (ADDRESS3, NULL, NULL, ADDRESS3 || ', ')
             || DECODE (ADDRESS4, NULL, NULL, ADDRESS4 || ', ')
             || DECODE (city, NULL, NULL, city || ', ')
             || DECODE (COUNTRY, NULL, NULL, COUNTRY))
               ADDRESS,
            NULL INVENTORY_ITEM_ID,
            A.COMMENTS DESCRIPTION,
            A.TYPE INV_TYPE,
            D.GL_DATE,
            NULL ACCOUNT_CLASS,
            GC.SEGMENT3 COST_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3) COST_CENTER,
            GC.SEGMENT5 SUB_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4) SUB_ACCOUNT,
            GC.SEGMENT6 PROJECT_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6) PROJECT_NAME,
            GC.SEGMENT7 INTER_COM_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7) INTER_COMPANY,
            GC.SEGMENT4 DIST_GL_CODE,
            GET_GL_CODE_DESC_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID)
               GL_CODE_AND_DESC,
            GC.SEGMENT1 BAL_SEG,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID, 1),
               1)
               BAL_SEG_NAME,
            NULL QUANTITY_INVOICED,
            NULL UNIT_SELLING_PRICE,
            SUM (AMOUNT_APPLIED) AMOUNT,
            --  SUM(ABS (LEAST (NVL (D.ACCTD_AMOUNT, D.AMOUNT), 0))) DR_AMOUNT,
            --SUM(GREATEST (NVL (D.ACCTD_AMOUNT, D.AMOUNT), 0)) CR_AMOUNT,
            ABS (LEAST (NVL (SUM (AMOUNT_APPLIED), SUM (D.AMOUNT)), 0))
            * NVL (A.EXCHANGE_RATE, 1)
               DR_AMOUNT,
            GREATEST (NVL (SUM (AMOUNT_APPLIED), SUM (D.AMOUNT)), 0)
            * NVL (A.EXCHANGE_RATE, 1)
               CR_AMOUNT,
            A.CURRENCY_CODE,
            A.EXCHANGE_RATE,
            NULL SO_NUMBER,
            NULL CHALLAN_NO,
            NULL PRODUCT_CATEGORY,
            DECODE (A.TYPE, 'MISC', 'MISCELLANEOUS', 'STANDARD') INV_DESC, --A.attribute1 || '-' || A.attribute2
            NULL UOM_CODE,
            -- D.CASH_RECEIPT_HISTORY_ID CUST_TRX_LINE_GL_DIST_ID,
            A.CUSTOMER_SITE_USE_ID,
               E.BANK_ACCOUNT_NAME
            || ' ,Inst. No:  '
            || RECEIPT_NUMBER
            || ', Inst. Date: '
            || RECEIPT_DATE
               BANK_ACCOUNT,
            D.STATUS,
            B.CUST_CATEGORY,
            TRUNC (A.CREATION_DATE) TRANSECTION_DATE,
            NULL FU1,
            NULL FU2,
            NULL FU3,
            NULL FU4,
            NULL FU5,
            NULL,                                             --XTE.ENTITY_ID,
            NULL,                                   --XAL.BUSINESS_CLASS_CODE,
            NULL,                                         -- XAL.AE_HEADER_ID,
            NULL,                                           -- XAL.AE_LINE_NUM
            NULL
       FROM AR_CASH_RECEIPTS_ALL A,
            XX_AR_CUSTOMER_SITE_V B,
            AR_CASH_RECEIPT_HISTORY_ALL D,
            GL_CODE_COMBINATIONS GC,
            HR_OPERATING_UNITS OU,
            XX_BANK_ACCTS_ALL_V E,
            AR_RECEIVABLE_APPLICATIONS_ALL F
      WHERE     A.ORG_ID = B.ORG_ID
            AND A.CUSTOMER_SITE_USE_ID = B.SITE_USE_ID
            AND A.PAY_FROM_CUSTOMER = B.CUSTOMER_ID
            AND A.CASH_RECEIPT_ID = F.CASH_RECEIPT_ID
            AND B.SITE_USE_CODE = 'BILL_TO'
            AND B.PRIMARY_FLAG = 'Y'
            AND A.CASH_RECEIPT_ID = D.CASH_RECEIPT_ID
            AND D.ACCOUNT_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
            AND A.ORG_ID = OU.ORGANIZATION_ID
            --  AND D.CURRENT_RECORD_FLAG = 'Y'
            AND D.STATUS <> 'REMITTED' -- 'CLEARED'--this part add by md ibrahim khalil for disable status
            AND A.REMIT_BANK_ACCT_USE_ID = E.BANK_ACCT_USE_ID
   --  AND F.DISPLAY = 'Y'
   -- AND F.STATUS = 'APP'
   GROUP BY A.CASH_RECEIPT_ID,
            A.LEGAL_ENTITY_ID,
            A.ORG_ID,
            OU.NAME,
            'AR RCV-' || A.DOC_SEQUENCE_VALUE,
            A.RECEIPT_NUMBER,
            A.RECEIPT_DATE,
            A.PAY_FROM_CUSTOMER,
            B.CUSTOMER_NUMBER,
            B.PARTY_NAME,
            (   DECODE (ADDRESS1, NULL, NULL, ADDRESS1 || ', ')
             || DECODE (ADDRESS2, NULL, NULL, ADDRESS2 || ', ')
             || DECODE (ADDRESS3, NULL, NULL, ADDRESS3 || ', ')
             || DECODE (ADDRESS4, NULL, NULL, ADDRESS4 || ', ')
             || DECODE (city, NULL, NULL, city || ', ')
             || DECODE (COUNTRY, NULL, NULL, COUNTRY)),
            A.COMMENTS,
            A.TYPE,
            D.GL_DATE,
            GC.SEGMENT3,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3),
            GC.SEGMENT5,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4),
            GC.SEGMENT6,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6),
            GC.SEGMENT7,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7),
            GC.SEGMENT4,
            GET_GL_CODE_DESC_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID),
            GC.SEGMENT1,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID, 1),
               1),
            A.CURRENCY_CODE,
            A.EXCHANGE_RATE,
            DECODE (A.TYPE, 'MISC', 'MISCELLANEOUS', 'STANDARD'),
            A.CUSTOMER_SITE_USE_ID,
               E.BANK_ACCOUNT_NAME
            || ' ,Inst. No:  '
            || RECEIPT_NUMBER
            || ', Inst. Date: '
            || RECEIPT_DATE,
            D.STATUS,
            B.CUST_CATEGORY,
            TRUNC (A.CREATION_DATE)
   UNION ALL
     ---------------------Refund Part---------------------------------------
     SELECT 2.1 SL,
            --  A.CASH_RECEIPT_ID CUSTOMER_TRX_ID,
            F.RECEIVABLE_APPLICATION_ID CUSTOMER_TRX_ID,
            --   D.CASH_RECEIPT_HISTORY_ID CUSTOMER_TRX_LINE_ID,
            A.LEGAL_ENTITY_ID,
            A.ORG_ID,
            OU.NAME ORGANIZATION_NAME,
            'AP PAY-' || I.DOC_SEQUENCE_VALUE VOUCHER,
            --  G.DOC_SEQUENCE_VALUE INVOICE_NO,
            NULL,
            I.CHECK_DATE INVOICE_DATE,
            A.PAY_FROM_CUSTOMER CUSTOMER_ID,
            B.CUSTOMER_NUMBER,
            B.PARTY_NAME CUSTOMER_NAME,
            (   DECODE (ADDRESS1, NULL, NULL, ADDRESS1 || ', ')
             || DECODE (ADDRESS2, NULL, NULL, ADDRESS2 || ', ')
             || DECODE (ADDRESS3, NULL, NULL, ADDRESS3 || ', ')
             || DECODE (ADDRESS4, NULL, NULL, ADDRESS4 || ', ')
             || DECODE (B.city, NULL, NULL, B.city || ', ')
             || DECODE (B.COUNTRY, NULL, NULL, B.COUNTRY))
               ADDRESS,
            NULL INVENTORY_ITEM_ID,
            A.COMMENTS DESCRIPTION,
            A.TYPE INV_TYPE,
            I.CHECK_DATE GL_DATE,
            --D.GL_DATE,
            NULL ACCOUNT_CLASS,
            GC.SEGMENT3 COST_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3) COST_CENTER,
            GC.SEGMENT5 SUB_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4) SUB_ACCOUNT,
            GC.SEGMENT6 PROJECT_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6) PROJECT_NAME,
            GC.SEGMENT7 INTER_COM_CODE,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7) INTER_COMPANY,
            GC.SEGMENT4 DIST_GL_CODE,
            GET_GL_CODE_DESC_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID)
               GL_CODE_AND_DESC,
            GC.SEGMENT1 BAL_SEG,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID, 1),
               1)
               BAL_SEG_NAME,
            NULL QUANTITY_INVOICED,
            NULL UNIT_SELLING_PRICE,
            SUM (A.AMOUNT) AMOUNT,
            --  ABS (LEAST (NVL (D.ACCTD_AMOUNT, D.AMOUNT), 0)) DR_AMOUNT,
            -- GREATEST (NVL (D.ACCTD_AMOUNT, D.AMOUNT), 0) CR_AMOUNT,
            NVL (SUM (AMOUNT_APPLIED_FROM), 0) DR_AMOUNT,
            0 CR_AMOUNT,
            A.CURRENCY_CODE,
            A.EXCHANGE_RATE,
            NULL SO_NUMBER,
            NULL CHALLAN_NO,
            NULL PRODUCT_CATEGORY,
            DECODE (A.TYPE, 'MISC', 'MISCELLANEOUS', 'STANDARD') INV_DESC, --A.attribute1 || '-' || A.attribute2
            NULL UOM_CODE,
            -- D.CASH_RECEIPT_HISTORY_ID CUST_TRX_LINE_GL_DIST_ID,
            A.CUSTOMER_SITE_USE_ID,
               I.BANK_ACCOUNT_NAME
            || ' ,Inst. No:  '
            || CHECK_NUMBER
            || ', Inst. Date: '
            || CHECK_DATE
               BANK_ACCOUNT,
            D.STATUS,
            B.CUST_CATEGORY,
            TRUNC (I.CREATION_DATE) TRANSECTION_DATE,
            NULL FU1,
            NULL FU2,
            NULL FU3,
            NULL FU4,
            NULL FU5,
            NULL,                                             --XTE.ENTITY_ID,
            NULL,                                   --XAL.BUSINESS_CLASS_CODE,
            NULL,                                         -- XAL.AE_HEADER_ID,
            NULL,                                           -- XAL.AE_LINE_NUM
            NULL
       FROM AR_CASH_RECEIPTS_ALL A,
            XX_AR_CUSTOMER_SITE_V B,
            AR_CASH_RECEIPT_HISTORY_ALL D,
            GL_CODE_COMBINATIONS GC,
            HR_OPERATING_UNITS OU,
            XX_BANK_ACCTS_ALL_V E,
            AR_RECEIVABLE_APPLICATIONS_ALL F,
            AP_INVOICES_ALL G,
            AP_INVOICE_PAYMENTS_ALL H,
            AP_CHECKS_ALL I
      WHERE     A.ORG_ID = B.ORG_ID
            AND G.REFERENCE_KEY1 = F.RECEIVABLE_APPLICATION_ID
            AND G.INVOICE_ID = H.INVOICE_ID
            AND H.CHECK_ID = I.CHECK_ID
            AND A.CUSTOMER_SITE_USE_ID = B.SITE_USE_ID
            AND A.PAY_FROM_CUSTOMER = B.CUSTOMER_ID
            AND A.CASH_RECEIPT_ID = F.CASH_RECEIPT_ID
            AND B.SITE_USE_CODE = 'BILL_TO'
            AND B.PRIMARY_FLAG = 'Y'
            AND A.CASH_RECEIPT_ID = D.CASH_RECEIPT_ID
            AND D.ACCOUNT_CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
            AND A.ORG_ID = OU.ORGANIZATION_ID
            --  AND D.CURRENT_RECORD_FLAG = 'Y'
            AND D.STATUS <> 'REMITTED' -- 'CLEARED'--this part add by md ibrahim khalil for disable status
            AND A.REMIT_BANK_ACCT_USE_ID = E.BANK_ACCT_USE_ID
            -- AND I.CLEARED_AMOUNT IS NOT NULL
            -- AND AMOUNT_APPLIED_FROM IS NOT NULL
            --  AND F.DISPLAY = 'Y'
            -- AND F.STATUS = 'APP'
            --AND A.CASH_RECEIPT_ID='125027'
            AND AMOUNT_APPLIED_FROM IS NOT NULL
   GROUP BY F.RECEIVABLE_APPLICATION_ID,
            --A.CASH_RECEIPT_ID,
            A.LEGAL_ENTITY_ID,
            A.ORG_ID,
            OU.NAME,
            'AR PAY-' || I.DOC_SEQUENCE_VALUE,
            I.DOC_SEQUENCE_VALUE,
            I.CHECK_DATE,
            A.PAY_FROM_CUSTOMER,
            B.CUSTOMER_NUMBER,
            B.PARTY_NAME,
            (   DECODE (ADDRESS1, NULL, NULL, ADDRESS1 || ', ')
             || DECODE (ADDRESS2, NULL, NULL, ADDRESS2 || ', ')
             || DECODE (ADDRESS3, NULL, NULL, ADDRESS3 || ', ')
             || DECODE (ADDRESS4, NULL, NULL, ADDRESS4 || ', ')
             || DECODE (B.city, NULL, NULL, B.city || ', ')
             || DECODE (B.COUNTRY, NULL, NULL, B.COUNTRY)),
            A.COMMENTS,
            A.TYPE,
            I.CLEARED_DATE,
            GC.SEGMENT3,
            XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3),
            GC.SEGMENT5,
            XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4),
            GC.SEGMENT6,
            XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6),
            GC.SEGMENT7,
            XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7),
            GC.SEGMENT4,
            GET_GL_CODE_DESC_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID),
            GC.SEGMENT1,
            GET_FLEX_VALUES_FROM_FLEX_ID (
               GET_SEGMENT_VALUE_FROM_CCID (D.ACCOUNT_CODE_COMBINATION_ID, 1),
               1),
            A.CURRENCY_CODE,
            A.EXCHANGE_RATE,
            DECODE (A.TYPE, 'MISC', 'MISCELLANEOUS', 'STANDARD'),
            A.CUSTOMER_SITE_USE_ID,
               I.BANK_ACCOUNT_NAME
            || ' ,Inst. No:  '
            || CHECK_NUMBER
            || ', Inst. Date: '
            || CHECK_DATE,
            D.STATUS,
            B.CUST_CATEGORY,
            APPLY_DATE,
            TRUNC (I.CREATION_DATE)
   UNION ALL --THIS PART ADD FOR RECEIVABLE ADJUST TRANSACTION  ADD BY IBRAHIM
   SELECT DISTINCT
          3 SL,
          A.CUSTOMER_TRX_ID,
          A.LEGAL_ENTITY_ID,
          A.ORG_ID,
          NULL ORGANIZATION_NAME,
          'AR INV-' || AD.DOC_SEQUENCE_VALUE VOUCHER,
          TO_CHAR (AD.DOC_SEQUENCE_VALUE) INVOICE_NO,
          AD.APPLY_DATE INVOICE_DATE,
          A.BILL_TO_CUSTOMER_ID CUSTOMER_ID,
          B.CUSTOMER_NUMBER,
          B.PARTY_NAME CUSTOMER_NAME,
          (   DECODE (B.ADDRESS1, NULL, NULL, B.ADDRESS1 || ', ')
           || DECODE (B.ADDRESS2, NULL, NULL, B.ADDRESS2 || ', ')
           || DECODE (B.ADDRESS3, NULL, NULL, B.ADDRESS3 || ', ')
           || DECODE (B.ADDRESS4, NULL, NULL, B.ADDRESS4 || ', ')
           || DECODE (B.city, NULL, NULL, B.city || ', ')
           || DECODE (B.COUNTRY, NULL, NULL, B.COUNTRY))
             ADDRESS,
          NULL INVENTORY_ITEM_ID,
          AD.COMMENTS DESCRIPTION,
          C.LINE_TYPE INV_TYPE,
          AD.GL_DATE,
          D.ACCOUNT_CLASS,
          GC.SEGMENT3 COST_CODE,
          XX_GET_ACCT_FLEX_SEG_DESC (3, GC.SEGMENT3) COST_CENTER,
          GC.SEGMENT5 SUB_CODE,
          XX_GET_ACCT_FLEX_SEG_DESC (5, GC.SEGMENT5, GC.SEGMENT4) SUB_ACCOUNT,
          GC.SEGMENT6 PROJECT_CODE,
          XX_GET_ACCT_FLEX_SEG_DESC (6, GC.SEGMENT6) PROJECT_NAME,
          GC.SEGMENT7 INTER_COM_CODE,
          XX_GET_ACCT_FLEX_SEG_DESC (7, GC.SEGMENT7) INTER_COMPANY,
          GC.SEGMENT4 DIST_GL_CODE,
          GET_GL_CODE_DESC_FROM_CCID (AD.CODE_COMBINATION_ID)
             GL_CODE_AND_DESC,
          GC.SEGMENT1 BAL_SEG,
          GET_FLEX_VALUES_FROM_FLEX_ID (
             GET_SEGMENT_VALUE_FROM_CCID (AD.CODE_COMBINATION_ID, 1),
             1)
             BAL_SEG_NAME,
          NULL QUANTITY_INVOICED,
          NULL UNIT_SELLING_PRICE,
          AD.AMOUNT,
          GREATEST ( (NVL (AD.AMOUNT, 0)), 0) DR_AMOUNT,
          ABS (LEAST (NVL (AD.AMOUNT, 0), 0)) CR_AMOUNT,
          A.INVOICE_CURRENCY_CODE CURRENCY_CODE,
          A.EXCHANGE_RATE,
          C.INTERFACE_LINE_ATTRIBUTE1 SO_NUMBER,
          C.INTERFACE_LINE_ATTRIBUTE3 CHALLAN_NO,
          NULL PRODUCT_CATEGORY,
          NULL INV_DESC,
          NULL UOM_CODE,
          A.BILL_TO_SITE_USE_ID CUSTOMER_SITE_USE_ID,
          NULL BANK_ACCOUNT,
          A.STATUS_TRX STATUS,
          B.CUST_CATEGORY,
          TRUNC (AD.CREATION_DATE) TRANSECTION_DATE,
          NULL FU1,
          NULL FU2,
          NULL FU3,
          NULL FU4,
          NULL FU5,
          NULL,                                               --XTE.ENTITY_ID,
          NULL,                                     --XAL.BUSINESS_CLASS_CODE,
          NULL,                                           -- XAL.AE_HEADER_ID,
          NULL,                                             -- XAL.AE_LINE_NUM
          NULL
     FROM RA_CUSTOMER_TRX_ALL A,
          XX_AR_CUSTOMER_SITE_V B,
          RA_CUSTOMER_TRX_LINES_ALL C,
          RA_CUST_TRX_LINE_GL_DIST_ALL D,
          GL_CODE_COMBINATIONS GC,
          AR_ADJUSTMENTS_ALL AD
    WHERE     A.CUSTOMER_TRX_ID = AD.CUSTOMER_TRX_ID
          AND A.ORG_ID = B.ORG_ID
          AND A.BILL_TO_SITE_USE_ID = B.SITE_USE_ID
          AND A.BILL_TO_CUSTOMER_ID = B.CUSTOMER_ID
          AND B.SITE_USE_CODE = 'BILL_TO'
          AND B.PRIMARY_FLAG = 'Y'
          AND A.CUSTOMER_TRX_ID = C.CUSTOMER_TRX_ID
          AND A.CUSTOMER_TRX_ID = D.CUSTOMER_TRX_ID
          AND C.CUSTOMER_TRX_LINE_ID = D.CUSTOMER_TRX_LINE_ID
          AND AD.CODE_COMBINATION_ID = GC.CODE_COMBINATION_ID
          AND D.ACCOUNT_CLASS NOT IN ('REC')
          AND AD.STATUS = 'A'
   --   AND AD.CUSTOMER_TRX_ID='117113'
   ORDER BY ORG_ID, CUSTOMER_ID, CUSTOMER_TRX_ID;

--============================================================
--AKG Customer Ledger  Query Summery
--=============================================================

select * from
(SELECT 0 SL,
         CUSTOMER_ID,
         CUSTOMER_NUMBER CUST_NUMBER,
         NULL CUSTOMER_TRX_ID,
         CUSTOMER_NAME CUSTOMER,
         AREA_NAME,
         ADDRESS,
         NULL CO_DATE,
         NULL CO_NUMBER,
         NULL GL_DATE,
         NULL DO_NUMBER,
         NULL DO_DATE,
         NULL VOUCHER,
         'Opening Balance' RECEIPT_NUMBER,
         NULL DR_AMOUNT,
         NULL CR_AMOUNT,
         (NVL (SUM (DR_AMOUNT), 0) - NVL (SUM (CR_AMOUNT), 0)) BALANCE
 FROM XXAKG_AR_CUSTOMER_LEDGER_V
-- where customer_number='40003'
   WHERE ORG_ID = :P_ORG_ID
         AND CUSTOMER_ID = :P_CUSTOMER_ID
         AND GL_DATE < :P_FROM_DATE
         AND (:P_STATUS IS NULL OR NVL (STATUS, :P_STATUS) = :P_STATUS)
GROUP BY CUSTOMER_ID,
         CUSTOMER_NUMBER,
         CUSTOMER_NAME,
         AREA_NAME,
         ADDRESS
UNION ALL
SELECT 1 SL,
       CUSTOMER_ID,
       CUSTOMER_NUMBER CUST_NUMBER,
       CUSTOMER_TRX_ID,
       CUSTOMER_NAME CUSTOMER,
       AREA_NAME,
       ADDRESS,
       CO_DATE,
       CO_NUMBER,
       GL_DATE,
       DO_NUMBER,
       DO_DATE,
       VOUCHER,
       RECEIPT_NUMBER,
       DR_AMOUNT,
       CR_AMOUNT,
       (NVL (DR_AMOUNT, 0) - NVL (CR_AMOUNT, 0))
  FROM XXAKG_AR_DTL_CUSTOMER_LEDGER_V
 WHERE ORG_ID = :P_ORG_ID
       AND CUSTOMER_ID = :P_CUSTOMER_ID
       AND GL_DATE BETWEEN :P_FROM_DATE AND :P_TO_DATE
       AND (:P_STATUS IS NULL OR NVL (STATUS, :P_STATUS) = :P_STATUS)
       AND (NVL (DR_AMOUNT, 0) <> 0 OR NVL (CR_AMOUNT, 0) <> 0)
ORDER BY SL, GL_DATE, VOUCHER DESC) xx,
(SELECT CUSTOMER_ID,
         CUSTOMER_TRX_ID,
         --       LINE_NUMBER,
         CONCATENATED_SEGMENTS,
         DESCRIPTION,
         QUANTITY,
         SUM (UNIT_SELLING_PRICE) UNIT_SELLING_PRICE,
         SUM (Dist_Com) Dist_Com,
         SUM (Prom_Disc) Prom_Disc,
         SUM (SP_Com) SP_Com,
         SUM (AMOUNT) AMOUNT,
         SUM (Dist_Com) + SUM (Prom_Disc) + SUM (SP_Com) TOTAL_DED,
         SUM (AMOUNT) - (SUM (Dist_Com) + SUM (Prom_Disc) + SUM (SP_Com)) NET_AMOUNT
    FROM (SELECT CUSTOMER_ID,
                 CUSTOMER_TRX_ID,
                LINE_NUMBER,
                 CONCATENATED_SEGMENTS,
                 (CASE
                     WHEN :p_org_id = 665
                          AND a.CONCATENATED_SEGMENTS IS NOT NULL
                     THEN
                        (SELECT msi.description
                           FROM mtl_system_items_b msi
                          WHERE msi.organization_id = 685
                                AND    msi.segment1
                                   || '.'
                                    || msi.segment2
                                   || '.'
                                    || msi.segment3 =
                                       TRIM (a.CONCATENATED_SEGMENTS))
                     ELSE
                        DESCRIPTION
                  END) DESCRIPTION, QUANTITY,
                 (CASE
                     WHEN UNIT_SELLING_PRICE < 0 THEN 0
                     ELSE UNIT_SELLING_PRICE
                 END)  UNIT_SELLING_PRICE,
                 (CASE
                    WHEN DESCRIPTION LIKE '%Distributor Commission%'
                     THEN
                        AMOUNT
                     ELSE
                        0
                  END) Dist_Com,
                 (CASE
                     WHEN DESCRIPTION LIKE '%Promotional Discounts%'
                     THEN
                        AMOUNT
                     ELSE
                        0
                  END)  Prom_Disc,                  
                (CASE
                     WHEN DESCRIPTION LIKE '%Special Commision%' THEN AMOUNT
                     ELSE 0
                  END) SP_Com,
                 (CASE
                     WHEN (   a.DESCRIPTION LIKE '%Special Commision%'
                           OR a.DESCRIPTION LIKE '%Promotional Discounts%'
                          OR a.DESCRIPTION LIKE '%Distributor Commission%')
                     THEN
                        0
                     ELSE
                        AMOUNT
                  END)  Amount
            FROM APPS.XXAKG_RA_CUSTOMER_TRX_ITEM_V a
           WHERE CUSTOMER_ID = :P_CUSTOMER_ID AND UNIT_SELLING_PRICE <> 0)
GROUP BY CUSTOMER_ID,
         CUSTOMER_TRX_ID,
         --       LINE_NUMBER,
         CONCATENATED_SEGMENTS,
         DESCRIPTION,
         QUANTITY) yy
         where xx.customer_id=yy.customer_id(+)
         and xx.CUSTOMER_TRX_ID=yy.CUSTOMER_TRX_ID(+)
       ORDER BY  SL,GL_DATE, VOUCHER asc
       
       --=======================================
      -- Some  AR Customer Details  this need to ready for KSRM
      -- Dated: 17-JAN-2019
       --========================================
      
      

/* Formatted on 12/29/2018 3:56:44 PM (QP5 v5.136.908.31019) */
CREATE OR REPLACE FORCE VIEW APPS.XXAKG_AR_CUSTOMER_LEDGER_V
(
   SL,
   ORG_ID,
   CUSTOMER_ID,
   CUSTOMER_NUMBER,
   CUSTOMER_TRX_ID,
   CUSTOMER_NAME,
   AREA_NAME,
   ADDRESS,
   CO_NUMBER,
   DO_NUMBER,
   VOUCHER,
   BANK,
   QUANTITY,
   UOM,
   GL_DATE,
   STATUS,
   DR_AMOUNT,
   CR_AMOUNT,
   TOTAL
)
AS
   SELECT 1,
          CT.ORG_ID,
          BILL_TO_CUSTOMER_ID,
          CT.RAC_BILL_TO_CUSTOMER_NUM,
          CT.CUSTOMER_TRX_ID,
          CT.RAC_BILL_TO_CUSTOMER_NAME,
          XXAKG_AR_PKG.GET_AREA_FROM_CUST_ID (CT.BILL_TO_CUSTOMER_ID),
          XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CT.BILL_TO_CUSTOMER_ID),
          CT.INTERFACE_HEADER_ATTRIBUTE1,
          XXAKG_ONT_PKG.GET_DO_NUMBER_FROM_TRX_ID (CT.CUSTOMER_TRX_ID),
          CT.DOC_SEQUENCE_VALUE,
          CT.CTT_TYPE_NAME,
          XXAKG_AR_PKG.GET_QUANTITY_FROM_TRX_ID (CT.CUSTOMER_TRX_ID),
          XXAKG_AR_PKG.GET_UOM_FROM_TRX_ID (CT.CUSTOMER_TRX_ID),
          CD.GL_DATE,
          NULL,
          GREATEST (NVL (CD.ACCTD_AMOUNT, CD.AMOUNT), 0),
          (0 - LEAST (NVL (CD.ACCTD_AMOUNT, CD.AMOUNT), 0)),
          NVL (CD.ACCTD_AMOUNT, CD.AMOUNT)
     FROM XXAKG_RA_CUSTOMER_TRX_V CT, RA_CUST_TRX_LINE_GL_DIST_ALL CD
    WHERE CT.CUSTOMER_TRX_ID = CD.CUSTOMER_TRX_ID
          AND CD.ACCOUNT_CLASS = 'REC'
   UNION ALL
   SELECT 2,
          ORG_ID,
          CUSTOMER_ID,
          CUSTOMER_NUMBER,
          NULL,
          CUSTOMER_NAME,
          XXAKG_AR_PKG.GET_AREA_FROM_CUST_ID (CUSTOMER_ID),
          XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CUSTOMER_ID),
          RECEIPT_NUMBER,
          NULL,
          DOCUMENT_NUMBER,
          REMIT_BANK_ACCOUNT_NUM || ', ' || REMIT_BANK_NAME,
          NULL,
          NULL,
          DECODE (LEGAL_ENTITY_ID, 23279, RECEIPT_DATE, GL_DATE), -- Cement want to see Receipt Date and Steel want to see Cleared Date (GL Date)
          STATE,
          (0 - LEAST (NVL (FUNCTIONAL_AMOUNT, AMOUNT), 0)),
          GREATEST (NVL (FUNCTIONAL_AMOUNT, AMOUNT), 0),
          0 - (NVL (FUNCTIONAL_AMOUNT, AMOUNT))
     FROM XXAKG_AR_CASH_RECEIPTS_V
    WHERE NVL (STATE, 'AKG') <> 'REVERSED'
   UNION ALL
   SELECT 3,
          ORG_ID,
          CUSTOMER_ID,
          CUSTOMER_NUMBER,
          NULL,
          CUSTOMER,
          AREA_NAME,
          ADDRESS,
          TO_CHAR (CHECK_NUMBER),
          NULL,
          VOUCHER,
          BANK,
          NULL,
          NULL,
          GL_DATE,
          STATUS,
          DR_AMOUNT,
          CR_AMOUNT,
          TOTAL
     FROM XXAKG_AR_CASH_PAYMENTS_V
    WHERE NVL (STATUS, 'AKG') <> 'VOIDED';


GRANT SELECT ON APPS.XXAKG_AR_CUSTOMER_LEDGER_V TO XXAKG_APPS_ROLE;

-----------------------------------------------------------------------------------------------------------------------
DROP VIEW APPS.XXAKG_AR_DTL_CUSTOMER_LEDGER_V;

/* Formatted on 12/29/2018 3:59:06 PM (QP5 v5.136.908.31019) */
CREATE OR REPLACE FORCE VIEW APPS.XXAKG_AR_DTL_CUSTOMER_LEDGER_V
(
   SL,
   ORG_ID,
   CUSTOMER_ID,
   CUSTOMER_NUMBER,
   CUSTOMER_TRX_ID,
   CUSTOMER_NAME,
   AREA_NAME,
   ADDRESS,
   CO_NUMBER,
   CO_DATE,
   DO_NUMBER,
   DO_DATE,
   VOUCHER,
   TRX_TYPE,
   GL_DATE,
   STATUS,
   RECEIPT_NUMBER,
   DR_AMOUNT,
   CR_AMOUNT,
   TOTAL
)
AS
   SELECT 1,
          CT.ORG_ID,
          BILL_TO_CUSTOMER_ID,
          CT.RAC_BILL_TO_CUSTOMER_NUM,
          CT.CUSTOMER_TRX_ID,
          CT.RAC_BILL_TO_CUSTOMER_NAME,
          XXAKG_AR_PKG.GET_AREA_FROM_CUST_ID (CT.BILL_TO_CUSTOMER_ID),
          XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CT.BILL_TO_CUSTOMER_ID),
          CT.INTERFACE_HEADER_ATTRIBUTE1,
          XXAKG_ONT_PKG.GET_ORDER_DATE_FROM_TRX_ID (CT.CUSTOMER_TRX_ID),
          XXAKG_ONT_PKG.GET_DO_NUMBER_FROM_TRX_ID (CT.CUSTOMER_TRX_ID),
          XXAKG_ONT_PKG.GET_DO_DATE_FROM_TRX_ID (CT.CUSTOMER_TRX_ID),
          CT.DOC_SEQUENCE_VALUE,
          NULL,
          CD.GL_DATE,
          NULL,
          CT.CTT_TYPE_NAME,
          GREATEST (NVL (CD.ACCTD_AMOUNT, CD.AMOUNT), 0),
          (0 - LEAST (NVL (CD.ACCTD_AMOUNT, CD.AMOUNT), 0)),
          NVL (CD.ACCTD_AMOUNT, CD.AMOUNT)
     FROM XXAKG_RA_CUSTOMER_TRX_V CT, RA_CUST_TRX_LINE_GL_DIST_ALL CD
    WHERE CT.CUSTOMER_TRX_ID = CD.CUSTOMER_TRX_ID
          AND CD.ACCOUNT_CLASS = 'REC'
   UNION ALL
   SELECT 2,
          ORG_ID,
          CUSTOMER_ID,
          CUSTOMER_NUMBER,
          NULL,
          CUSTOMER_NAME,
          XXAKG_AR_PKG.GET_AREA_FROM_CUST_ID (CUSTOMER_ID),
          XXAKG_AR_PKG.GET_CUSTOMER_ADDRESS (CUSTOMER_ID),
          NULL,
          NULL,
          NULL,
          NULL,
          DOCUMENT_NUMBER,
          NULL,
          DECODE (LEGAL_ENTITY_ID, 23279, RECEIPT_DATE, GL_DATE), -- Cement want to see Receipt Date and Steel want to see Cleared Date (GL Date)
          STATE,
          RECEIPT_NUMBER || ', ' || REMIT_BANK_ACCOUNT_NUM,
          (0 - LEAST (NVL (FUNCTIONAL_AMOUNT, AMOUNT), 0)),
          GREATEST (NVL (FUNCTIONAL_AMOUNT, AMOUNT), 0),
          0 - (NVL (FUNCTIONAL_AMOUNT, AMOUNT))
     FROM XXAKG_AR_CASH_RECEIPTS_V
    WHERE NVL (STATE, 'AKG') <> 'REVERSED'
   UNION ALL
   SELECT 3,
          ORG_ID,
          CUSTOMER_ID,
          CUSTOMER_NUMBER,
          NULL,
          CUSTOMER,
          AREA_NAME,
          ADDRESS,
          NULL,
          NULL,
          NULL,
          NULL,
          VOUCHER,
          NULL,
          GL_DATE,
          STATUS,
          PAYMENT_NUMBER,
          DR_AMOUNT,
          CR_AMOUNT,
          TOTAL
     FROM XXAKG_AR_CASH_PAYMENTS_V
    WHERE NVL (STATUS, 'AKG') <> 'VOIDED';


GRANT SELECT ON APPS.XXAKG_AR_DTL_CUSTOMER_LEDGER_V TO XXAKG_APPS_ROLE;

--------------------------------------------------------------------------------------------------------------------------+


DROP VIEW APPS.XXAKG_RA_CUSTOMER_TRX_ITEM_V;

/* Formatted on 12/29/2018 4:02:31 PM (QP5 v5.136.908.31019) */
CREATE OR REPLACE FORCE VIEW APPS.XXAKG_RA_CUSTOMER_TRX_ITEM_V
(
   CUSTOMER_ID,
   CUSTOMER_NUM,
   CUSTOMER_TRX_ID,
   LINE_NUMBER,
   CONCATENATED_SEGMENTS,
   DESCRIPTION,
   QUANTITY,
   UNIT_SELLING_PRICE,
   AMOUNT
)
AS
   SELECT TRXL.SHIP_TO_CUSTOMER_ID CUSTOMER_ID,
          TRXL.SHIP_TO_CUSTOMER_NUM,
          TRXL.CUSTOMER_TRX_ID,
          TRXL.LINE_NUMBER,
          ITEM.CONCATENATED_SEGMENTS,
          SUBSTR (TRXL.DESCRIPTION, 1, 44),
          TRXL.QUANTITY,
          TRXL.UNIT_SELLING_PRICE,
          NVL ( (TRXL.QUANTITY * TRXL.UNIT_SELLING_PRICE), 0) AMOUNT
     FROM XXAKG_RA_CUSTOMER_TRX_LINES_V TRXL, MTL_SYSTEM_ITEMS_B_KFV ITEM
    WHERE     TRXL.INVENTORY_ITEM_ID = ITEM.INVENTORY_ITEM_ID
          AND TRXL.WAREHOUSE_ID = ITEM.ORGANIZATION_ID
          AND TRXL.LINE_TYPE IN ('LINE', 'CB', 'CHARGES');


GRANT SELECT ON APPS.XXAKG_RA_CUSTOMER_TRX_ITEM_V TO XXAKG_APPS_ROLE;

-- EBS Customer Bill
select
distinct
rct.trx_number invoice_number,
rct.trx_date invoice_date,
rct.org_id,
substr(ou.operating_unit,5,240) operating_unit,
rct.sold_to_customer_id customer_id,
--(select distinct customer_name from xx_ar_customer_site_v where customer_id = rct.sold_to_customer_id and org_id = rct.org_id)  customer_name,
(select distinct 
(CASE WHEN customer_name='KBIL Manufacturing Unit' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSPL Manufacturing Unit' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSPL Barpa' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSRM Transport Old Yard' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSRM Transport Barabkunda' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSL Manufacturing Unit' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KASIL Manufacturing Unit' THEN '104-Khawja Ajmeer Steel Industries Limited' 
WHEN customer_name='KSPL Barabkunda' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KBIL Bara Awlia' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSRM Transport Joramtal' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSL Halishahar' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KSPL Sadarghat Lighter Jetty Main Store' THEN '101-KSRM Steel Plant Ltd (Sadarghat Lighter Jetty)' 
WHEN customer_name='Jahan Marine (Pvt.) Limited' THEN '305-Jahan Marine (Pvt.) Limited' 
WHEN customer_name='KBIL Barabkunda' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSL Head Office' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KBIL New Yard' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSL Warehouse Barabkunda' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KBIL Warehouse Kumira' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSRM Transport New Yard' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSRM Old Yard' THEN '102-KSRM Steel Plant Ltd (General)' 
WHEN customer_name='KPPL Manufacturing Unit' THEN '106-KSRM Power Plant Limited' 
WHEN customer_name='KOL Manufacturing Unit' THEN '105-Kabir Oxygen Ltd.' 
WHEN customer_name='KSRM Transport Barakumira' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSPL Kalurghat' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSPL New Yard' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSRM Transport Head Office' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSPL Lighter Ship Main Store' THEN '101-KSRM Steel Plant Ltd (Lighter Ship)' 
WHEN customer_name='KWSBL New Yard' THEN '202-Khawaja Ship Breaking Limited' 
WHEN customer_name='KSBL Old Yard' THEN '203-Kabir Ship Breaking Limited' 
WHEN customer_name='KSRM Power Manufacturing Unit' THEN '102-KSRM Steel Plant Ltd (Power)' 
WHEN customer_name='KSRM Manufacturing Unit' THEN '102-KSRM Steel Plant Ltd (General)' 
WHEN customer_name='KSRM Barabkunda' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSPL New Yard' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
ELSE customer_name END)
from xx_ar_customer_site_v where customer_id = rct.sold_to_customer_id and org_id = rct.org_id)  customer_name,
(select distinct account_number from xx_ar_customer_site_v where customer_id = rct.sold_to_customer_id and org_id = rct.org_id)  customer_number,
(select attribute11 from hz_cust_accounts where cust_account_id = rct.sold_to_customer_id) customer_phone_no,
to_char(ooh.order_number) order_number,
trunc(ooh.ordered_date) ordered_date,
wdd.source_line_id line_id,
--wdd.delivery_detail_id,
wnd.delivery_id,
wnd.name challan_number,
wnd.confirm_date challan_date,
rctl.warehouse_id organization_id,
(select distinct organization_code from org_organization_definitions where organization_id = rctl.warehouse_id) organization_name,
xx_inv_pkg.xxget_org_location (rct.org_id) org_address  
,(select distinct address from xx_ont_party_location_v where ship_to_org_id = rct.bill_to_site_use_id) bill_to_address
,nvl(wdd.attribute15,nvl(ooh.shipping_instructions,(select distinct address from xx_ont_party_location_v where ship_to_org_id=ooh.ship_to_org_id))) ship_to_add
,(select distinct reg_no from xx_ont_trip_v trip where tripsys_no = wnd.attribute4) reg_no
,(select distinct description from mtl_system_items_b where inventory_item_id=wdd.inventory_item_id and  organization_id=wdd.organization_id) item_description
,rctl.uom_code item_uom
,(select distinct segment3 from mtl_system_items_b where ool.inventory_item_id = inventory_item_id) item_size
--,nvl(wdd.shipped_quantity,0) shipped_quantity
,nvl(rctl.quantity_invoiced,0) quantity_invoiced
,rct.invoice_currency_code
,rct.exchange_rate_type
,rct.exchange_date
,rct.exchange_rate
,rct.purchase_order,
/*
------ unit price
nvl(ool.unit_list_price,0) unit_list_price,
nvl(xx_fnd_line_discount(ool.line_id),0) unit_discount_amt,
nvl(xx_fnd_line_freight(ool.line_id),0) unit_freight_amt,
nvl(xx_fnd_line_loading(ool.line_id),0) unit_loading_amt,
nvl(xx_fnd_line_handling(ool.line_id),0) unit_unloading_amt,
nvl(xx_fnd_line_surcharge(ool.line_id),0) unit_surcharge_amt,
nvl(xx_fnd_line_vat(ool.line_id),0) unit_vat_amt, 
nvl(xx_fnd_line_amt(ool.line_id),0) unit_line_amt,
*/
(nvl(ool.unit_list_price,0) + nvl(xx_fnd_line_discount(ool.line_id),0)) unit_selling_price,
nvl(rctl.quantity_invoiced,0) * (nvl(ool.unit_list_price,0) + nvl(xx_fnd_line_discount(ool.line_id),0)) line_base_value,
nvl(rctl.quantity_invoiced,0) * nvl(xx_fnd_line_vat(ool.line_id),0) line_vat_amt,
nvl(rctl.quantity_invoiced,0) * (nvl(ool.unit_list_price,0) + nvl(xx_fnd_line_discount(ool.line_id),0) + nvl(xx_fnd_line_vat(ool.line_id),0)) line_base_value_with_vat,
nvl(rctl.quantity_invoiced,0) * nvl(xx_fnd_line_freight(ool.line_id),0) line_freight_amt,
nvl(rctl.quantity_invoiced,0) * nvl(xx_fnd_line_loading(ool.line_id),0) line_loading_amt,
nvl(rctl.quantity_invoiced,0) * nvl(xx_fnd_line_handling(ool.line_id),0) line_unloading_amt,
nvl(rctl.quantity_invoiced,0) * nvl(xx_fnd_line_surcharge(ool.line_id),0) line_surcharge_amt,
nvl(rctl.quantity_invoiced,0) * nvl(xx_fnd_line_amt(ool.line_id),0) line_total_amt,
--to_char(null) iso_number,
--to_char(null) vat_reg_number,
xx_ont_get_ename(:p_user) printed_by,
:p_currency  p_currency
from 
oe_order_headers_all ooh
,oe_order_lines_all ool
,wsh_new_deliveries wnd
,wsh_delivery_assignments wda
,xx_operating_units_v ou
,ra_customer_trx_lines_all rctl
,ra_customer_trx_all rct
,wsh_delivery_details wdd
/*left join
xx_ont_trip_v trip
on wdd.delivery_detail_id = trip.delivery_detail_id
and trip_status in ('I','C')*/
where ooh.header_id=ool.header_id
and wdd.source_header_id=ool.header_id
and wdd.source_line_id=ool.line_id
and wdd.delivery_detail_id=wda.delivery_detail_id
and wda.delivery_id=wnd.delivery_id
and rct.org_id = ou.organization_id
and rctl.interface_line_attribute1 = ooh.order_number
--and rctl.interface_line_attribute3 = wnd.name
/*Modification for Intercompany Bill issue By Showkat Hossain at 31-Oct-22*/
AND CASE WHEN rct.INTERFACE_HEADER_CONTEXT = 'ORDER ENTRY' AND rctl.interface_line_attribute3 = wnd.name THEN 1
                WHEN rct.INTERFACE_HEADER_CONTEXT != 'ORDER ENTRY' AND rctl.interface_line_attribute3 != wnd.name THEN 1
                ELSE 0
            END = 1
and rctl.interface_line_attribute6 = ool.line_id
and rctl.customer_trx_id = rct.customer_trx_id
and wdd.released_status = 'C'
and rct.org_id = :p_org_id
and rct.sold_to_customer_id = nvl(:p_customer_id,rct.sold_to_customer_id)
and rct.trx_number between nvl(:p_invoice_no_from,rct.trx_number) and nvl(:p_invoice_no_to,rct.trx_number)
and rct.trx_date between nvl(:p_invoice_date_from, rct.trx_date) and nvl(:p_invoice_date_to,rct.trx_date)
--order by rct.trx_number
union
select
distinct
rct.trx_number invoice_number,
rct.trx_date invoice_date,
rct.org_id,
substr(ou.operating_unit,5,240) operating_unit,
rct.sold_to_customer_id customer_id,
--(select distinct customer_name from xx_ar_customer_site_v where customer_id = rct.sold_to_customer_id and org_id = rct.org_id)  customer_name,
(select distinct 
(CASE WHEN customer_name='KBIL Manufacturing Unit' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSPL Manufacturing Unit' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSPL Barpa' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSRM Transport Old Yard' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSRM Transport Barabkunda' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSL Manufacturing Unit' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KASIL Manufacturing Unit' THEN '104-Khawja Ajmeer Steel Industries Limited' 
WHEN customer_name='KSPL Barabkunda' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KBIL Bara Awlia' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSRM Transport Joramtal' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSL Halishahar' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KSPL Sadarghat Lighter Jetty Main Store' THEN '101-KSRM Steel Plant Ltd (Sadarghat Lighter Jetty)' 
WHEN customer_name='Jahan Marine (Pvt.) Limited' THEN '305-Jahan Marine (Pvt.) Limited' 
WHEN customer_name='KBIL Barabkunda' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSL Head Office' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KBIL New Yard' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSL Warehouse Barabkunda' THEN '201-Kabir Steel Limited' 
WHEN customer_name='KBIL Warehouse Kumira' THEN '103-KSRM Steel Plant Ltd  (Melting)' 
WHEN customer_name='KSRM Transport New Yard' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSRM Old Yard' THEN '102-KSRM Steel Plant Ltd (General)' 
WHEN customer_name='KPPL Manufacturing Unit' THEN '106-KSRM Power Plant Limited' 
WHEN customer_name='KOL Manufacturing Unit' THEN '105-Kabir Oxygen Ltd.' 
WHEN customer_name='KSRM Transport Barakumira' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSPL Kalurghat' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSPL New Yard' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSRM Transport Head Office' THEN '102-KSRM Steel Plant Ltd (Transport)' 
WHEN customer_name='KSPL Lighter Ship Main Store' THEN '101-KSRM Steel Plant Ltd (Lighter Ship)' 
WHEN customer_name='KWSBL New Yard' THEN '202-Khawaja Ship Breaking Limited' 
WHEN customer_name='KSBL Old Yard' THEN '203-Kabir Ship Breaking Limited' 
WHEN customer_name='KSRM Power Manufacturing Unit' THEN '102-KSRM Steel Plant Ltd (Power)' 
WHEN customer_name='KSRM Manufacturing Unit' THEN '102-KSRM Steel Plant Ltd (General)' 
WHEN customer_name='KSRM Barabkunda' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
WHEN customer_name='KSPL New Yard' THEN '101-KSRM Steel Plant Ltd (KSPL)' 
ELSE customer_name END)
from xx_ar_customer_site_v where customer_id = rct.sold_to_customer_id and org_id = rct.org_id)  customer_name,
(select distinct account_number from xx_ar_customer_site_v where customer_id = rct.sold_to_customer_id and org_id = rct.org_id)  customer_number,
(select attribute11 from hz_cust_accounts where cust_account_id = rct.sold_to_customer_id) customer_phone_no,
rctl.sales_order order_number,
rctl.sales_order_date ordered_date,
null line_id,
--null delivery_detail_id,
null delivery_id,
null challan_number,
null challan_date,
rctl.warehouse_id organization_id,
(select distinct organization_code from org_organization_definitions where organization_id = rctl.warehouse_id) organization_name,
xx_inv_pkg.xxget_org_location (rct.org_id) org_address  
,(select distinct address from xx_ont_party_location_v where ship_to_org_id = rct.bill_to_site_use_id) bill_to_address
,(select distinct address from xx_ont_party_location_v where ship_to_org_id = rct.ship_to_site_use_id) ship_to_add
,null reg_no  
,rctl.description item_description
,rctl.uom_code item_uom
,null item_size
--,to_number(null) shipped_quantity
,nvl(rctl.quantity_invoiced,rctl.quantity_credited) quantity_invoiced
--,nvl(rctl.quantity_invoiced,0) quantity_invoiced
,rct.invoice_currency_code
,rct.exchange_rate_type
,rct.exchange_date
,rct.exchange_rate
,rct.purchase_order,
/*
------ unit price
nvl(ool.unit_list_price,0) unit_list_price,
nvl(xx_fnd_line_discount(ool.line_id),0) unit_discount_amt,
nvl(xx_fnd_line_freight(ool.line_id),0) unit_freight_amt,
nvl(xx_fnd_line_loading(ool.line_id),0) unit_loading_amt,
nvl(xx_fnd_line_handling(ool.line_id),0) unit_unloading_amt,
nvl(xx_fnd_line_surcharge(ool.line_id),0) unit_surcharge_amt,
nvl(xx_fnd_line_vat(ool.line_id),0) unit_vat_amt, 
nvl(xx_fnd_line_amt(ool.line_id),0) unit_line_amt,
*/
rctl.unit_selling_price unit_selling_price,
rctl.revenue_amount line_base_value,
0 line_vat_amt,
rctl.revenue_amount line_base_value_with_vat,
0 line_freight_amt,
0 line_loading_amt,
0 line_unloading_amt,
0 line_surcharge_amt,
rctl.revenue_amount line_total_amt,
--to_char(null) iso_number,
--to_char(null) vat_reg_number,
xx_ont_get_ename(:p_user) printed_by,
:p_currency p_currency    
from 
xx_operating_units_v ou
,ra_customer_trx_lines_all rctl
,ra_customer_trx_all rct
where
rctl.customer_trx_id = rct.customer_trx_id
and rct.org_id = ou.organization_id
and rctl.interface_line_attribute1 is null
and rctl.interface_line_attribute3 is null
and rctl.interface_line_attribute6 is null
and rct.org_id = :p_org_id
and rct.sold_to_customer_id = nvl(:p_customer_id,rct.sold_to_customer_id)
and rct.trx_number between nvl(:p_invoice_no_from,rct.trx_number) and nvl(:p_invoice_no_to,rct.trx_number)
and rct.trx_date between nvl(:p_invoice_date_from, rct.trx_date) and nvl(:p_invoice_date_to,rct.trx_date)


SELECT * FROM HR_OPERATING_UNITS

SELECT  * FROM ra_customer_trx_lines_all rctl where DESCRIPTION <> 'Opening Balance for Customer'

 SELECT  * FROM  ra_customer_trx_all  where INTERFACE_HEADER_CONTEXT <> 'Opening Balance for Customer'
 
 SELECT * FROM xx_ar_customer_site_v where CUST_CATEGORY = 'INTERNAL' and CUSTOMER_NAME  LIKE  '%KBIL%'
 
  SELECT distinct A.CUSTOMER_ID,A.CUSTOMER_NAME, A.ADDRESS1,CUST_CATEGORY,
NVL( (SELECT ORGANIZATION_CODE FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_NAME=A.CUSTOMER_NAME),
CASE WHEN A.CUSTOMER_NAME= 'KBIL Barabkunda' THEN 'KBIL Warehouse Barabkunda' ||'- '||'KBA'
 WHEN A.CUSTOMER_NAME ='KSRM Barabkunda' THEN 'KSRM Warehouse Barabkunda'||'- '||'KRA'
 WHEN A.CUSTOMER_NAME='KSPL Barabkunda' THEN 'KSPL Warehouse Barabkunda'||'- '||'KSA'
 else A.CUSTOMER_NAME END) ORG_CODE, 
 (SELECT OPERATING_UNIT FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_NAME=A.CUSTOMER_NAME) OU
    FROM xx_ar_customer_site_v A  where 1=1 -- CUST_CATEGORY = 'INTERNAL'  
    and a.CUSTOMER_NAME='SS CONSTRUCTION' --'ROYAL CEMENT LIMITED-OTHERS'
    
    
    
    SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE LIKE  '%KRA%'
    
    SELECT * FROM HR_OPERATING_UNITS