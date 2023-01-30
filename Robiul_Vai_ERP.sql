--=========================================
-- GET COST CENTER LIST
--=========================================

SELECT  distinct SEGMENT3, XX_GET_ACCT_FLEX_SEG_DESC(3,SEGMENT3)  Cost_Center -- , SEGMENT5 SUB_ACCOUNT_ID, XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT
FROM gl_code_combinations 
WHERE   SEGMENT3 <>0000


--=====================
--GET ALL USE OF AREA LIST
--======================

SELECT GET_OU_NAME_FROM_ID(A.OU_ID), A.* from XXKSRM_INV_USE_AREA_V A


--=======================
-- GET ALL DEPARTMENTS
--=======================

SELECT  DISTINCT FULL_NAME, SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',2,1)+1,INSTR(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',2,1)+1),'.',1)-1) DEPT--, PAPF.START_DATE,END_DATE
----SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1,INSTR(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1),'.',1)-1)  DEPT
--INTO V_DEPT     
FROM PER_ALL_PEOPLE_F      PAPF
,PER_ALL_ASSIGNMENTS_F PAAF
,PER_ALL_POSITIONS     PAP
,FND_USER   FU 
WHERE PAPF.PERSON_ID=PAAF.PERSON_ID
AND PAPF.CURRENT_EMPLOYEE_FLAG='Y'
AND PAAF.PRIMARY_FLAG='Y'
AND PAAF.POSITION_ID=PAP.POSITION_ID
AND TRUNC(SYSDATE) BETWEEN TRUNC(PAPF.EFFECTIVE_START_DATE) 
AND   TRUNC(PAPF.EFFECTIVE_END_DATE)   
AND TRUNC(SYSDATE) BETWEEN TRUNC(PAAF.EFFECTIVE_START_DATE) 
AND   TRUNC(PAAF.EFFECTIVE_END_DATE)
--AND END_DATE is not null
--AND PAPF.PERSON_ID=225 --FU.EMPLOYEE_ID
--AND FU.USER_NAME= 'KG-4079' --225 P_PERSON_ID










-- FINDINGS 
--10731968 This transaction_id have to check in system
--SO NUMBER : 2210000001259




--ROHIM SB ISSUE: Difference Between MAY-21 CLosing andd JUN -21 Opening 

--WE KNOW THAT: MTL_MATERIAL_TRANSACTIONS.TRANSACTION_SOURCE_ID=GME_BATCH_HEADER.BATCH_ID

select * from MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=10731968 --10732231 -- 10731277



select * from gme_batch_header where BATCH_ID= 728982

select * from MTL_TRANSACTION_TYPES where transaction_type_id=17 --5 --44


select * from PER_ALL_PEOPLE_F  WHERE FIRST_NAME = 'KG-3896'

--=============================================
--ANOTHER WIP COMPLETION RETURN IN JAN-21
select * from MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID IN (9257114,10732231)

select * from gme_batch_header where BATCH_ID IN ( 725111, 728982)  ------>

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

select * from org_organization_definitions where ORGANIZATION_CODE  like '%KP%'


