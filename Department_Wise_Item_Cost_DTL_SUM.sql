--=============================================================================================
/*XXKSRM Department Wise Item Cost Details Report    AFTER PERIOD CLOSING*/

SELECT OU_NAME, 
OU_ADD,IO_NAME,DEPARTMENT,MO_NUMBER,ITEM_CODE,ITEM_ID,ITEM_DESC,UOM,
ITEM_TYPE,PDATE_FROM,PDATE_TO,SUM(ISSUE_QUANTITY) ISSUE_QUANTITY,SUM(RECEIVE_QTY) RECEIVE_QTY,
--PREPARED_BY CREATED_BY,
--COST_PER_UNIT
SUM(ISSUE_QTY) ISSUE_QTY,SUM(MO_QTY) MO_QUANTITY,AVG(RATE) UNIT_PRICE,
DECODE(GET_RATE_FROM_ITEM_ID(ITEM_ID),1,0,0,0,NULL,0,GET_RATE_FROM_ITEM_ID(ITEM_ID)) FOREIGN_RATE,
sum (NVL(AMOUNT,0)) * SUM(NVL(ISSUE_QUANTITY,0)) * NVL(GET_RATE_FROM_ITEM_ID(ITEM_ID) ,1) TOTAL_AMOUNT,
NVL(SUM(ITEM_COST),0)*SUM(NVL(ISSUE_QUANTITY,0)) COST_AMOUNT
FROM 
(
SELECT
--GET_QTY_FROM_ITEM_ID(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID) COST_PER_UNIT,
 NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE),XX_GET_LIST_PRICE (WXMD.ITEM_ID)) ITEM_COST,
 GET_RATE_FROM_ITEM_ID(WXMD.ITEM_ID) FOREIGN_RATE,
WIOD.OPERATING_UNIT_NAME OU_NAME,
WIOD.INV_ORG_ADDRESS OU_ADD,
WIOD.INVENTORY_ORGANIZATION_NAME IO_NAME,
--(SELECT DISTINCT ATTRIBUTE5 FROM MTL_TXN_REQUEST_LINES_V WHERE REQUEST_NUMBER=MTRL.REQUEST_NUMBER AND  ATTRIBUTE5 IS NOT NULL) DEPARTMENT,
(SELECT DISTINCT ATTRIBUTE5 FROM MTL_TXN_REQUEST_LINES_V WHERE REQUEST_NUMBER=MTRL.REQUEST_NUMBER and (ATTRIBUTE5=:P_DEPT or :P_DEPT is null) AND  ATTRIBUTE5 IS NOT NULL) DEPARTMENT,
XX_GET_LIST_PRICE (WXMD.ITEM_ID) RATE,
WXMD.ITEM_ID ITEM_ID,
WXMD.ITEM_CODE,
WXMD.ITEM_DESC,
MTRL.UOM_CODE UOM,
MTRL.QUANTITY_DELIVERED ISSUE_QTY,
MTRL.QUANTITY MO_QTY,
WXMD.ITEM_TYPE,
XX_INV_PKG.XXGET_ENAME(MTRL.CREATED_BY )  PREPARED_BY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) RECEIVE_QTY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) ISSUE_QUANTITY, 
--GET_QTY_FROM_ITEM_ID(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID) * NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) AMOUNT,
-- NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE), (XX_GET_LIST_PRICE (WXMD.ITEM_ID)) * GET_RATE_FROM_ITEM_ID(WXMD.ITEM_ID))
--* NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) AMOUNT,
NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE),(XX_GET_LIST_PRICE (WXMD.ITEM_ID))) AMOUNT,
XXGET_ENAME_WITH_KG(MTRL.CREATED_BY) DEPT_USER, 
MTRL.REFERENCE REFERENCE,
MTRL.REQUEST_NUMBER MO_NUMBER,
MTRL.CREATION_DATE MO_DATE,
:P_TRANSACTION_DATE_FROM PDATE_FROM,
:P_TRANSACTION_DATE_TO  PDATE_TO
FROM  
MTL_MATERIAL_TRANSACTIONS MMT, 
MTL_TXN_REQUEST_LINES_V  MTRL,
WBI_XXKBGITEM_MT_D WXMD,
WBI_INV_ORG_DETAIL WIOD
WHERE wxmd.INVENTORY_ITEM_ID =MMT.INVENTORY_ITEM_ID
and WXMD.ORGANIZATION_ID= MMT.ORGANIZATION_ID
AND MTRL.LINE_ID (+) =MMT.MOVE_ORDER_LINE_ID
AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
 AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
