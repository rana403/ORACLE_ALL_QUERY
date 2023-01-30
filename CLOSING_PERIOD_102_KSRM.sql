1. OPM Batch Close or Not 
2. IVA Problem Have or not 
3. Inventory Period must need to open 
4. Reverse inventory data if required
5. Run 30 query
6. Run draft process

--=-==========================================================

From inventory perspective there is no pending issues or dependency to run draft Accounting in KBIL SEP-18 in UAT 

--================================================
-- TO GET INVENTORY PERIOD STATUS
--================================================

SELECT * FROM ORG_ORGANIZATION_DEFINITIONS where LEGAL_ENTITY = 26280



SELECT  OOD.OPERATING_UNIT "OPERATING_UNIT",
ood.organization_id "Organization ID" ,
  ood.organization_code "Organization Code" ,
  ood.organization_name "Organization Name" ,
  oap.period_name "Period Name" ,
  oap.period_start_date "Start Date" ,
  oap.period_close_date "Closed Date" ,
  oap.schedule_close_date "Scheduled Close" ,
  DECODE(oap.open_flag, 'P','P - Period Close is processing' ,
                        'N','Close' ,
                        'Y','open ' ,'Unknown') "Period Status"
FROM org_acct_periods oap,
  org_organization_definitions ood
WHERE oap.organization_id = ood.organization_id
--AND (TRUNC(SYSDATE) -- Comment line if a a date other than SYSDATE is being tested.
--  --AND ('01-DEC-2014' -- Uncomment line if a date other than SYSDATE is being tested.
--  BETWEEN TRUNC(oap.period_start_date) AND TRUNC (oap.schedule_close_date))
  and oap.period_name  = 'Apr-22'
  --and OOD.OPERATING_UNIT IN(81,361,382) -- KSPL
  --  and OOD.OPERATING_UNIT IN(104) -- KBIL
    --and OOD.OPERATING_UNIT IN(102) --
 and    OOD.OPERATING_UNIT IN( 101,102,103) -- KSRM
ORDER BY ood.organization_id, 
  oap.period_start_date
-- If Period Status is 'Y' and Closed Date is not NULL then the closing of the INV period failed.

SELECT * FROM HR_OPERATING_UNITS

--===================================================================
-- TO GET  AP, AR, GL,  PERIOD STATUS
--===================================================================

SELECT ROWID,
 (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) LE,
  (SELECT PRODUCT_CODE
  FROM fnd_application fa
  WHERE fa.application_id = gps.application_id
  ) application,
  (SELECT name
  FROM gl_sets_of_books gsp
  where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID
  ) SETOFBOOK,
  period_name,
  closing_status,
  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) status,
  period_num,
  period_year,
  start_date,
  end_date
from GL_PERIOD_STATUSES GPS
WHERE 1=1
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ('AP', 'AR', 'PO', 'GL')
and period_name like '%Apr%22%'  
and  PERIOD_NAME NOT LIKE '%Adj%' 
and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID) IN ('102-KSRM Steel Plant Ltd')
ORDER BY period_year DESC, 
period_num DESC  




SELECT NAME, DESCRIPTION FROM GL_SETS_OF_BOOKS GSP ORDER BY NAME


select * from  ORG_ORGANIZATION_DEFINITIONS WHERE 
OPERATING_UNIT IN( 101,102,103)
-- and OPERATING_UNIT=81



--================================
-- INVENTORY PENDING TRANSACTIONS 
--===============================

select * from ORG_ORGANIZATION_DEFINITIONS where ORGANIZATION_ID= 142

select * from RCV_SHIPMENT_HEADERS where SHIPMENT_HEADER_ID= 994991

select * from RCV_SHIPMENT_LINES where SHIPMENT_HEADER_ID= 995165

SELECT * FROM RCV_TRANSACTIONS_INTERFACE WHERE  TO_CHAR(TRANSACTION_DATE,'MON-YY')='FEB-20'  and ORG_ID= 81

SELECT COUNT(*)
   FROM WSH_DELIVERY_DETAILS     WDD,
        WSH_DELIVERY_ASSIGNMENTS WDA,
        WSH_NEW_DELIVERIES       WND,
        WSH_DELIVERY_LEGS        WDL,
        WSH_TRIP_STOPS          WTS
  WHERE WDD.SOURCE_CODE = 'OE'
    AND WDD.RELEASED_STATUS = 'C'
    AND WDD.INV_INTERFACED_FLAG IN ('N', 'P')
  --  AND WDD.ORGANIZATION_ID = :Organization_ID
    AND WDA.DELIVERY_DETAIL_ID = WDD.DELIVERY_DETAIL_ID
    AND WND.DELIVERY_ID = WDA.DELIVERY_ID
    AND WND.STATUS_CODE IN ('CL', 'IT')
    AND WDL.DELIVERY_ID = WND.DELIVERY_ID
    AND WTS.PENDING_INTERFACE_FLAG IN ('Y', 'P')
    AND TRUNC(WTS.ACTUAL_DEPARTURE_DATE) BETWEEN
        TO_DATE('01-FEB-2020 00:00:00', 'DD-MON-YYYY HH24:MI:SS') AND
        TO_DATE('29-FEB-2020 23:59:59', 'DD-MON-YYYY HH24:MI:SS')
    AND WDL.PICK_UP_STOP_ID = WTS.STOP_ID





