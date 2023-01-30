--TO Find out sub inventory
--=========================
select * FROM apps.mtl_secondary_inventories where ORGANIZATION_ID = 121





--MY QUERY FOR  XXKSRM Item Stock SI Wise 

select ohd.item,
--NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID,:P_ORG_ID,  NVL(:P_SUBINVENTORY_CODE,MOQ.SUBINVENTORY_CODE), NULL, :P_DATE),0) OPENING_QTY ,
ohd.item_desc,
ohd.org_code,
ohd.org_name,
ohd.sub_inventory,
ohd.locator, 
msn.serial_number,
ohd.item_status,
ohd.uom,
NVL2(msn.serial_number,1,ohd.total_onhand_qty) onhand_qty,
ohd.total_onhand_qty,
ohd.total_reserve_qty,
ohd.total_transact_qty,
mmt.transaction_date stock_in_date,
mst.transaction_source_type_name stock_in_type
from (SELECT msi.inventory_item_id ,
    (select max(mq.create_transaction_id) from mtl_onhand_quantities mq
        where 1=1
        and mq.organization_id = moq.organization_id
        and mq.inventory_item_id=moq.inventory_item_id
        and mq.locator_id=moq.locator_id
        and mq.transaction_quantity>0
        )transaction_id,
    moq.organization_id,
    msi.segment1 item,
    msi.description item_desc,
    moq.subinventory_code sub_inventory,
    moq.locator_id,
    ood.organization_code org_code,
    ood.organization_name org_name,
    (mil.segment1||'-'||mil.segment2||'-'||mil.segment3||'-'||mil.segment4||'-'||mil.segment5) locator,
    msi.inventory_item_status_code item_status,
    msi.primary_uom_code,
    msi.primary_unit_of_measure uom,
    SUM(moq.transaction_quantity) total_onhand_qty,
    SUM(moq.transaction_quantity) - ( nvl( (
        SELECT
            SUM(transaction_quantity)
        FROM
            mtl_onhand_quantities
        WHERE
            inventory_item_id = moq.inventory_item_id
            AND organization_id = moq.organization_id
            AND locator_id = moq.locator_id
            AND subinventory_code IN(
                SELECT
                    secondary_inventory_name
                FROM
                    mtl_secondary_inventories
                WHERE
                    organization_id = moq.organization_id
                    AND reservable_type = '2'
            )
    ),0) + nvl( (
        SELECT
            SUM(reservation_quantity) 
        FROM
            mtl_reservations
        WHERE
            inventory_item_id = moq.inventory_item_id
            AND organization_id = moq.organization_id
            AND subinventory_code = moq.subinventory_code
            AND locator_id = moq.locator_id
    ),0) ) total_reserve_qty,
    SUM(moq.transaction_quantity) - nvl( (
        SELECT
            SUM(reservation_quantity)
        FROM
            mtl_reservations
        WHERE
            inventory_item_id = moq.inventory_item_id
            AND organization_id = moq.organization_id
            AND subinventory_code = moq.subinventory_code
            AND locator_id = moq.locator_id
    ),0) total_transact_qty
FROM
    mtl_onhand_quantities moq,
    mtl_system_items_b msi,
    org_organization_definitions ood,
    mtl_item_locations mil
WHERE
    msi.inventory_item_id = moq.inventory_item_id --(+)
    AND msi.organization_id = moq.organization_id-- (+)
    AND ood.organization_id = moq.organization_id
    AND mil.inventory_location_id = moq.locator_id
GROUP BY
msi.inventory_item_id,
    moq.organization_id,
    moq.inventory_item_id,
    msi.segment1,
    msi.description,
    moq.subinventory_code,
    moq.locator_id,
     ood.organization_id,
    ood.organization_code,
    ood.organization_name,
    ( mil.segment1
      || '-'
      || mil.segment2
      || '-'
      || mil.segment3
      || '-'
      || mil.segment4
      || '-'
      || mil.segment5 ),
    msi.inventory_item_status_code,
    msi.primary_uom_code,
    msi.primary_unit_of_measure
) ohd,
    mtl_serial_numbers msn,
    mtl_material_transactions mmt,
    mtl_txn_source_types mst
where msn.current_organization_id(+)=ohd.organization_id
and msn.inventory_item_id(+)=ohd.inventory_item_id
and msn.current_locator_id(+)=ohd.locator_id
and msn.current_status(+)=3
and mmt.transaction_id=ohd.transaction_id
and mst.transaction_source_type_id=mmt.transaction_source_type_id
and ohd.org_code = NVL(:P_INV, ohd.org_code)
--AND ohd.item_desc = 'DIESEL'
--and ohd.org_code = 'KSM'
order by ohd.item,
ohd.sub_inventory,
ohd.org_code,
ohd.org_name,
ohd.locator



--========================================

-- XXKSRM Item Stock SI Wise 
SELECT DISTINCT
WXMD.ITEM_TYPE,
wxmd.item_id,
WXMD.ITEM_GROUP,
WXMD.ITEM_SUB_GROUP,
WXMD.FINANCE_CATEGORY,
WXMD.ORGANIZATION_NAME,
(SELECT  INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORG_ID) ORG_ADD,
---(SELECT address_line_1||','|| address_line_2||','|| address_line_3||','|| town_or_city||','|| country  FROM hr_locations  HL ,hr_all_organization_units HOU
---WHERE HL.location_id = HOU.location_id AND HOU.organization_id =MOQ.ORGANIZATION_ID) ORG_ADD,
WXMD.ORGANIZATION_code,
MOQ.ORGANIZATION_ID,
--MOQ.CREATION_DATE,
WXMD.ITEM_CODE,
WXMD.ITEM_DESC,
WXMD.UOM1 UOM,
MOQ.SUBINVENTORY_CODE,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID,:P_ORG_ID,  NVL(:P_SUBINVENTORY_CODE,MOQ.SUBINVENTORY_CODE), NULL, :P_DATE),0) OPENING_QTY ,
--XX_INV_OPEN_QTY(P_ORG_ID NUMBER,P_SUBINVENTORY_CODE VARCHAR2, P_INVENTORY_ITEM_ID NUMBER,P_DATE_FROM DATE)
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID,:P_ORG_ID,NULL, NULL, :P_DATE),0) GLOBAL_STOCK,
:P_ITEM_TYPE  PITEM_TYPE,
:P_ITEM_GROU PITEM_GROUP,
:P_ITEM_SUB_GROUP PITEM_SUB_GROUP,
:P_FINANCE_CATEGORY PFINANCE_CATEGORY,
TRUNC(:P_DATE) AS_ON_DATE 
FROM WBI_XXKBGITEM_MT_D WXMD,
MTL_ONHAND_QUANTITIES MOQ
WHERE     WXMD.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID(+)
AND WXMD.ORGANIZATION_ID = MOQ.ORGANIZATION_ID(+)   
AND   WXMD.ORGANIZATION_ID=NVL(:P_ORG_ID,WXMD.ORGANIZATION_ID)
AND WXMD.ITEM_TYPE=NVL(:P_ITEM_TYPE,WXMD.ITEM_TYPE)
AND  WXMD.ITEM_GROUP=NVL(:P_ITEM_GROU,WXMD.ITEM_GROUP)
AND  WXMD.ITEM_SUB_GROUP=NVL(:P_ITEM_SUB_GROUP,WXMD.ITEM_SUB_GROUP)
AND NVL(WXMD.FINANCE_CATEGORY,'XX')=NVL(:P_FINANCE_CATEGORY,NVL(WXMD.FINANCE_CATEGORY,'XX'))
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND NVL(MOQ.SUBINVENTORY_CODE,'XX')=NVL(:P_SUBINVENTORY_CODE,NVL(MOQ.SUBINVENTORY_CODE,'XX'))
ORDER BY WXMD.ORGANIZATION_CODE, MOQ.SUBINVENTORY_CODE;


