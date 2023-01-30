
--=========================== GET ALL BATCH WITHIN MONTH ========================================

--SELECT  DISTINCT BATCH_STATUS  FROM GME_BATCH_HEADER

SELECT o.ORGANIZATION_CODE, o.ORGANIZATION_NAME, o.ORGANIZATION_ID,gbh.BATCH_ID,gbh.BATCH_NO,
to_char(gbh.creation_date,'DD-MON-YYYY HH24:MI:SS AM') BATCH_CREATION_DT,
to_char(gbh.ACTUAL_START_DATE,'DD-MON-YYYY HH24:MI:SS AM') ACTUAL_START_DATE ,
to_char(gbh.ACTUAL_CMPLT_DATE,'DD-MON-YYYY HH24:MI:SS AM') ACTUAL_CMPLT_DATE , 
to_char(gbh.BATCH_CLOSE_DATE,'DD-MON-YYYY HH24:MI:SS AM') BATCH_CLOSE_DATE , 
gbh.BATCH_STATUS,
decode(gbh.BATCH_STATUS,3,'Completed',4,'Closed',2,'WIP', -1,'Cancelled',
'Just Created') Batch_Status
FROM GME_BATCH_HEADER gbh,
ORG_ORGANIZATION_DEFINITIONS o
WHERE 1=1 
--and  to_char(CREATION_DATE,'MON-YY')='FEB-22'
and  to_char(ACTUAL_CMPLT_DATE,'MON-YY')='SEP-22'
--and to_char(BATCH_CLOSE_DATE,'MON-YY') > 'FEB-20' 
--and  to_char(BATCH_CLOSE_DATE,'MON-YY') <'FEB-21'
AND gbh.ORGANIZATION_ID=o.ORGANIZATION_ID
AND gbh.BATCH_STATUS <> -1
AND o.ORGANIZATION_ID=163
and gbh.BATCH_NO = 3902
ORDER BY gbh.creation_date desc




select * from ORG_ORGANIZATION_DEFINITIONS where ORGANIZATION_CODE = 'KPM'


  --==================================================== 
--Query 2    
 /* Query to find all batches where batch close date not within this period*/
 --=====================================================
 
select ORGANIZATION_ID, BATCH_ID,BATCH_NO, ACTUAL_START_DATE,--BATCH_STATUS,    
BATCH_CLOSE_DATE, CREATION_DATE 
--MOVE_ORDER_HEADER_ID
from GME_BATCH_HEADER 
where --batch_id in ()
--BATCH_NO=59 and 
ORGANIZATION_ID=163
--and to_char(ACTUAL_START_DATE,'MM-YYYY')='12-2021'
--and to_char(BATCH_CLOSE_DATE,'MM-YYYY')='12-2021'
AND TO_CHAR(ACTUAL_CMPLT_DATE, 'MM-YYYY') = '9-2022'
--and to_char(ACTUAL_START_DATE,'MM-YYYY')<>'12-2021'

--========================================================================



--Query 1
/* Query to find batch detail with their  transaction date*/
SELECT GMD.BATCH_ID,
       GBH.BATCH_NO,
       ACTUAL_START_DATE,
       ACTUAL_CMPLT_DATE,
       BATCH_CLOSE_DATE,
       BATCH_STATUS,
       TRANSACTION_DATE,
       GBH.LAST_UPDATE_DATE,
       GMD.CREATED_BY,
       GMD.ORGANIZATION_ID,
       ACTUAL_QTY,
       GMD.INVENTORY_ITEM_ID,
       TRANSACTION_ID,
       TRANSACTION_TYPE_ID,
       TRANSACTION_QUANTITY
  --,DISTRIBUTION_ACCOUNT_ID
  FROM GME_BATCH_HEADER GBH,
       gme_material_details GMD,
       MTL_MATERIAL_TRANSACTIONS MTL
 WHERE     1 = 1
       AND MTL.transaction_SOURCE_ID = GBH.BATCH_ID
       AND MTL.transaction_SOURCE_ID = GMD.BATCH_ID
       AND GBH.BATCH_ID = GMD.BATCH_ID
       AND GMD.INVENTORY_ITEM_ID = MTL.INVENTORY_ITEM_ID
       AND GBH.ORGANIZATION_ID = 163
       and to_char (trunc (TRANSACTION_DATE),'MON-YYYY')='SEP-2022'  --ACTUAL_CMPLT_DATE, ACTUAL_START_DATE
        AND GBH.BATCH_NO in (3902)
--AND trunc (ACTUAL_CMPLT_DATE)  between '01-DEC-2021' and '31-DEC-2021'

--CASE: QUANTITY MISMATCH: MAMUN BOS FACED A PROBLEM IN KSPL WHERE AGAINST A BATCH 2750 , PRIMARY QUANTITY SHOW 0 BUT SECONDERY QUANTITY HAVE VALUE: BATCH NO: 2750 
--=====================================================================================================

/*
 MTL_MATERIAL_TRANSACTIONS.TRANSACTION_SOURCE_ID =  GME_BATCH_HEADER.BATCH_ID 
 
 GME_MATERIAL_DETAILS.MOVE_ORDER_LINE_ID = MTL_TXN_REQUEST_LINES.LINE_ID
 
*/


--=======================================================================
--CASE : BELLOW QUERY AND UPDATE IS REQUIRED WHEN START DATE IS SEP-2021 BUT ACTUAL COMPLETE DATE IS WRONGLY OCT-2021 THEN 
--=======================================================================


 SELECT * FROM  GME_BATCH_HEADER  WHERE  BATCH_ID in (
3514
)
 

 UPDATE GME_BATCH_HEADER
 SET ACTUAL_CMPLT_DATE = TO_DATE('2/28/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM'),
 LAST_UPDATE_DATE =TO_DATE('2/28/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM'),
 CREATION_DATE = TO_DATE('2/28/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM'),
 ACTUAL_START_DATE = TO_DATE('2/28/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM')
 WHERE  BATCH_ID in (
735775,735773,735768,
735767,
735766
)
AND ORGANIZATION_ID= 176

--======================================
select 
    PLAN_START_DATE,
    PLAN_CMPLT_DATE,
    ACTUAL_START_DATE,
    ACTUAL_CMPLT_DATE,
    a.*
from GME_BATCH_STEP_ACTIVITIES a
where batch_id  IN (
749767
)


