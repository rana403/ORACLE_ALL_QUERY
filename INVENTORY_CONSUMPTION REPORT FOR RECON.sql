
-- XXKSRM Consumption Report Date: 5-11-2021

SELECT X.PERIOD_CODE,X.LEDGER_ID, X.COMPANY_NAME, X.COMPANY,X.OPERATING_UNIT,OPERATING_UNIT||'-'||SUBSTR(GET_OU_NAME_FROM_ID(X.OPERATING_UNIT),5,70),  X.COST_CENTER, 
X.ORGANIZATION_CODE,X.MEJOR_FIN_CAT,X.FIN_CAT,X.ORGANIZATION_ID,--X.TRANSACTION_ID,
X.INVENTORY_ITEM_ID,X.ITEM_CODE,X.ITEM_DESC, X.UOM, X.EVENT_TYPE_CODE,X.TRANSACTION_TYPE_ID,
X.TRANSACTION_TYPE_NAME,X.ACCOUNT_NAME,X.SUB_ACCOUNT,X.OP_QTY, X.OP_VAL,
SUM(X.RCV_QTY) RCV_QTY, SUM(X.RCV_VAL) RCV_VAL, (SUM(X.ISSUE_QTY))*-1 ISSUE_QTY, (SUM(X.ISSUE_VAL))* -1 ISSUE_VAL, (SUM(X.TRANS_QTY))*-1  TRANS_QTY,
ABS( (SUM(X.TRANS_VAL))*-1 / NULLIF( (SUM(X.ISSUE_QTY)),0)) RATE,
  (SUM(X.TRANS_VAL))*-1 TRANS_VAL,
