-- PENDING MOVE ORDER FOR ROBIUL VAI AND BOS
--===============================

SELECT  GET_OU_NAME_FROM_ID((SELECT  OPERATING_UNIT FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID=a.ORGANIZATION_ID)) OU,
GET_ORG_CODE_FROM_ID(A.ORGANIZATION_ID) ORG_CODE, A.TRANSACTION_TYPE_NAME, A.REQUEST_NUMBER MO_NUMBER, 
B.QUANTITY REQUEST_QTY, B.QUANTITY_DELIVERED,--B.LINE_STATUS ,
  (case 
   when B.LINE_STATUS =3 and B.QUANTITY_DELIVERED <B.QUANTITY THEN   'Partially Received' 
   when B.LINE_STATUS =3 THEN 'Approved'
when B.LINE_STATUS =5 then 'Closed' 
when B.LINE_STATUS =6 then 'Canceled' 
 when B.LINE_STATUS =7 then 'Pre Approved'
  when B.LINE_STATUS =8 then 'Others'
end) MO_STATUS,
 (D.SEGMENT1 || '|' || D.SEGMENT2 || '|' || D.SEGMENT3||'|' || D.SEGMENT4)    ITEM_CODE,
 XXGET_ITEM_DESCRIPTION(B.INVENTORY_ITEM_ID,A.ORGANIZATION_ID) ITEM_DESC, B.UOM_CODE,
--XX_INV_PKG.XXGET_EMP_DEPT(A.CREATED_BY) DEPARTMENT,
(SELECT DISTINCT  USE_AREA FROM XXKSRM_INV_USE_AREA_V WHERE USE_AREA_ID= B.ATTRIBUTE2 ) USEOFAREA,
A.CREATION_DATE MO_DATE,XX_GET_EMP_NAME_FROM_USER_ID (A.CREATED_BY) CREATED_BY,
:P_FROM_DATE,:P_TO_DATE
FROM MTL_TXN_REQUEST_HEADERS_V A, MTL_TXN_REQUEST_LINES_V B , MFG_LOOKUPS C, MTL_SYSTEM_ITEMS_B D
WHERE B.REQUEST_NUMBER = A.REQUEST_NUMBER
       AND B.HEADER_ID = A.HEADER_ID
       AND B.ORGANIZATION_ID = A.ORGANIZATION_ID
              AND B.ORGANIZATION_ID = D.ORGANIZATION_ID
           AND B.INVENTORY_ITEM_ID = D.INVENTORY_ITEM_ID
--AND A.HEADER_STATUS_NAME = 'Approved'
AND A.REQUEST_NUMBER LIKE 'MO%'
--AND A.REQUEST_NUMBER IN ( 'MO-TRM-0102283', 'MO-TRM-0102284','MO-TRM-0102285')
       AND B.LINE_STATUS = C.LOOKUP_CODE
       AND C.LOOKUP_TYPE = 'MTL_TXN_REQUEST_STATUS'
       --AND a.CREATION_DATE BETWEEN '01-JAN-2023' AND '17-JAN-2023'
and TRUNC(a.CREATION_DATE)  BETWEEN NVL(:P_FROM_DATE,a.CREATION_DATE)  AND NVL(:P_TO_DATE,a.CREATION_DATE)
       AND A.ORGANIZATION_ID =NVL(:P_ORG_ID,A.ORGANIZATION_ID)
       AND (SELECT  OPERATING_UNIT FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID=a.ORGANIZATION_ID) = NVL(:P_OU, (SELECT  OPERATING_UNIT FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID=a.ORGANIZATION_ID))
       AND  C.MEANING  ='Approved'
       




2266907

SELECT * FROM MTL_TXN_REQUEST_HEADERS_V WHERE REQUEST_NUMBER ='MO-TRM-0102283'

SELECT * FROM MTL_TXN_REQUEST_HEADERS_V WHERE REQUEST_NUMBER ='2266897' -- 'MO-TRM-0102283'


SELECT * FROM XX_ONT_TRIP_MT where TRIPSYS_NO =  349303

2260251


-- MISCILINIUS RECEIVE
--==========================

 select * from MTL_MATERIAL_TRANSACTIONS where TRANSACTION_ID= 15282136



UPDATE MTL_MATERIAL_TRANSACTIONS
SET ATTRIBUTE4 = 'MO-KPM-0003270'
WHERE TRANSACTION_ID = 15419357


UPDATE MTL_MATERIAL_TRANSACTIONS
SET ATTRIBUTE4 = 'MO-KPM-0003128',
 ATTRIBUTE3 = 'ELECTRICAL'
WHERE TRANSACTION_ID = 15282136

15282107



-- GRN NA PAOA GELE NICER PROGRAM DUTI CHALATE HOE: Responsibility : Inventory Administrator
SHIPMENTS INTERFACE IMPORT
LANDED COST INTEGRATION MANAGER