UPDATE GME_BATCH_STEP_ACTIVITIES
SET ACTUAL_CMPLT_DATE =TO_DATE('1/30/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM')
where batch_id  IN (
734599,
734598,
734597,
734596
)

--=====================================
select 
    PLAN_START_DATE,
    PLAN_CMPLT_DATE,
    ACTUAL_START_DATE,
    ACTUAL_CMPLT_DATE,
    a.*
from GME_BATCH_STEP_RESOURCES a
where batch_id  IN (
749767
)

------------------------------------------------------------

UPDATE GME_BATCH_STEP_RESOURCES
SET ACTUAL_CMPLT_DATE = TO_DATE('1/30/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM')
where batch_id  IN (
734599,
734598,
734597,
734596
)

--===========================================

select 
    PLAN_START_DATE,
    PLAN_CMPLT_DATE,
    ACTUAL_START_DATE,
    ACTUAL_CMPLT_DATE,
    a.*
from GME_BATCH_STEPS a
where batch_id IN (
749767
)

-------------------------------------------------------------

UPDATE GME_BATCH_STEPS
SET ACTUAL_CMPLT_DATE = TO_DATE('1/30/2022 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM')
where batch_id  IN (
734599,
734598,
734597,
734596
)
 
--===================================================================
 
SELECT CREATION_DATE, LAST_UPDATE_DATE,TRANSACTION_DATE FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_SOURCE_ID IN(
749767
)  -- NOTE: MTL_MATERIAL_TRANSACTIONS.TRANSACTION_SOURCE_ID =  GME_BATCH_HEADER.BATCH_ID 
 
---------------------------------------------------------------------------------------------------------------------------------------------------

 UPDATE MTL_MATERIAL_TRANSACTIONS
  SET LAST_UPDATE_DATE= TO_DATE('1/30/2020 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM'),
  CREATION_DATE=TO_DATE('1/30/2020 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM'),
  TRANSACTION_DATE=TO_DATE('1/30/2020 11:14:02 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE TRANSACTION_SOURCE_ID IN(
711106
)







SELECT mmt.transaction_type_id, mmt.transaction_action_id,
 mtt.transaction_type_name TxnType,
 gbh.batch_no,
 gbh.batch_id,
 mmt.*
FROM mtl_material_transactions mmt,
 mtl_transaction_types mtt ,
 gme_batch_header gbh
WHERE mmt.transaction_source_type_id = 5
AND mtt.transaction_type_id = mmt.transaction_type_id
AND mtt.transaction_action_id = mmt.transaction_action_id
AND gbh.batch_id = mmt.transaction_source_id
AND mtt.transaction_source_type_id = mmt.transaction_source_type_id
AND gbh.BATCH_ID IN(
749767)



--===========================GET BATCH CREATED BY  ========================================

select XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) created_by,  XX_GET_EMP_NAME_FROM_USER_ID (LAST_UPDATED_BY) UPDATED_BY
 from GME_BATCH_HEADER where BATCH_ID= 734023 --and LAST_UPDATED_BY = 1579


--====================== TO GET ALL BATCH INFO DETAILS WITH QTY BETWEEN MONTH =========================
/* Formatted By REAZ VAI */
SELECT        GMD.ORGANIZATION_ID, GMD.BATCH_ID, MTT.TRANSACTION_TYPE_ID, MTT.TRANSACTION_TYPE_NAME,
       GBH.BATCH_NO,
       ACTUAL_START_DATE,
       ACTUAL_CMPLT_DATE,
       BATCH_CLOSE_DATE,
       BATCH_STATUS,
       TRANSACTION_DATE,
       GBH.LAST_UPDATE_DATE,
       GMD.CREATED_BY,
       ACTUAL_QTY,
       GMD.INVENTORY_ITEM_ID,
       TRANSACTION_ID,
       MTL.TRANSACTION_TYPE_ID,
       TRANSACTION_QUANTITY
  --,DISTRIBUTION_ACCOUNT_ID
  FROM GME_BATCH_HEADER GBH,
       gme_material_details GMD,
       MTL_MATERIAL_TRANSACTIONS MTL,
       MTL_TRANSACTION_TYPES  MTT
 WHERE     1 = 1
       AND MTL.transaction_SOURCE_ID = GBH.BATCH_ID
       and MTL.TRANSACTION_TYPE_ID= MTT.TRANSACTION_TYPE_ID
       AND MTL.transaction_SOURCE_ID = GMD.BATCH_ID
       AND GBH.BATCH_ID = GMD.BATCH_ID
       AND GMD.INVENTORY_ITEM_ID = MTL.INVENTORY_ITEM_ID
      AND GBH.ORGANIZATION_ID = 121
       AND TO_CHAR (TRANSACTION_DATE, 'MM-YYYY') = '31-2022'   -- 
      -- and batch_status  IN ( 1,2,3)
      and  TRUNC(ACTUAL_CMPLT_DATE)   BETWEEN '01-DEC-2021' and '31-DEC-2021' 

--====================================================================================

-- TO GET ANY TRANSACTION WHICJ+H IS NOT COMPLETED AND PENDING ON  INTERFACE TABLE
--=====================================================================================----
select * from MTL_TRANSACTIONS_INTERFACE
where to_char (transaction_date,'MON-YYYY')='SEP-2022'
AND ORGANIZATION_ID in (163)


Create:
--------
create table MTL_TRANSACTIONS_INT_nov21 as
 select * from MTL_TRANSACTIONS_INTERFACE
where to_char (transaction_date,'MON-YYYY')='NOV-2021'
AND ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)

Check:
-------
select * from MTL_TRANSACTIONS_INT_nov21


Delete:
--------
--  delete from MTL_TRANSACTIONS_INTERFACE
--  where to_char (transaction_date,'MON-YYYY')='NOV-2021'
--  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)


--===================================================================================================

Find:
-----

select * from   MTL_MATERIAL_TRANSACTIONS_TEMP
where 1=1 --to_char (transaction_date,'MON-YYYY')='SEP-2022'
and ORGANIZATION_ID in (163)
--AND TRANSACTION_HEADER_ID IN(15592152)

SELECT * FROm TABLE_KBM_TEMP

CREATE TABLE TABLE_KBM_TEMP AS 
select * from   MTL_MATERIAL_TRANSACTIONS_TEMP
where 1=1 --to_char (transaction_date,'MON-YYYY')='SEP-2022'
and ORGANIZATION_ID in (163)

