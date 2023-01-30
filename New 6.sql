
-- XXKSRM MOVE ORDER (Brand)
-- Date  29-MAY-2021

SELECT    
                 MTRL.ORGANIZATION_ID, MTHL.ATTRIBUTE_CATEGORY
                ,NVL((SELECT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORG),'KABIR GROUP') ORG_NAME
                ,XX_INV_PKG.XXGET_EMP_DEPT(MTHL.CREATED_BY) DEPARTMENT
               ,(SELECT DISTINCT  OTM.TRIPSYS_NO FROM  XX_ONT_TRIP_MT OTM WHERE TO_CHAR(OTM.MOVE_ORDER_NUMBER)=TO_CHAR(MTRL.REQUEST_NUMBER) AND OTM.MOVE_ORDER_NUMBER IS NOT NULL) TRIP_NO
              ,(SELECT DISTINCT DECODE(OTM.EMPLOYEE_ID,NULL,UNLISTED_DRIVER,(SELECT DISTINCT VENDOR_NAME  FROM AP_SUPPLIERS  WHERE VENDOR_ID = OTM.EMPLOYEE_ID)) DRIVER_NAME FROM  XX_ONT_TRIP_MT OTM WHERE TO_CHAR(OTM.MOVE_ORDER_NUMBER)=TO_CHAR(MTRL.REQUEST_NUMBER) AND OTM.MOVE_ORDER_NUMBER IS NOT NULL) DRIVER_NAME
                ,MTRL.ATTRIBUTE15 GATE_PASS_NO
                ,XX_INV_PKG.XXGET_CUSTOMER_NAME((SELECT ATTRIBUTE11 FROM MTL_TXN_REQUEST_HEADERS_V WHERE ATTRIBUTE_CATEGORY='Sample Issue to Customer/Test' AND HEADER_ID=MTHL.HEADER_ID) ) CUSTOMER_NAME           
             ---- ,(SELECT ATTRIBUTE11 FROM MTL_TXN_REQUEST_HEADERS_V WHERE ATTRIBUTE_CATEGORY='Sample Issue to Customer/Test' AND HEADER_ID=MTHL.HEADER_ID) CUSTOMER_NAME
               ,(SELECT ATTRIBUTE1 FROM MTL_TXN_REQUEST_HEADERS_V WHERE ATTRIBUTE_CATEGORY='Move Order Issue' AND HEADER_ID=MTHL.HEADER_ID) WORK_ORDER_NO
                ,MTRL.REQUEST_NUMBER MOVE_ORDER_NUMBER
                 , MTHL.attribute10 Event_Type
                ,MTHL.attribute1 Management
                ,MTHL.attribute2 Govt_NON_GOVT_Office
                ,MTHL.attribute3 Media
                , MTHL.attribute4  KSRM_Office
                ,MTHL.attribute5 DESIGNATION
                , MTHL.attribute13 Destination_and_through_by
                , MTHL.attribute14 GIFT_TO               
                ,MTRL.DATE_REQUIRED  MOVE_ORDER_DATE
                ,MTRL.TRANSACTION_TYPE_NAME MOVE_ORDER_TYPE
                ,ML.MEANING MO_STATUS_LINE
                ,MTHL.HEADER_STATUS_NAME  MO_STATUS
                ,(SELECT ATTRIBUTE9 FROM MTL_TXN_REQUEST_HEADERS_V WHERE ATTRIBUTE_CATEGORY='Issue to Project' AND HEADER_ID=MTHL.HEADER_ID) PROJECT_NAME
                ,MTRL.LINE_NUMBER
                , (MSI.SEGMENT1 || '|' || MSI.SEGMENT2 || '|' || MSI.SEGMENT3||'|' || MSI.SEGMENT4)    ITEM_CODE
                ,MSI.DESCRIPTION
                ,MTRL.UOM_CODE
                ---=========================================
                ,MTRL.FROM_SUBINVENTORY_CODE
                ,MTRL.INVENTORY_ITEM_ID
                -----------------------------------------------------
                , (SELECT NVL(SUM(PRIMARY_QUANTITY),0)
                FROM 
                MTL_MATERIAL_TRANSACTIONS
                WHERE 
                ORGANIZATION_ID=MTRL.ORGANIZATION_ID
                AND SUBINVENTORY_CODE=NVL(MTRL.FROM_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
                AND INVENTORY_ITEM_ID=MTRL.INVENTORY_ITEM_ID 
                AND  TRANSACTION_DATE <MTRL.DATE_REQUIRED) IO_STOCK
                ---=========================================
                ,MTRL.QUANTITY  MO_QTY
                ,XX.QTY_ISSUED MO_ISSUE_QTY
                ,CASE WHEN MTRL.LINE_STATUS <>5 THEN 0   ELSE (MTRL.QUANTITY-MTRL.QUANTITY_DELIVERED)  END  CANCEL_QTY
                ,XX.SUBINVENTORY_CODE
                , (SELECT SEGMENT2||'|'||SEGMENT3||'|'||SEGMENT4||'|'||SEGMENT5 LOCATOR_DESC FROM MTL_ITEM_LOCATIONS WHERE INVENTORY_LOCATION_ID=XX.LOCATOR_ID AND ORGANIZATION_ID=MTRL.ORGANIZATION_ID) LOCATOR
                ,XX.LOT_NUMBER
                ,XX_INV_PKG.XXGET_SERIAL_NUMBER(XX.TRANSACTION_ID) SERIAL_NUMBER
               ----,(SELECT DISTINCT  USE_AREA FROM XXKSRM_INV_USE_AREA_V WHERE USE_AREA_ID= MTRL.ATTRIBUTE2 AND OU_ID=(SELECT OPERATING_UNIT_ID FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID)) USEOFAREA
               ,(SELECT DISTINCT  USE_AREA FROM XXKSRM_INV_USE_AREA_V WHERE USE_AREA_ID= MTRL.ATTRIBUTE2 ) USEOFAREA
                ,MTRL.REFERENCE REASON
                ---===================================================
                ,MTHL.DESCRIPTION PURPOSE
                ,XX.TRACKING_REMARKS
                ,MTHL.CREATED_BY PREPARED_BY_ID
                , XX_INV_PKG.XXGET_ENAME(MTHL.CREATED_BY )  PREPARED_BY
                ,XX.TAKEN_BY
                ----===========HOD=====================
                ,(XX_INV_PKG.XXGET_ENAME ((SELECT USER_ID FROM FND_USER 
                WHERE USER_NAME =(SELECT APPROVED_BY FROM XXKSRM_MOAPPROVAL_STATUS
                WHERE HEADER_ID=MTHL.HEADER_ID AND WF_STATUS='Approved')))) HOD
                ----===========HOD=====================
                --,DECODE(MTHL.HEADER_STATUS,
                --3,XX_INV_PKG.XX_INV_HOD(MTRL.ORGANIZATION_ID,XX_INV_PKG.XXGET_EMP_DEPT(MTHL.CREATED_BY)),
                --7,XX_INV_PKG.XX_INV_HOD(MTRL.ORGANIZATION_ID,XX_INV_PKG.XXGET_EMP_DEPT(MTHL.CREATED_BY)),
                --8,XX_INV_PKG.XX_INV_HOD(MTRL.ORGANIZATION_ID,XX_INV_PKG.XXGET_EMP_DEPT(MTHL.CREATED_BY)),
                --NULL
                --) HOD
               ---- ,XX_INV_PKG.XX_INV_HOD(MTRL.ORGANIZATION_ID,XX_INV_PKG.XXGET_EMP_DEPT(MTHL.CREATED_BY)) HOD
                ----===========HOD=====================
                ----===========HOD=====================
                ,XX.ISSUED_STORE STORE_IN_CHARGE_ID
                , XX_INV_PKG.XXGET_ENAME(XX.ISSUED_STORE) STORE_IN_CHARGE
                ,XX.CREATED_BY ISSUED_BY_ID
                , XX_INV_PKG.XXGET_ENAME(XX.CREATED_BY) ISSUED_BY
                ,XX.RECEIVED_STORE  RECEIVED_BY_ID
                , XX_INV_PKG.XXGET_ENAME(XX.RECEIVED_STORE)  RECEIVED_BY
                ,XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME
                ,NVL((SELECT DISTINCT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORG),'KABIR GROUP') PORG_NAME
                ,NVL((SELECT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID= :P_ORG),'Kabir Manzil,SK, Mujib Road,Agrabad,Chittagong,BD') PORG_ADDRESS
                ----=====================================================
        FROM   MTL_TXN_REQUEST_HEADERS_V MTHL
          ,MTL_TXN_REQUEST_LINES_V MTRL
          ,MTL_SYSTEM_ITEMS_B MSI
          ,MFG_LOOKUPS ML
          , (  SELECT   MMT.ORGANIZATION_ID
                       ,MMT.INVENTORY_ITEM_ID
                       ,MMT.TRANSACTION_TYPE_ID
                       ,MMT.MOVE_ORDER_LINE_ID
                       ,MMT.SUBINVENTORY_CODE
                       ,MMT.LOCATOR_ID
                       ,MMT.ATTRIBUTE1 TAKEN_BY
                       ,MMT.ATTRIBUTE11 TRACKING_REMARKS 
                       ,MMT.TRANSACTION_SOURCE_ID
                       ,MMT.REASON_ID
                       ,MAX (MMT.CREATED_BY) CREATED_BY
                       ,MMT.TRANSACTION_ID
                       , (MMT.TRANSACTION_DATE) TRANSACTION_DATE
                       ,SUM (ABS (MMT.PRIMARY_QUANTITY)) QTY_ISSUED
                       ,MTLN.LOT_NUMBER
                      ,MMT.ATTRIBUTE1 ISSUED_STORE
                       ,MMT.ATTRIBUTE2 RECEIVED_STORE
                 FROM   MTL_MATERIAL_TRANSACTIONS MMT
                       ,MTL_TRANSACTION_LOT_NUMBERS MTLN
                WHERE   MMT.PRIMARY_QUANTITY < 0
                    AND MMT.ORGANIZATION_ID = :P_ORG
                    AND MMT.TRANSACTION_SOURCE_TYPE_ID = 4
                    AND MTLN.TRANSACTION_ID(+)=MMT.TRANSACTION_ID
             GROUP BY   MMT.ORGANIZATION_ID
                       ,MMT.INVENTORY_ITEM_ID
                       ,MMT.TRANSACTION_TYPE_ID
                       ,MMT.ATTRIBUTE1
                       ,MMT.ATTRIBUTE11
                       ,MMT.MOVE_ORDER_LINE_ID
                       ,MMT.SUBINVENTORY_CODE
                       ,MMT.LOCATOR_ID
                       ,MMT.TRANSACTION_SOURCE_ID
                       ,MMT.REASON_ID
                       ,MTLN.LOT_NUMBER
                       ,MMT.ATTRIBUTE1 
                       ,MMT.ATTRIBUTE2 
                       ,(MMT.TRANSACTION_DATE)
                       ,MMT.TRANSACTION_ID) XX
   WHERE   MTRL.REQUEST_NUMBER = MTHL.REQUEST_NUMBER
       AND MTRL.HEADER_ID = MTHL.HEADER_ID
       AND MTRL.ORGANIZATION_ID = MTHL.ORGANIZATION_ID
       --TRANSACTION_TYPE_ID
       AND MTRL.LINE_STATUS = ML.LOOKUP_CODE
       AND ML.LOOKUP_TYPE = 'MTL_TXN_REQUEST_STATUS'
       and  MTHL.ATTRIBUTE_CATEGORY = 'General'
       --AND UPPER(MTRL.transaction_type_name)='MOVE ORDER ISSUE'
       AND MTRL.ORGANIZATION_ID = NVL (:P_ORG, MTRL.ORGANIZATION_ID)
       AND MTRL.REQUEST_NUMBER = NVL (:P_FROM_MO, MTRL.REQUEST_NUMBER)
      AND TRUNC(MTHL.DATE_REQUIRED) BETWEEN NVL(:P_FROM_DATE,TRUNC(MTHL.DATE_REQUIRED))  AND  NVL(:P_TO_DATE,TRUNC(MTHL.DATE_REQUIRED))
       AND MTRL.INVENTORY_ITEM_ID =NVL(:P_ITEM_ID,MTRL.INVENTORY_ITEM_ID)
      AND MTHL.HEADER_STATUS_NAME =NVL(:P_MO_STATUS,HEADER_STATUS_NAME)
    --   AND MTRL.transaction_source_type_id = 4
       AND MTRL.ORGANIZATION_ID = XX.ORGANIZATION_ID(+)
       AND MTRL.ORGANIZATION_ID = MSI.ORGANIZATION_ID
       AND MTRL.INVENTORY_ITEM_ID = XX.INVENTORY_ITEM_ID(+)
       AND MTRL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
       AND MTRL.LINE_ID = XX.MOVE_ORDER_LINE_ID(+)
       AND MTRL.HEADER_ID = XX.TRANSACTION_SOURCE_ID(+)
     --  AND MTRL.transaction_type_id = XX.transaction_type_id
       --AND MTRL.request_number='2002'
ORDER BY  MTRL.DATE_REQUIRED, MTRL.REQUEST_NUMBER,MTRL.LINE_NUMBER---- XX.TAKEN_BY