--LC NUMBER UPDATE IN IOT AND GRN DFF
==============================
-- LC NUMBER UPDATE  IN GRN DFF
--------------------------------------------------------
UPDATE RCV_TRANSACTIONS
SET ATTRIBUTE_CATEGORY = 'LC Item Receiving'
WHERE SHIPMENT_HEADER_ID = 1095418

--LC NUMBER UPDATE IN  IOT DFF
-----------------------------------------------
 update MTL_MATERIAL_TRANSACTIONS
 SET ATTRIBUTE3 = 11008,
 ATTRIBUTE_CATEGORY = 'LC Number' 
 WHERE TRANSACTION_ID IN(
--TRANS_ID
)




--MUABIAR ISSUE: TRANSACTION TYPE AND ACCOUNT CODE VUL KORESE MISCELINIOUS REIPT TRANSACTION KORTE GIE: PORE IE QUERY DIE UPDATE KORESI
--===================================================================
UPDATE MTL_MATERIAL_TRANSACTIONS
SET DISTRIBUTION_ACCOUNT_ID = 60531,
TRANSACTION_TYPE_ID= 111
WHERE TRANSACTION_ID=14637930




--ROHIM SB ISSUE: Difference Between MAY-21 CLosing andd JUN -21 Opening 

--WE KNOW THAT: MTL_MATERIAL_TRANSACTIONS.TRANSACTION_SOURCE_ID=GME_BATCH_HEADER.BATCH_ID

select * from MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID IN (9685914, 9685877)

select * from gme_batch_header where BATCH_ID= 728982

select * from MTL_TRANSACTION_TYPES where transaction_type_id=44

UPDATE MTL_MATERIAL_TRANSACTIONS
SET TRANSACTION_DATE = TO_DATE('3/9/2021 5:29:01 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE TRANSACTION_ID IN (9685914)


SELECT * FROM MTL_MATERIAL_TRANSACTIONS WHERE INVENTORY_ITEM_ID=12936 --SP|MECH|PRNG|005113


select * from MTL_ONHAND_QUANTITIES_DETAIL where INVENTORY_ITEM_ID = 12936

 SELECT
 msib.segment1 item_code  ,
moqd.SUBINVENTORY_CODE
,moqd.LOCATOR_ID
 ,SUM(moqd.TRANSACTION_QUANTITY)  onhand_quantity ,
                milkfv.CONCATENATED_SEGMENTS LOCATORS      
           FROM APPS.MTL_SYSTEM_ITEMS_B msib,
              APPS.MTL_ONHAND_QUANTITIES_DETAIL moqd ,
                APPS.mtl_item_locations_kfv milkfv
          WHERE 1=1
          --msib.organization_id = 567
            and msib.INVENTORY_ITEM_ID = moqd.INVENTORY_ITEM_ID
            AND MSIB.ORGANIZATION_ID =MOQD.ORGANIZATION_ID
        -- and moqd.SUBINVENTORY_CODE = :P_SUBINVENTORY
           AND milkfv.INVENTORY_LOCATION_ID = moqd.LOCATOR_ID
          AND MSIB.SEGMENT1 = :P_ITEM
            GROUP BY MSIB.SEGMENT1,MOQD.SUBINVENTORY_CODE,MILKFV.CONCATENATED_SEGMENTS,moqd.LOCATOR_ID
            




--==================================================================================
--- ISSUE: OPENING QTY SHOWS NEGATIVE VALUE :  In this issue I found that In a Batch 75. something qty is issued in march but in mtl_material_transaction table --> Transaction Date is showing 25 february


BATCH NO : 2434
BATCH_ID= 726239

SELECT * --  XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) --INTO OPEN_QTY
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE  TRANSACTION_ID IN (9685961,9685914 )
--and  XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY)


select * from MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=9685914

select * from MTL_TRANSACTION_TYPES where transaction_type_id=42

select * from gme_batch_header where BATCH_ID= 726239  --9685956 9685956


SELECT NVL(SUM(PRIMARY_QUANTITY),0) --INTO OPEN_QTY
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=NVL(:P_ORG_ID,ORGANIZATION_ID) 
--AND SUBINVENTORY_CODE=NVL(P_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID=:P_INVENTORY_ITEM_ID  
-----AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
AND  TRUNC(TRANSACTION_DATE) <TO_DATE(:P_DATE_FROM)


SELECT* --INTO OPEN_QTY
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=NVL(:P_ORG_ID,ORGANIZATION_ID) 
--AND SUBINVENTORY_CODE=NVL(P_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID=:P_INVENTORY_ITEM_ID  
-----AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
--and TRANSACTION_ID = 9685914
AND  TRANSACTION_DATE <TO_DATE(:P_DATE_FROM)
--==================================================================================================================================