AND WXMD.ORGANIZATION_ID=MTRL.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MTRL.INVENTORY_ITEM_ID
AND WIOD.INV_ORGANIZATION_ID=WXMD.ORGANIZATION_ID
AND WIOD.INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID 
AND REQUEST_NUMBER  LIKE '%-%'
AND MTRL.QUANTITY_DELIVERED IS NOT NULL
AND MTRL.ORGANIZATION_ID=NVL(:P_ORGANIZATION_ID,MTRL.ORGANIZATION_ID)
and WXMD.ITEM_ID = NVL(:P_ITEM_ID,WXMD.ITEM_ID)
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND WXMD.ITEM_TYPE=NVL(:P_ITEM_TYPE,WXMD.ITEM_TYPE)
AND WXMD.ITEM_GROUP=NVL(:P_ITEM_GROUP,WXMD.ITEM_GROUP)
AND WXMD.ITEM_SUB_GROUP=NVL(:P_ITEM_SUB_GROUP,WXMD.ITEM_SUB_GROUP)
AND NVL(MTRL.ATTRIBUTE2,'XX')=NVL(:P_USE_OF_AREA,NVL(MTRL.ATTRIBUTE2,'XX'))
)
WHERE 
DEPARTMENT IS NOT NULL
and department = NVL(:P_DEPT,department)
--and ITEM_ID = 35187   
--AND MO_DATE BETWEEN NVL(:P_TRANSACTION_DATE_FROM, MO_DATE)   AND NVL(:P_TRANSACTION_DATE_TO,MO_DATE) 
AND (:P_TRANSACTION_DATE_FROM IS null OR MO_DATE BETWEEN :P_TRANSACTION_DATE_FROM  AND :P_TRANSACTION_DATE_TO)
and ITEM_TYPE not in ('BY PRODUCTS', 'CO PRODUCTS', 'FINISHED GOODS', 'SEMI FINISHED GOODS')
and MO_NUMBER = NVL(:P_MO_NUMBER, MO_NUMBER)
GROUP BY ITEM_COST,OU_NAME, OU_ADD,IO_NAME,DEPARTMENT,ITEM_ID,ITEM_CODE,ITEM_DESC,UOM,ITEM_TYPE,PDATE_FROM,PDATE_TO,MO_NUMBER,PREPARED_BY
ORDER BY MO_NUMBER

--===================================================================================================

-- /*  Department Wise Item Cost Report (SUMMARY) BEFORE PERIOD CLOSING  */
SELECT DEPARTMENT, COUNT(MO_NUMBER),SUM(TOTAL_AMOUNT) , SUM(ITEM_COST)
FROM 
(SELECT OU_NAME, 
OU_ADD,IO_NAME,DEPARTMENT,MO_NUMBER,ITEM_CODE,ITEM_ID,ITEM_DESC,UOM,
ITEM_TYPE,PDATE_FROM,PDATE_TO,SUM(ISSUE_QUANTITY) ISSUE_QUANTITY,SUM(RECEIVE_QTY) RECEIVE_QTY,
--COST_PER_UNIT
SUM(ISSUE_QTY) ISSUE_QTY,SUM(MO_QTY) MO_QUANTITY,AVG(RATE) UNIT_PRICE,
DECODE(GET_RATE_FROM_ITEM_ID(ITEM_ID),1,0,0,0,NULL,0,GET_RATE_FROM_ITEM_ID(ITEM_ID)) FOREIGN_RATE,
sum (NVL(AMOUNT,0)) * SUM(NVL(ISSUE_QUANTITY,0)) * NVL(GET_RATE_FROM_ITEM_ID(ITEM_ID) ,1) TOTAL_AMOUNT,
SUM(NVL(ITEM_COST,0)) * SUM(NVL(ISSUE_QUANTITY,0)) ITEM_COST
FROM 
(
SELECT
--GET_QTY_FROM_ITEM_ID(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID) COST_PER_UNIT,
 NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE),XX_GET_LIST_PRICE (WXMD.ITEM_ID)) ITEM_COST,
 GET_RATE_FROM_ITEM_ID(WXMD.ITEM_ID) FOREIGN_RATE,
