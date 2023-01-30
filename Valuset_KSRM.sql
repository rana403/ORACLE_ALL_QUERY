-- GET ALL VALUSET

select ffvs.flex_value_set_id ,
    ffvs.flex_value_set_name ,
    ffvs.description set_description ,
    ffvs.validation_type,
    ffvt.value_column_name ,
    ffvt.meaning_column_name ,
    ffvt.id_column_name ,
    ffvt.application_table_name ,
    FFVT.ADDITIONAL_WHERE_CLAUSE
FROM APPS.fND_FLEX_VALUE_SETS FFVS,
    apps.FND_FLEX_VALIDATION_TABLES FFVT
WHERE FFVS.FLEX_VALUE_SET_ID = FFVT.FLEX_VALUE_SET_ID
--AND FLEX_VALUE_SET_NAME LIKE '%XX%SERIAL%'


-- GET USE OF AREA DATA
--====================
SELECT * FROM XXKSRM_INV_USE_AREA_V


--=========================================
-- GET ALL COST CENTER LIST
--=========================================

SELECT  distinct SEGMENT3, XX_GET_ACCT_FLEX_SEG_DESC(3,SEGMENT3)  Cost_Center -- , SEGMENT5 SUB_ACCOUNT_ID, XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT
FROM gl_code_combinations 
WHERE   SEGMENT3 <>0000


--====================================
--GET TABLE BASED VALUE SETS IN ORACLE APPS R12
--====================================
select ffvs.flex_value_set_id ,
    ffvs.flex_value_set_name ,
    ffvs.description set_description ,
    ffvs.validation_type,
    ffvt.value_column_name ,
    ffvt.meaning_column_name ,
    ffvt.id_column_name ,
    ffvt.application_table_name ,
    ffvt.additional_where_clause
FROM fnd_flex_value_sets ffvs ,
    fnd_flex_validation_tables ffvt
WHERE ffvs.flex_value_set_id = ffvt.flex_value_set_id
and FLEX_VALUE_SET_NAME like '%XX%USE%'


SELECT * FROM XXKSRM_INV_USE_AREA_V where USE_AREA like '%M.V JAHAN MONI%'

Table name: XXKSRM_INV_USE_AREA_V

Valuset Name: XXKSRM_USE_AREA_VS

Lookup type: XXKSRM_USE_AREA (Application Developer--> lookup common--> XXKSRM_USE_AREA)

--=====================
--GET ALL USE OF AREA LIST
--======================

SELECT GET_OU_NAME_FROM_ID(A.OU_ID), A.* from XXKSRM_INV_USE_AREA_V A

--=====================
--VALU for ITEM  Related Valuset 
--=====================
Item Type: XXKSRM_ITEM_TYPE :  (SELECT  DISTINCT WXMD.ITEM_TYPE FROM WBI_XXKBGITEM_MT_D WXMD)

Item Group: XXKSRM_ITEM_GROUP_D : (SELECT  DISTINCT ITEM_GROUP,ITEM_TYPE FROM WBI_XXKBGITEM_MT_D )   
WHERE CLOUSE : WHERE ITEM_TYPE=:$FLEX$.XXKSRM_ITEM_TYPE

Item Sub Group: XXKSRM_ITEM_SUB_GROUP_D: (SELECT  DISTINCT ITEM_SUB_GROUP,ITEM_GROUP,ITEM_TYPE FROM WBI_XXKBGITEM_MT_D )
where clouse: WHERE ITEM_TYPE=:$FLEX$.XXKSRM_ITEM_TYPE
AND ITEM_GROUP=:$FLEX$.XXKSRM_ITEM_GROUP_D


Finance Category: XXKSRM_FINANCE_CATEGORY_D: (SELECT  DISTINCT FINANCE_CATEGORY ,ITEM_SUB_GROUP,ITEM_GROUP,ITEM_TYPE  FROM WBI_XXKBGITEM_MT_D )
where clouse: WHERE ITEM_TYPE=:$FLEX$.XXKSRM_ITEM_TYPE
AND ITEM_GROUP=:$FLEX$.XXKSRM_ITEM_GROUP_D
AND ITEM_SUB_GROUP=:$FLEX$.XXKSRM_ITEM_SUB_GROUP_D

Sub Inventories: XXKSRM_SUBINVENTORIES : (SELECT SECONDARY_INVENTORY_NAME, ORGANIZATION_ID FROM MTL_SUBINVENTORIES_ALL_V) X
where clouse: WHERE X.ORGANIZATION_ID=:$FLEX$.XXKSRM_MO_ORG

SELECT * FROM WBI_XXKBGITEM_MT_D

SELECT * FROM MTL_ITEM_CATEGORIES_V where segment1='SERVICE'

/************************************************
--VALUSET FOR ITEM LOCATOR
/**************************************************/
SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGAnization_code='TRM'

(SELECT DISTINCT SEGMENT2 Locator, ORGANIZATION_ID, SUBINVENTORY_CODE FROM MTL_ITEM_LOCATIONS) X

SELECT DISTINCT SEGMENT2 Locator, ORGANIZATION_ID, SUBINVENTORY_CODE FROM MTL_ITEM_LOCATIONS WHERE ORGANIZATION_ID= 163

--========================================
-- GET INDEPENDENT  VALUSET WITH MANUAL LOOKUP  LIKE: 