DELETE FROM MTL_MATERIAL_TRANSACTIONS_TEMP
WHERE ORGANIZATION_ID in (163)



UPDATE apps.mtl_material_transactions_temp
         SET process_flag      = 'Y',
             lock_flag         = NULL ,
             Transaction_mode  = 3 ,
             Error_code        = NULL ,
             Error_explanation = NULL
             WHERE ORGANIZATION_ID in (163)
AND TRANSACTION_HEADER_ID IN(15592152)


  
Create:
-------
create table mtl_material_trans_temp_nov21 as
select * from MTL_MATERIAL_TRANSACTIONS_TEMP
where to_char (transaction_date,'MON-YYYY')='NOV-2021'
and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)
  
Check:
------
select * from   mtl_material_trans_temp_nov21
  
Delete:
-------
--  delete from MTL_MATERIAL_TRANSACTIONS_TEMP
--   where to_char (transaction_date,'MON-YYYY')='NOV-2021'
--  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)


--=============================================================================

SELECT * FROM MTL_MATERIAL_TRANSACTIONS  WHERE transaction_ID  IN (12738412,
12738465,
12738406,
12738467,
12738407,
12738469,
12738408,
12738471,
12738410,
12738475,
12738411,
12738477,
12738409,
12738473)


-- /Query to update transaction Date into mtl_material_transactions /

UPDATE mtl_material_transactions
   SET TRANSACTION_DATE=
          TO_DATE ('12/30/2021 11:59:00 PM', 'MM/DD/YYYY HH:MI:SS PM')   
 WHERE transaction_ID  IN (12738412,
12738465,
12738406,
12738467,
12738407,
12738469,
12738408,
12738471,
12738410,
12738475,
12738411,
12738477,
12738409,
12738473)
      -- AND TRUNC (TRANSACTION_DATE) > '31-MAR-2020' 
       
       
       select * from   MTL_MATERIAL_TRANSACTIONS_TEMP
  where to_char (transaction_date,'MON-YYYY')='MAR-2020'
  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)
  
  delete from MTL_MATERIAL_TRANSACTIONS_TEMP
    where to_char (transaction_date,'MON-YYYY')='FEB-2020'
  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)
  
  select * from GME_BATCH_HEADER WHERE BATCH_ID= 1421870
  
 SELECT * FROM GME_MATERIAL_DETAILS WHERE BATCH_ID = 6448812
 
 select * FROM MTL_TRANSACTION_TYPES where TRANSACTION_TYPE_ID = 63
 
 select * from   MTL_MATERIAL_TRANSACTIONS where TRANSACTION_SOURCE_ID=  1421870
 
 
 
 
 select * from XLA_AE_lines WHERE AE_HEADER_ID = 35305284

SELECT * FROM MTL_TXN_REQUEST_HEADERS  where HEADER_ID= 1421870


 SELECT * FROM  MTL_TXN_REQUEST_LINES WHERE HEADER_ID= 1421870
 
 
       
       
       
       SELECT * FROM  GME_BATCH_HEADER 
       






--======================================



select * from ALL_OBJECTS WHERE OBJECT_NAME LIKE 'GME%BATCH%HEAD%' and OBJECT_TYPE = 'TABLE'

select * from GME_BATCH_HEADER where BATCH_NO= 394 --7013
and   ORGANIZATION_ID= 121
--INFO
gme_batch_header.OPM_BATCH ID = MTL_MATERIAL_TRANSACTIONS.TRANSACTION_SOURCE_ID

select * from GL_ALOC_BAS where alloc_id=85 

--XXGL_COST_ALLOC_PROC

SELECT distinct EVENT_TYPE_CODE  FROM GMF_XLA_EXTRACT_HEADERS where TRANSACTION_DATE between '01-OCT-2019' and '31-OCT-2019'  --and EVENT_TYPE_CODE LIKE  '%GLCOST%'


select * from gme_batch_header where ACTUAL_START_DATE between '01-OCT-2019' and '31-OCT-2019'
and ORGANIZATION_ID= 121


SELECT * FROM GME_BATCH_HEADER WHERE BATCH_NO= 1524 AND ORGANIZATION_ID= 121


select * from MTL_MATERIAL_TRANSACTIONS where TRANSACTION_SOURCE_ID =711077 -- 1542
--and trunc(TRANSACTION_DATE) > '31-JAN-2020' 
and TRUNC(TRANSACTION_DATE) between '01-JAN-2020' and '31-JAN-2020' 

select * from GME_BATCH_HEADER a, MTL_MATERIAL_TRANSACTIONS b
where a.BATCH_ID = b.TRANSACTION_SOURCE_ID
and b.TRANSACTION_SOURCE_ID = 711077





where TRANSACTION_SOURCE_ID IN()
and ORGANIZATION_ID= 121

-- 13 oct -2019 er batch info
select * from gme_batch_header
where trunc (ACTUAL_START_DATE) = '14-OCT2019'

select * from MTL_MATERIAL_TRANSACTIONS where transaction_id in (53685, 153938)

select * from GMF_XLA_EXTRACT_HEADERS where transaction_id in (53685, 153938)

select * from XLA_AE_HEADERS WHERE EVENT_ID IN(2114801,
3060675)

select * from XLA_AE_LINES where AE_HEADER_ID IN(23607697,
27520937)


select distinct FIXED_PERCENT  from GL_ALOC_BAS where organization_id= 121 and inventory_ITEM_ID=35626

select distinct TRANSACTION_TYPE_NAME , TRANSACTION_TYPE_ID from MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_NAME LIKE '%WIP%'
and transaction_type_id in (35,
17,
43,
44,
1002,
1003
)