WIOD.OPERATING_UNIT_NAME OU_NAME,
WIOD.INV_ORG_ADDRESS OU_ADD,
WIOD.INVENTORY_ORGANIZATION_NAME IO_NAME,
--(SELECT DISTINCT ATTRIBUTE5 FROM MTL_TXN_REQUEST_LINES_V WHERE REQUEST_NUMBER=MTRL.REQUEST_NUMBER AND  ATTRIBUTE5 IS NOT NULL) DEPARTMENT,
(SELECT DISTINCT ATTRIBUTE5 FROM MTL_TXN_REQUEST_LINES_V WHERE REQUEST_NUMBER=MTRL.REQUEST_NUMBER and (ATTRIBUTE5=:P_DEPT or :P_DEPT is null) AND  ATTRIBUTE5 IS NOT NULL) DEPARTMENT,
XX_GET_LIST_PRICE (WXMD.ITEM_ID) RATE,
WXMD.ITEM_ID ITEM_ID,
WXMD.ITEM_CODE,
WXMD.ITEM_DESC,
MTRL.UOM_CODE UOM,
MTRL.QUANTITY_DELIVERED ISSUE_QTY,
MTRL.QUANTITY MO_QTY,
WXMD.ITEM_TYPE,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) RECEIVE_QTY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) ISSUE_QUANTITY, 
--GET_QTY_FROM_ITEM_ID(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID) * NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) AMOUNT,
-- NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE), (XX_GET_LIST_PRICE (WXMD.ITEM_ID)) * GET_RATE_FROM_ITEM_ID(WXMD.ITEM_ID))
--* NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) AMOUNT,
NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE),(XX_GET_LIST_PRICE (WXMD.ITEM_ID))) AMOUNT,
XXGET_ENAME_WITH_KG(MTRL.CREATED_BY) DEPT_USER, 
MTRL.REFERENCE REFERENCE,
MTRL.REQUEST_NUMBER MO_NUMBER,
MTRL.CREATION_DATE MO_DATE,
:P_TRANSACTION_DATE_FROM PDATE_FROM,
:P_TRANSACTION_DATE_TO  PDATE_TO
FROM 
MTL_MATERIAL_TRANSACTIONS MMT, 
MTL_TXN_REQUEST_LINES_V  MTRL,
WBI_XXKBGITEM_MT_D WXMD,
WBI_INV_ORG_DETAIL WIOD
WHERE wxmd.INVENTORY_ITEM_ID =MMT.INVENTORY_ITEM_ID
and WXMD.ORGANIZATION_ID= MMT.ORGANIZATION_ID
AND MTRL.LINE_ID (+) =MMT.MOVE_ORDER_LINE_ID
AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
 AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
AND WXMD.ORGANIZATION_ID=MTRL.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MTRL.INVENTORY_ITEM_ID
AND WIOD.INV_ORGANIZATION_ID=WXMD.ORGANIZATION_ID
AND WIOD.INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID 
AND REQUEST_NUMBER  LIKE '%-%'
AND MTRL.QUANTITY_DELIVERED IS NOT NULL
AND MTRL.ORGANIZATION_ID=NVL(:P_ORGANIZATION_ID,MTRL.ORGANIZATION_ID)
and WXMD.ITEM_ID = NVL(:P_ITEM_ID,WXMD.ITEM_ID)
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND WXMD.ITEM_TYPE=NVL(:P_ITEM_TYPE,WXMD.ITEM_TYPE)
AND WXMD.ITEM_GROUP=NVL(:P_ITEM_GROUP,WXMD.ITEM_GROUP)
AND WXMD.ITEM_SUB_GROUP=NVL(:P_ITEM_SUB_GROUP,WXMD.ITEM_SUB_GROUP)
AND NVL(MTRL.ATTRIBUTE2,'XX')=NVL(:P_USE_OF_AREA,NVL(MTRL.ATTRIBUTE2,'XX'))
)
WHERE 
DEPARTMENT IS NOT NULL
and department = NVL(:P_DEPT,department)
--and ITEM_ID = 35187   
--AND MO_DATE BETWEEN NVL(:P_TRANSACTION_DATE_FROM, MO_DATE)   AND NVL(:P_TRANSACTION_DATE_TO,MO_DATE) 
AND (:P_TRANSACTION_DATE_FROM IS null OR MO_DATE BETWEEN :P_TRANSACTION_DATE_FROM  AND :P_TRANSACTION_DATE_TO)
and ITEM_TYPE not in ('BY PRODUCTS', 'CO PRODUCTS', 'FINISHED GOODS', 'SEMI FINISHED GOODS')
and MO_NUMBER = NVL(:P_MO_NUMBER, MO_NUMBER)
GROUP BY ITEM_COST,OU_NAME, OU_ADD,IO_NAME,DEPARTMENT,ITEM_ID,ITEM_CODE,ITEM_DESC,UOM,ITEM_TYPE,PDATE_FROM,PDATE_TO,MO_NUMBER)
GROUP BY DEPARTMENT