--COMPANY VALUSET:  XX_COMPANY
--UNIT: XX_UNIT
--Cost Center: XX_COST_CENTER
--Account: XX_ACCOUNT
--Sub Account: XX_SUB_ACCOUNT
--Project: XX_PROJECT_NEW
--Intercompany: XX_INTERCOMPANY
--========================================
SELECT ffvs.flex_value_set_id ,
--ffvs.flex_value_set_name ,
--ffvs.description set_description ,
--ffvs.validation_type,
--ffv.flex_value,
ffvt.description PROJECT_NAME,
ffv.enabled_flag,
ffv.last_update_date
--ffv.last_updated_by,
--ffv.attribute1,
--ffv.attribute2,
--ffv.attribute3 --Include attribute values based on DFF segments
FROM fnd_flex_value_sets ffvs ,
fnd_flex_values ffv ,
fnd_flex_values_tl ffvt
WHERE
ffvs.flex_value_set_id = ffv.flex_value_set_id
and ffv.flex_value_id = ffvt.flex_value_id
AND ffvt.language = USERENV('LANG')
and flex_value_set_name like '%XX_PROJECT_NEW%'
AND ffvt.description <> 'Default'

--=========================
--VALUE SET TABLES IN ORACLE APPS R12
--========================
FND_FLEX_VALUE_SETS
FND_FLEX_VALUES
FND_FLEX_VALUES_TL


--=============================VALUSET AS PARAMETER============================
--==================
--GET LE: Valuset name: XX_LE_NAME
--=======
 SELECT DISTINCT SEGMENT1 LEGAL_ENTITY_CODE,SEGMENT1||'-'||XX_GET_ACCT_FLEX_SEG_DESC (1, SEGMENT1) LEGAL_ENTITY_NAME FROM GL_CODE_COMBINATIONS


--GET OU: OU DEPENDS ON LE: XX_LE_OU_NAME
--===============================
TABLE ANME : HR_OPERATING_UNITS

WHERE SUBSTR(NAME,1,3)=:$FLEX$.XX_LE_NAME
ORDER BY NAME
 
 
/*******************************************************
DRIVER VALUSET
*******************************************************/
(select  distinct SUBSTR(XX_GET_VENDOR_NAME_WITH_NUMBER (OTM.EMPLOYEE_ID),8) DRIVER_NAME, otm.org_id from XX_ONT_TRIP_MT OTM) XXDVR

select  distinct SUBSTR(XX_GET_VENDOR_NAME_WITH_NUMBER (OTM.EMPLOYEE_ID),8) DRIVER_NAME, otm.org_id from XX_ONT_TRIP_MT OTM where REG_NO = 'ABC DRIVER(TP-0001)'

select * from XX_ONT_TRIP_MT   

(SELECT DISTINCT REG_NO, ORG_ID FROM XXTRIPDTLS_ALL) XXTDA

Select * from XXTRIPDTLS_ALL 

SELECT * FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = 'KG-1010'

select  distinct VENDOR_NAME  FROM AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'DRIVER'  and END_DATE_ACTIVE is null

select  distinct VENDOR_NAME  FROM AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'DRIVER'  and END_DATE_ACTIVE is null and VENDOR_NAME = 'ABC DRIVER(TP-0001)'

(select  distinct SUBSTR(XX_GET_VENDOR_NAME_WITH_NUMBER (OTM.EMPLOYEE_ID),8) DRIVER_NAME, otm.org_id from XX_ONT_TRIP_MT OTM) XXDVR 


select  distinct *  FROM AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'DRIVER'  and END_DATE_ACTIVE is null and VENDOR_NAME not like '%TP%'


/****************************
Valuset on Item 
***************************/

SELECT distinct CONCATENATED_SEGMENTS,description,inventory_item_id from mtl_system_items_kfv where CONCATENATED_SEGMENTS LIKE '%SP|MECH|PLAT|020909%'

select * from USER_DB_LINKS 


EBS Purchase Order
==============
Valuset:
Operating Unit: XX_OU_NAME
Purchase Order No 
--===============
VEHICLE TYPE VALUSET
--==================
SELECT DISTINCT VEHICLE_TYPE  FROM xx_ont_vehicle_v WHERE REG_NO LIKE '%EXCAVATOR 31%'

--===============
--VEHICLE NUMBER  VALUSET
--==================
1. valuset name : XXTRIP_REG_NO
(SELECT DISTINCT REG_NO, TRANSPORT_TYPE, VEHICLE_ID, ORG_ID FROM XX_ONT_TRIP_MT) XXTDA
WHERE TRANSPORT_TYPE = 'Company Vehicle'
AND VEHICLE_ID IS NOT NULL
AND ORG_ID = 103

2. Valuset Name: XX_VEHICLE_NO


--===================
--USER NAME VALUSET
--===================

SELECT * FROM FND_USER

SELECT * FROM PER_ALL_PEOPLE_F

SELECT *  FROM PER_ALL_PEOPLE_F where FULL_NAME LIKE '%KG-5298%'

--==============
--CREATED BY VALUSET
--==============
NAME: XX_CREATED_BY

SELECT B.USER_ID,A.FULL_NAME  FROM PER_ALL_PEOPLE_F A ,FND_USER B WHERE A.FIRST_NAME=B.USER_NAME

(SELECT B.USER_ID,A.FULL_NAME  FROM PER_ALL_PEOPLE_F A ,FND_USER B WHERE A.FIRST_NAME=B.USER_NAME) X

--=========================
--VEHICLE TYPE
--=========================
NAME: XX_VEHICLE_TYPE

SELECT DISTINCT VEHICLE_TYPE FROM XX_ONT_VEHICLE_V

(SELECT DISTINCT VEHICLE_TYPE FROM XX_ONT_VEHICLE_V) XOV_VT


Inventory org
==============

Oragnization Name --
Valuset: XXKSRM_MO_ORG
FROM DATE:FND_STANDARD_DATE
TO_DATE : FND_STANDARD_DATE
OU/ Operaning Unit: XX_OU_NAME