SELECT GMD.ORGANIZATION_ID, (SELECT ORGANIZATION_CODE FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID=GMD.ORGANIZATION_ID) ORGANIZATION_CODE,
(SELECT ORGANIZATION_NAME FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID=GMD.ORGANIZATION_ID) ORGANIZATION_NAME, 
GMD.BATCH_NO, GMD.PLAN_START_DATE, GMD.ACTUAL_START_DATE, GMD.PLAN_CMPLT_DATE, GMD.ACTUAL_CMPLT_DATE, GMD.BATCH_STATUS, GMD.ATTRIBUTE14, GMD.ATTRIBUTE15 
FROM GME_BATCH_HEADER GMD
WHERE BATCH_STATUS=2
AND ((SELECT ORGANIZATION_CODE FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID=GMD.ORGANIZATION_ID)=:P_ORGANIZATION_CODE OR :P_ORGANIZATION_CODE IS NULL)
--AND (GMD.ORGANIZATION_ID = :P_ORGANIZATION_ID OR :P_ORGANIZATION_ID IS NULL)
AND TRUNC (ACTUAL_START_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO
ORDER BY 2,8







-- XXKSRM KASIL Daily Production Reports

SELECT DISTINCT  gbh.batch_id, 
          get_inv_org_to_org_desc_fn(:p_org_id) ORG_HEADER_NAME,
          gbh.batch_no, 
          to_char(gbh.ACTUAL_START_DATE, 'DD-MON-YYYY') actual_start_date,
          NVL (gbh.attribute7, 0) roll_fg_no_of_bundles,
          gbh.attribute8 batch_type,
          gmd.material_detail_id,
          gmd.inventory_item_id ingrdnt_inv_item_id,
          gmd.organization_id,
          gmd.ingrdnt_actual_qty,
          gmd5.cs_ingrdnt_actual_qty,
          gmd.ingrdnt_item_code,
          gmd.ingrdnt_item_desc,
          gmd1.inventory_item_id roll_fg_inv_item_id,
          gmd1.fg_item_code,
          gmd1.fg_item_desc,
          gmd1.fg_rebar_weight,
          gmd2.inventory_item_id by_product_inv_item_id,
          gmd2.by_product_item_code,
          gmd2.by_product_item_desc,
          gmd2.by_product_no_of_billets,
          gmd2.by_product_weight,
          gmd3.inventory_item_id scrap_inv_item_id,
          gmd3.scrap_item_code,
          gmd3.scrap_item_desc,
          gmd3.attribute7 scrap_no_of_billets,
          gmd3.actual_qty scrap_weight,
          XX_INV_PKG.XXGET_ENAME(:P_USER) PRINTED_BY,
          gmd1.attribute12 MILL_HOUR_RUNNING,
          gmd1.attribute13 REMARKS
FROM gme_batch_header gbh
LEFT OUTER JOIN (select gmdd.batch_id,gmdd.organization_id,
kfv.concatenated_segments ingrdnt_item_code,
kfv.description ingrdnt_item_desc,material_detail_id,gmdd.inventory_item_id,gmdd.actual_qty ingrdnt_actual_qty from gme_material_details gmdd,mtl_system_items_kfv kfv where gmdd.inventory_item_id=kfv.inventory_item_id and gmdd.organization_id=kfv.organization_id and gmdd.line_type=-1) gmd --INGREDIANT
ON gbh.batch_id = gmd.batch_id
LEFT OUTER JOIN (select gmdd.batch_id,gmdd.organization_id,gmdd.attribute12,gmdd.attribute13,
kfv.concatenated_segments fg_item_code,
kfv.description fg_item_desc,material_detail_id,gmdd.inventory_item_id,gmdd.actual_qty ingrdnt_actual_qty,gmdd.actual_qty fg_rebar_weight from gme_material_details gmdd,mtl_system_items_kfv kfv 
where gmdd.inventory_item_id=kfv.inventory_item_id and gmdd.organization_id=kfv.organization_id and gmdd.line_type=1 and gmdd.LINE_NO=1) gmd1 --FG
ON gbh.batch_id = gmd1.batch_id
LEFT OUTER JOIN (select gmdd.batch_id,gmdd.organization_id,
kfv.concatenated_segments by_product_item_code,
kfv.description by_product_item_desc,material_detail_id,gmdd.inventory_item_id,gmdd.actual_qty ingrdnt_actual_qty,nvl(gmdd.actual_qty*1000,0) by_product_weight,gmdd.attribute7 by_product_no_of_billets from gme_material_details gmdd,mtl_system_items_kfv kfv 
where gmdd.inventory_item_id=kfv.inventory_item_id and gmdd.organization_id=kfv.organization_id and gmdd.line_type=1 AND kfv.description not in ('MILL SCALE','MILL SCALE CS') and gmdd.line_no not in(1)) gmd2 --BY-PRODUCT
ON gbh.batch_id = gmd2.batch_id
LEFT OUTER JOIN (select gmdd.batch_id,gmdd.organization_id,
kfv.concatenated_segments scrap_item_code,
kfv.description scrap_item_desc,material_detail_id,gmdd.inventory_item_id,gmdd.actual_qty ingrdnt_actual_qty,actual_qty,gmdd.attribute7 from gme_material_details gmdd,mtl_system_items_kfv kfv 
where gmdd.inventory_item_id=kfv.inventory_item_id and gmdd.organization_id=kfv.organization_id and gmdd.line_type=2 
--AND kfv.description in ('MILL SCALE','MILL SCALE CS')
) gmd3 --SCARP
ON gbh.batch_id = gmd3.batch_id,
(select sum(gmd5.actual_qty) cs_ingrdnt_actual_qty,batch_id,organization_id from gme_material_details gmd5 where gmd5.line_type=-1 group by gmd5.batch_id,gmd5.organization_id) gmd5
WHERE gmd5.batch_id=gbh.batch_id
AND gmd5.organization_id=gbh.organization_id 
AND gbh.batch_status=3
--AND gbh.ORGANIZATION_ID=:p_org_id
AND trunc(gbh.ACTUAL_START_DATE)=nvl(:p_p_date,trunc(gbh.ACTUAL_START_DATE))
AND gmd1.inventory_item_id=NVL(:p_item_id,gmd1.inventory_item_id)
and gbh.attribute21=nvl(:p_batch_type,gbh.attribute21)
--and gbh.batch_NO= 1306
--and gbh.ACTUAL_START_DATE between '01-OCT-2019' and '31-OCT-2019'




--========================================================


-- AKG OPM Pickling Coil Stiker

/* Formatted on 1/29/2015 5:30:16 PM (QP5 v5.136.908.31019) */
CREATE OR REPLACE PACKAGE BODY APPS.xxakg_lot_no_sequence_pkg
AS
   -- =============================================
   -- Abul Khair Group Oracle Apps Implementation
   -- Description:
   -- This package is used to refresh the default auto Lot number
   -- This will be scheduled at 00:00:00

   /******************************************************************************/
   -- This program is being provided by PricewaterhouseCoopers for the sole use and benefit of Abul Khair.
   -- Draft - Tentative and Preliminary Subject to Change
   -- =============================================

   --Author:
   /*****************************************************************************
      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        28/11/2011             1. Created this package.
      1.1        20/11/2011             2. Update This Package Body
   ******************************************************************************/

   -- Define Programs
   /*
  To get the Complete Sequence for LOT NUMBER AT MATERIAL TRANSACT.
   */
   PROCEDURE gen_lot_number (pi_batch_id            IN NUMBER,
                             pi_vendor_site_id      IN NUMBER,
                             ---Place of Origin for HR Coil Receiving
                             pi_org_id              IN NUMBER,
                             pi_inventory_item_id   IN NUMBER)
   IS
      -- Define Variables
      v_lot_sequence   NUMBER (10);
      v_routing        VARCHAR2 (5);
      v_resource       VARCHAR2 (10);
      -- this has been inserted by partha on 9 DEC 11
      v_lot_number     VARCHAR2 (40);
      v_lot_number1    VARCHAR2 (40);
      v_lot_number2    VARCHAR2 (40);
      v_lot_country    VARCHAR2 (2);
      v_lot_dt         VARCHAR2 (2);
      l_max_seq        NUMBER;
      l_date           DATE;
   BEGIN
      l_date := SYSDATE;

      --    *START*REMOVED FROM THIS PORTION AS THIS WAS NOT GENERATING LOT NUMBER ON RECEIVING HR COIL
      --      SELECT actual_start_date
      --        INTO l_date
      --        FROM gme_batch_header
      --       WHERE batch_id = pi_batch_id;
      --    REMOVED FROM THIS PORTION AS THIS WAS NOT GENERATING LOT NUMBER ON RECEIVING HR COIL*END*
      --    MOVED TO LINE NO. 94

      -- This line has inserted by Partha on 9 DEC 11 to generate lot number in batch release date
      IF TO_CHAR (l_date, 'HH24:MI:SS') BETWEEN '00:00:00' AND '05:59:55'
      THEN
         l_date := l_date - 1;
      END IF;

      IF (pi_batch_id = -9999)                               ----HR Lot Number
      THEN
         SELECT akg_hrcoil_lot_number_seq.NEXTVAL
           INTO v_lot_sequence
           FROM DUAL;

         SELECT UPPER (SUBSTR (ftv.territory_short_name, 0, 2))
           INTO v_lot_country
           FROM ap_supplier_sites_all assa, fnd_territories_vl ftv
          WHERE ftv.territory_code = assa.country
                AND assa.vendor_site_id = pi_vendor_site_id;

         SELECT    TO_CHAR (l_date, 'YY')
                || v_lot_country
                || TO_CHAR (l_date, 'DD')
                || DECODE (TO_CHAR (l_date, 'MON'),
                           'JAN', 'A',
                           'FEB', 'B',
                           'MAR', 'C',
                           'APR', 'D',
                           'MAY', 'E',
                           'JUN', 'F',
                           'JUL', 'G',
                           'AUG', 'H',
                           'SEP', 'I',
                           'OCT', 'J',
                           'NOV', 'K',
                           'DEC', 'L')
           INTO v_lot_number
           FROM DUAL;
      ELSE
         --    *START*INSERTED THIS PORTION FOR GENERATING LOT NUMBER FOR BATCHES OTHER THAN HR COIL
         SELECT actual_start_date
           INTO l_date
           FROM gme_batch_header
          WHERE batch_id = pi_batch_id;

         --    INSERTED THIS PORTION FOR GENERATING LOT NUMBER FOR BATCHES OTHER THAN HR COIL*END*

         IF (pi_batch_id <> -9999)
         THEN
            SELECT frh.attribute1, frh.attribute2
              -- ,frh.attribute2 is interted by PArtha on 9 DEC 11
              INTO v_routing, v_resource -- ,v_resource is interted by PArtha on 9 DEC 11
              FROM gme_batch_header gbh, fm_rout_hdr frh
             WHERE gbh.routing_id = frh.routing_id AND batch_id = pi_batch_id;

            IF (v_routing = 'P' AND v_resource = 'NA')
            ---- PICKLING -- AND v_resource = 'NA' is interted by PArtha on 9 DEC 11
            THEN
               SELECT akg_pickled_lot_number_seq.NEXTVAL
                 INTO v_lot_sequence
                 FROM DUAL;

               SELECT    TO_CHAR (l_date, 'YY')
                      || frh.attribute1
                      || TO_CHAR (l_date, 'DD')
                      || DECODE (TO_CHAR (l_date, 'MON'),
                                 'JAN', 'A',
                                 'FEB', 'B',
                                 'MAR', 'C',
                                 'APR', 'D',
                                 'MAY', 'E',
                                 'JUN', 'F',
                                 'JUL', 'G',
                                 'AUG', 'H',
                                 'SEP', 'I',
                                 'OCT', 'J',
                                 'NOV', 'K',
                                 'DEC', 'L')
                 INTO v_lot_number
                 FROM gme_batch_header gbh, fm_rout_hdr frh
                WHERE gbh.routing_id = frh.routing_id
                      AND batch_id = pi_batch_id;
            ELSE
               IF (v_routing = 'R' AND v_resource = 'M')
               ----ROLLING , AND v_resource = 'M' IS INSERTED BY PARTHA ON 9 DEC 11
               THEN
                  SELECT akg_roll_mill_1_lot_n0_seq.NEXTVAL
                    INTO v_lot_sequence
                    FROM DUAL;

                  SELECT    TO_CHAR (l_date, 'YY')
                         || frh.attribute2
                         || frh.attribute1
                         || TO_CHAR (l_date, 'DD')
                         || DECODE (TO_CHAR (l_date, 'MON'),
                                    'JAN', 'A',
                                    'FEB', 'B',
                                    'MAR', 'C',
                                    'APR', 'D',
                                    'MAY', 'E',
                                    'JUN', 'F',
                                    'JUL', 'G',
                                    'AUG', 'H',
                                    'SEP', 'I',
                                    'OCT', 'J',
                                    'NOV', 'K',
                                    'DEC', 'L')
                    INTO v_lot_number
                    FROM gme_batch_header gbh, fm_rout_hdr frh
                   WHERE gbh.routing_id = frh.routing_id
                         AND batch_id = pi_batch_id;
               ELSE
                  IF (v_routing = 'G')               -- AND v_resource = '1F')
                  ----GALVANIZING , AND v_resource = '1F' is interted by PArtha on 9 DEC 11
                  THEN
                     SELECT akg_gp_lot_number_seq.NEXTVAL
                       INTO v_lot_sequence
                       FROM DUAL;

                     /*
                                          SELECT gmd.attribute4
                                            INTO v_lot_number1
                                            FROM mtl_item_categories_v mic,
                                                 gme_material_details gmd
                                           WHERE mic.inventory_item_id = gmd.inventory_item_id
                                             AND gmd.inventory_item_id = pi_inventory_item_id
                                             AND mic.organization_id = gmd.organization_id
                                             AND gmd.organization_id = pi_org_id
                                             AND gmd.batch_id = pi_batch_id
                                             AND gmd.line_type = 1
                                             AND mic.category_concat_segs LIKE 'WIP|GP COIL%'
                                             AND mic.category_set_name = 'Inventory'
                                             AND gmd.attribute_category = 'GP Coil Output';*/
                     SELECT    TO_CHAR (l_date, 'YY')
                            || frh.attribute2
                            || TO_CHAR (l_date, 'DD')
                            || DECODE (TO_CHAR (l_date, 'MON'),
                                       'JAN', 'A',
                                       'FEB', 'B',
                                       'MAR', 'C',
                                       'APR', 'D',
                                       'MAY', 'E',
                                       'JUN', 'F',
                                       'JUL', 'G',
                                       'AUG', 'H',
                                       'SEP', 'I',
                                       'OCT', 'J',
                                       'NOV', 'K',
                                       'DEC', 'L')
                       INTO v_lot_number2
                       FROM gme_batch_header gbh, fm_rout_hdr frh
                      WHERE gbh.routing_id = frh.routing_id
                            AND batch_id = pi_batch_id;

                     --  v_lot_number := v_lot_number2 || v_lot_number1;
                     v_lot_number := v_lot_number2;
                  ELSE
                     IF (v_routing = 'RP' AND v_resource = 'NA')
                     ----RE PICKLING , AND v_resource = 'NA' is interted by PArtha on 9 DEC 11
                     THEN
                        SELECT akg_re_pickled_lot_number_seq.NEXTVAL
                          INTO v_lot_sequence
                          FROM DUAL;

                        SELECT    TO_CHAR (l_date, 'YY')
                               || frh.attribute1
                               || TO_CHAR (l_date, 'DD')
                               || DECODE (TO_CHAR (l_date, 'MON'),
                                          'JAN', 'A',
                                          'FEB', 'B',
                                          'MAR', 'C',
                                          'APR', 'D',
                                          'MAY', 'E',
                                          'JUN', 'F',
                                          'JUL', 'G',
                                          'AUG', 'H',
                                          'SEP', 'I',
                                          'OCT', 'J',
                                          'NOV', 'K',
                                          'DEC', 'L')
                          INTO v_lot_number
                          FROM gme_batch_header gbh, fm_rout_hdr frh
                         WHERE gbh.routing_id = frh.routing_id
                               AND batch_id = pi_batch_id;
                     ELSE
                        IF (v_routing = 'RRP' AND v_resource = 'NA')
                        ----RE RE PICKLING , AND v_resource = 'NA' is interted by PArtha on 9 DEC 11
                        THEN
                           SELECT akg_re_re_pickled_lot_seq.NEXTVAL
                             INTO v_lot_sequence
                             FROM DUAL;

                           SELECT    TO_CHAR (l_date, 'YY')
                                  || frh.attribute1
                                  || TO_CHAR (l_date, 'DD')
                                  || DECODE (TO_CHAR (l_date, 'MON'),
                                             'JAN', 'A',
                                             'FEB', 'B',
                                             'MAR', 'C',
                                             'APR', 'D',
                                             'MAY', 'E',
                                             'JUN', 'F',
                                             'JUL', 'G',
                                             'AUG', 'H',
                                             'SEP', 'I',
                                             'OCT', 'J',
                                             'NOV', 'K',
                                             'DEC', 'L')
                             INTO v_lot_number
                             FROM gme_batch_header gbh, fm_rout_hdr frh
                            WHERE gbh.routing_id = frh.routing_id
                                  AND batch_id = pi_batch_id;
                        ELSE
                           IF (v_routing = 'RRW')     -- AND v_resource = 'M')
                           ----RE RE WINDING , AND v_resource = 'M' is interted by PArtha on 9 DEC 11
                           THEN
                              SELECT akg_re_rewind_lot_number_seq.NEXTVAL
                                INTO v_lot_sequence
                                FROM DUAL;

                              SELECT    TO_CHAR (l_date, 'YY')
                                     || frh.attribute2
                                     || frh.attribute1
                                     || TO_CHAR (l_date, 'DD')
                                     || DECODE (TO_CHAR (l_date, 'MON'),
                                                'JAN', 'A',
                                                'FEB', 'B',
                                                'MAR', 'C',
                                                'APR', 'D',
                                                'MAY', 'E',
                                                'JUN', 'F',
                                                'JUL', 'G',
                                                'AUG', 'H',
                                                'SEP', 'I',
                                                'OCT', 'J',
                                                'NOV', 'K',
                                                'DEC', 'L')
                                INTO v_lot_number
                                FROM gme_batch_header gbh, fm_rout_hdr frh
                               WHERE gbh.routing_id = frh.routing_id
                                     AND batch_id = pi_batch_id;
                           ELSE
                              IF (v_routing = 'RW')   -- AND v_resource = 'M')
                              --AND v_resource = 'M' is interted by PArtha on 9 DEC 11
                              ----REWINDING
                              THEN
                                 SELECT akg_rewind_lot_number_seq.NEXTVAL
                                   INTO v_lot_sequence
                                   FROM DUAL;

                                 SELECT    TO_CHAR (l_date, 'YY')
                                        || frh.attribute2
                                        || frh.attribute1
                                        || TO_CHAR (l_date, 'DD')
                                        || DECODE (TO_CHAR (l_date, 'MON'),
                                                   'JAN', 'A',
                                                   'FEB', 'B',
                                                   'MAR', 'C',
                                                   'APR', 'D',
                                                   'MAY', 'E',
                                                   'JUN', 'F',
                                                   'JUL', 'G',
                                                   'AUG', 'H',
                                                   'SEP', 'I',
                                                   'OCT', 'J',
                                                   'NOV', 'K',
                                                   'DEC', 'L')
                                   INTO v_lot_number
                                   FROM gme_batch_header gbh, fm_rout_hdr frh
                                  WHERE gbh.routing_id = frh.routing_id
                                        AND batch_id = pi_batch_id;
                              ELSE
                                 IF (v_routing = 'B' AND v_resource = 'NA')
                                 -- AND v_resource = 'NA' is interted by PArtha on 9 DEC 11
                                 ----COIL BUILD UP
                                 THEN
                                    SELECT akg_buildup_lot_number_seq.NEXTVAL
                                      INTO v_lot_sequence
                                      FROM DUAL;

                                    SELECT    TO_CHAR (l_date, 'YY')
                                           || frh.attribute1
                                           || TO_CHAR (l_date, 'DD')
                                           || DECODE (
                                                 TO_CHAR (l_date, 'MON'),
                                                 'JAN',
                                                 'A',
                                                 'FEB',
                                                 'B',
                                                 'MAR',
                                                 'C',
                                                 'APR',
                                                 'D',
                                                 'MAY',
                                                 'E',
                                                 'JUN',
                                                 'F',
                                                 'JUL',
                                                 'G',
                                                 'AUG',
                                                 'H',
                                                 'SEP',
                                                 'I',
                                                 'OCT',
                                                 'J',
                                                 'NOV',
                                                 'K',
                                                 'DEC',
                                                 'L')
                                      INTO v_lot_number
                                      FROM gme_batch_header gbh,
                                           fm_rout_hdr frh
                                     WHERE gbh.routing_id = frh.routing_id
                                           AND batch_id = pi_batch_id;
                                 ELSIF (v_routing = 'R' AND v_resource = 'N')
                                 ----ROLLING , AND v_resource = 'N' IS INSERTED BY PARTHA ON 9 DEC 11
                                 THEN
                                    SELECT akg_roll_mill_2_lot_n0_seq.NEXTVAL
                                      INTO v_lot_sequence
                                      FROM DUAL;

                                    SELECT    TO_CHAR (l_date, 'YY')
                                           || frh.attribute2
                                           || frh.attribute1
                                           || TO_CHAR (l_date, 'DD')
                                           || DECODE (
                                                 TO_CHAR (l_date, 'MON'),
                                                 'JAN',
                                                 'A',
                                                 'FEB',
                                                 'B',
                                                 'MAR',
                                                 'C',
                                                 'APR',
                                                 'D',
                                                 'MAY',
                                                 'E',
                                                 'JUN',
                                                 'F',
                                                 'JUL',
                                                 'G',
                                                 'AUG',
                                                 'H',
                                                 'SEP',
                                                 'I',
                                                 'OCT',
                                                 'J',
                                                 'NOV',
                                                 'K',
                                                 'DEC',
                                                 'L')
                                      INTO v_lot_number
                                      FROM gme_batch_header gbh,
                                           fm_rout_hdr frh
                                     WHERE gbh.routing_id = frh.routing_id
                                           AND batch_id = pi_batch_id;
                                 ELSIF (v_routing = 'R' AND v_resource = 'R')
                                 ----ROLLING , AND v_resource = 'R' IS INSERTED BY PARTHA ON 9 DEC 11
                                 THEN
                                    SELECT akg_roll_mill_4_lot_n0_seq.NEXTVAL
                                      INTO v_lot_sequence
                                      FROM DUAL;

                                    SELECT    TO_CHAR (l_date, 'YY')
                                           || frh.attribute2
                                           || frh.attribute1
                                           || TO_CHAR (l_date, 'DD')
                                           || DECODE (
                                                 TO_CHAR (l_date, 'MON'),
                                                 'JAN',
                                                 'A',
                                                 'FEB',
                                                 'B',
                                                 'MAR',
                                                 'C',
                                                 'APR',
                                                 'D',
                                                 'MAY',
                                                 'E',
                                                 'JUN',
                                                 'F',
                                                 'JUL',
                                                 'G',
                                                 'AUG',
                                                 'H',
                                                 'SEP',
                                                 'I',
                                                 'OCT',
                                                 'J',
                                                 'NOV',
                                                 'K',
                                                 'DEC',
                                                 'L')
                                      INTO v_lot_number
                                      FROM gme_batch_header gbh,
                                           fm_rout_hdr frh
                                     WHERE gbh.routing_id = frh.routing_id
                                           AND batch_id = pi_batch_id;
                                 ELSIF (v_routing = 'R' AND v_resource = 'S')
                                 ----ROLLING , AND v_resource = 'R' IS INSERTED BY PARTHA ON 9 DEC 11
                                 THEN
                                    SELECT akg_roll_mill_3_lot_n0_seq.NEXTVAL
                                      INTO v_lot_sequence
                                      FROM DUAL;

                                    SELECT    TO_CHAR (l_date, 'YY')
                                           || frh.attribute2
                                           || frh.attribute1
                                           || TO_CHAR (l_date, 'DD')
                                           || DECODE (
                                                 TO_CHAR (l_date, 'MON'),
                                                 'JAN',
                                                 'A',
                                                 'FEB',
                                                 'B',
                                                 'MAR',
                                                 'C',
                                                 'APR',
                                                 'D',
                                                 'MAY',
                                                 'E',
                                                 'JUN',
                                                 'F',
                                                 'JUL',
                                                 'G',
                                                 'AUG',
                                                 'H',
                                                 'SEP',
                                                 'I',
                                                 'OCT',
                                                 'J',
                                                 'NOV',
                                                 'K',
                                                 'DEC',
                                                 'L')
                                      INTO v_lot_number
                                      FROM gme_batch_header gbh,
                                           fm_rout_hdr frh
                                     WHERE gbh.routing_id = frh.routing_id
                                           AND batch_id = pi_batch_id;
                                 /*  Begin: Added By Imrul on 29-JAN-2015 For GP Coil Reprocess Lot  */
                                 ELSE
                                    IF (v_routing = 'GR' AND v_resource = '4F')
                                    ----GP Reprocess , AND v_resource = '4F' is interted by Imrul on 29 JAN 15
                                    THEN
                                       SELECT akg_gp_reproc_nof4_lot_num_seq.NEXTVAL
                                         INTO v_lot_sequence
                                         FROM DUAL;

                                       SELECT    TO_CHAR (l_date, 'YY')
                                              || frh.attribute2
                                              || frh.attribute1
                                              || TO_CHAR (l_date, 'DD')
                                              || DECODE (
                                                    TO_CHAR (l_date, 'MON'),
                                                    'JAN',
                                                    'A',
                                                    'FEB',
                                                    'B',
                                                    'MAR',
                                                    'C',
                                                    'APR',
                                                    'D',
                                                    'MAY',
                                                    'E',
                                                    'JUN',
                                                    'F',
                                                    'JUL',
                                                    'G',
                                                    'AUG',
                                                    'H',
                                                    'SEP',
                                                    'I',
                                                    'OCT',
                                                    'J',
                                                    'NOV',
                                                    'K',
                                                    'DEC',
                                                    'L')
                                         INTO v_lot_number
                                         FROM gme_batch_header gbh,
                                              fm_rout_hdr frh
                                        WHERE gbh.routing_id = frh.routing_id
                                              AND batch_id = pi_batch_id;
                                    END IF;
                                 /*End: Added By Imrul on 29-JAN-2015 For GP Coil Reprocess Lot */
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      BEGIN
         SELECT NVL (MAX (SEQUENCE), 0)
           INTO l_max_seq
           FROM xxakg_lot_number_seq xlt
          WHERE xlt.lot_number = v_lot_number;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_max_seq := 0;
      END;

      v_lot_sequence := l_max_seq + 1;

      INSERT INTO xxakg_lot_number_seq (lot_number, SEQUENCE)
             SELECT v_lot_number, v_lot_sequence FROM DUAL;

      COMMIT;
      g_lot_number := v_lot_number || v_lot_sequence;
   END gen_lot_number;

   FUNCTION get_lot_number
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_lot_number;
   END get_lot_number;