select * from ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE = 'PWM'

SELECT * FROM RCV_TRANSACTIONS  WHERE TRANSACTION_DATE  between '01-DEC-2019' AND '31-DEC-2219'   

select *  from RCV_SHIPMENT_LINES WHERE ITEM_ID IN (243, 244)  and  CREATION_DATE  between '01-DEC-2019' AND '31-DEC-2019'   and FROM_ORGANIZATION_ID=160


select * from PO_HEADERS_ALL

SELECT *
 FROM PO_HEADERS_ALL a, PO_LINES_ALL b 
 WHERE a.po_header_id= b.po_header_id
 and  b.ITEM_ID IN (243, 244) and approved_date  between '01-DEC-2019' AND '31-DEC-2019' 
 
 --================================================================
-- TO CHECK  RECEIVING DATE AND MATL DATE ARE SAME OR NOT  FOR ALL ITEMS MONTH WISE
--================================================================
SELECT MMT.TRANSACTION_ID,
 -- INVORG_NAME_FROM_ID (a.SHIP_TO_ORG_ID) INV_ORG,
 INVORG_NAME_FROM_ID (b.FROM_ORGANIZATION_ID) FROM_ORGANIZATION_ID, b.PO_HEADER_ID,
 GET_LC_FROM_PO_ID(b.PO_HEADER_ID) LC_NUMBER,
 GET_PONUM_FROM_ID(b.PO_HEADER_ID) PO_NUMBER ,
 a.ship_to_org_id,
  INVORG_NAME_FROM_ID (b.TO_ORGANIZATION_ID) TO_ORGANIZATION_ID,
 XXGET_ITEM_DESCRIPTION(b.ITEM_ID) , d.DESCRIPTION ,a.SHIPMENT_HEADER_ID,a.RECEIPT_NUM, a.SHIPMENT_NUM,b.SHIPMENT_LINE_ID,
TO_CHAR(TRUNC(a.CREATION_DATE),'DD-MON-RRRR') GRN_CREATION_DATE, TO_CHAR(TRUNC( c.TRANSACTION_DATE),'DD-MON-RRRR') DELIVERD_DATE,  TO_CHAR(TRUNC(MMT.TRANSACTION_DATE),'DD-MON-RRRR') MTL_TRANSACTION_DATE
FROM RCV_SHIPMENT_HEADERS a ,RCV_SHIPMENT_LINES b, RCV_TRANSACTIONS c , mtl_material_transactions MMT, MTL_SYSTEM_ITEMS_B d
WHERE a.SHIPMENT_HEADER_ID = b.SHIPMENT_HEADER_ID
and b.SHIPMENT_HEADER_ID = c.SHIPMENT_HEADER_ID 
and b.SHIPMENT_LINE_ID = c.SHIPMENT_LINE_ID
and c.transaction_id=mmt.RCV_TRANSACTION_ID
and b.ITEM_ID= d.INVENTORY_ITEM_ID
and a.ship_to_org_id= d.ORGANIZATION_ID
and c.TRANSACTION_TYPE = 'DELIVER'
--and b.ITEM_ID IN (243, 244)
--and a.RECEIPT_NUM= 80000288
and a.ship_to_ORG_ID= 166
--and GET_LC_FROM_PO_ID(b.PO_HEADER_ID) = '1554-18-02-0077'
and TRUNC(c.TRANSACTION_DATE)  between '01-OCT-2018' AND '31-OCT-2018'    --  TOW LINES ARE  27-MAY-2020
 AND TRUNC(MMT.TRANSACTION_DATE)  >  '31-OCT-2018'
--and TRUNC(c.TRANSACTION_DATE)  between '01-NOV-2019' AND '30-NOV-2019'   
 
 
 select * from MTL_SYSTEM_ITEMS_B
 
--================================================================
-- TO CHECK  RECEIVING DATE AND MATL DATE ARE SAME OR NOT  FOR POWER ITEMS
--================================================================
SELECT MMT.TRANSACTION_ID,
 -- INVORG_NAME_FROM_ID (a.SHIP_TO_ORG_ID) INV_ORG,
 INVORG_NAME_FROM_ID (b.FROM_ORGANIZATION_ID) FROM_ORGANIZATION_ID,
  INVORG_NAME_FROM_ID (b.TO_ORGANIZATION_ID) TO_ORGANIZATION_ID,
 XXGET_ITEM_DESCRIPTION(b.ITEM_ID) , a.SHIPMENT_HEADER_ID,a.RECEIPT_NUM, a.SHIPMENT_NUM,b.SHIPMENT_LINE_ID,
