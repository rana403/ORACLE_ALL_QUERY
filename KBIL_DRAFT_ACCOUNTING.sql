--===============================================================
--THIS DRAFT IS ONLY FOR KBIL COZ one line is commented here line is bellow 

--AND (NVL (e.ACCOUNTED_DR, 0)>0.49 or NVL (e.ACCOUNTED_CR, 0)>0.49 ) 
--===============================================================


SELECT INV_TRANS.ORGANIZATION_CODE ORG, INV_TRANS.GRN,INV_TRANS.TXN_ID,INV_TRANS.XLA_HEADER_ID,FIN_CAT.MEJOR_FIN_CAT,INV_TRANS.ITEM_CODE,INV_TRANS.EVENT_TYPE_CODE, 
CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.EVENT_TYPE_CODE ELSE INV_TRANS.TRANSACTION_TYPE_NAME END  TRX_TYPE_NAME,
0 OP_QTY, 0 OP_VAL,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (17,12,44,18,61,1002,1003) THEN INV_TRANS.TRANSACTION_QUANTITY ELSE 0 END) RCV_QTY,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (17,18,1002,1003) THEN INV_TRANS.TRANSACTION_VALUE 
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (44) THEN INV_TRANS.TRANSACTION_VALUE -----INV_TRANS.ACCOUNTED_DR 
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (61)  THEN INV_TRANS.ACCOUNTED_DR
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (12)  THEN INV_TRANS.ACCOUNTED_DR 
                  WHEN NVL(INV_TRANS.TRANSACTION_TYPE_ID,11111)=11111  AND EVENT_TYPE_CODE = 'GLCOSTALOC' THEN INV_TRANS.TRANSACTION_VALUE    
                  WHEN NVL(INV_TRANS.TRANSACTION_TYPE_ID,2222)=2222  AND EVENT_TYPE_CODE = 'LC_ADJUST_VALUATION' THEN INV_TRANS.TRANSACTION_VALUE  
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.TRANSACTION_VALUE ELSE 0 END) RCV_VAL,
                  SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (32,35,36,42,43,15,21,63,101,103,104,106,107,111,120,10008,140,71,200,240,241,260,261,52) THEN INV_TRANS.TRANSACTION_QUANTITY
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,1) > 0 THEN 0 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,1) =  0 THEN 0 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_DR,0) >  0 THEN INV_TRANS.TRANSACTION_QUANTITY
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_CR,0) > 0 THEN INV_TRANS.TRANSACTION_QUANTITY
                  ELSE 0 END) ISSUE_QTY,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (32,35,36,42,43,21,63,101,103,104,106,107,111,120,10008,140,71,200,240,241,260,261,52) THEN INV_TRANS.TRANSACTION_VALUE 
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (15) THEN INV_TRANS.ACCOUNTED_DR   
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,0) > 0 THEN INV_TRANS.ACCOUNTED_DR
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,0) =  0 THEN INV_TRANS.TRANSACTION_VALUE 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_DR,0) >  0 THEN INV_TRANS.TRANSACTION_VALUE
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_CR,0) > 0 THEN INV_TRANS.TRANSACTION_VALUE
                  ELSE 0 END) ISSUE_VAL, 
                  SUM(nvl(INV_TRANS.TRANSACTION_QUANTITY,0)) TRANS_QTY, 
INV_TRANS.PRIMARY_UOM_CODE UOM, 
SUM(nvl(INV_TRANS.TRANSACTION_VALUE,0)) TRANS_VAL,
INV_TRANS.ACCOUNT_NAME,
INV_TRANS.SUB_ACCOUNT,
INV_TRANS.je_category_name,
INV_TRANS.accounting_class_code,
SUM(INV_TRANS.ACCOUNTED_DR) DR,SUM(INV_TRANS.ACCOUNTED_CR) CR ,
INV_TRANS.ACCOUNTING_CODE,
FIN_CAT.FIN_CAT,
INV_TRANS.ORGANIZATION_ID ORG_ID,INV_TRANS.LEDGER_ID LE_ID, INV_TRANS.OPERATING_UNIT OU, INV_TRANS.INVENTORY_ITEM_ID ITEM_ID,
INV_TRANS.TRANSACTION_TYPE_ID TRX_TYPE_ID
FROM
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
--and a.transaction_id IN (10830084,11079515,11079428) -- 5759855 -- 5647504
and a.inventory_item_id=b.inventory_item_id(+) and a.organization_id=b.organization_id(+) and A.organization_id=c.organization_id  and a.transaction_type_id=g.transaction_type_id(+)
and a.event_id=d.event_id and d.ae_header_id=e.ae_header_id and e.code_combination_id=f.code_combination_id
--AND (NVL (e.ACCOUNTED_DR, 0)>0.49 or NVL (e.ACCOUNTED_CR, 0)>0.49 )   -- Added  for Transaction id  4911717,4911442,4911409,4911720 , 4878396,4906916  qty shows double
and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE and a.ledger_id=:P_LEDGER_ID
group by 
---------------------------------------------------------------------------------------------------------------------------------------------------  
transaction_date,
a.event_type_code , C.ORGANIZATION_CODE,A.ORGANIZATION_ID,A.LEDGER_ID, A.OPERATING_UNIT,a.TRANSACTION_ID ,A.INVENTORY_ITEM_ID,B.SEGMENT1||'|'||B.SEGMENT2||'|'||B.SEGMENT3||'|'||B.SEGMENT4 ,a.transaction_id,a.event_class_code,a.event_type_code,
g.transaction_type_id,g.transaction_type_name,a.transaction_type_id,
d.je_category_name,d.AE_HEADER_ID ,e.accounting_class_code,d.ae_header_id,XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (e.CODE_COMBINATION_ID) ,XX_AP_PKG.GET_SUB_ACCOUNT_DESC_FROM_CCID(TO_NUMBER(e.CODE_COMBINATION_ID)) ,
TRANSACTION_QUANTITY, PRIMARY_UOM_CODE, TRANSACTION_VALUE ,f.concatenated_segments , a.SOURCE_LINE_ID, a.ENTITY_CODE
) INV_TRANS 
LEFT OUTER JOIN  (SELECT  MIC.INVENTORY_ITEM_ID,MIC.ORGANIZATION_ID,MC.SEGMENT1 MEJOR_FIN_CAT,MC.SEGMENT1||'|'||MC.SEGMENT2 FIN_CAT 
                                       FROM MTL_ITEM_CATEGORIES MIC,MTL_CATEGORIES MC WHERE  MIC.CATEGORY_ID=MC.CATEGORY_ID  AND STRUCTURE_ID=50408) FIN_CAT 
                                                ON FIN_CAT.INVENTORY_ITEM_ID=INV_TRANS.INVENTORY_ITEM_ID AND  FIN_CAT.ORGANIZATION_ID=INV_TRANS.ORGANIZATION_ID
GROUP BY INV_TRANS.PRIMARY_UOM_CODE,GRN,INV_TRANS.TXN_ID,INV_TRANS.XLA_HEADER_ID,FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.ORGANIZATION_CODE,INV_TRANS.LEDGER_ID, INV_TRANS.OPERATING_UNIT,INV_TRANS.ORGANIZATION_ID,INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,INV_TRANS.EVENT_TYPE_CODE,
INV_TRANS.TRANSACTION_TYPE_NAME,INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,INV_TRANS.ACCOUNTING_CODE,INV_TRANS.TRANSACTION_TYPE_ID,INV_TRANS.je_category_name,INV_TRANS.accounting_class_code

