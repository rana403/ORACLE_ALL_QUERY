-=========================================================
--TO GET PO, GRN, LC AND GRN VALUS in ONE LINE AS SUMMARY
--=========================================================

SELECT  ORG_ID, SUPPLIER_NAME,PO_NUMBER,LC_NUMBER,CURRENCY_CODE,GRN_NO,GRN_DATE ,GRN_VALUE,BILL_OF_ENTRY_NO , BILL_OF_ENTRY_DATE
FROM XX_LC_DETAILS LC, XX_LC_DETAILS_DT LCD
WHERE LC.LC_ID= LCD.LC_ID 
--AND LC.LC_NUMBER=  '2355-18-02-0065' 
AND TO_DATE(GRN_DATE)  between '01-MAY-2021' and '31-MAR-2022'
--and PO_NUMBER='40008494'
ORDER BY PO_NUMBER

--============================================================
--TO GET PO, GRN, LC AND GRN VALUS  AS DETAILS
--============================================================

SELECT LC.LC_NUMBER, POH.SEGMENT1 PO_NUMBER,RSH.RECEIPT_NUM GRN_NUMBER,RT.TRANSACTION_DATE ,POH.CURRENCY_CODE,POL.ITEM_DESCRIPTION ,POH.RATE,
-- POL.QUANTITY PO_QUANTITY,
-- RSH.ATTRIBUTE11 BL_NO,
-- RSH.ATTRIBUTE12 BL_DT,
 RT.QUANTITY GRN_QTY,POL.UNIT_PRICE UNIT_PRICE,
RT.QUANTITY*POL.UNIT_PRICE AMOUNT ,RT.QUANTITY*POL.UNIT_PRICE*POH.RATE BDT_AMOUNT
 FROM PO_HEADERS_ALL POH, PO_LINES_ALL POL,XX_LC_DETAILS LC, RCV_SHIPMENT_HEADERS RSH,RCV_SHIPMENT_LINES RSL,RCV_TRANSACTIONS RT
WHERE POH.PO_HEADER_ID = POL.PO_HEADER_ID
AND POH.PO_HEADER_ID(+)= LC.PO_HEADER_ID
AND POH.PO_HEADER_ID= RSL.PO_HEADER_ID
AND RSL.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
AND RSL.SHIPMENT_LINE_ID= RT.SHIPMENT_LINE_ID
AND RT.TRANSACTION_TYPE = 'DELIVER'
AND TRUNC(TRANSACTION_DATE) between '01-MAY-2021' and '31-MAR-2022'
AND RT.ORGANIZATION_ID= 166
AND POH.currency_code <> 'BDT'
--AND POH.SEGMENT1= 40000023
ORDER BY POH.SEGMENT1  



select * from RCV_SHIPMENT_HEADERS WHERE SHIP_TO_ORG_ID= 166 --RECEIPT_NUM


select * from XX_LCM_LINE 

select * from 

select * from  INL_ALLOCATIONS
  
select * from  INL_ALWD_LINE_TYPES

select * from  INL_ALWD_PARTY_TYPES

select * from  INL_ALWD_PARTY_USAGES

select * from  INL_ALWD_SOURCE_TYPES

select * from  INL_ASSOCIATIONS

select * from INL_CHARGE_LINES    --- MATCH_ID , CHARGE_AMT, CHARGE_LINE_TYPE_ID 

select * from INL_CONDITIONS

select * from INL_ENTITIES_B

select * from INL_ENTITIES_TL

select * from INL_INTERFACE_ERRORS

select * from INL_MATCH_AMOUNTS   -- MATCH_AMOUNT_ID ,  MATCHED_AMT












-- LC TABLE and QUERY

select * from INL_ALWD_LINE_TYPES

select * from INL_SHIP_HEADERS_ALL 

select * from inl_ship_lines_all

select * from INL_CHARGE_LINES

select * from INL_TAX_LINES

select * from INL_ALLOCATIONS

select * from INL_SHIP_LINE_GROUPS where SHIP_LINE_GROUP_REFERENCE = 80000047

select * from INL_ALWD_SOURCE_TYPES

select * from INL_MATCH_AMOUNTS