---============================================

select * from  mtl_system_items_b where item description = ''

select * from XXKBG_BI_PO_GRN

select * from  WBI_XXKBGITEM_MT_D

select * from  MTL_SYSTEM_ITEMS_KFV where CONCATENATED_SEGMENTS = 'SP|MECH|DVLV|020212' and organization_id = '121'

select * from MTL_SYSTEM_ITEMS_FVL 

select * from MTL_ITEM_CATEGORIES_V where  organization_id = '121' and CATEGORY_CONCAT_SEGS = ''  --like '%STORE%SPARES%'

select * from  MTL_SYSTEM_ITEMS_b
          (SELECT DISTINCT CATEGORY_CONCAT_SEGS
             FROM MTL_ITEM_CATEGORIES_V
            WHERE     INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
                  AND CATEGORY_SET_ID = 1100000041
                  AND ORGANIZATION_ID = MSIB.ORGANIZATION_ID)
             FINANCE_CATEGORY,
             
             
--======================================================================================================================



select a.ITEM_TYPE, a.ITEM_GROUP ,a.ITEM_SUBGROUP, a.Item_id  , a.ITEM_DESCRIPTION,a.SHIPMENT_ORG_CODE,a.SHIPMENT_ORG_NAME,  --, a.FINANCE_CATEGORY,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (b.INVENTORY_ITEM_ID,:P_ORG_ID,  NVL(:P_SUBINVENTORY_CODE,b.SUBINVENTORY_CODE), NULL, :P_DATE),0) OPENING_QTY ,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (b.INVENTORY_ITEM_ID,:P_ORG_ID,NULL, NULL, :P_DATE),0) GLOBAL_STOCK,
sum(a.STORE_QTY) ,
:P_ITEM_TYPE  PITEM_TYPE,
:P_ITEM_GROU PITEM_GROUP,
:P_ITEM_SUB_GROUP PITEM_SUB_GROUP,
:P_FINANCE_CATEGORY PFINANCE_CATEGORY,
TRUNC(:P_DATE) AS_ON_DATE 
 from XXKBG_BI_PO_GRN a , MTL_ONHAND_QUANTITIES b
where a.ITEM_ID = b.INVENTORY_ITEM_ID(+)
and a.SHIPMENT_ORG_ID = b.ORGANIZATION_ID(+)
--and SHIPMENT_ORG_CODE = 'TRM'
--and ITEM_DESCRIPTION = 'DIESEL'
AND   a.SHIPMENT_ORG_ID=NVL(:P_ORG_ID, a.SHIPMENT_ORG_ID)
AND a.ITEM_TYPE=NVL(:P_ITEM_TYPE,a.ITEM_TYPE)
AND   a.ITEM_GROUP=NVL(:P_ITEM_GROUP, a.ITEM_GROUP)
AND a.ITEM_SUBGROUP=NVL(:P_ITEM_SUB_GROUP,a.ITEM_SUBGROUP)
--and a.ITEM_TYPE <> 'DEFAULT'
--and ITEM_TYPE = 'DEFAULT'
group by a.ITEM_TYPE, a.ITEM_GROUP ,a.ITEM_SUBGROUP, a.Item_id ,ITEM_DESCRIPTION,a.SHIPMENT_ORG_CODE,a.SHIPMENT_ORG_NAME,  --,a.FINANCE_CATEGORY,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (b.INVENTORY_ITEM_ID,:P_ORG_ID,  NVL(:P_SUBINVENTORY_CODE,b.SUBINVENTORY_CODE), NULL, :P_DATE),0) ,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (b.INVENTORY_ITEM_ID,:P_ORG_ID,NULL, NULL, :P_DATE),0)


SELECT * FROM MTL_MATERIAL_TRANSACTIONS WHERE  INVENTORY_ITEM_ID=14 and SUBINVENTORY_CODE = 'STAGIN' --TRANSACTION_QUANTITY=236 






--======================= NEW  QUERY-========================

SELECT 
ITEM_TYPE, ITEM_GROUP, ITEM_SUBGROUP, ITEM_CATEGORY, ITEM_DESCRIPTION, SUBINVENTORY, SHIPMENT_ORG_CODE
FROM XXKBG_BI_PO_GRN
where ITEM_DESCRIPTION = 'DIESEL'
and SHIPMENT_ORG_CODE = 'TRM'
AND ITEM_SUB_GROUP <> ''


SELECT * FROM XXKBG_BI_PO_GRN      





--===========================================
-- XXKSRM Item Stock SI Wise to update 