END xxakg_lot_no_sequence_pkg;
/

--=================================================

select * from GME_BATCH_HEADER where batch_no=283

select * from gme_material_details where batch_id = '324062'

select * from GME_MATERIAL_DETAILS

select * from gme_batch_steps where batch_id=324062



--=========================================== GET RECIPE NUMBER ================================================

select DISTINCT gmd.RECIPE_NO Receipe_code,RECIPE_DESCRIPTION Receipe_Name ,gmd.RECIPE_VERSION,
--(select distinct description from mtl_system_items mtl1,FM_MATL_DTL fd1
--where fd1.line_type=1
--and fd1.formula_id=fd.formula_id
--and fd1.inventory_item_id = mtl1.inventory_item_id
--and fd1.organization_id= mtl1.organization_id) product,
fm.formula_no,fm.FORMULA_DESC1,fm.FORMULA_VERS,
decode (gmd.RECIPE_STATUS,'900', 'Frozen','700','Approved for General Use') Rec_Status,
b.segment1||'-'||b.segment2 Item_code,
b.description item_desc,
fd.line_no,
fd.qty
from FM_FORM_MST fm,
FM_MATL_DTL fd,
mtl_system_items b,
GMD_RECIPE_VALIDITY_RULES GV,
gmd_recipes gmd
where  fd.formula_id=fm.formula_id
and fd.organization_id=fm.OWNER_ORGANIZATION_ID
and fm.formula_id =gmd.formula_id
and fm.owner_organization_id=gmd.owner_organization_id
AND GV.RECIPE_ID=GMd.RECIPE_ID
and b.inventory_item_id=fd.inventory_item_id
and b.organization_id=fm.OWNER_ORGANIZATION_ID
and fm.OWNER_ORGANIZATION_ID in (121)
and fd.line_type in (-1,2)
--and fm.FORMULA_STATUS=700
and gmd.RECIPE_STATUS in (700)
AND gmd.RECIPE_NO = 'FG|500W|19MM|000005'
order by 1