TO_CHAR(TRUNC(a.CREATION_DATE),'DD-MON-RRRR') GRN_CREATION_DATE, TO_CHAR(TRUNC( c.TRANSACTION_DATE),'DD-MON-RRRR') DELIVERD_DATE,  TO_CHAR(TRUNC(MMT.TRANSACTION_DATE),'DD-MON-RRRR') MTL_TRANSACTION_DATE
FROM RCV_SHIPMENT_HEADERS a ,RCV_SHIPMENT_LINES b, RCV_TRANSACTIONS c , mtl_material_transactions MMT--, MTL_SYSTEM_ITEMS_B d
WHERE a.SHIPMENT_HEADER_ID = b.SHIPMENT_HEADER_ID
and b.SHIPMENT_HEADER_ID = c.SHIPMENT_HEADER_ID 
and b.SHIPMENT_LINE_ID = c.SHIPMENT_LINE_ID
and c.transaction_id=mmt.RCV_TRANSACTION_ID
--and b.ITEM_ID= d.INVENTORY_ITEM_ID
and c.TRANSACTION_TYPE = 'DELIVER'
and b.ITEM_ID IN (243, 244)
and a.RECEIPT_NUM= 80000288
--and ship_to_ORG_ID= 121
and TRUNC(c.TRANSACTION_DATE)  between '01-APR-2020' AND '30-APR-2020'    --  TOW LINES ARE  27-MAY-2020
--and TRUNC(c.TRANSACTION_DATE)  between '01-NOV-2019' AND '30-NOV-2019'   






--===========================

--QUERY WITH MTL TABLE
Select mtt.transaction_id, RSH.SHIPMENT_HEADER_ID,
TO_CHAR(TRUNC(MTT.TRANSACTION_DATE) ,'DD-MON-RRRR') MTL_TRASNT_DATE,
TO_CHAR(TRUNC(RSH.CREATION_DATE),'DD-MON-RRRR') GRN_CREATION_DATE,
TO_CHAR(TRUNC(RT.TRANSACTION_DATE),'DD-MON-RRRR') GRN_CREATION_DATE
 from mtl_material_transactions mtt , rcv_shipment_headers rsh , rcv_shipment_lines rsl,rcv_transactions rt