--=================================================================================================================

-- > 840   PS|STGN|MASK|000775       COTTON MASK
-- MCCB 50A, 3 POLE  --> SP|ELEC|MCCB|002847

-- FINAL
/*XXKSRM Department Wise Item Cost Details Report    BEFORE PERIOD CLOSING*/

SELECT OU_NAME, 
OU_ADD,IO_NAME,DEPARTMENT,MO_NUMBER,ITEM_CODE,ITEM_ID,ITEM_DESC,UOM,
ITEM_TYPE,PDATE_FROM,PDATE_TO,SUM(ISSUE_QUANTITY) ISSUE_QUANTITY,SUM(RECEIVE_QTY) RECEIVE_QTY,
--PREPARED_BY CREATED_BY,
--COST_PER_UNIT
SUM(ISSUE_QTY) ISSUE_QTY,SUM(MO_QTY) MO_QUANTITY,AVG(RATE) UNIT_PRICE,
DECODE(GET_RATE_FROM_ITEM_ID(ITEM_ID),1,0,0,0,NULL,0,GET_RATE_FROM_ITEM_ID(ITEM_ID)) FOREIGN_RATE,
sum (NVL(AMOUNT,0)) * SUM(NVL(ISSUE_QUANTITY,0)) * NVL(GET_RATE_FROM_ITEM_ID(ITEM_ID) ,1) TOTAL_AMOUNT,
NVL(SUM(ITEM_COST),0)*SUM(NVL(ISSUE_QUANTITY,0)) COST_AMOUNT
FROM 
(
SELECT
--GET_QTY_FROM_ITEM_ID(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID) COST_PER_UNIT,
 NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE),XX_GET_LIST_PRICE (WXMD.ITEM_ID)) ITEM_COST,
 GET_RATE_FROM_ITEM_ID(WXMD.ITEM_ID) FOREIGN_RATE,
WIOD.OPERATING_UNIT_NAME OU_NAME,
WIOD.INV_ORG_ADDRESS OU_ADD,
WIOD.INVENTORY_ORGANIZATION_NAME IO_NAME,
--(SELECT DISTINCT ATTRIBUTE5 FROM MTL_TXN_REQUEST_LINES_V WHERE REQUEST_NUMBER=MTRL.REQUEST_NUMBER AND  ATTRIBUTE5 IS NOT NULL) DEPARTMENT,
(SELECT DISTINCT ATTRIBUTE5 FROM MTL_TXN_REQUEST_LINES_V WHERE REQUEST_NUMBER=MTRL.REQUEST_NUMBER and (ATTRIBUTE5=:P_DEPT or :P_DEPT is null) AND  ATTRIBUTE5 IS NOT NULL) DEPARTMENT,
XX_GET_LIST_PRICE (WXMD.ITEM_ID) RATE,
WXMD.ITEM_ID ITEM_ID,
WXMD.ITEM_CODE,
WXMD.ITEM_DESC,
MTRL.UOM_CODE UOM,
MTRL.QUANTITY_DELIVERED ISSUE_QTY,
MTRL.QUANTITY MO_QTY,
WXMD.ITEM_TYPE,
XX_INV_PKG.XXGET_ENAME(MTRL.CREATED_BY )  PREPARED_BY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) RECEIVE_QTY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) ISSUE_QUANTITY, 
--GET_QTY_FROM_ITEM_ID(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID) * NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) AMOUNT,
-- NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE), (XX_GET_LIST_PRICE (WXMD.ITEM_ID)) * GET_RATE_FROM_ITEM_ID(WXMD.ITEM_ID))
--* NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID )),0) AMOUNT,
NVL(xx_inv_pkg.GET_MFG_ORG_ITEM_COST(MTRL.ORGANIZATION_ID,WXMD.ITEM_ID, MTRL.CREATION_DATE),(XX_GET_LIST_PRICE (WXMD.ITEM_ID))) AMOUNT,
XXGET_ENAME_WITH_KG(MTRL.CREATED_BY) DEPT_USER, 
MTRL.REFERENCE REFERENCE,
MTRL.REQUEST_NUMBER MO_NUMBER,
MTRL.CREATION_DATE MO_DATE,
:P_TRANSACTION_DATE_FROM PDATE_FROM,
:P_TRANSACTION_DATE_TO  PDATE_TO
FROM 
MTL_MATERIAL_TRANSACTIONS MMT, 
MTL_TXN_REQUEST_LINES_V  MTRL,
WBI_XXKBGITEM_MT_D WXMD,
WBI_INV_ORG_DETAIL WIOD
WHERE wxmd.INVENTORY_ITEM_ID =MMT.INVENTORY_ITEM_ID
and WXMD.ORGANIZATION_ID= MMT.ORGANIZATION_ID
AND MTRL.LINE_ID (+) =MMT.MOVE_ORDER_LINE_ID
AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
 AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