--==================== GET FORMULA INFORMATION=============================

select gmd.RECIPE_NO Receipe_code,RECIPE_DESCRIPTION Receipe_Name ,gmd.RECIPE_VERSION,
--(select distinct description from mtl_system_items mtl1,FM_MATL_DTL fd1
--where fd1.line_type=1
--and fd1.formula_id=fd.formula_id
--and fd1.inventory_item_id = mtl1.inventory_item_id
--and fd1.organization_id= mtl1.organization_id) product,
fm.formula_no,fm.FORMULA_DESC1,fm.FORMULA_VERS,
decode (gmd.RECIPE_STATUS,'900', 'Frozen','700','Approved for General Use') Rec_Status,
b.segment1||'-'||b.segment2 Item_code,
b.description item_desc,
fd.line_no,
fd.qty
from FM_FORM_MST fm,
FM_MATL_DTL fd,
mtl_system_items b,
GMD_RECIPE_VALIDITY_RULES GV,
gmd_recipes gmd
where  fd.formula_id=fm.formula_id
and fd.organization_id=fm.OWNER_ORGANIZATION_ID
and fm.formula_id =gmd.formula_id
and fm.owner_organization_id=gmd.owner_organization_id
AND GV.RECIPE_ID=GMd.RECIPE_ID
and b.inventory_item_id=fd.inventory_item_id
and b.organization_id=fm.OWNER_ORGANIZATION_ID
--and fm.OWNER_ORGANIZATION_ID in (XXXX)
and fd.line_type in (-1,2)
--and fm.FORMULA_STATUS=700
--and gmd.RECIPE_STATUS in (700)
AND RECIPE_DESCRIPTION  = 'FA|OTFA|OLVA|000003CYLIN-CONV'
--and gmd.RECIPE_NO='FA|OTFA|OLVA|000003CYLIN-CONV'
order by 1

SELECT * FROM FM_MATL_DTL


--===============================

select ORGANIZATION_ID, BATCH_ID,BATCH_NO, ACTUAL_START_DATE,--BATCH_STATUS,    
BATCH_CLOSE_DATE, CREATION_DATE 
--MOVE_ORDER_HEADER_ID
from GME_BATCH_HEADER 
where --batch_id in ()
--BATCH_NO=59 and 
ORGANIZATION_ID=176
and CREATION_DATE

select * FROM GME_BATCH_HEADER 