where rsh.SHIPMENT_HEADER_ID=rsl.SHIPMENT_HEADER_ID
and rsl.SHIPMENT_HEADER_ID=rt.SHIPMENT_HEADER_ID
and rsl.SHIPMENT_LINE_ID=rt.SHIPMENT_LINE_ID
and rt.transaction_id=mtt.RCV_TRANSACTION_ID
and rt.transaction_type='DELIVER'
and RSH.RECEIPT_NUM= 80000288
--and  MTT.TRANSACTION_DATE = TO_DATE('12/26/2019 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
AND RSH.SHIP_TO_ORG_ID = 160


select * from MTL_MATERIAL_TRANSACTIONS_TEMP where   trunc(transaction_date)  between '01-NOV-2019' and '30-NOV-2019'   -- un processed materials

select * from MTL_MATERIAL_TRANSACTIONS where   trunc(transaction_date)  between '01-NOV-2019' and '30-NOV-2019'   

-- FOR PENDING TRANSACTION RELEASE---> RUN THE REPORT FROM --> ORDER MANAGEMENT ADMINSTRATOR--> Interface Trip Stop - SRS ---


-- ORDER MANAGEMENT  Pending Data findings

SELECT 
to_char(WTS.ACTUAL_DEPARTURE_DATE,'MON-YY') PERIOD,
WDD.DELIVERY_DETAIL_ID,
WDD.SOURCE_CODE,
WDD.SOURCE_HEADER_ID,
WDD.SOURCE_LINE_ID,
WDD.SOURCE_HEADER_TYPE_ID,
WDD.CUSTOMER_ID,
WDD.INVENTORY_ITEM_ID,
WDD.ITEM_DESCRIPTION,
WDD.SHIP_FROM_LOCATION_ID,
WDD.ORGANIZATION_ID,
WDD.SHIP_TO_LOCATION_ID,
WDD.DELIVER_TO_LOCATION_ID,
WDD.SRC_REQUESTED_QUANTITY,
WDD.SRC_REQUESTED_QUANTITY_UOM,
WDD.REQUESTED_QUANTITY,
WDD.REQUESTED_QUANTITY_UOM,
WDD.SHIPPED_QUANTITY,
WDD.DELIVERED_QUANTITY,
WDD.MOVE_ORDER_LINE_ID,
WDD.SUBINVENTORY,
WDD.LOT_NUMBER,
WDD.RELEASED_STATUS,
WDD.DATE_REQUESTED,
WDD.DATE_SCHEDULED,
WDD.ORG_ID,
WDD.TRACKING_NUMBER, 
WDD.CREATED_BY,
WDD.SEAL_CODE,
WDD.UNIT_PRICE,
WDD.SOURCE_HEADER_NUMBER,
WDD.SOURCE_LINE_NUMBER,
WDD.PICKABLE_FLAG,
WDD.TRANSACTION_ID,
WDA.DELIVERY_ID,
WDA.DELIVERY_DETAIL_ID,
WND.NAME,
WND.STATUS_CODE,
WND.ROUTING_INSTRUCTIONS,
WTS.STOP_ID,
WTS.TRIP_ID,
WTS.BATCH_ID
   FROM WSH_DELIVERY_DETAILS     WDD,
        WSH_DELIVERY_ASSIGNMENTS WDA,
        WSH_NEW_DELIVERIES       WND,
        WSH_DELIVERY_LEGS        WDL,
        WSH_TRIP_STOPS           WTS
  WHERE WDD.SOURCE_CODE = 'OE'
    AND WDD.RELEASED_STATUS = 'C'
    AND WDD.INV_INTERFACED_FLAG IN ('N', 'P')
    --AND WDD.ORGANIZATION_ID = :Organization_ID
    AND WDA.DELIVERY_DETAIL_ID = WDD.DELIVERY_DETAIL_ID
    AND WND.DELIVERY_ID = WDA.DELIVERY_ID
    AND WND.STATUS_CODE IN ('CL', 'IT')
    AND WDL.DELIVERY_ID = WND.DELIVERY_ID
    AND WTS.PENDING_INTERFACE_FLAG IN ('Y', 'P')
    and to_char(WTS.ACTUAL_DEPARTURE_DATE,'MON-YY')=:P_PERIOD_CODE 
--    AND TRUNC(WTS.ACTUAL_DEPARTURE_DATE) BETWEEN
--        TO_DATE('01-NOV-2019 00:00:00', 'DD-MON-YYYY HH24:MI:SS') AND
--        TO_DATE('30-NOV-2019 23:59:59', 'DD-MON-YYYY HH24:MI:SS')
    AND WDL.PICK_UP_STOP_ID = WTS.STOP_ID
    
    
    

---------------------------------------------------------------------------------------------------------------------------------------
--CONSUMPTION CHAEK: WHEN f.SEGMENT1 in ('FG', 'CV','BI','FA','CP','TR'  ), IT WILL NEVER IN THIS ACCOUNT c.segment4 in (6010203) --> SO  'FG', 'CV','BI','FA','CP' , 'TR'  WILL NEVER GO IN GL CODE  6010203
-------------------------------------------------------------------------------------------------------------------------------------
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
AND f.SEGMENT1 in ('FG', 'CV','BI','FA','CP', 'TR')  
AND c.segment4 in (6010203)

--========================================================================================
--=================================================================================================================
/*Iva PENDING IF AVAILABLE Transaction Before Running Process*/

select  distinct XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) ACCOUNT_DESC FROM GL_CODE_COMBINATIONS WHERE SEGMENT4 in (2010101,2010102,2010103,2010104,2010105)

--select * from MTL_TXN_REQUEST_HEADERS

-- IVA FINDINGS BEFORE DRAFT ACCOUNTING

select to_char(transaction_date,'MON-YY') PERIOD, c.segment4 GL_CODE,
SET_OF_BOOKS_ID LEDGER_ID,
ORGANIZATION_NAME,
ORGANIZATION_CODE, 
REQUEST_NUMBER,
f.CONCATENATED_SEGMENTS,
d.ORGANIZATION_ID, 
OPERATING_UNIT, 
a.TRANSACTION_TYPE_ID, 
--b.CREATED_BY, 
 XX_GET_EMP_NAME_FROM_USER_ID (B.CREATED_BY) CREATED_BY, 
TRANSACTION_TYPE_NAME,
XX_GET_ACCT_FLEX_SEG_DESC(4,c.SEGMENT4) ACCOUNT_DESC,
a.DESCRIPTION,
TRANSACTION_ID,
b.INVENTORY_ITEM_ID,
CODE_COMBINATION_ID,
c.CONCATENATED_SEGMENTS      
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
AND TRANSACTION_TYPE_NAME in ('Issue Return','Move Order Issue','Move Order Issue of FL','Move Order Issue from HO Store Branding','Move Order Issue from HO Store Stationary','Move Order Issue from HO Vehicle Repair','Move Order FG Issue','Move Order Issue To Project','Miscellaneous issue','Miscellaneous receipt')
--and c.SEGMENT4 in (2010101,2010102,2010103,2010104,2010105)    
AND c.segment4 in(
2010101,2010102,2010103,2010104,2010105, -- INVENTORY ACCOUNT
1010101,  -- ASSET ACCOUNT
1010102,
1010103,
1010104,
1010105,
1010106,
1010107,
1010108,
1010109,
1010110,
1010111,
1010112,
1010113,
1010114,
5020114 -- MISCLINIUS INCOME
--1030101,-- 
--6010206,
--6010217,
--6010203
)