select poha.segment1, poha.org_id, poha.po_header_id, plla.po_line_id, isla.ship_line_source_id, plla.shipment_num, isla.*
from po_line_locations_all plla, inl_ship_lines_all isla, po_headers_all poha
where poha.po_header_id = plla.po_header_id
and isla.ship_line_source_id = plla.line_location_id
--and plla.last_update_date > sysdate - :P_LastNdays
and poha.segment1 = 40002006

select distinct rsh.receipt_num  into l_receipt_num from (select shipment_header_id, receipt_num, shipment_num,ship_to_org_id,asn_type from rcv_shipment_headers ) rsh,
 (select shipment_header_id, po_header_id, shipment_line_status_code,po_line_location_id from rcv_shipment_lines  ) rsl
where rsh.shipment_header_id = rsl.shipment_header_id
and rsl.po_header_id = p_po_header_id
and rsl.po_line_location_id = p_po_line_location_id
and rsh.shipment_num like p_lcm_ship_num||'%'
and rsh.asn_type = 'LCM'
and rsh.ship_to_org_id = 166 --p_org_id
and rsl.shipment_line_status_code <> 'CANCELLED'



select * from AP_INVOICES_ALL where INVOICE_NUM = 'ABP-183'

select * from AP_INVOICE_LINES_ALL WHERE INVOICE_ID = 1393417








SELECT * FROM PO_HEADERS_ALL where SEGMENT1= 40002006 and org_id= 81

SELECT * FROM XX_LC_DETAILS WHERE PO_NUMBER= 40002006

select * from RCV_SHIPMENT_HEADERS  where receipt_num= 80000047 and SHIP_TO_ORG_ID= 166

SELECT * FROM PO_HEADERS_ALL WHERE SEGMENT1=40000023 AND ORG_ID=104

SELECT * FROM PO_LINES_ALL WHERE PO_HEADER_ID=34001 AND ORG_ID=104

SELECT A.ORG_ID, A.PO_HEADER_ID,A.SEGMENT1,A.CURRENCY_CODE,A.RATE
FROM PO_HEADERS_ALL A ,
RCV_SHIPMENT_HEADERS RH,
RCV_SHIPMENT_LINES RL
WHERE A.SEGMENT1=40000023 AND ORG_ID=104



--================================================
-- LC REGISTER REPORT
--=================================================

SELECT ORG.Organization_code, LC.LC_NUMBER,LC.LC_OPENING_DATE,
RH.SHIPMENT_NUM,
LC.Bank_name,
ROUND(IND.GRN_DT-LC.LC_OPENING_DATE)LEAD_TIME,
POL.ITEM_DESCRIPTION,
XX_FND_EMP_NAME(POH.CREATED_BY) USER_NAME,
(LC.Supplier_Name||' ( '||    LC.Supplier_Number||') ')Supplier,
PLL.QUANTITY PO_QTY,
POL.UNIT_MEAS_LOOKUP_CODE UOM,
RL.QUANTITY_SHIPPED,
POL.UNIT_PRICE,
(SUM(PLL.QUANTITY)*POL.UNIT_PRICE)Amount,
POH.CURRENCY_CODE,
 POH.SEGMENT1 PO_NO,
 POH.CREATION_DATE,
 LC.PROFORMA_INVOICE_NUM PI_NO,
 LC.PROFORMA_INVOICE_DATE PI_Date,
 pol.Attribute2 origin,
 --DECODE(RH.ATTRIBUTE_CATEGORY,'Billet Receiving',RH.ATTRIBUTE14,NULL) ORIGIN,
 POH.Revision_num PO_AMEND_NO,
 LC.HS_CODE,
 GRN_QTY PORT_QTY,
 DEL_QTY FAC_QTY,
 DEL_DT Delivery_DT,
 SHA.ATTRIBUTE1 LSD,
        SHA.ATTRIBUTE2 EXP1,
        SHA.ATTRIBUTE3 ETD,
        SHA.ATTRIBUTE4 ETA,
        SHA.ATTRIBUTE5 NON_ND,
        SHA.ATTRIBUTE6 ORG_DOC_DT,
        SHA.ATTRIBUTE7 Duty_DT,
        SHA.ATTRIBUTE8 LCA_NO,
        SHA.ATTRIBUTE9 Cover_Note,
        SHA.ATTRIBUTE10 Cover_DT,
        SHA.ATTRIBUTE11 BL_NO,
        SHA.ATTRIBUTE12 BL_DT,
        SHA.ATTRIBUTE13 Courier_NO,
        SHA.ATTRIBUTE14 BE_NO,
        SHA.ATTRIBUTE15 BE_DT ,   