X.JE_CATEGORY_NAME,X.ACCOUNTING_CLASS_CODE, SUM(X.DR) DR, SUM(X.CR) CR ,X.ACCOUNTING_CODE
FROM
(
SELECT INV_TRANS.PERIOD_CODE,INV_TRANS.LEDGER_ID, INV_TRANS.COMPANY_NAME, INV_TRANS.COMPANY, INV_TRANS.OPERATING_UNIT, INV_TRANS.COST_CENTER, 
INV_TRANS.ORGANIZATION_CODE,FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.ORGANIZATION_ID,--INV_TRANS.TRANSACTION_ID,
INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,INV_TRANS.ITEM_DESC, INV_TRANS.UOM, INV_TRANS.EVENT_TYPE_CODE,INV_TRANS.TRANSACTION_TYPE_ID,
CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.EVENT_TYPE_CODE ELSE INV_TRANS.TRANSACTION_TYPE_NAME END TRANSACTION_TYPE_NAME,
INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,
0 OP_QTY, 0 OP_VAL,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (17,12,44,18,61,1002,1003) THEN INV_TRANS.TRANSACTION_QUANTITY ELSE 0 END) RCV_QTY,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (17,18,1002,1003) THEN INV_TRANS.TRANSACTION_VALUE
WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (44) THEN INV_TRANS.TRANSACTION_VALUE -----INV_TRANS.ACCOUNTED_DR
WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (61) THEN INV_TRANS.ACCOUNTED_DR
WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (12) THEN INV_TRANS.ACCOUNTED_DR
WHEN NVL(INV_TRANS.TRANSACTION_TYPE_ID,11111)=11111 AND EVENT_TYPE_CODE = 'GLCOSTALOC' THEN INV_TRANS.TRANSACTION_VALUE
WHEN NVL(INV_TRANS.TRANSACTION_TYPE_ID,2222)=2222 AND EVENT_TYPE_CODE = 'LC_ADJUST_VALUATION' THEN INV_TRANS.TRANSACTION_VALUE
WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.TRANSACTION_VALUE ELSE 0 END) RCV_VAL,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (106,63,200,261,101,103,104,107,111,120,140,240,32) THEN INV_TRANS.TRANSACTION_QUANTITY ELSE 0 END) ISSUE_QTY,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (106,63,200,261,101,103,104,107,111,120,140,240,32) THEN INV_TRANS.TRANSACTION_VALUE ELSE 0 END) ISSUE_VAL,
SUM(NVL(INV_TRANS.TRANSACTION_QUANTITY,0)) TRANS_QTY,
SUM(NVL(INV_TRANS.TRANSACTION_VALUE,0)) TRANS_VAL,
INV_TRANS.JE_CATEGORY_NAME,INV_TRANS.ACCOUNTING_CLASS_CODE,
SUM(INV_TRANS.ACCOUNTED_DR) DR,SUM(INV_TRANS.ACCOUNTED_CR) CR ,INV_TRANS.ACCOUNTING_CODE
FROM
(
SELECT TO_CHAR(TRANSACTION_DATE,'MON-YY') PERIOD_CODE, A.LEDGER_ID, (SELECT DISTINCT BAL_SEG_NAME FROM XX_INV_ORG_VW WHERE LEDGER_ID=A.LEDGER_ID) COMPANY_NAME,
C.ORGANIZATION_CODE,A.ORGANIZATION_ID,A.OPERATING_UNIT,
XX_GET_ACCT_FLEX_SEG_DESC (1, F.SEGMENT1) COMPANY,
--XX_GET_ACCT_FLEX_SEG_DESC (2, F.SEGMENT2) OPERATING_UNIT,
XX_GET_ACCT_FLEX_SEG_DESC (3, F.SEGMENT3) COST_CENTER,
--(SELECT DISTINCT XX_GET_ACCT_FLEX_SEG_DESC (3, SEGMENT3) COST_CENTER FROM GL_CODE_COMBINATIONS_KFV WHERE CODE_COMBINATION_ID=E.CODE_COMBINATION_ID) COST_CENTER,
A.INVENTORY_ITEM_ID,B.SEGMENT1||'|'||B.SEGMENT2||'|'||B.SEGMENT3||'|'||B.SEGMENT4 ITEM_CODE,
(SELECT DESCRIPTION FROM MTL_SYSTEM_ITEMS_B WHERE INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND ORGANIZATION_ID=A.ORGANIZATION_ID) ITEM_DESC,
(SELECT PRIMARY_UOM_CODE FROM MTL_SYSTEM_ITEMS_B WHERE INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND ORGANIZATION_ID=A.ORGANIZATION_ID) UOM,
A.EVENT_CLASS_CODE,A.EVENT_TYPE_CODE, -- a.transaction_id,
G.TRANSACTION_TYPE_ID,G.TRANSACTION_TYPE_NAME,
D.JE_CATEGORY_NAME,E.ACCOUNTING_CLASS_CODE,D.AE_HEADER_ID,XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (E.CODE_COMBINATION_ID) ACCOUNT_NAME,
XX_AP_PKG.GET_SUB_ACCOUNT_DESC_FROM_CCID(TO_NUMBER(E.CODE_COMBINATION_ID)) SUB_ACCOUNT,
TRANSACTION_QUANTITY,TRANSACTION_VALUE,E.ACCOUNTED_DR,E.ACCOUNTED_CR ,F.CONCATENATED_SEGMENTS ACCOUNTING_CODE
FROM GMF_XLA_EXTRACT_HEADERS A,MTL_SYSTEM_ITEMS_B B,ORG_ORGANIZATION_DEFINITIONS C,XLA_AE_HEADERS D,XLA_AE_LINES E,GL_CODE_COMBINATIONS_KFV F,MTL_TRANSACTION_TYPES G
WHERE A.INVENTORY_ITEM_ID=B.INVENTORY_ITEM_ID(+) AND A.ORGANIZATION_ID=B.ORGANIZATION_ID(+) AND A.ORGANIZATION_ID=C.ORGANIZATION_ID AND A.TRANSACTION_TYPE_ID=G.TRANSACTION_TYPE_ID(+)
AND (NVL (e.ACCOUNTED_DR, 0)>0.49 or NVL (ACCOUNTED_CR, 0)>0.49 ) 
AND A.EVENT_ID=D.EVENT_ID AND D.AE_HEADER_ID=E.AE_HEADER_ID AND E.CODE_COMBINATION_ID=F.CODE_COMBINATION_ID
AND TO_CHAR(TRANSACTION_DATE,'MON-YY')=:P_PERIOD_CODE
and A.OPERATING_UNIT= NVL(:P_OPERATING_UNIT,A.OPERATING_UNIT)
AND A.LEDGER_ID=:P_LEDGER_ID AND A.ORGANIZATION_ID=NVL(:P_ORGANIZATION_ID,A.ORGANIZATION_ID) AND A.INVENTORY_ITEM_ID=NVL(:P_INVENTORY_ITEM_ID,A.INVENTORY_ITEM_ID)
and A.EVENT_TYPE_CODE <> 'CERT'
) INV_TRANS
LEFT OUTER JOIN (SELECT MIC.INVENTORY_ITEM_ID,MIC.ORGANIZATION_ID,MC.SEGMENT1 MEJOR_FIN_CAT,MC.SEGMENT1||'|'||MC.SEGMENT2 FIN_CAT
FROM MTL_ITEM_CATEGORIES MIC,MTL_CATEGORIES MC WHERE MIC.CATEGORY_ID=MC.CATEGORY_ID AND STRUCTURE_ID=50408) FIN_CAT
ON FIN_CAT.INVENTORY_ITEM_ID=INV_TRANS.INVENTORY_ITEM_ID AND FIN_CAT.ORGANIZATION_ID=INV_TRANS.ORGANIZATION_ID AND FIN_CAT.MEJOR_FIN_CAT= NVL(:P_MEJOR_FIN_CAT,FIN_CAT.MEJOR_FIN_CAT)
GROUP BY PERIOD_CODE,FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.LEDGER_ID, INV_TRANS.COMPANY_NAME,INV_TRANS.ORGANIZATION_CODE,INV_TRANS.ORGANIZATION_ID,--INV_TRANS.TRANSACTION_ID,
INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,INV_TRANS.ITEM_DESC, INV_TRANS.UOM,
INV_TRANS.EVENT_TYPE_CODE,INV_TRANS.TRANSACTION_TYPE_NAME,INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,INV_TRANS.ACCOUNTING_CODE,
INV_TRANS.TRANSACTION_TYPE_ID,INV_TRANS.JE_CATEGORY_NAME,INV_TRANS.ACCOUNTING_CLASS_CODE, COMPANY, OPERATING_UNIT, COST_CENTER
/*UNION ALL
SELECT IPB.ORGANIZATION_CODE,MC.SEGMENT1 MEJOR_FIN_CAT,MC.SEGMENT1||'|'||MC.SEGMENT2 FIN_CAT,IPB.ORGANIZATION_ID,IPB.INVENTORY_ITEM_ID,
IPB.ITEM_CODE,NULL,NULL,'OPENING VALUE' TRANSACTION_TYPE_NAME,NULL ACCOUNT_NAME,NULL SUB_ACCOUNT,IPB.OP_QTY OP_QTY,IPB.OP_VAL,
0 RCV_QTY,0 RCV_VAL,NULL ISSUE_QTY,NULL ISSUE_VAL,NULL TRANS_QTY,NULL TRANS_VAL,NULL,NULL,NULL DR,NULL CR , NULL ACCOUNTING_CODE
FROM XXINV_PERIOD_BALANCE IPB,MTL_ITEM_CATEGORIES MIC,MTL_CATEGORIES MC, ORG_ORGANIZATION_DEFINITIONS OOD
WHERE MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MIC.INVENTORY_ITEM_ID=IPB.INVENTORY_ITEM_ID AND MIC.ORGANIZATION_ID=IPB.ORGANIZATION_ID
AND MIC.ORGANIZATION_ID=OOD.ORGANIZATION_ID AND STRUCTURE_ID=50408
AND IPB.PERIOD_CODE=:P_PERIOD_CODE AND SET_OF_BOOKS_ID=:P_LEDGER_ID*/
ORDER BY ORGANIZATION_ID,INVENTORY_ITEM_ID --,CASE WHEN TRANSACTION_TYPE_NAME = 'OPENING VALUE' THEN 1 ELSE 2 END ---,ae_header_id
) X
WHERE (ACCOUNT_NAME IN ('Finished Goods','Raw Materials')
OR ACCOUNT_NAME LIKE ('Stores%Spares')
OR ACCOUNT_NAME LIKE ('Fuel%Lubricants')
OR ACCOUNT_NAME LIKE ('Bi Product%Wastage')
OR ACCOUNT_NAME LIKE ('Bi Product%Wastage')
)
AND ACCOUNTING_CLASS_CODE  IN ('INVENTORY_VALUATION')
AND EVENT_TYPE_CODE IN ('MOVE_ORDER_ISSUE','MISC_RECEIPT','MISC_ISSUE')
AND X.COST_CENTER = NVL(:P_COST_CENTER, X.COST_CENTER)
AND X.TRANSACTION_TYPE_ID NOT IN (42)
--AND to_date('01-'||period_code) BETWEEN '01-SEP-18' AND '30-SEP-18'
--and to_char(INV_TRANS.transaction_date,'MON-YY')=:P_PERIOD_CODE
GROUP BY X.PERIOD_CODE,X.LEDGER_ID, X.COMPANY_NAME, X.ORGANIZATION_CODE,X.MEJOR_FIN_CAT,X.FIN_CAT,X.ORGANIZATION_ID,--X.TRANSACTION_ID,
X.INVENTORY_ITEM_ID,X.ITEM_CODE,X.ITEM_DESC, X.UOM, X.EVENT_TYPE_CODE,X.TRANSACTION_TYPE_ID,
X.TRANSACTION_TYPE_NAME,X.ACCOUNT_NAME,X.SUB_ACCOUNT,X.OP_QTY, X.OP_VAL,
X.JE_CATEGORY_NAME,X.ACCOUNTING_CLASS_CODE, X.ACCOUNTING_CODE,X.COMPANY, X.OPERATING_UNIT, X.COST_CENTER