SELECT 
NVL(SUM(PRIMARY_QUANTITY),0) --INTO OPEN_QTY
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=NVL(:P_ORG_ID,ORGANIZATION_ID) 
--AND SUBINVENTORY_CODE=NVL(P_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID=:P_INVENTORY_ITEM_ID  
-----AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
--and transaction_type_id <>17
AND  TRUNC(TRANSACTION_DATE) <TO_DATE(:P_DATE_FROM)


SELECT* --INTO OPEN_QTY
FROM 
MTL_MATERIAL_TRANSACTIONS
WHERE 
ORGANIZATION_ID=NVL(:P_ORG_ID,ORGANIZATION_ID) 
--AND SUBINVENTORY_CODE=NVL(P_SUBINVENTORY_CODE,SUBINVENTORY_CODE)
AND INVENTORY_ITEM_ID=:P_INVENTORY_ITEM_ID  
-----AND SUBINVENTORY_CODE<>'STAGIN'  ---- NEW ADD
--and TRANSACTION_ID = 10732231
--and  transaction_type_id=17
AND  TRANSACTION_DATE <TO_DATE(:P_DATE_FROM)

--==================================================================================================================================







select * from PO_LINES_ALL WHERE ITEM_ID = 774051     

select *FROM  PO_HEADERS_ALL WHERE PO_HEADER_ID IN ( 844103,
843082,
844988)


        
      SELECT * FROM MTL_TXN_REQUEST_LINES  where line_id= 534424   
        

select *  from MTL_MATERIAL_TRANSACTIONS  where transaction_id IN( 5910028,1880167, 8180165) 

select * from   GL_CODE_COMBINATIONS_KFV  where CONCATENATED_SEGMENTS = '101.01.1008.6010217.001.0000.000.000.000.000'

select MMT.TRANSACTION_ID, mmt.inventory_item_id,mmt.transaction_quantity,mtt.TRANSACTION_TYPE_NAME, GCCK.CODE_COMBINATION_ID ,GCCK.CONCATENATED_SEGMENTS CODE_COMBINATIONS , 
XX_GET_ACCT_FLEX_SEG_DESC (5, gcck.SEGMENT5,gcck.SEGMENT4) SUB_ACCOUNT,
 XX_GET_ACCT_FLEX_SEG_DESC(4,GCCK.SEGMENT4) ACCOUNT_DESC, GCCK.SEGMENT4 
 from GL_CODE_COMBINATIONS_KFV GCCK,  MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_TYPES MTT
 where GCCK.CODE_COMBINATION_ID(+) = MMT.DISTRIBUTION_ACCOUNT_ID
 and mmt.TRANSACTION_TYPE_ID = mtt.TRANSACTION_TYPE_ID
-- and  GCCK.CODE_COMBINATION_ID IN( 60531 , 62528)
 and mmt.transaction_id IN(4609529)
--and  XX_GET_ACCT_FLEX_SEG_DESC(4,GCCK.SEGMENT4) <> 'Dummy A/C For Opening Stock Upload'
--and mtt.TRANSACTION_TYPE_NAME = 'Issue Return' 
--and mmt.organization_id= 121
--and transaction_date between '01-DEC-2020' and '31-JAN-2021'   

select * from FND_FLEX_VALUES_VL

 
select * from MTL_TRANSACTION_TYPES where TRANSACTION_TYPE_ID  IN(52,
111,
111)
 
 select * from GL_CODE_COMBINATIONS_KFV

DISTRIBUTION_ACCOUNT_ID

select * from HR_OPERATING_UNITS 

-- 774051    TR|TRAD|SCIP|000012    STONE CHIPS (VIETNAM)


SELECT  mmt.transaction_id,mmt.organization_id ,mmt.transaction_source_id header_id,
       mmt.trx_source_line_id line_id,
       mmt.DISTRIBUTION_ACCOUNT_ID,
       mtrl.TO_ACCOUNT_ID,
       (select CODE_COMBINATION_ID from  GL_CODE_COMBINATIONS_KFV where CONCATENATED_SEGMENTS=xgd.WORNG_ACC_CODE) WORNG_ACC_CODE,
              (select CODE_COMBINATION_ID from  GL_CODE_COMBINATIONS_KFV where CONCATENATED_SEGMENTS=xgd.CORRCT_ACC_CODE) CORRCT_ACC_CODE   
  FROM mtl_material_Transactions mmt,
       MTL_TXN_REQUEST_HEADERS mtrh,
       MTL_TXN_REQUEST_LINES mtrl
        WHERE     mmt.organization_id = mtrh.organization_id
       AND mmt.transaction_source_id = mtrh.header_id
       AND mmt.trx_source_line_id = mtrl.line_id
       AND mtrh.HEADER_ID = mtrl.HEADER_ID
     --  AND mmt.transaction_id = xgd.txn_id
      -- AND mmt.organization_id = xgd.org_id
      -- AND mmt.inventory_item_id = xgd.inventory_item_id
       --AND mmt.transaction_type_id = xgd.TRX_TYPE_ID
      -- and mmt.transaction_id=896031
      and XGD.STATUS<>'Y'


SELECT mmt.transaction_id,mmt.organization_id ,mmt.transaction_source_id header_id,
       mmt.trx_source_line_id line_id,
       mmt.DISTRIBUTION_ACCOUNT_ID,
       mtrl.TO_ACCOUNT_ID,
       (select CODE_COMBINATION_ID from  GL_CODE_COMBINATIONS_KFV where CONCATENATED_SEGMENTS=xgd.WORNG_ACC_CODE) WORNG_ACC_CODE,
              (select CODE_COMBINATION_ID from  GL_CODE_COMBINATIONS_KFV where CONCATENATED_SEGMENTS=xgd.CORRCT_ACC_CODE) CORRCT_ACC_CODE     
  FROM mtl_material_Transactions mmt,
       MTL_TXN_REQUEST_HEADERS mtrh,
       MTL_TXN_REQUEST_LINES mtrl,
       apps.XXGLCODEUPDATE xgd
 WHERE     mmt.organization_id = mtrh.organization_id
       AND mmt.transaction_source_id = mtrh.header_id
       AND mmt.trx_source_line_id = mtrl.line_id
       AND mtrh.HEADER_ID = mtrl.HEADER_ID
       AND mmt.transaction_id = xgd.txn_id
       AND mmt.organization_id = xgd.org_id
       AND mmt.inventory_item_id = xgd.inventory_item_id
       AND mmt.transaction_type_id = xgd.TRX_TYPE_ID
      -- and mmt.transaction_id=896031
      and XGD.STATUS<>'Y'