AND WXMD.ORGANIZATION_ID=MTRL.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MTRL.INVENTORY_ITEM_ID
AND WIOD.INV_ORGANIZATION_ID=WXMD.ORGANIZATION_ID
AND WIOD.INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID 
AND REQUEST_NUMBER  LIKE '%-%'
AND MTRL.QUANTITY_DELIVERED IS NOT NULL
AND MTRL.ORGANIZATION_ID=NVL(:P_ORGANIZATION_ID,MTRL.ORGANIZATION_ID)
and WXMD.ITEM_ID = NVL(:P_ITEM_ID,WXMD.ITEM_ID)
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND WXMD.ITEM_TYPE=NVL(:P_ITEM_TYPE,WXMD.ITEM_TYPE)
AND WXMD.ITEM_GROUP=NVL(:P_ITEM_GROUP,WXMD.ITEM_GROUP)
AND WXMD.ITEM_SUB_GROUP=NVL(:P_ITEM_SUB_GROUP,WXMD.ITEM_SUB_GROUP)
AND NVL(MTRL.ATTRIBUTE2,'XX')=NVL(:P_USE_OF_AREA,NVL(MTRL.ATTRIBUTE2,'XX'))
)
WHERE 
DEPARTMENT IS NOT NULL
and department = NVL(:P_DEPT,department)
--and ITEM_ID = 35187   
--AND MO_DATE BETWEEN NVL(:P_TRANSACTION_DATE_FROM, MO_DATE)   AND NVL(:P_TRANSACTION_DATE_TO,MO_DATE) 
AND (:P_TRANSACTION_DATE_FROM IS null OR MO_DATE BETWEEN :P_TRANSACTION_DATE_FROM  AND :P_TRANSACTION_DATE_TO)
and ITEM_TYPE not in ('BY PRODUCTS', 'CO PRODUCTS', 'FINISHED GOODS', 'SEMI FINISHED GOODS')
and MO_NUMBER = NVL(:P_MO_NUMBER, MO_NUMBER)
GROUP BY ITEM_COST,OU_NAME, OU_ADD,IO_NAME,DEPARTMENT,ITEM_ID,ITEM_CODE,ITEM_DESC,UOM,ITEM_TYPE,PDATE_FROM,PDATE_TO,MO_NUMBER,PREPARED_BY
ORDER BY MO_NUMBER




-- CHAKING PURPOSE 
select GET_RATE_FROM_ITEM_ID(33734) from dual 

select MAX(LAST_UPDATE_DATE) from po_LINES_ALL where ITEM_DESCRIPTION= 'SAFETY SHOE'

select ph.APPROVED_DATE,ph.SEGMENT1 , ph.po_header_id,ph.CURRENCY_CODE, pl.ITEM_ID,pl.ITEM_DESCRIPTION
from po_headers_all ph, PO_LINES_ALL PL
WHERE Ph.PO_HEADER_ID= pl.PO_HEADER_ID
and pl.item_id= 33734