SELECT DISTINCT
WXMD.ITEM_TYPE,
wxmd.item_id,
WXMD.ITEM_GROUP,
WXMD.ITEM_SUB_GROUP,
WXMD.FINANCE_CATEGORY,
WXMD.ORGANIZATION_NAME,
(SELECT  INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORG_ID) ORG_ADD,
---(SELECT address_line_1||','|| address_line_2||','|| address_line_3||','|| town_or_city||','|| country  FROM hr_locations  HL ,hr_all_organization_units HOU
---WHERE HL.location_id = HOU.location_id AND HOU.organization_id =MOQ.ORGANIZATION_ID) ORG_ADD,
WXMD.ORGANIZATION_code,
MOQ.ORGANIZATION_ID,
WXMD.ITEM_CODE,
WXMD.ITEM_DESC,
WXMD.UOM1 UOM,
MOQ.SUBINVENTORY_CODE,
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID,:P_ORG_ID,  NVL(:P_SUBINVENTORY_CODE,MOQ.SUBINVENTORY_CODE), NULL, :P_DATE),0) OPENING_QTY ,
--XX_INV_OPEN_QTY(P_ORG_ID NUMBER,P_SUBINVENTORY_CODE VARCHAR2, P_INVENTORY_ITEM_ID NUMBER,P_DATE_FROM DATE)
NVL (XX_INV_PKG.XXGET_INV_OPENING_STOCK (MOQ.INVENTORY_ITEM_ID,:P_ORG_ID,NULL, NULL, :P_DATE),0) GLOBAL_STOCK,
:P_ITEM_TYPE  PITEM_TYPE,
:P_ITEM_GROU PITEM_GROUP,
:P_ITEM_SUB_GROUP PITEM_SUB_GROUP,
:P_FINANCE_CATEGORY PFINANCE_CATEGORY,
TRUNC(:P_DATE) AS_ON_DATE 
FROM WBI_XXKBGITEM_MT_D WXMD,
MTL_ONHAND_QUANTITIES MOQ
WHERE     WXMD.INVENTORY_ITEM_ID = MOQ.INVENTORY_ITEM_ID(+)
AND WXMD.ORGANIZATION_ID = MOQ.ORGANIZATION_ID(+)   
AND   WXMD.ORGANIZATION_ID=NVL(:P_ORG_ID,WXMD.ORGANIZATION_ID)
AND WXMD.ITEM_TYPE=NVL(:P_ITEM_TYPE,WXMD.ITEM_TYPE)
AND  WXMD.ITEM_GROUP=NVL(:P_ITEM_GROU,WXMD.ITEM_GROUP)
AND  WXMD.ITEM_SUB_GROUP=NVL(:P_ITEM_SUB_GROUP,WXMD.ITEM_SUB_GROUP)
AND NVL(WXMD.FINANCE_CATEGORY,'XX')=NVL(:P_FINANCE_CATEGORY,NVL(WXMD.FINANCE_CATEGORY,'XX'))
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND NVL(MOQ.SUBINVENTORY_CODE,'XX')=NVL(:P_SUBINVENTORY_CODE,NVL(MOQ.SUBINVENTORY_CODE,'XX'))
AND TRUNC(:P_DATE) = NVL(TRUNC(:P_DATE),MOQ.CREATION_DATE )
--and TRUNC(:P_DATE) = NVL(TRUNC(:P_DATE), null)
ORDER BY WXMD.ORGANIZATION_CODE,  MOQ.SUBINVENTORY_CODE


--============================================