DECODE(LC.LC_STATUS,'O','Open','C','Closed') LC_STATUS
FROM PO_HEADERS_ALL POH,
PO_LINES_ALL POL,
INL_SHIP_HEADERS_ALL SHA,
INL_ADJ_SHIP_LINES_V SLA,
RCV_SHIPMENT_HEADERS RH,
RCV_SHIPMENT_LINES RL,
xx_lc_details LC,
PO_LINE_LOCATIONS_ALL PLL,
ORG_ORGANIZATION_DEFINITIONS ORG,
XX_IND_PAY_V IND
WHERE POH.PO_HEADER_ID=POL.PO_HEADER_ID
AND SHA.SHIP_HEADER_ID=SLA.SHIP_HEADER_ID
AND SLA.INVENTORY_ITEM_ID=POL.ITEM_ID
AND PLL.LINE_LOCATION_ID=IND.PO_LINE_LOCATION_ID
AND POL.PO_LINE_ID=PLL.PO_LINE_ID
AND SHIP_LINE_SOURCE_ID=PLL.LINE_LOCATION_ID
AND RH.SHIPMENT_HEADER_ID=IND.SHIPMENT_HEADER_ID
AND RL.SHIPMENT_LINE_ID=IND.SHIPMENT_LINE_ID
AND POH.PO_HEADER_ID=LC.PO_HEADER_ID
AND POH.ORG_ID =ORG.ORGANIZATION_ID
AND POH.ORG_ID =SHA.ORG_ID
AND POH.type_lookup_code IN ('BLANKET','STANDARD')
AND NVL (UPPER (POH.authorization_status), 'INCOMPLETE') = 'APPROVED'
AND POH.ORG_ID=NVL(:P_ORG,POH.ORG_ID)
--AND LC.LC_ID BETWEEN NVL(:P_LC,LC.LC_ID) And NVL(:P_LC,LC.LC_ID)
AND TRUNC(LC.LC_OPENING_DATE) BETWEEN  nvl(:P_FR_DT, TRUNC(LC.LC_OPENING_DATE)) AND NVL(:P_TO_DT, TRUNC(LC.LC_OPENING_DATE))
GROUP BY
POH.SEGMENT1,LC.LC_NUMBER,
LC.HS_CODE,
SHA.ATTRIBUTE1,
SHA.ATTRIBUTE2,
SHA.ATTRIBUTE3,
SHA.ATTRIBUTE4 ,
SHA.ATTRIBUTE5, 
SHA.ATTRIBUTE6, 
SHA.ATTRIBUTE7,
SHA.ATTRIBUTE8,
SHA.ATTRIBUTE9 ,
SHA.ATTRIBUTE10 ,
SHA.ATTRIBUTE11 ,
SHA.ATTRIBUTE12,
SHA.ATTRIBUTE13,
SHA.ATTRIBUTE14,
SHA.ATTRIBUTE15,
LC.LC_OPENING_DATE,
POL.UNIT_PRICE,
LC.Bank_name,
DEL_DT,
ORG.Organization_code,
RL.QUANTITY_SHIPPED,
RH.SHIPMENT_NUM,
LC.LC_STATUS,
(LC.Supplier_Name||' ( '||    LC.Supplier_Number||') '),
POL.UNIT_MEAS_LOOKUP_CODE,
POH.CREATION_DATE,
LC.PROFORMA_INVOICE_NUM,
(IND.GRN_DT-LC.LC_OPENING_DATE),
 POH.CURRENCY_CODE,
 POH.Revision_num,
 pol.Attribute2,
 GRN_QTY,
 DEL_QTY,
 PLL.QUANTITY,
 XX_FND_EMP_NAME(POH.CREATED_BY),
 POL.ITEM_DESCRIPTION,
 LC.PROFORMA_INVOICE_DATE
 order by 2 DESC
 
 --================================================
 --AKG LC PROVISIONS
 --===============================================
 
 SELECT SL,
       BAL_SEG,
       BANK_NAME,
       BRANCH_NAME,
       LC_NUMBER,
       TRX_TYPE,
       ACCOUNTING_DATE,
       VOUCHER,
       DECODE (EXPENSE_TYPE, 'Insurance Premium', AMOUNT, NULL) INSURANCE_PREMIUM,
       DECODE (EXPENSE_TYPE, 'Clearing Expence', AMOUNT, NULL) CLEARING_EXPENCE,
       DECODE (EXPENSE_TYPE, 'Carrying Charge', AMOUNT, NULL) CARRYING_CHARGE,
       DECODE (EXPENSE_TYPE, 'Clearing Expenses (Ex-Bond)', AMOUNT, NULL) CLEARING_EXPENSES_EX_BOND,
       DECODE (EXPENSE_TYPE, 'Acceptance Commission', AMOUNT, NULL) ACCEPTANCE_COMMISSION
  FROM XX_LC_PROVISIONS_V
 WHERE     ORG_ID = :P_ORG_ID
       AND (:P_COMPANY_FROM IS NULL OR BAL_SEG >= :P_COMPANY_FROM)
       AND (:P_COMPANY_TO IS NULL OR BAL_SEG <= :P_COMPANY_TO)
       AND (:P_LC_FROM IS NULL OR LC_ID >= :P_LC_FROM)
       AND (:P_LC_TO IS NULL OR LC_ID <= :P_LC_TO)
       AND (:P_DATE_FROM IS NULL OR TRUNC (ACCOUNTING_DATE) >= :P_DATE_FROM)
       AND (:P_DATE_TO IS NULL OR TRUNC (ACCOUNTING_DATE) <= :P_DATE_TO)