--================================ INV TRANS============================

--(

SELECT TO_CHAR(TRANSACTION_DATE,'MON-YY') PERIOD_CODE, A.LEDGER_ID, (SELECT DISTINCT BAL_SEG_NAME FROM XX_INV_ORG_VW WHERE LEDGER_ID=A.LEDGER_ID) COMPANY_NAME,
C.ORGANIZATION_CODE,A.ORGANIZATION_ID,A.OPERATING_UNIT,
XX_GET_ACCT_FLEX_SEG_DESC (1, F.SEGMENT1) COMPANY,
--XX_GET_ACCT_FLEX_SEG_DESC (2, F.SEGMENT2) OPERATING_UNIT,
XX_GET_ACCT_FLEX_SEG_DESC (3, F.SEGMENT3) COST_CENTER,
--(SELECT DISTINCT XX_GET_ACCT_FLEX_SEG_DESC (3, SEGMENT3) COST_CENTER FROM GL_CODE_COMBINATIONS_KFV WHERE CODE_COMBINATION_ID=E.CODE_COMBINATION_ID) COST_CENTER,
A.INVENTORY_ITEM_ID,B.SEGMENT1||'|'||B.SEGMENT2||'|'||B.SEGMENT3||'|'||B.SEGMENT4 ITEM_CODE,
(SELECT DESCRIPTION FROM MTL_SYSTEM_ITEMS_B WHERE INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND ORGANIZATION_ID=A.ORGANIZATION_ID) ITEM_DESC,
(SELECT PRIMARY_UOM_CODE FROM MTL_SYSTEM_ITEMS_B WHERE INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID AND ORGANIZATION_ID=A.ORGANIZATION_ID) UOM,
A.EVENT_CLASS_CODE,A.EVENT_TYPE_CODE, a.transaction_id,
G.TRANSACTION_TYPE_ID,G.TRANSACTION_TYPE_NAME,
D.JE_CATEGORY_NAME,E.ACCOUNTING_CLASS_CODE,D.AE_HEADER_ID,XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (E.CODE_COMBINATION_ID) ACCOUNT_NAME,
XX_AP_PKG.GET_SUB_ACCOUNT_DESC_FROM_CCID(TO_NUMBER(E.CODE_COMBINATION_ID)) SUB_ACCOUNT,
TRANSACTION_QUANTITY,TRANSACTION_VALUE,E.ACCOUNTED_DR,E.ACCOUNTED_CR,F.CONCATENATED_SEGMENTS ACCOUNTING_CODE
FROM GMF_XLA_EXTRACT_HEADERS A,MTL_SYSTEM_ITEMS_B B,ORG_ORGANIZATION_DEFINITIONS C,XLA_AE_HEADERS D,XLA_AE_LINES E,GL_CODE_COMBINATIONS_KFV F,MTL_TRANSACTION_TYPES G
WHERE A.INVENTORY_ITEM_ID=B.INVENTORY_ITEM_ID(+) AND A.ORGANIZATION_ID=B.ORGANIZATION_ID(+) AND A.ORGANIZATION_ID=C.ORGANIZATION_ID AND A.TRANSACTION_TYPE_ID=G.TRANSACTION_TYPE_ID(+)
AND (NVL (e.ACCOUNTED_DR, 0)>0.49 or NVL (ACCOUNTED_CR, 0)>0.49 ) 
AND A.EVENT_ID=D.EVENT_ID AND D.AE_HEADER_ID=E.AE_HEADER_ID AND E.CODE_COMBINATION_ID=F.CODE_COMBINATION_ID
AND TO_CHAR(TRANSACTION_DATE,'MON-YY')=:P_PERIOD_CODE
and A.OPERATING_UNIT= NVL(:P_OPERATING_UNIT,A.OPERATING_UNIT)
AND A.LEDGER_ID=:P_LEDGER_ID AND A.ORGANIZATION_ID=NVL(:P_ORGANIZATION_ID,A.ORGANIZATION_ID) AND A.INVENTORY_ITEM_ID=NVL(:P_INVENTORY_ITEM_ID,A.INVENTORY_ITEM_ID)
--and A.EVENT_TYPE_CODE <> 'CERT'
--) INV_TRANS