--
--
--/*Updated by REAZ Bhai IVA query Adeed Operating Unit and  mismatch segment2 */
--/*Last Update by Reyaz _ Fixed asset code and Item Code combination*/
--select to_char(transaction_date,'MON-YY') PERIOD,
--SET_OF_BOOKS_ID LEDGER_ID,
--ORGANIZATION_NAME,
--ORGANIZATION_CODE, 
--REQUEST_NUMBER,
--f.CONCATENATED_SEGMENTS,
--d.ORGANIZATION_ID, 
--OPERATING_UNIT, 
--a.TRANSACTION_TYPE_ID, 
----b.CREATED_BY, 
-- XX_GET_EMP_NAME_FROM_USER_ID (B.CREATED_BY) CREATED_BY, 
--TRANSACTION_TYPE_NAME,
--XX_GET_ACCT_FLEX_SEG_DESC(4,c.SEGMENT4) ACCOUNT_DESC,
--a.DESCRIPTION,
--TRANSACTION_ID,
--b.INVENTORY_ITEM_ID,
--CODE_COMBINATION_ID,
--c.CONCATENATED_SEGMENTS      
--from mtl_transaction_types a, MTL_MATERIAL_TRANSACTIONS b, gl_code_combinations_kfv c, org_organization_definitions d, MTL_TXN_REQUEST_HEADERS e , mtl_system_items_kfv f
--WHERE -- a.transaction_id=46678 and 
--a.transaction_type_id=b.transaction_type_id 
--AND b.INVENTORY_ITEM_ID=f.INVENTORY_ITEM_ID
--AND d.ORGANIZATION_ID=f.ORGANIZATION_ID
-- AND b.transaction_source_id= e.header_id(+)
--and b.DISTRIBUTION_ACCOUNT_ID=c.code_combination_id
--and b.ORGANIZATION_ID=d.ORGANIZATION_ID
--and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE 
----and transaction_date between '01-SEP-2019' and '30-SEP-2019'
--and SET_OF_BOOKS_ID=:P_LEDGER_ID
--AND OPERATING_UNIT=:P_OPERATING_UNIT
--AND c.SEGMENT2 <>:P_SEGMENT2  -- FOR WRONG  GL WITHOUT IVA
---- FOR WRONG  GL WITH IVA
--and SET_OF_BOOKS_ID=:P_LEDGER_ID
----AND TRUNC(TRANSACTION_TYPE_NAME) in ('Move Order Issue','Move Order Issue of FL','Move Order Issue from HO Store Branding','Move Order Issue from HO Store Stationary','Move Order Issue from HO Vehicle Repair','Move Order Issue To Project','Miscellaneous issue','Miscellaneous receipt')
----and c.SEGMENT4 in (2010101,2010102,2010103,2010104,2010105)    
--AND c.segment4 in(
--2010101,2010102,2010103,2010104,2010105, -- INVENTORY ACCOUNT
--1010101,  -- ASSET ACCOUNT
--1010102,
--1010103,
--1010104,
--1010105,
--1010106,
--1010107,
--1010108,
--1010109,
--1010110,
--1010111,
--1010112,
--1010113,
--1010114,
--5020114, -- MISCLINIUS INCOME
--5020109
----1030101,-- 
----6010206,
----6010217,
----6010203
--)










--CLOSING SEP-19 IN UAT
   Create table MTL_TRANSACTIONS_INTERFCE_0919 as  select * from MTL_TRANSACTIONS_INTERFACE  where TRANSACTION_DATE   between  '01-SEP-2019' and '30-SEP-2019'



--GL EXPENCE CODE

SELECT * FROM GL_ALOC_EXP 




SELECT *
  FROM RCV_TRANSACTIONS_INTERFACE
  WHERE TO_ORGANIZATION_ID   = 121
  AND TRANSACTION_DATE      <= '30-NOV-2019'
 -- AND DESTINATION_TYPE_CODE IN ('INVENTORY','SHOP FLOOR')
    AND DESTINATION_TYPE_CODE IN ('INVENTORY')
    
    select * from MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID = 4619753
    
    select * from RCV_SHIPMENT_HEADERS where shipment_num IN('4191010050962' , '4191010049284') -- '4191010022692'
    