UNION ALL
  SELECT 3,
         BAL_SEG,
         BANK_NAME,
         BRANCH_NAME,
         LC_NUMBER,
         'Balance',
         NULL,
         NULL,
         SUM (
            CASE
               WHEN TRX_TYPE = 'Provision' AND EXPENSE_TYPE = 'Insurance Premium' THEN AMOUNT
               WHEN TRX_TYPE = 'Adjustment' AND EXPENSE_TYPE = 'Insurance Premium' THEN (0 - AMOUNT)
               ELSE NULL
            END)
            INSURANCE_PREMIUM,
         SUM (
            CASE
               WHEN TRX_TYPE = 'Provision' AND EXPENSE_TYPE = 'Clearing Expence' THEN AMOUNT
               WHEN TRX_TYPE = 'Adjustment' AND EXPENSE_TYPE = 'Clearing Expence' THEN (0 - AMOUNT)
               ELSE NULL
            END)
            CLEARING_EXPENCE,
         SUM (
            CASE
               WHEN TRX_TYPE = 'Provision' AND EXPENSE_TYPE = 'Carrying Charge' THEN AMOUNT
               WHEN TRX_TYPE = 'Adjustment' AND EXPENSE_TYPE = 'Carrying Charge' THEN (0 - AMOUNT)
               ELSE NULL
            END)
            CARRYING_CHARGE,
         SUM (
            CASE
               WHEN TRX_TYPE = 'Provision' AND EXPENSE_TYPE = 'Clearing Expenses (Ex-Bond)' THEN AMOUNT
               WHEN TRX_TYPE = 'Adjustment' AND EXPENSE_TYPE = 'Clearing Expenses (Ex-Bond)' THEN (0 - AMOUNT)
               ELSE NULL
            END)
            CLEARING_EXPENSES_EX_BOND,
         SUM (
            CASE
               WHEN TRX_TYPE = 'Provision' AND EXPENSE_TYPE = 'Acceptance Commission' THEN AMOUNT
               WHEN TRX_TYPE = 'Adjustment' AND EXPENSE_TYPE = 'Acceptance Commission' THEN (0 - AMOUNT)
               ELSE NULL
            END)
            ACCEPTANCE_COMMISSION
    FROM XXAKG_LC_PROVISIONS_V
   WHERE     ORG_ID = :P_ORG_ID
         AND (:P_COMPANY_FROM IS NULL OR BAL_SEG >= :P_COMPANY_FROM)
         AND (:P_COMPANY_TO IS NULL OR BAL_SEG <= :P_COMPANY_TO)
         AND (:P_LC_FROM IS NULL OR LC_ID >= :P_LC_FROM)
         AND (:P_LC_TO IS NULL OR LC_ID <= :P_LC_TO)
GROUP BY ORG_ID,
         BAL_SEG,
         BANK_NAME,
         BRANCH_NAME,
         LC_NUMBER
ORDER BY 1,
         2,
         3,
         4,
         SL