SELECT NVL(SUM(PRIMARY_QUANTITY),0) 
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=152 --NVL(P_ORG_ID,ORGANIZATION_ID) 
AND SUBINVENTORY_CODE= 'STAGIN'   --NVL(P_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID=180 --P_INVENTORY_ITEM_ID  
-----AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
--AND  TRUNC( TRANSACTION_DATE) <TO_DATE(P_DATE_FROM);











--======================================================================




select * from org_organization_definitions where organization_code = 'KSM';

select distinct(OPERATING_UNIT), ORGANIZATION_NAME, ORGANIZATION_CODE from org_organization_definitions order by operating_unit

select * from hr_operating_units;

Select * from APPS.WBI_XXKBGITEM_MT_D;   -- This is a VIEW

select *  FROM WBI_INV_RCV_TRANSACTIONS_F 
 where organization_id= 171 
 and receipt_no = 80000142 
 and TRANSACTION_TYPE = 'DELIVER'


--============================================================
--RDF: XXINVGRNREP  ,  REPORT NAME: XXKSRM GRN Local
--===========================================================

SELECT
DISTINCT WIRTF.ORGANIZATION_ID
,WIRTF.RECEIPT_NO GRN_NO
,WIRTF.RECEIPT_DATE GRN_DATE
,DECODE(WIRTF.GRN_SOURCE,'VENDOR',WIRTF.PO_NO,'INTERNAL ORDER',WIRTF.SHIPMENT_NUM,'INVENTORY',WIRTF.SHIPMENT_NUM,'CUSTOMER',WIRTF.CUSTOMER_ORDER_NO)  PO_NO
,WIRTF.PO_APPROVED_DATE
,DECODE(WIRTF.GRN_SOURCE,'VENDOR',WIRTF.SUPPLIER,
                                              'INTERNAL ORDER',(SELECT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.IOT_IR_FROM_ORG),
                                              'INVENTORY',(SELECT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.IOT_IR_FROM_ORG),
                                              'CUSTOMER',XX_INV_PKG.XXGET_CUSTOMER_NAME(WIRTF.GRN_CUS_ID)) SUPPLIER
,WIRTF.VENDOR_ID SUPPLIER_ID
,DECODE(WIRTF.GRN_SOURCE,'VENDOR',WIRTF.SUPPLIER_ADDRESS,
                                              'INTERNAL ORDER',(SELECT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.IOT_IR_FROM_ORG),
                                              'INVENTORY',(SELECT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.IOT_IR_FROM_ORG),
                                              'CUSTOMER',(SELECT ADDRESS1||', '||ADDRESS2||', '||ADDRESS3||', '||ADDRESS4||', '||CITY||', '||COUNTRY ADDRESS  FROM XX_AR_CUSTOMER_SITE_V 
                                                                 WHERE SITE_USE_CODE = 'BILL_TO' AND PRIMARY_FLAG = 'Y' AND CUSTOMER_ID =WIRTF.GRN_CUS_ID 
                                                                 AND ORG_ID =(SELECT DISTINCT OPERATING_UNIT_ID FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID= :P_ORGANIZATION_ID) ) ) SUPPLIER_ADDRESS
,WIRTF.PREPAYMENT_AMOUNT
,WIRTF.LC_CERTIF_OF_ORIGIN CERTIF_OF_ORGN
,NVL(XLD.LC_NUMBER,WIRTF.LC_NO_IOT) LC_NUMBER
,NVL(XLD.LC_OPENING_DATE,WIRTF.LC_OPENING_DATE_IOT) LC_DATE
,DECODE(XLD.LC_TYPE,'D','Defferd','S','Sight','U','UPass','C','CAD',NULL) LC_TYPE
,WIRTF.LC_AIR_VSL_NAME AIR_VSL_NAME
,WIRTF.LC_BL_NO
,WIRTF.LC_BL_DATE BL_DATE
,(SELECT  DISTINCT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.ORGANIZATION_ID) INV_ORG_NAME
,(SELECT  DISTINCT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.ORGANIZATION_ID) ORG_ADDRESS
,(SELECT DISTINCT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.ORGANIZATION_ID) ORG_NAME
,WIRTF.DEPARTMENT
,WIRTF.GATE_ENTRY_NO
,TO_CHAR(TO_DATE(WIRTF.GATE_ENTRY_DATE,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') GATE_ENTRY_DATE
,WIRTF.RELEASE_NUMBER RELEASE_NO
,WIRTF.RELEASE_DATE RELEASE_DATE
,WIRTF.INVENTORY_ITEM_ID
,WIRTF.ITEM_CODE
,WIRTF.ITEM_DESC
,WIRTF.UOM
,WIRTF.PR_NO
,WIRTF.PR_QTY
,NVL(WIRTF.PO_QTY,WIRTF.IOT_QTY)  PO_QTY
,WIRTF.RECEIPT_QTY RECEIPT_QTY
,(NVL(WIRTF.DELIVER_QTY,0)-NVL(WIRTF.DLV_RETURN_QTY,0)) DELIVER_QTY
,WIRTF.DLV_RETURN_QTY
,WIRTF.ACCEPTED_QTY
,(NVL(WIRTF.REJECTED_QTY,0)-NVL(WIRTF.RETURN_QTY,0)) REJECTED_QTY
,WIRTF.RETURN_QTY
,WIRTF.SUBINVENTORY
,WIRTF.LOCATOR_NAME
,WIRTF.ACCEPTED_QTY DELIVER_TO_SI
,WIRTF.RATE
,(NVL((NVL(WIRTF.DELIVER_QTY,0)-NVL(WIRTF.DLV_RETURN_QTY,0)),0) * NVL(WIRTF.RATE,0) ) AMOUNT
,WIRTF.CHALLAN_NUMBER_RT CHALLAN_NO
,WIRTF.CHALLAN_QUANTITY_RT CHALLAN_QTY
,TO_CHAR(TO_DATE(WIRTF.CHALLAN_DATE,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') CHALLAN_DATE
,WIRTF.VEHICLE_NUMBER_RT
,WIRTF.BRAND 
,WIRTF.ORIGIN 
,WIRTF.LOT_NO LOT_NUMBER
,WIRTF.SERIAL_NO SERIAL_NUM
, NULL EXPIRY_DATE
,WIRTF.INSPECTION_DATE
,WIRTF.INSPECTION_BY
,WIRTF.REMARKS
,WIRTF.PREPARED_BY
,WIRTF.LC_LDT_WT
,WIRTF.LC_DWT_WT
,WIRTF.LC_CUTTING_WT
,WIRTF.LOT_NO
,DECODE(WIRTF.GRN_SOURCE,'INVENTORY','Inter Org Transfer','VENDOR','Purchase Order',WIRTF.GRN_SOURCE)  GRN_SOURCE
,XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME
FROM WBI_INV_RCV_TRANSACTIONS_F WIRTF
,XX_LC_DETAILS XLD
WHERE WIRTF.PO_HEADER_ID=XLD.PO_HEADER_ID(+)
AND WIRTF.ORGANIZATION_ID=:P_ORGANIZATION_ID
AND WIRTF.TRANSACTION_TYPE IN ('RECEIVE','UNORDERED')
AND NVL(WIRTF.RECEIPT_NO,'A') =NVL(NVL(:P_RECEIPT_NO,WIRTF.RECEIPT_NO),'A')
AND TO_DATE(WIRTF.RECEIPT_DATE) BETWEEN NVL(:P_TRANSACTION_DATE_FROM,TO_DATE(WIRTF.RECEIPT_DATE))  AND NVL(:P_TRANSACTION_DATE_TO,TO_DATE(WIRTF.RECEIPT_DATE))
AND NVL(WIRTF.PO_NO,'A')=NVL(NVL(:P_PO_NO,PO_NO),'A')
AND NVL(WIRTF.LC_NO,'A')=NVL(NVL(:P_LC_NO,LC_NO),'A')
AND NVL(WIRTF.CHALLAN_NUMBER_RT ,'A')=NVL(NVL(:P_CHALLAN_NO,WIRTF.CHALLAN_NUMBER_RT),'A')
AND NVL(WIRTF.VENDOR_ID,0)=NVL(NVL(:P_VENDOR_ID,WIRTF.VENDOR_ID),0)
AND WIRTF.ITEM_CODE=NVL(:P_ITEM_CODE,WIRTF.ITEM_CODE)
AND NVL(WIRTF.LOT_NO,'XX')=NVL(:P_LOT_NO,NVL(WIRTF.LOT_NO,'XX'))
ORDER BY WIRTF.RECEIPT_DATE,WIRTF.RECEIPT_NO

--==================================================================
--XXINVDAILYTRANSMATERIAL  -----> XXKSRM Daily Transacted Material Report 
--================================================================
SELECT 
DISTINCT
TRUNC(RECEIPT_DATE) RECEIPT_DATE
,ORGANIZATION_ID
----,ORGANIZATION_NAME
,(SELECT DISTINCT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.ORGANIZATION_ID) ORGANIZATION_NAME
,NVL((SELECT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORG_ID),'KABIR GROUP') PORG_NAME
,NVL((SELECT DISTINCT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID= :P_ORG_ID),'Kabir Manzil,SK, Mujib Road,Agrabad,Chittagong,BD') PORG_ADDRESS
,PR_NO
---,PO_NO
,DECODE(WIRTF.GRN_SOURCE,'VENDOR',WIRTF.PO_NO,'INTERNAL ORDER',WIRTF.SHIPMENT_NUM,'INVENTORY',WIRTF.SHIPMENT_NUM,'CUSTOMER',WIRTF.CUSTOMER_ORDER_NO)  PO_NO
,LC_NO
,NULL CONSIGNMENT_NO
,RECEIPT_NO
,SOURCE_DOCUMENT_CODE TRANSACTION_TYPE
,ITEM_CODE
,ITEM_DESC
,UOM
,PO_QTY
,RECEIPT_QTY
,ACCEPTED_QTY INSPECTED_QTY
,REJECTED_QTY
,DEPARTMENT
,challan_number_rt CHALLAN_NO
,TO_CHAR(TO_DATE(WIRTF.CHALLAN_DATE,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') CHALLAN_DATE
,CHALLAN_QUANTITY_RT CHALLAN_QTY
----,SUPPLIER
,DECODE(WIRTF.GRN_SOURCE,'VENDOR',WIRTF.SUPPLIER,
                                              'INTERNAL ORDER',(SELECT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.IOT_IR_FROM_ORG),
                                              'INVENTORY',(SELECT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WIRTF.IOT_IR_FROM_ORG),
                                              'CUSTOMER',XX_INV_PKG.XXGET_CUSTOMER_NAME(WIRTF.GRN_CUS_ID)) SUPPLIER
,XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME
,:P_FROM_DATE PDATE_FROM
,:P_TO_DATE PDATE_TO
FROM WBI_INV_RCV_TRANSACTIONS_F WIRTF
WHERE 
ORGANIZATION_ID=NVL(:P_ORG_ID,ORGANIZATION_ID)
AND NVL(RECEIPT_NO,'XX')=NVL(:P_RECEIPT_NO,NVL(RECEIPT_NO,'XX'))
AND TO_DATE(RECEIPT_DATE) BETWEEN NVL(:P_FROM_DATE,TO_DATE(RECEIPT_DATE)) AND NVL(:P_TO_DATE,TO_DATE(RECEIPT_DATE))
AND ITEM_CODE=NVL(:P_ITEM_CODE,ITEM_CODE)
AND NVL(PO_NO,'XX')=NVL(:P_PO_NO,NVL(PO_NO,'XX'))
AND NVL(DEPARTMENT,'ASDF')=NVL(:P_DEPARTMENT,NVL(DEPARTMENT,'ASDF'))
AND TO_CHAR(NVL(CHALLAN_NUMBER_RT,'ASDF'))=TO_CHAR(NVL(:P_CHALLAN_NO,NVL(CHALLAN_NUMBER_RT,'ASDF')))
AND TO_CHAR(NVL(LC_NO,'ASDF'))=TO_CHAR(NVL(:P_LC_NO,NVL(LC_NO,'ASDF')))
AND TRANSACTION_TYPE IN ('RECEIVE','UNORDERED')
AND NVL(VENDOR_ID,'1111')=NVL(:P_VENDOR_ID,NVL(VENDOR_ID,'1111'))
---ORDER BY RECEIPT_DATE
UNION ALL 
SELECT  
TRUNC(MMT.TRANSACTION_DATE) RECEIPT_DATE
,MMT.ORGANIZATION_ID ORGANIZATION_ID
---,(SELECT DISTINCT  NVL(ORGANIZATION_NAME,NULL) FROM WBI_INV_ORG_D WIOD WHERE WIOD.ORGANIZATION_ID=MMT.ORGANIZATION_ID) ORGANIZATION_NAME
,(SELECT DISTINCT INV_ORGANIZATION_CODE||'-'||INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MMT.ORGANIZATION_ID) ORGANIZATION_NAME
,NVL((SELECT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORG_ID),'KABIR GROUP') PORG_NAME
,NVL((SELECT DISTINCT INV_ORG_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID= :P_ORG_ID),'Kabir Manzil,SK, Mujib Road,Agrabad,Chittagong,BD') PORG_ADDRESS
,NULL PR_NO
,NULL PO_NO
,NULL LC_NO
,NULL CONSIGNMENT_NO
,NULL RECEIPT_NO
,(SELECT TRANSACTION_TYPE_NAME FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID) TRANSACTION_TYPE
, WXMD.ITEM_CODE ITEM_CODE
, WXMD.ITEM_DESC ITEM_DESC
,WXMD.UOM1 UOM
,NULL PO_QTY
,MMT.PRIMARY_QUANTITY RECEIPT_QTY
,NULL  INSPECTED_QTY
, NULL REJECTED_QTY
,NULL DEPARTMENT
,NULL CHALLAN_NO
,NULL CHALLAN_DATE
,NULL CHALLAN_QTY
,NULL SUPPLIER
,XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME
,:P_FROM_DATE PDATE_FROM
,:P_TO_DATE PDATE_TO
FROM MTL_MATERIAL_TRANSACTIONS MMT, WBI_XXKBGITEM_MT_D WXMD
WHERE 
----MMT.TRANSACTION_TYPE_ID=42
MMT.TRANSACTION_TYPE_ID in (42,108)
AND WXMD.ITEM_ID=MMT.INVENTORY_ITEM_ID
AND WXMD.ORGANIZATION_ID=MMT.ORGANIZATION_ID
AND MMT.ORGANIZATION_ID=NVL(:P_ORG_ID,MMT.ORGANIZATION_ID)
AND 10=NVL(:P_RECEIPT_NO,10)
AND TO_DATE(MMT.TRANSACTION_DATE) BETWEEN NVL(:P_FROM_DATE,TO_DATE(MMT.TRANSACTION_DATE)) AND NVL(:P_TO_DATE,TO_DATE(MMT.TRANSACTION_DATE))
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND 7=NVL(:P_PO_NO,7)
AND TO_CHAR(17)=NVL(:P_DEPARTMENT,TO_CHAR(17))
AND TO_CHAR(18)=TO_CHAR(NVL(:P_CHALLAN_NO,18))
AND TO_CHAR(8)=TO_CHAR(NVL(:P_LC_NO,8))
AND 19=NVL(:P_VENDOR_ID,19)
ORDER BY 1,10

--===========================================================================

--==========================================================================================================
--INVENTORY SOME AKG QUERY IS READY FOR KSRM
-- INTER ORG TRANSFER REPORT
--================================================

SELECT 
MMT.TRANSFER_ORGANIZATION_ID transfer_party,
null address,
null vechical_no,
MMT.SUBINVENTORY_CODE,
mmt.SHIPMENT_NUMBER,
MMT.TRANSACTION_ID,
mmt.TRANSACTION_DATE,
tt.TRANSACTION_TYPE_NAME,
NULL TRANSACTION_STATUS,
msib.CONCATENATED_SEGMENTS ITEM_CODE,
NULL LOT,
msib.DESCRIPTION,
MMT.TRANSACTION_UOM,
ABS (TRANSACTION_QUANTITY) quantity,
NULL REMARKS,
mmt.CREATED_BY, mmt.LAST_UPDATED_BY
    FROM  inv.mtl_material_transactions mmt,
         apps.mtl_system_items_b_kfv msib,
         APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
         INV.MTL_TRANSACTION_TYPES tt
  WHERE    msib.inventory_item_id = mmt.inventory_item_id
   AND msib.ORGANIZATION_id = mmt.ORGANIZATION_id
  AND MMT.TRANSACTION_TYPE_ID=21 -- MISC RECEIVE
         AND mmt.ORGANIZATION_ID = OOD.ORGANIZATION_ID 
     --    AND msib.item_type = 'FG'
      --   AND OOD.ORGANIZATION_CODE ='PSU'
         and mmt.transaction_type_id = tt.transaction_type_id
     --    AND TO_CHAR(mmt.TRANSACTION_DATE,'DD-MON-YYYY') = NVL(:P_DATE,TO_CHAR(mmt.TRANSACTION_DATE,'DD-MON-YYYY') )
AND mmt.SHIPMENT_NUMBER = NVL(:P_SHIPMENT_NUMBER,mmt.SHIPMENT_NUMBER)


--===============================================================================
--ITEM LEDGER REPORT  (READY FOR KSRM)
--================================================================================

WITH ON_HAND AS 
   (SELECT    organization_id,oq.inventory_item_id,SUM (target_qty) op_qty
    FROM  (SELECT  organization_id,  inventory_item_id ,  SUM (primary_transaction_quantity) target_qty
              FROM     apps.mtl_onhand_quantities_detail moq
              GROUP BY organization_id, inventory_item_id 
              UNION
              SELECT    organization_id,inventory_item_id, -SUM (primary_quantity) target_qty
              FROM     apps.mtl_material_transactions mmt
              WHERE     transaction_date >= nvl(TO_DATE (:p_date_from),sysdate)
              GROUP BY  organization_id, inventory_item_id ) oq
    GROUP BY  organization_id,  inventory_item_id),
RCV AS (select organization_id, inventory_item_id , sum(decode(transaction_source_type_id ,5,decode(sign(mmt.transaction_quantity),1,primary_quantity))) as prod_rcv,
                                    sum(decode(transaction_source_type_id ,1,decode(sign(mmt.transaction_quantity),1,primary_quantity))) as po_rcv,
                                    sum(decode(transaction_source_type_id ,13,decode(sign(mmt.transaction_quantity),1,primary_quantity))) as inv_rcv
 from  apps.mtl_material_transactions mmt
WHERE    transaction_date between  TO_DATE (:p_date_from)  and  TO_DATE (:p_date_to)+1
group by organization_id,  inventory_item_id),
 ISSUE AS ( select  organization_id, inventory_item_id , sum(decode(transaction_source_type_id ,5,decode(sign(mmt.transaction_quantity),-1,primary_quantity))) as prod_issue,
                                    sum(decode(transaction_source_type_id ,1,decode(sign(mmt.transaction_quantity),-1,primary_quantity))) as po_issue,
                                    sum(decode(transaction_source_type_id ,13,decode(sign(mmt.transaction_quantity),-1,primary_quantity))) as inv_issue
from  apps.mtl_material_transactions mmt
WHERE    transaction_date between  TO_DATE (:p_date_from)  and  TO_DATE (:p_date_to)+1
group by organization_id, inventory_item_id)
--select   a.Item_type, sum(a.op_qty) opening ,sum(a.prod_rcv) prod_rcv ,sum(a.po_rcv) po_rcv,sum(a.inv_rcv) inv_rcv ,( sum(a.prod_rcv)+sum(a.po_rcv)+sum(a.inv_rcv)) tot_rcv , 
--sum(a.prod_issue)  prod_isu, sum(a.po_issue) po_isu, sum(a.inv_issue) inv_issue,(sum(a.prod_issue)+sum(a.po_issue)+sum(a.inv_issue)) tot_isu,
--(sum(a.op_qty)+( sum(a.prod_rcv)+sum(a.po_rcv)+sum(a.inv_rcv))+(sum(a.prod_issue)+sum(a.po_issue)+sum(a.inv_issue)))  closing
--from (
 select mic.segment2 Item_type ,ood.organization_code, NVL(oh.op_qty,0) OP_QTY ,NVL(r.prod_RCV,0) Prod_RCV,NVL(r.PO_RCV,0) PO_RCV,NVL(r.inv_rcv,0) INV_RCV, NVL(isu.prod_issue,0) Prod_issue,
NVL(isu.PO_issue,0) PO_issue,NVL(isu.inv_issue,0) inv_issue           
from ON_HAND  oh ,RCV r,ISSUE  isu,
        apps.mtl_system_items_kfv msi,
        apps.mtl_item_categories_v mic,
        APPS.ORG_ORGANIZATION_DEFINITIONS OOD
      where oh.organization_id =r.organization_id 
   and oh.inventory_item_id = r.inventory_item_id 
   and oh.organization_id =isu.organization_id 
   and oh.inventory_item_id = isu.inventory_item_id 
   and oh.organization_id =ood.organization_id 
   and oh.inventory_item_id =msi.inventory_item_id 
   and oh.organization_id=msi.organization_id 
   and mic.organization_id =msi.organization_id
   and mic.inventory_item_id =msi.inventory_item_id
-- and mic.segment2 in ('HR COIL','PICKLED COIL','RE PICKLED COIL','RE RE PICKLED COIL','ROLLING COIL',
-- 'REWINDING COIL','REWINDED BUILD UP COIL','RE REWINDING COIL','RE RE REWINDING COIL','GP COIL - NOF','GP COIL - CGL')
-- and ood.organization_id in (94,95,96,97,98,464)

--=========================================================================================

--=========================================================================================

--========================================
-- Staging table for Item upload in system
--========================================

DROP TABLE XXERP.XXKSRM_ITEM_CONV_STG CASCADE CONSTRAINTS;

CREATE TABLE XXERP.XXKSRM_ITEM_CONV_STG
(
  LEGACY_ITEM_ID             VARCHAR2(100 BYTE),
  LEGECY_ITEM_CODE           VARCHAR2(100 BYTE),
  ITEM_SEGMENT1              VARCHAR2(40 BYTE),
  ITEM_SEGMENT2              VARCHAR2(40 BYTE),
  ITEM_SEGMENT3              VARCHAR2(40 BYTE),
  ITEM_SEGMENT4              VARCHAR2(40 BYTE),
  ITEM_DESCRIPTION           VARCHAR2(240 BYTE),
  IMPA_CODE                  VARCHAR2(40 BYTE),
  DRAWING_NUM                VARCHAR2(40 BYTE),
  PART_NUM                   VARCHAR2(40 BYTE),
  PARENT_ITEM_CODE           VARCHAR2(40 BYTE),
  MAKE_OR_BUY                VARCHAR2(20 BYTE),
  MASTER_TEMPLATE_NAME       VARCHAR2(30 BYTE),
  TEMPLATE_NAME              VARCHAR2(30 BYTE),
  MIN_MAX_PLAN               VARCHAR2(3 BYTE),
  MIN_QTY                    NUMBER,
  MAX_QTY                    NUMBER,
  REORDER_POINT_ENABLED      VARCHAR2(3 BYTE),
  SAFETY_STOCK               NUMBER,
  TOTAL_LEAD_TIME            VARCHAR2(40 BYTE),
  PURCHASE_LIST_PRICE        VARCHAR2(10 BYTE),
  INVENTORY_CATEGORY_SET     VARCHAR2(50 BYTE),
  CAT_SEGMENT1               VARCHAR2(40 BYTE),
  CAT_SEGMENT2               VARCHAR2(40 BYTE),
  CAT_SEGMENT3               VARCHAR2(40 BYTE),
  CAT_SEGMENT4               VARCHAR2(40 BYTE),
  PRIMARY_UOM_CODE           VARCHAR2(3 BYTE),
  SECONDARY_UOM_CODE         VARCHAR2(3 BYTE),
  PRICING_UOM_TYPE           VARCHAR2(40 BYTE),
  PRICING_UOM                VARCHAR2(3 BYTE),
  CODE                       VARCHAR2(100 BYTE),
  CLASS                      VARCHAR2(100 BYTE),
  CONVERSION                 VARCHAR2(100 BYTE),
  FINANCE_CATEGORY_SET       VARCHAR2(100 BYTE),
  FINANCE_SUB_ACCOUNT        VARCHAR2(100 BYTE),
  FISCAL_CLASSIFICATION      VARCHAR2(100 BYTE),
  COGS_ACCOUNT               VARCHAR2(40 BYTE),
  COST_OF_SALE_ACCOUNT       VARCHAR2(40 BYTE),
  EXPENSE_ACCOUNT            VARCHAR2(40 BYTE),
  LOT_FLAG                   VARCHAR2(3 BYTE),
  LOT_SERIAL_NO              VARCHAR2(3 BYTE),
  OU                         VARCHAR2(50 BYTE),
  KSM                        VARCHAR2(3 BYTE),
  KS1                        VARCHAR2(3 BYTE),
  KSD                        VARCHAR2(3 BYTE),
  KSH                        VARCHAR2(3 BYTE),
  KS3                        VARCHAR2(3 BYTE),
  KS2                        VARCHAR2(3 BYTE),
  KSO                        VARCHAR2(3 BYTE),
  KSN                        VARCHAR2(3 BYTE),
  KSA                        VARCHAR2(3 BYTE),
  KSK                        VARCHAR2(3 BYTE),
  KSB                        VARCHAR2(3 BYTE),
  KRM                        VARCHAR2(3 BYTE),
  TRM                        VARCHAR2(3 BYTE),
  TRO                        VARCHAR2(3 BYTE),
  TRN                        VARCHAR2(3 BYTE),
  TRH                        VARCHAR2(3 BYTE),
  TRD                        VARCHAR2(3 BYTE),
  TRJ                        VARCHAR2(3 BYTE),
  TRK                        VARCHAR2(3 BYTE),
  TRB                        VARCHAR2(3 BYTE),
  PWM                        VARCHAR2(3 BYTE),
  PWH                        VARCHAR2(3 BYTE),
  PWD                        VARCHAR2(3 BYTE),
  KBM                        VARCHAR2(3 BYTE),
  KBA                        VARCHAR2(3 BYTE),
  KB1                        VARCHAR2(3 BYTE),
  KBD                        VARCHAR2(3 BYTE),
  KBH                        VARCHAR2(3 BYTE),
  KB2                        VARCHAR2(3 BYTE),
  KBO                        VARCHAR2(3 BYTE),
  KBN                        VARCHAR2(3 BYTE),
  KAM                        VARCHAR2(3 BYTE),
  KAD                        VARCHAR2(3 BYTE),
  KAH                        VARCHAR2(3 BYTE),
  KOM                        VARCHAR2(3 BYTE),
  KOH                        VARCHAR2(3 BYTE),
  KOD                        VARCHAR2(3 BYTE),
  KMM                        VARCHAR2(3 BYTE),
  KLM                        VARCHAR2(3 BYTE),
  KLD                        VARCHAR2(3 BYTE),
  KLH                        VARCHAR2(3 BYTE),
  KLO                        VARCHAR2(3 BYTE),
  KWM                        VARCHAR2(3 BYTE),
  KWD                        VARCHAR2(3 BYTE),
  KWH                        VARCHAR2(3 BYTE),
  KWN                        VARCHAR2(3 BYTE),
  SBM                        VARCHAR2(3 BYTE),
  SBD                        VARCHAR2(3 BYTE),
  SBH                        VARCHAR2(3 BYTE),
  SBO                        VARCHAR2(3 BYTE),
  BRM                        VARCHAR2(3 BYTE),
  BRO                        VARCHAR2(3 BYTE),
  BRN                        VARCHAR2(3 BYTE),
  CSM                        VARCHAR2(3 BYTE),
  CSO                        VARCHAR2(3 BYTE),
  CSN                        VARCHAR2(3 BYTE),
  SRM                        VARCHAR2(3 BYTE),
  SRO                        VARCHAR2(3 BYTE),
  SRN                        VARCHAR2(3 BYTE),
  FMM                        VARCHAR2(3 BYTE),
  JMM                        VARCHAR2(3 BYTE),
  MAM                        VARCHAR2(3 BYTE),
  KHM                        VARCHAR2(3 BYTE),
  BMM                        VARCHAR2(3 BYTE),
  COMMON                     VARCHAR2(100 BYTE),
  UOM_CONVERSION             VARCHAR2(10 BYTE),
  HS_CODE                    VARCHAR2(100 BYTE),
  MASTER_ORG_ID              NUMBER,
  MASTER_ORG_CODE            VARCHAR2(10 BYTE),
  TEMPLATE_ID                NUMBER,
  MASTER_TEMPLATE_ID         NUMBER,
  INVENTORY_ITEM_ID          NUMBER,
  CATEGORY_ID                NUMBER,
  CATEGORY_SET_ID            NUMBER,
  TAB_SEGMENT1               VARCHAR2(40 BYTE),
  TAB_SEGMENT2               VARCHAR2(40 BYTE),
  TAB_SEGMENT3               VARCHAR2(40 BYTE),
  LOT_CONTROL_ID             NUMBER,
  SERIAL_CONTROL_ID          NUMBER,
  ONT_PRICING_QTY_SOURCE     VARCHAR2(10 BYTE),
  REC_ID                     VARCHAR2(40 BYTE),
  CREATED_BY                 NUMBER,
  CREATION_DATE              DATE,
  LAST_UPDATED_DATE          DATE,
  LAST_UPDATED_BY            NUMBER,
  REQUEST_ID                 NUMBER,
  ITEM_MAST_STATUS           VARCHAR2(3 BYTE)   DEFAULT 'N',
  ITEM_MAST_ERROR_MSG        VARCHAR2(4000 BYTE),
  ORG_ASSIGN_STATUS          VARCHAR2(3 BYTE)   DEFAULT 'N',
  ORG_ASSIGN_ERROR_MSG       VARCHAR2(4000 BYTE),
  CAT_ASSIGN_STATUS          VARCHAR2(3 BYTE)   DEFAULT 'N',
  CAT_ASSIGN_ERROR_MSG       VARCHAR2(4000 BYTE),
  ORG_PARA_ASSIGN_STATUS     VARCHAR2(3 BYTE)   DEFAULT 'N',
  ORG_PARA_ASSIGN_ERROR_MSG  VARCHAR2(4000 BYTE)
)
TABLESPACE APPS_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP SYNONYM SYS.XXKSRM_ITEM_CONV_STG;

CREATE OR REPLACE SYNONYM SYS.XXKSRM_ITEM_CONV_STG FOR XXERP.XXKSRM_ITEM_CONV_STG;


DROP SYNONYM APPS.XXKSRM_ITEM_CONV_STG;

CREATE OR REPLACE SYNONYM APPS.XXKSRM_ITEM_CONV_STG FOR XXERP.XXKSRM_ITEM_CONV_STG;


GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, READ, DEBUG, FLASHBACK ON XXERP.XXKSRM_ITEM_CONV_STG TO APPS;


--===========================================================================
--XXKSRM Item Transactions/ Bin Card  --->  XXINVITEMBINCARD
-- DATE : 3-FEB-2019
--===========================================================================


SELECT 
WIOD.OPERATING_UNIT_NAME OU_NAME,
WIOD.INV_ORG_ADDRESS OU_ADD,
WIOD.INVENTORY_ORGANIZATION_NAME,
WXMD.ITEM_DESC,
WXMD.ITEM_CODE,
WXMD.UOM1 UOM,
WXMD.ITEM_TYPE,
WXMD.ITEM_GROUP,
WXMD.ITEM_SUB_GROUP,
--XX_INV_PKG.XX_INV_OPEN_QTY(MMT.ORGANIZATION_ID,NULL, MMT.INVENTORY_ITEM_ID ,:P_DATE_FROM) OPEN_QTY,
----=====================================================================================
MMT.SUBINVENTORY_CODE SUBINVENTORY,
NULL LOCATION,
TO_CHAR(MMT.TRANSACTION_DATE,'DD/MM/RRRR HH24:MI:SS')  TRANSACTION_DATE,
----MMT.TRANSACTION_DATE  TRANSACTION_DATE,
MMT.TRANSACTION_TYPE_ID,
(SELECT TRANSACTION_TYPE_NAME  FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID ) TRANSACTION_TYPE,
MMT.TRANSACTION_ID,
DECODE(MMT.TRANSACTION_TYPE_ID,
                                    21,(SELECT SHIPMENT_NUMBER FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_SOURCE_TYPE_ID=13 AND TRANSACTION_TYPE_ID=21 AND TRANSACTION_ID=MMT.TRANSACTION_ID),
                                    XX_INV_PKG.XX_INV_TRANS_NO(MMT.TRANSACTION_ID)) TRANSACTION_NO,
-----==========================================================================================================
MMT.ORGANIZATION_ID,
MMT.TRANSACTION_DATE,
MMT.INVENTORY_ITEM_ID,
---==================================CALCULATION PART ==========================================================
NVL((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID AND PRIMARY_QUANTITY>0),0) RECEIVE_QTY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID AND PRIMARY_QUANTITY<0)),0) ISSUE_QTY, 
(SELECT NVL(SUM(PRIMARY_QUANTITY),0)  FROM  MTL_MATERIAL_TRANSACTIONS WHERE  ORGANIZATION_ID=MMT.ORGANIZATION_ID AND INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID  AND TRANSACTION_ID <=MMT.TRANSACTION_ID) CLOSE_QTY,
----==========================================================================================================
NULL REMARKS
--XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME ,
--TO_DATE(:P_DATE_FROM) DATE_FROM,
--TO_DATE(:P_DATE_TO) DATE_TO 
FROM 
MTL_MATERIAL_TRANSACTIONS MMT, 
WBI_INV_ORG_DETAIL WIOD,
WBI_XXKBGITEM_MT_D WXMD
WHERE 
MMT.ORGANIZATION_ID=WIOD.INV_ORGANIZATION_ID
--=====================================
AND WXMD.INVENTORY_ITEM_ID =MMT.INVENTORY_ITEM_ID
AND WXMD.ORGANIZATION_ID= MMT.ORGANIZATION_ID
---=====================================
AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
--AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE) 
--AND MMT.ORGANIZATION_ID=NVL(:P_ORG_ID, MMT.ORGANIZATION_ID)
--AND TRUNC( TRANSACTION_DATE) BETWEEN TO_DATE(:P_DATE_FROM) AND TO_DATE(:P_DATE_TO)
ORDER BY MMT.TRANSACTION_ID

--=======================================================

select * from MTL_MATERIAL_TRANSACTIONS MMT where CREATION_DATE between '19-JUN-2019' and '20-JUN-2019'  --and TRANSACTION_TYPE_ID = 42

select * from MTL_TRANSACTION_TYPES where TRANSACTION_TYPE_ID = 42   -- creation_date between '18-JAN-2019' and '20-JAN-2019'

select * from MTL_MATERIAL_TRANSACTIONS  where TRANSACTION_TYPE_ID = 42 

select * from WBI_XXKBGITEM_MT_D  

select * from  MTL_TRANSACTION_ACCOUNTS

select * from GL_CODE_COMBINATIONS

select * from MTL_ITEM_ATTRIBUTES             

select * from MTL_CATEGORY_SETS_B

select * from MTL_TRANSACTIONS_INTERFACE where DISTRIBUTION_ACCOUNT_ID = 11005