--=================================  INV TRANS FROM DRAFT======================================

(

SELECT to_char(transaction_date,'MON-YY') PERIOD_CODE, 
(CASE when a.transaction_type_id IN (18,36) then NVL(( Select rsh.RECEIPT_NUM  from rcv_shipment_headers rsh , rcv_shipment_lines rsl,rcv_transactions rt,mtl_material_transactions mmt
where rsh.shipment_header_id=rsl.shipment_header_id
and rsl.shipment_header_id=rt.shipment_header_id
and rsl.SHIPMENT_LINE_ID=rt.SHIPMENT_LINE_ID
and rt.transaction_id=mmt.RCV_TRANSACTION_ID
--and rt.transaction_type='DELIVER'
and mmt.transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id=33 then 
NVL(( Select SHIPMENT_NUMBER  from mtl_material_transactions where 
transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id in (63,103,104,107,120,200,106) then 
NVL(( select MTRH.REQUEST_NUMBER from MTL_TXN_REQUEST_HEADERS MTRH,MTL_TXN_REQUEST_LINES MTRL,MTL_MATERIAL_TRANSACTIONS MMT
where MTRH.header_id=MTRL.header_id
and MTRL.LINE_ID=MMT.TRX_SOURCE_LINE_ID
and MMT.transaction_id=a.transaction_id
),0)
when a.transaction_type_id=62 and a.event_type_code='FOB_SHIP_SENDER_SHIP_NO_TP' then 
NVL(( Select SHIPMENT_NUMBER  from mtl_material_transactions where 
transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id=62 and a.event_type_code='FOB_SHIP_RECIPIENT_SHIP_NO_TP' then 
NVL(( Select rmv.RECEIPT_NUM  from rcv_msh_v rmv ,mtl_material_transactions mmt
where rmv.SHIPMENT_NUM=mmt.SHIPMENT_NUMBER
and mmt.transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id=21 and a.event_type_code='FOB_SHIP_SENDER_SHIP_NO_TP' then 
NVL(( Select SHIPMENT_NUMBER  from mtl_material_transactions where 
transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id=21 and a.event_type_code='FOB_SHIP_RECIPIENT_SHIP_NO_TP' then 
NVL(( Select rmv.RECEIPT_NUM  from rcv_msh_v rmv ,mtl_material_transactions mmt
where rmv.SHIPMENT_NUM=mmt.SHIPMENT_NUMBER
and mmt.transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id=62 and a.event_type_code='FOB_SHIP_RECIPIENT_SHIP_TP' then 
NVL(( Select rmv.RECEIPT_NUM  from rcv_msh_v rmv ,mtl_material_transactions mmt
where rmv.SHIPMENT_NUM=mmt.SHIPMENT_NUMBER
and mmt.transaction_Id=a.transaction_Id),0)
when a.transaction_type_id in (21,62) and a.event_type_code='FOB_SHIP_SENDER_SHIP_TP' then 
NVL(( Select SHIPMENT_NUMBER  from mtl_material_transactions where 
transaction_Id=a.transaction_Id
),0)
when a.transaction_type_id in (61,12) and a.event_type_code='FOB_SHIP_RECIPIENT_RCPT' then 
NVL(( Select rmv.RECEIPT_NUM  from rcv_msh_v rmv ,mtl_material_transactions mmt
where rmv.SHIPMENT_NUM=mmt.SHIPMENT_NUMBER
and mmt.transaction_Id=a.transaction_Id),0)
when a.transaction_type_id=10008 and a.event_type_code='COGS_RECOGNITION' then 
NVL(( Select TRANSACTION_SOURCE_NAME  from mtl_material_transactions where 
transaction_Id=a.transaction_Id
),0)
when  a.event_type_code IN ('RECEIVE','DELIVER_EXPENSE','RET_TO_VENDOR','LC_ADJUST_DELIVER','LC_ADJUST_RECEIVE','LC_ADJUST_VALUATION') then 
NVL((Select rsh.RECEIPT_NUM  from rcv_shipment_headers rsh , rcv_shipment_lines rsl,rcv_transactions rt
where rsh.shipment_header_id=rsl.shipment_header_id
and rsl.shipment_header_id=rt.shipment_header_id
and rsl.SHIPMENT_LINE_ID=rt.SHIPMENT_LINE_ID
--and rt.transaction_type='RECEIVE'
and a.SOURCE_LINE_ID=rt.transaction_Id
and a.ENTITY_CODE='PURCHASING'),0)
when a.transaction_type_id in(44,35,1002,1003,17,43) then 
NVL(( Select gbh.batch_no  from gme_batch_header gbh ,mtl_material_transactions mmt
where gbh.BATCH_ID=mmt.TRANSACTION_SOURCE_ID
and gbh.organization_id=mmt.organization_id
and mmt.transaction_Id=a.transaction_Id),0)
else NULL
end ) GRN, C.ORGANIZATION_CODE,A.ORGANIZATION_ID,A.LEDGER_ID, A.OPERATING_UNIT,a.TRANSACTION_ID TXN_ID,A.INVENTORY_ITEM_ID,B.SEGMENT1||'|'||B.SEGMENT2||'|'||B.SEGMENT3||'|'||B.SEGMENT4 ITEM_CODE,a.transaction_id,a.event_class_code,a.event_type_code,
g.transaction_type_id,g.transaction_type_name,
d.je_category_name,d.AE_HEADER_ID XLA_HEADER_ID,e.accounting_class_code,d.ae_header_id,XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (e.CODE_COMBINATION_ID) ACCOUNT_NAME,XX_AP_PKG.GET_SUB_ACCOUNT_DESC_FROM_CCID(TO_NUMBER(e.CODE_COMBINATION_ID)) SUB_ACCOUNT,
TRANSACTION_QUANTITY, PRIMARY_UOM_CODE, TRANSACTION_VALUE,SUM(NVL(e.accounted_dr,0))accounted_dr ,SUM(NVL(e.accounted_cr,0))accounted_cr ,f.concatenated_segments accounting_code
FROM GMF_XLA_EXTRACT_HEADERS a,mtl_system_items_b b,org_organization_definitions c,xla_ae_headers d,xla_ae_lines e,gl_code_combinations_kfv f,mtl_transaction_types g
WHERE 1= 1 --a.transaction_id=
--and a.transaction_id IN (11049268)  -- 5759855 -- 5647504
and a.inventory_item_id=b.inventory_item_id(+) and a.organization_id=b.organization_id(+) and A.organization_id=c.organization_id  and a.transaction_type_id=g.transaction_type_id(+)
and a.event_id=d.event_id and d.ae_header_id=e.ae_header_id and e.code_combination_id=f.code_combination_id
AND (NVL (e.ACCOUNTED_DR, 0)>0.49 or NVL (e.ACCOUNTED_CR, 0)>0.49 )   -- Added  for Transaction id  4911717,4911442,4911409,4911720 , 4878396,4906916  qty shows double
and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE and a.ledger_id=:P_LEDGER_ID
and A.INVENTORY_ITEM_ID = 70
group by 
--------------- 
transaction_date,
a.event_type_code , C.ORGANIZATION_CODE,A.ORGANIZATION_ID,A.LEDGER_ID, A.OPERATING_UNIT,a.TRANSACTION_ID ,A.INVENTORY_ITEM_ID,B.SEGMENT1||'|'||B.SEGMENT2||'|'||B.SEGMENT3||'|'||B.SEGMENT4 ,a.transaction_id,a.event_class_code,a.event_type_code,
g.transaction_type_id,g.transaction_type_name,a.transaction_type_id,
d.je_category_name,d.AE_HEADER_ID ,e.accounting_class_code,d.ae_header_id,XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (e.CODE_COMBINATION_ID) ,XX_AP_PKG.GET_SUB_ACCOUNT_DESC_FROM_CCID(TO_NUMBER(e.CODE_COMBINATION_ID)) ,
TRANSACTION_QUANTITY, PRIMARY_UOM_CODE, TRANSACTION_VALUE ,f.concatenated_segments , a.SOURCE_LINE_ID, a.ENTITY_CODE

) INV_TRANS 