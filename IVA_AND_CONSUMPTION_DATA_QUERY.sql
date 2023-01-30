
--- IVA DATA 
--===================

select to_char(transaction_date,'MON-YY') PERIOD,SET_OF_BOOKS_ID LEDGER_ID,ORGANIZATION_NAME ORG_NAME,ORGANIZATION_CODE, REQUEST_NUMBER,
f.CONCATENATED_SEGMENTS ITEM_CODE,d.ORGANIZATION_ID ORG_ID, OPERATING_UNIT OU, a.TRANSACTION_TYPE_ID TRN_TYPE_ID, --b.CREATED_BY, 
 XX_GET_EMP_NAME_FROM_USER_ID (B.CREATED_BY) CREATED_BY, TRANSACTION_TYPE_NAME TRN_TYPE_NAME,
XX_GET_ACCT_FLEX_SEG_DESC(4,c.SEGMENT4) ACCOUNT_DESC,a.DESCRIPTION,TRANSACTION_ID TRN_ID,b.INVENTORY_ITEM_ID INV_ITEM_ID,
CODE_COMBINATION_ID CCID,c.CONCATENATED_SEGMENTS GL_CODE      
from mtl_transaction_types a, MTL_MATERIAL_TRANSACTIONS b, gl_code_combinations_kfv c, org_organization_definitions d, MTL_TXN_REQUEST_HEADERS e , mtl_system_items_kfv f
WHERE -- a.transaction_id=46678 and 
a.transaction_type_id=b.transaction_type_id 
AND b.INVENTORY_ITEM_ID=f.INVENTORY_ITEM_ID
AND d.ORGANIZATION_ID=f.ORGANIZATION_ID
 AND b.transaction_source_id= e.header_id(+)
and b.DISTRIBUTION_ACCOUNT_ID=c.code_combination_id
and b.ORGANIZATION_ID=d.ORGANIZATION_ID
and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE 
--and transaction_date between '01-SEP-2019' and '30-SEP-2019'
and SET_OF_BOOKS_ID=:P_LEDGER_ID
--AND OPERATING_UNIT=:P_OPERATING_UNIT
--AND c.SEGMENT2 <>:P_SEGMENT2  -- FOR WRONG  GL WITHOUT IVA
-- FOR WRONG  GL WITH IVA
AND TRANSACTION_TYPE_NAME in ('Issue Return','Move Order FG Issue','Move Order Issue','Move Order Issue of FL','Move Order Issue from HO Store Branding','Move Order Issue from HO Store Stationary','Move Order Issue from HO Vehicle Repair','Move Order Issue To Project','Miscellaneous issue','Miscellaneous receipt')
--and c.SEGMENT4 in (2010101,2010102,2010103,2010104,2010105)    
AND c.segment4 in(2010101,2010102,2010103,2010104,2010105, -- INVENTORY ACCOUNT
1010101,  -- ASSET ACCOUNT
1010102,1010103,1010104,1010105,1010106,1010107,1010108,1010109,1010110,1010111,1010112,1010113,1010114,
5020114, -- MISCLINIUS INCOME
5020109
--1030101,-- 
--6010206,
--6010217,
--6010203
)

--=================================================

--- CONSUMPTION DATA
select to_char(transaction_date,'MON-YY') PERIOD,SET_OF_BOOKS_ID LEDGER_ID,ORGANIZATION_NAME ORG_NAME,ORGANIZATION_CODE Org_Code, REQUEST_NUMBER,
f.CONCATENATED_SEGMENTS ITEM_CODE,d.ORGANIZATION_ID ORG_ID, OPERATING_UNIT OU, a.TRANSACTION_TYPE_ID TRN_TYPE_ID, --b.CREATED_BY, 
 XX_GET_EMP_NAME_FROM_USER_ID (B.CREATED_BY) CREATED_BY, TRANSACTION_TYPE_NAME TRN_TYPE_NAME,
XX_GET_ACCT_FLEX_SEG_DESC(4,c.SEGMENT4) ACCOUNT_DESC,a.DESCRIPTION,TRANSACTION_ID TRN_ID,b.INVENTORY_ITEM_ID INV_ITEM_ID,
CODE_COMBINATION_ID CCID,c.CONCATENATED_SEGMENTS GL_CODE      
from mtl_transaction_types a, MTL_MATERIAL_TRANSACTIONS b, gl_code_combinations_kfv c, org_organization_definitions d, MTL_TXN_REQUEST_HEADERS e , mtl_system_items_kfv f
WHERE -- a.transaction_id=46678 and 
a.transaction_type_id=b.transaction_type_id 
AND b.INVENTORY_ITEM_ID=f.INVENTORY_ITEM_ID
AND d.ORGANIZATION_ID=f.ORGANIZATION_ID
 AND b.transaction_source_id= e.header_id(+)
and b.DISTRIBUTION_ACCOUNT_ID=c.code_combination_id
and b.ORGANIZATION_ID=d.ORGANIZATION_ID
and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE 
--and transaction_date between '01-SEP-2019' and '30-SEP-2019'
and SET_OF_BOOKS_ID=:P_LEDGER_ID
--AND OPERATING_UNIT=:P_OPERATING_UNIT
--AND c.SEGMENT2 <>:P_SEGMENT2  -- FOR WRONG  GL WITHOUT IVA
-- FOR WRONG  GL WITH IVA
--AND TRANSACTION_TYPE_NAME in ('Issue Return','Move Order Issue','Move Order Issue of FL','Move Order Issue from HO Store Branding','Move Order Issue from HO Store Stationary','Move Order Issue from HO Vehicle Repair','Move Order Issue To Project','Miscellaneous issue','Miscellaneous receipt')
--and c.SEGMENT4 in (2010101,2010102,2010103,2010104,2010105)  
AND f.SEGMENT1 in ('FG', 'CV','BI','FA','CP','TR')  
AND c.segment4 in (6010203)