select * from RCV_TRANSACTIONS_INTERFACE  where TRANSACTION_DATE   between  '01-SEP-2019' and '30-SEP-2019'
   
   
    
    select * from MTL_TRANSACTIONS_INTERFACE  where TRANSACTION_DATE   between  '01-SEP-2019' and '30-SEP-2019'
    
    select * FROM RCV_TRANSACTIONS WHERE SHIPMENT_HEADER_ID= 680735 --and 
    
    select * from PO_REQUISITION_HEADERS_ALL WHERE REQUISITION_HEADER_ID= 1216682
    
    select * from MTL_TRANSACTIONS_INTERFACE_V where TRANSACTION_DATE       between  '01-SEP-2019' and '30-SEP-2019'
    
    select * from  RCV_VIEW_INTERFACE_V where TRANSACTION_DATE   between  '01-SEP-2019' and '30-SEP-2019' and ORGANIZATION_ID in (
    121
--150,
--149,
--148,
--147,
--146,
--145,
--144,
--143,
--142,
--141
    )

    
    select distinct TRANSACTION_TYPE from RCV_VIEW_INTERFACE_V
    
    select * from ORG_ORGANIZATION_DEFINITIONS WHERE OPERATING_UNIT=81


--==================================
-- GET INTERNAL IR ISO THAT IS CHALLAN IS COMPLETED BUT NOT RECEIVE
--=================================
/* XXKSRM Challan Wise Dlelivery And Consumption Report */ 
 SELECT DISTINCT
           -- ooh.org_id,
            APPS.XXGET_OU_NAME_FROM_ID(OOH.ORG_ID) OU,
             XXGET_ORG_NAME(WDD.ORGANIZATION_ID) WAREHOUSE,
           xx_get_INTERNAL_customer_name ( WDD.CUSTOMER_ID)  CUSTOMER_NAME ,
             wdd.REQUESTED_QUANTITY_UOM UOM,
             WND.CONFIRM_DATE  CHALLAN_DATE,
      --    TD.VEHICLE_TYPE,
           --  ooh.fob_point_code FOB , 
                          WND.NAME CHALLAN_NO,                     
                        TD.REG_NO,
                        TO_CHAR (TD.TRIPSYS_NO) TRIPSYS_NO,
                        WDD.CUSTOMER_ID CUSTOMER_ID,
           NVL(SUM(WDD.SHIPPED_QUANTITY),0) CHALLAN_QUANTITY,
                       NVL(TD.FUEL_ISSUED,0)  FUEL_ISSUED
        -- XX_TOTAL_FUEL(:P_ORG_ID ,:P_VEHICLE_NO ,:P_FROM_DT ,:P_TO_DT )
       FROM                                     
            OE_ORDER_HEADERS_ALL OOH,
            OE_ORDER_LINES_ALL OOL,
            WBI_ONT_PARTY_LOCATION_D LOC,
            WSH_DELIVERY_ASSIGNMENTS WDA,
            WSH_NEW_DELIVERIES WND,
                  WSH_DELIVERY_DETAILS WDD
               LEFT JOIN
                  XX_ONT_TRIP_V TD
               ON WDD.DELIVERY_DETAIL_ID = TD.DELIVERY_DETAIL_ID
               AND TD.TRIP_STATUS = 'C'
                  LEFT JOIN XXTRIPDTLS_ALL B
                  ON B.TRIPSYS_NO = TD.TRIPSYS_NO
            LEFT JOIN
               XX_ONT_ORDER_HEADER_DFF_V HDFF
            ON WDD.SOURCE_HEADER_ID = HDFF.HEADER_ID
      WHERE     OOH.HEADER_ID = OOL.HEADER_ID
            AND OOH.SHIP_TO_ORG_ID = LOC.SHIP_TO_ORG_ID
            AND OOL.HEADER_ID = WDD.SOURCE_HEADER_ID
            AND OOL.LINE_ID = WDD.SOURCE_LINE_ID
            AND WDD.ORGANIZATION_ID = 121
            AND WDD.DELIVERY_DETAIL_ID = WDA.DELIVERY_DETAIL_ID
            AND WDA.DELIVERY_ID = WND.DELIVERY_ID
            AND    TD.REG_NO IS NOT NULL
              AND  (:P_OU IS NULL OR OOH.ORG_ID =  :P_OU)
            AND (:P_VEHICLE_TYPE IS NULL OR TD.VEHICLE_TYPE= :P_VEHICLE_TYPE )
          AND ( WND.CONFIRM_DATE  BETWEEN :P_FROM_DATE AND :P_TO_DATE OR :P_FROM_DATE IS NULL OR :P_TO_DATE IS NULL)
          AND  WND.NAME = NVL(:P_CHALLAN_NO,WND.NAME) -- 4191010047951
           -- and wnd.name= '4191010046863'
            GROUP BY   OOH.ORG_ID,
                        TD.REG_NO,
                      TO_CHAR (TD.TRIPSYS_NO) ,
                     --    td.FUEL_ISSUED,
                          WDD.ORGANIZATION_ID,
                          WND.NAME,
                         --  ooh.fob_point_code,
                          --   TD.VEHICLE_TYPE,
                           TD.FUEL_ISSUED,
                           WDD.CUSTOMER_ID,
                           wdd.REQUESTED_QUANTITY_UOM,
                           WND.CONFIRM_DATE
   ORDER BY  WND.NAME 


