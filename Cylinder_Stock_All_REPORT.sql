
-- XXKSRM Cylinder Stock All

SELECT DISTINCT
WXMD.ORGANIZATION_NAME,
(SELECT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MOQ.ORGANIZATION_ID) ORG_ADD,
WXMD.ORGANIZATION_code,
MOQ.ORGANIZATION_ID,
MOQ.SUBINVENTORY_CODE,
WXMD.ITEM_CODE,
WXMD.ITEM_DESC,
WXMD.UOM1 UOM,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID, MOQ.ORGANIZATION_ID, MOQ.SUBINVENTORY_CODE, MOQ.LOCATOR_ID, :P_DATE),0) OPENING_QTY ,
--NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID,MOQ.ORGANIZATION_ID,NULL, NULL, :P_DATE),0) GLOBAL_STOCK,
---NULL GLOBAL_STOCK,
XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME,
:P_DATE PDATE
FROM WBI_XXKBGITEM_MT_D WXMD,
MTL_ONHAND_QUANTITIES MOQ
WHERE     WXMD.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID
AND TRUNC(MOQ.DATE_RECEIVED) <=:P_DATE
AND WXMD.ATTRIBUTE13='KOM_CYLINDER'
AND WXMD.ORGANIZATION_ID = MOQ.ORGANIZATION_ID     
AND WXMD.ORGANIZATION_ID=173
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
UNION 
SELECT 
DISTINCT 
(SELECT INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL  WHERE INV_ORGANIZATION_ID=KCV.ORGANIZATION_ID) ORGANIZATION_NAME,
(SELECT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=KCV.ORGANIZATION_ID) ORG_ADD,
(SELECT INV_ORGANIZATION_CODE FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=KCV.ORGANIZATION_ID) ORGANIZATION_CODE,
KCV.ORGANIZATION_ID  ORGANIZATION_ID,
'PARTY'  SUBINVENTORY_CODE,
KCV.ITEMCODE ITEM_CODE,
KCV.ITEM_DESCRIPTION ITEM_DESC,
KCV.UOM_CODE UOM,
XX_TAB.PARTY_BALANCE OPENING_QTY ,
----NULL GLOBAL_STOCK,
XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME,
:P_DATE PDATE
FROM XXKSRM_KOL_CHALLAN_V KCV,
 (SELECT ORGANIZATION_ID,ITEMCODE,
            SUM(PARTY_BALANCE)  PARTY_BALANCE
            FROM XXKSRM_KOL_CHALLAN_V
            WHERE TO_DATE(CHALLAN_DATE)<=(:P_DATE) AND PARTY_BALANCE>0
            GROUP BY ORGANIZATION_ID,ITEMCODE) 
            XX_TAB
WHERE KCV.ORGANIZATION_ID=XX_TAB.ORGANIZATION_ID
AND KCV.ITEMCODE=XX_TAB.ITEMCODE
AND  KCV.ITEMCODE=NVL(:P_ITEM_CODE,KCV.ITEMCODE)


--=====================FINDINGS ========================================

 
select *  FROM XX_CHALLAN_MO_TEMP WHERE CHALLAN_NO= '4201010071930'

SELECT ORGANIZATION_ID,ITEMCODE,
            SUM(PARTY_BALANCE)  PARTY_BALANCE
            FROM XXKSRM_KOL_CHALLAN_V           
            WHERE TO_DATE(CHALLAN_DATE)<=(:P_DATE) AND PARTY_BALANCE>0
            GROUP BY ORGANIZATION_ID,ITEMCODE
            
            
                    select *  FROM XXKSRM_KOL_CHALLAN_V where CUSTOMER_ID = 20958
            
            select SUM(PARTY_BALANCE)   FROM XXKSRM_KOL_CHALLAN_V where CUSTOMER_ID = 20958
            
            select * from MTL_TXN_REQUEST_LINES where LINE_ID =  1824301
            
 ----===================================================================================================================
           
            SELECT * ----  SUM (TRANSACTION_QUANTITY)
             FROM MTL_MATERIAL_TRANSACTIONS
            WHERE    1= 1
           -- AND  TRANSACTION_TYPE_ID IN (42, 163, 129)            ---= 42
                 AND ATTRIBUTE3 = '4201010071930'
                  --   AND MOVE_ORDER_LINE_ID = MTRL.LINE_ID
                  AND ATTRIBUTE_CATEGORY = 'Empty Cylinder Receive' ---- 'KOM Delivery challan'
                  --                   and  ATTRIBUTE4= MTRL.LINE_ID
                  --                   and ATTRIBUTE4 is not null
                  
                  
                  AND INVENTORY_ITEM_ID =
                         (SELECT ATTRIBUTE2
                            FROM MTL_SYSTEM_ITEMS_B
                           WHERE INVENTORY_ITEM_ID = WDD.INVENTORY_ITEM_ID
                                 AND ORGANIZATION_ID = WDD.ORGANIZATION_ID)
                  AND ORGANIZATION_ID = WDD.ORGANIZATION_ID
            
            select * from MTL_MATERIAL_TRANSACTIONS WHERE 
            
            
            select * from 


--=============================================================

SELECT * FROM MTL_MATERIAL_TRANSACTIONS 
WHERE 1=1 -- INVENTORY_ITEM_ID= 75
and TRANSACTION_ID IN (
9882655,
9892600,
9892642,
9892716)
--AND  TRUNC(TRANSACTION_DATE) between '01-SEP-2018' and '31-DEC-2021' 
AND ORGANIZATION_ID=173

SELECT sum(TRANSACTION_QUANTITY) FROM MTL_MATERIAL_TRANSACTIONS WHERE INVENTORY_ITEM_ID= 75
AND  TRUNC( TRANSACTION_DATE) between '01-SEP-2018' and '31-DEC-2021' 

--==================================================================================================================

--FUNCTION XX_INV_OPEN_QTY(P_ORG_ID NUMBER,P_SUBINVENTORY_CODE VARCHAR2, P_INVENTORY_ITEM_ID NUMBER,P_DATE_FROM DATE)
--RETURN NUMBER IS
--OPEN_QTY NUMBER;
--BEGIN
SELECT NVL(SUM(PRIMARY_QUANTITY),0)  --INTO OPEN_QTY
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=173
--AND SUBINVENTORY_CODE=NVL('KOM_FG',SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID= 75 --P_INVENTORY_ITEM_ID  
AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
AND  TRUNC(TRANSACTION_DATE) between '01-SEP-2018' and '31-DEC-2018' --<TO_DATE(P_DATE_FROM)
--RETURN(OPEN_QTY);
--EXCEPTION 
--WHEN OTHERS THEN  
--RETURN(null);
--END;


NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID, MOQ.ORGANIZATION_ID, MOQ.SUBINVENTORY_CODE, MOQ.LOCATOR_ID, :P_DATE),0) OPENING_QTY ,

SELECT NVL(SUM(PRIMARY_QUANTITY),0) 
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=NVL(P_ORG_ID,ORGANIZATION_ID) 
AND SUBINVENTORY_CODE=NVL(P_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID=P_INVENTORY_ITEM_ID  
-----AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
AND  TRUNC( TRANSACTION_DATE) <TO_DATE(P_DATE_FROM);


KOM_FG
PARTY