select * from MTL_MATERIAL_TRAnsactions_temp
where to_char (transaction_date, 'MM-YYYY')='07-2019'

select * from receiving_transactions_temp

select * from all_objects
where object_name like '%RCV%TRANSACTION%'
and object_type='TABLE'

SELECT * FROM RCV_TRANSACTIONS_INTERFACE
WHERE TO_CHAR (TRANSACTION_DATE, 'MM-YYYY')='08-2019' --- JUL-19
--and TRANSACTION_STATUS_CODE  <> 'ERROR'
AND ORG_ID=81

select * from RCV_SHIPMENT_HEADERS WHERE SHIP_TO_ORG_ID = 121 and SHIPMENT_NUM ='4191010049284'  --  '4191010047951'

--Pending Transaction in transaction summary status scerre 
select * from RCV_VIEW_INTERFACE_V where transaction_date between '01-AUG-2019' and '31-AUG-2019' and TRANSACTION_TYPE = 'DELIVER'



-- FOR BACKUP
CREATE TABLE RCV_TRANS_INTERFACE_0819BK AS SELECT * FROM RCV_TRANSACTIONS_INTERFACE WHERE  TO_CHAR(TRANSACTION_DATE,'mm-yyyy')='08-2019'  AND ORG_ID=81

CREATE TABLE RCV_TRANS_INTERFACE_0819BK AS SELECT * FROM RCV_TRANSACTIONS_INTERFACE WHERE  TO_CHAR(TRANSACTION_DATE,'mm-yyyy')='09-2019'  AND ORG_ID=81

select * from RCV_TRANS_INTERFACE_0819BK

SELECT * FROM RCV_TRANSACTIONS_INTERFACE
WHERE TO_CHAR (TRANSACTION_DATE, 'MM-YYYY')='08-2019' and ORG_ID=81

DELETE FROM RCV_TRANSACTIONS_INTERFACE 
WHERE TO_CHAR (TRANSACTION_DATE, 'MM-YYYY')='08-2019' and ORG_ID=81

  
SELECT distinct PRODUCT_CODE  FROM fnd_application fa

select * from GL_PERIOD_STATUSES where period_name= 'Sep-18'

select * from fnd_application
  
  --=============================================================================================
 --GET PENDING TRANSACTION IN INVENTORY
  --=============================================================================================
  
  SELECT *
 -- ,COUNT(mmtt.transaction_temp_id)
FROM MTL_MATERIAL_TRANSACTIONS_TEMP mmtt
WHERE mmtt.ORGANIZATION_ID = 121
AND mmtt.TRANSACTION_DATE <='31-AUG-2019'
--AND NVL(mmtt.TRANSACTION_STATUS,0) <> 2

SELECT *
FROM MTL_MATERIAL_TRANSACTIONS_TEMP mmtt
WHERE mmtt.ORGANIZATION_ID = 121
AND mmtt.TRANSACTION_DATE between '01--2021' and '31-JAN-2021'

1235


/*Iva Transaction After Running Process*/

select *
 from (
SELECT INV_TRANS.ORGANIZATION_CODE,INV_TRANS.GRN,INV_TRANS.TXN_ID,INV_TRANS.XLA_HEADER_ID,FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.ORGANIZATION_ID,INV_TRANS.LEDGER_ID, INV_TRANS.OPERATING_UNIT, INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,
INV_TRANS.EVENT_TYPE_CODE,INV_TRANS.TRANSACTION_TYPE_ID,
CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.EVENT_TYPE_CODE ELSE INV_TRANS.TRANSACTION_TYPE_NAME END TRANSACTION_TYPE_NAME,
INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,
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
SUM(nvl(INV_TRANS.TRANSACTION_VALUE,0)) TRANS_VAL,
INV_TRANS.je_category_name,INV_TRANS.accounting_class_code,
SUM(INV_TRANS.ACCOUNTED_DR) DR,SUM(INV_TRANS.ACCOUNTED_CR) CR ,INV_TRANS.ACCOUNTING_CODE, INV_TRANS.SEGMENT4
FROM
(SELECT to_char(transaction_date,'MON-YY') PERIOD_CODE,
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
TRANSACTION_QUANTITY,TRANSACTION_VALUE,e.accounted_dr,e.accounted_cr,f.concatenated_segments accounting_code,f.SEGMENT4
FROM GMF_XLA_EXTRACT_HEADERS a,mtl_system_items_b b,org_organization_definitions c,xla_ae_headers d,xla_ae_lines e,gl_code_combinations_kfv f,mtl_transaction_types g
WHERE -- a.transaction_id=46678 and 
a.inventory_item_id=b.inventory_item_id(+) and a.organization_id=b.organization_id(+) and A.organization_id=c.organization_id  and a.transaction_type_id=g.transaction_type_id(+)
and a.event_id=d.event_id and d.ae_header_id=e.ae_header_id and e.code_combination_id=f.code_combination_id
and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE 
and a.ledger_id=:P_LEDGER_ID) INV_TRANS 
LEFT OUTER JOIN  (SELECT  MIC.INVENTORY_ITEM_ID,MIC.ORGANIZATION_ID,MC.SEGMENT1 MEJOR_FIN_CAT,MC.SEGMENT1||'|'||MC.SEGMENT2 FIN_CAT 
                                       FROM MTL_ITEM_CATEGORIES MIC,MTL_CATEGORIES MC WHERE  MIC.CATEGORY_ID=MC.CATEGORY_ID  AND STRUCTURE_ID=50408) FIN_CAT 
                                                ON FIN_CAT.INVENTORY_ITEM_ID=INV_TRANS.INVENTORY_ITEM_ID AND  FIN_CAT.ORGANIZATION_ID=INV_TRANS.ORGANIZATION_ID
GROUP BY GRN,INV_TRANS.TXN_ID,INV_TRANS.XLA_HEADER_ID,FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.ORGANIZATION_CODE,INV_TRANS.LEDGER_ID, INV_TRANS.OPERATING_UNIT,INV_TRANS.ORGANIZATION_ID,INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,INV_TRANS.EVENT_TYPE_CODE,
INV_TRANS.TRANSACTION_TYPE_NAME,INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,INV_TRANS.ACCOUNTING_CODE,INV_TRANS.SEGMENT4,INV_TRANS.TRANSACTION_TYPE_ID,INV_TRANS.je_category_name,INV_TRANS.accounting_class_code
)
where 1=1
AND accounting_class_code ='IVA'
and SEGMENT4 in (2010101,2010102,2010103,2010104,2010105)



  --================================ FAHIM VAI FOR PENDINGING TRANSACTION  RELEASE============================
  
  /*
 * Generic script to delete RTI records which are not appearing in Transaction Status Summary form for deletion.
 * Please refer to bug 9919054.
 *
 * Input for the script :-
 * please replace &interface_transaction_ids with all interface transaction ids separated by comma. 
 *
 * Important Note :
 * Please ensure the scripts are ran on TEST instance first and tested for data 
 * correctness thoroughly. After the scripts are ran, please check the data and 
 * only the correct records are updated before committing.
 * If all goes well, the script can be promoted to the PRODUCTION instance.
 *
 */


--back up date in rti, rli, mtli,mtlt, rsi, msni and msnt
create table rti_bak as 
select * from rcv_transactions_interface
where interface_transaction_id in (&interface_transaction_ids)
and (processing_status_code in ('ERROR','PENDING','RUNNING') or (processing_status_code = 'COMPLETED' and transaction_status_code = 'ERROR'))
and lcm_shipment_line_id is null   / LCM shipment receipt /
and unit_landed_cost is null          / LCM shipment receipt /
and (header_interface_id is NULL OR mobile_txn = 'Y');     


create table rli_bak as
select * from rcv_lots_interface 
where  interface_transaction_id in (select interface_transaction_id
                                    from rti_bak);
create table mtli_bak as 
select * from mtl_transaction_lots_interface
where  product_code = 'RCV' 
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

create table mtlt_bak as 
select * from mtl_transaction_lots_temp
where  product_code = 'RCV' 
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

create table rsi_bak as
select * from rcv_serials_interface
where  interface_transaction_id  in  (select interface_transaction_id
                                     from rti_bak);
create table msni_bak as
select * from mtl_serial_numbers_interface
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

create table msnt_bak as
select * from mtl_serial_numbers_temp
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

--delete data in rti, rli, mtli,mtlt, rsi, msni and msnt
delete rcv_transactions_interface 
where interface_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

delete rcv_lots_interface 
where  interface_transaction_id in (select interface_transaction_id
                                    from rti_bak);

delete mtl_transaction_lots_interface
where  product_code = 'RCV'
and    product_transaction_id in (select interface_transaction_id 
                               from rti_bak);

delete mtl_transaction_lots_temp
where  product_code = 'RCV' 
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

delete rcv_serials_interface
where  interface_transaction_id  in  (select interface_transaction_id
                                     from rti_bak);

delete mtl_serial_numbers_interface
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

delete mtl_serial_numbers_temp
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);
