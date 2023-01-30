--============ SERIAL AND LOT ISSUE  WHEN CREATE GRN =======================================

SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE = 'TRB'

SELECT * FROM MTL_MATERIAL_TRANSACTIONS WHERE ORGANIZATION_ID=157 AND INVENTORY_ITEM_ID = 5814 and TRANSACTION_REFERENCE= 'B021895021'  ORDER BY CREATION_DATE DESC

select * from org_organization_definitions

select * from cat where table_name like '%MTL_%LOT%'


select * from MTL_LOT_NUMBERS where ORGANIZATION_ID=152 and INVENTORY_ITEM_ID = 8392

select * from MTL_SERIAL_NUMBERS 
where CURRENT_ORGANIZATION_ID=152 
AND OWNING_ORGANIZATION_ID=152
AND PLANNING_ORGANIZATION_ID=152
AND INVENTORY_ITEM_ID = 8392    and 
SERIAL_NUMBER IN (
'B021895021'
)   

--================================================================================
--============ SERIAL AND LOT ISSUE  WHEN CREATE MOVE ORDER  =======================================



--==================================== MOVE ORDER  QUERY FOR  LOT/Serial Correction ==================================================

-- FOR CHECKING 
SELECT TOL.ATTRIBUTE5,MMT.TRANSACTION_ID TRANSACTION_ID, MMT.TRANSACTION_TYPE_ID,mmt.transaction_date, 
TOH.HEADER_ID WITH_HEADER_ID,TOH.CREATION_DATE,
 XX_GET_EMP_NAME_FROM_USER_ID (TOH.CREATED_BY) CREATED_BY,
  TOL.ORGANIZATION_ID,
  TOH.REQUEST_NUMBER,
  TOH.HEADER_ID,
  TOL.LINE_NUMBER,
  TOL.LINE_ID,
  TOL.INVENTORY_ITEM_ID,
  MY_PACKAGE.XXGET_ITEM_DESCRIPTION(TOL.INVENTORY_ITEM_ID, TOL.ORGANIZATION_ID) ITEM_DESCRIPTION,
  TOH.DESCRIPTION,
  TOH.MOVE_ORDER_TYPE,
  TOL.LINE_STATUS,
  TOL.QUANTITY,
  TOL.QUANTITY_DELIVERED,
  TOL.QUANTITY_DETAILED
FROM MTL_TXN_REQUEST_HEADERS TOH,
  MTL_TXN_REQUEST_LINES TOL,
  MTL_MATERIAL_TRANSACTIONS MMT
WHERE TOH.HEADER_ID = TOL.HEADER_ID
 AND TOH.ORGANIZATION_ID= TOL.ORGANIZATION_ID
 AND TOL.LINE_ID = MMT.MOVE_ORDER_LINE_ID(+)
AND TOH.REQUEST_NUMBER='MO-TRB-0041234'
 --and TOH.HEADER_ID IN (1764072)
-- )



SELECT * FROM MTL_MATERIAL_TRANSACTIONS WHERE ORGANIZATION_ID=157 AND INVENTORY_ITEM_ID = 5814 and TRANSACTION_REFERENCE= 'B021895021'  ORDER BY CREATION_DATE DESC

SELECT * FROM MTL_TXN_REQUEST_HEADERS WHERE REQUEST_NUMBER='MO-TRB-0041234'

SELECT * FROM MTL_TXN_REQUEST_LINES WHERE HEADER_ID= 2112558

select * from MTL_SERIAL_NUMBERS where SERIAL_NUMBER = 'B021895021' 



select GROUP_MARK_ID,LINE_MARK_ID, LOT_LINE_MARK_ID from MTL_SERIAL_NUMBERS where SERIAL_NUMBER = 'B021895021' and INVENTORY_ITEM_ID=5814

--update MTL_SERIAL_NUMBERS 
set GROUP_MARK_ID = null, LINE_MARK_ID = null, LOT_LINE_MARK_ID = null 
where INVENTORY_ITEM_ID = 5814 and SERIAL_NUMBER IN ('B021895021')





--===================================================================

-- LC FORM A GRN LOV QUERY  BATEN VAI
SELECT DISTINCT RECEIPT_NO,RECEIPT_DATE,SUM(RECEIPT_QTY) RECEIPT_QTY,RATE*SUM(RECEIPT_QTY) RATE,SHIPMENT_HEADER_ID
FROM WBI_INV_RCV_TRANSACTIONS_F
WHERE TRANSACTION_TYPE='RECEIVE'
AND PO_HEADER_ID=856418 --:XX_LC_DETAILS.PO_HEADER_ID
GROUP BY RECEIPT_NO,RECEIPT_DATE,RECEIPT_QTY,RATE,SHIPMENT_HEADER_ID

select distinct TABTYPE  from tab   -- tabtype = 


select * from dba_objects    where OBJECT_TYPE = 'FUNCTION'   
and OBJECT_NAME like '%XX%C%'
and OBJECT_NAME LIKE '%ITEM%'

XX_KSRM_GET_ITEM_OP_COST

 SELECT NVL(SUM (CMPNT_COST),0) COST  
     FROM CM_CMPT_DTL CCD, GMF_PERIOD_STATUSES GPS, XX_BAL_SEG_INFO XBEI
     WHERE CCD.PERIOD_ID=GPS.PERIOD_ID
     AND GPS.LEGAL_ENTITY_ID=XBEI.LEGAL_ENTITY_ID
     AND CCD.INVENTORY_ITEM_ID=:P_INVENTORY_ITEM_ID 
     AND CCD.ORGANIZATION_ID= NVL(:P_ORGANIZATION_ID,CCD.ORGANIZATION_ID)
     AND XBEI.LEDGER_ID = NVL(:P_LEDGER_ID, XBEI.LEDGER_ID)
     AND GPS.PERIOD_CODE = TO_CHAR(TRUNC(TO_DATE(:P_PERIOD_CODE,'MON-YY')-1),'MON-YY');
     
     
     select * from XX_BAL_SEG_INFO
     
        (SELECT DISTINCT LEGAL_ENTITY_IDENTIFIER BAL_SEG,
                    b.name BAL_SEG_NAME,
                    A.SET_OF_BOOKS_ID LEDGER_ID,
                    B.LEGAL_ENTITY_ID
      FROM HR_OPERATING_UNITS a, xle_entity_profiles b
     WHERE a.DEFAULT_LEGAL_CONTEXT_ID = b.LEGAL_ENTITY_ID);
     
     
     XX_GMF_RCV_COST
     
     
      SELECT NVL(nullif((CLS_QTY*CLS_COST) - ((OP_QTY*OP_COST)-(ISU_QTY*ISU_COST)),0) /
        NULLIF(case when op_qty = 0 and cls_qty = 0 and isu_qty > 0 then isu_qty
        when op_qty = 0 and cls_qty > 0 and isu_qty = 0 then cls_qty
        when op_qty > 0 and cls_qty > 0 and  isu_qty = 0  then cls_qty - op_qty 
        when op_qty = 0 and cls_qty > 0 and isu_qty > 0 then isu_qty + cls_qty 
        when op_qty > 0 and cls_qty = 0 and isu_qty > 0 then isu_qty - op_qty
        when op_qty > 0 and cls_qty > 0 and isu_qty > 0 then isu_qty + cls_qty - op_qty
        when op_qty = cls_qty and isu_qty = 0 then 0 
        when op_qty = cls_qty and isu_qty > 0 then isu_qty else null end,0),0) 
         FROM
         (SELECT ORGANIZATION_CODE,ORGANIZATION_ID,ITEM_CODE,INVENTORY_ITEM_ID,
            NVL(XX_GMF_OPN_QTY(INVENTORY_ITEM_ID,NULL,ORGANIZATION_ID,:P_PERIOD_CODE),0)  OP_QTY,
            GMF_CMCOMMON.GET_CMPT_COST(INVENTORY_ITEM_ID,ORGANIZATION_ID,TRUNC(TO_DATE(:P_PERIOD_CODE,'MON-YY')-1),1000,0) OP_COST,
            NVL(XX_GMF_ISU_QTY(INVENTORY_ITEM_ID,NULL,ORGANIZATION_ID,:P_PERIOD_CODE),0) ISU_QTY,
            GMF_CMCOMMON.GET_CMPT_COST(INVENTORY_ITEM_ID,ORGANIZATION_ID, TRUNC(TO_DATE(:P_PERIOD_CODE,'MON-YY')),1000,0) ISU_COST,
         NVL(XX_GMF_CLS_QTY(INVENTORY_ITEM_ID,NULL,ORGANIZATION_ID,:P_PERIOD_CODE),0) CLS_QTY,
          (GMF_CMCOMMON.GET_CMPT_COST(INVENTORY_ITEM_ID,ORGANIZATION_ID, TRUNC(TO_DATE(:P_PERIOD_CODE,'MON-YY')),1000,0)) CLS_COST
            FROM XXINV_ITEM_TRANS_COUNT_VW
            WHERE ORGANIZATION_ID=:P_ORGANIZATION_ID
            AND INVENTORY_ITEM_ID=:P_INVENTORY_ITEM_ID)
    
 --===============================================================================================================
 -- FUNCTION TO GET CURRENT ITEM QUANTITY O FROM OPM FINANCIAL        
 --===============================================================================================================
            
         --   CREATE OR REPLACE FUNCTION XX_GET_PRIOR_ITEM_QTY(P_PERIOD_CODE IN VARCHAR2, P_ORGANIZATION_ID IN NUMBER,P_INVENTORY_ITEM_ID IN NUMBER )
RETURN NUMBER IS
    V_QTY number;
    BEGIN
SELECT SUM(PRIMARY_QUANTITY) INTO V_QTY
    FROM GMF_PERIOD_BALANCES  GPB,ORG_ACCT_PERIODS   OAP , ORG_ORGANIZATION_DEFINITIONS OOD            
    WHERE  GPB.ACCT_PERIOD_ID=OAP.ACCT_PERIOD_ID  AND OAP.ORGANIZATION_ID=OOD.ORGANIZATION_ID AND GPB.ORGANIZATION_ID=OOD.ORGANIZATION_ID
    AND UPPER(OAP.PERIOD_NAME)=TO_CHAR(TRUNC(TO_DATE(P_PERIOD_CODE,'MON-YY')-1),'MON-YY')    
    AND GPB.ORGANIZATION_ID=P_ORGANIZATION_ID    
     AND GPB.INVENTORY_ITEM_ID=P_INVENTORY_ITEM_ID;
     RETURN V_QTY;
     EXCEPTION
      WHEN OTHERS THEN 
      RETURN 0;
     END;
     







select* from MTL_TRANSACTION_TYPES where TRANSACTION_TYPE_NAME =   'Logical Intransit Receipt'

select * from MTL_TRANSACTION_TYPES
where TRANSACTION_TYPE_ID IN (42, 163, 129)
--WHERE  transaction_source_type_id   IN (5,7,9)

select * from MTL_TRANSACTION_TYPES
WHERE  transaction_source_type_id  IN (7,8,13)
--and TRANSACTION_ACTION_ID = 28

select DISTINCT TRANSACTION_TYPE_ID ,TRANSACTION_TYPE_NAME ,DESCRIPTION from MTL_TRANSACTION_TYPES
WHERE TRANSACTION_TYPE_ID IN (12,61)  --27
and TRANSACTION_TYPE_ID not in(59, 76)

SELECT distinct SOURCE_CODE from MTL_MATERIAL_TRANSACTIONS

select distinct RVT.SOURCE_DOC_CODE from RCV_VRC_TXS_V RVT


select * from MTL_MATERIAL_TRANSACTIONS where transaction_id=295352 -- 809035 --596459

select * from MTL_TXN_REQUEST_LINES_V where line_id=61717 --305303 -- 255601 --REQUEST_NUMBER = 'MO-KSA-0002308' 

select DISTINCT TRANSACTION_SOURCE_TYPE_NAME from invfv_material_transactions 

select  * from invfv_material_transactions 
where 1=1
--and TRANSACTION_SOURCE_TYPE_NAME is not null
and TRANSACTION_SRC_HDR  is  null 

select SHIPMENT_NUMBER  from MTL_MATERIAL_TRANSACTIONS where SHIPMENT_NUMBER=454422 --SHIPMENT_NUMBER  is  null  and SHIPMENT_NUMBER='454422'

/* 1. 2010104  EI CODE ER  AGAINST A BLANK REFFERENCE COLUMN JA DEKHA JAE  ER KAORN HOLO EGULO MISCELINIOUS TRANSACTION, TAI KONO MOVE ORDER NUMBER PORE NA  
    2. 
*/
--SELECT SUM(DR_AMT), SUM(CR_AMT) FROM (
/*EBS GL Account Wise Ledger Baten Vai*/
SELECT MMT.TRANSACTION_ID, B.EVENT_TYPE_CODE,
CASE WHEN IMT.TRANSACTION_SRC_HDR IS  NULL THEN MMT.SHIPMENT_NUMBER ELSE IMT.TRANSACTION_SRC_HDR END REFERENCE,
(SELECT TRANSACTION_TYPE_NAME FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID) TRN_TYPE,
XX_INV_PKG.XXGET_PARTICULAR_NAME(MMT.TRANSACTION_ID) REF,
D.BAL_SEG, D.BAL_SEG_NAME,B.LEDGER_ID,A.ACCOUNTING_DATE,
--DECODE(A.APPLICATION_ID, 200,'AP-'||DOC_SEQUENCE_VALUE, 222,'AR-'||DOC_SEQUENCE_VALUE, DOC_SEQUENCE_VALUE) VOUCHER_NUMBER
DECODE(B.EVENT_TYPE_CODE, 'REFUND RECORDED','AP PAY','PAYMENT CREATED','AP PAY','PAYMENT CLEARED','AP PAY','PAYMENT CANCELLED','AP PAY','REFUND CANCELLED','AP PAY',
'PREPAYMENT APPLIED','AP INV','PREPAYMENT CANCELLED','AP INV','CREDIT MEMO VALIDATED','AP INV','INVOICE CANCELLED','AP INV',
'PREPAYMENT UNAPPLIED','AP INV','INVOICE VALIDATED','AP INV','PREPAYMENT VALIDATED','AP INV','CREDIT MEMO CANCELLED','AP INV',
'CM_CREATE','AR INV','DM_CREATE','AR INV','INV_CREATE','AR INV','CM_UPDATE','AR INV','RECP_CREATE','AR RCV',
'MISC_RECP_CREATE','AR RCV','MISC_RECP_REVERSE','AR RCV','RECP_REVERSE','AR RCV','RECP_UPDATE','AR RCV')||'-'|| DOC_SEQUENCE_VALUE VOUCHER_NUMBER
,B.EVENT_TYPE_CODE,A.AE_HEADER_ID, A.APPLICATION_ID,XX_PARTY_VENDOR_NAME_FUNCTION(A.APPLICATION_ID, PARTY_ID) PARTY_VENDOR_NAME,
B.JE_CATEGORY_NAME,
SEGMENT4,
XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) ACCOUNT_DESC,
XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT,
PARTY_ID,
XX_OPOSITE_HEAD_FUNCTION(:P_ACCOUNT_CODE, A.AE_HEADER_ID) OPOSITE_HEAD,
DECODE( XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, B.EVENT_ID) , NULL , NULL, XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, B.EVENT_ID)||'.')
|| DECODE( XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID) , NULL , NULL, XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID)||'.' )
|| DECODE( XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME) , NULL , NULL,
XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME)||'.' ) DFF_INFO,
NVL(SUM(ACCOUNTED_DR),0) DR_AMT,NVL(SUM(ACCOUNTED_CR),0) CR_AMT
FROM XLA_AE_LINES A, XLA_AE_HEADERS B, GL_CODE_COMBINATIONS C, XX_BAL_SEG_INFO D,-- xla_events ev,
GMF_XLA_EXTRACT_HEADERS E, MTL_MATERIAL_TRANSACTIONS MMT,INVFV_MATERIAL_TRANSACTIONS IMT
WHERE C.CODE_COMBINATION_ID=A.CODE_COMBINATION_ID
AND A.AE_HEADER_ID=B.AE_HEADER_ID
AND SEGMENT4=NVL(:P_ACCOUNT_CODE,SEGMENT4)
AND B.LEDGER_ID=D.LEDGER_ID 
AND A.ACCOUNTING_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
AND A.ACCOUNTING_DATE>'31-AUG-2018'
AND BAL_SEG=NVL(:P_BAL_SEG,BAL_SEG)
AND SEGMENT5=NVL(:P_SUB_ACC,SEGMENT5)
-- and EV.event_id = b.event_id
AND B.EVENT_ID = E.EVENT_ID(+)
AND E.TRANSACTION_ID=MMT.TRANSACTION_ID(+)
AND MMT.TRANSACTION_ID= IMT.TRANSACTION_ID(+)
--and b.EVENT_TYPE_CODE ='PO_RECEIPT' -- 'MOVE_ORDER_ISSUE'
GROUP BY MMT.TRANSACTION_TYPE_ID,
MMT.TRANSACTION_ID,XX_INV_PKG.XXGET_PARTICULAR_NAME(MMT.TRANSACTION_ID),IMT.TRANSACTION_SRC_HDR, MMT.SHIPMENT_NUMBER,
D.BAL_SEG, D.BAL_SEG_NAME,B.LEDGER_ID,A.ACCOUNTING_DATE,
DECODE(B.EVENT_TYPE_CODE, 'REFUND RECORDED','AP PAY','PAYMENT CREATED','AP PAY','PAYMENT CLEARED','AP PAY','PAYMENT CANCELLED','AP PAY','REFUND CANCELLED','AP PAY',
'PREPAYMENT APPLIED','AP INV','PREPAYMENT CANCELLED','AP INV','CREDIT MEMO VALIDATED','AP INV','INVOICE CANCELLED','AP INV',
'PREPAYMENT UNAPPLIED','AP INV','INVOICE VALIDATED','AP INV','PREPAYMENT VALIDATED','AP INV','CREDIT MEMO CANCELLED','AP INV',
'CM_CREATE','AR INV','DM_CREATE','AR INV','INV_CREATE','AR INV','CM_UPDATE','AR INV','RECP_CREATE','AR RCV',
'MISC_RECP_CREATE','AR RCV','MISC_RECP_REVERSE','AR RCV','RECP_REVERSE','AR RCV','RECP_UPDATE','AR RCV')||'-'|| DOC_SEQUENCE_VALUE
,B.EVENT_TYPE_CODE,A.AE_HEADER_ID, A.APPLICATION_ID,XX_PARTY_VENDOR_NAME_FUNCTION(A.APPLICATION_ID, PARTY_ID) ,
B.JE_CATEGORY_NAME,
SEGMENT4,XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) , PARTY_ID,
XX_OPOSITE_HEAD_FUNCTION(:P_ACCOUNT_CODE, A.AE_HEADER_ID),
DECODE( XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, B.EVENT_ID) , NULL , NULL, XX_AP_DFF_FUNCTION(DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID, B.EVENT_ID)||'.')
|| DECODE( XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID) , NULL , NULL, XX_FIN_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID)||'.' )
|| DECODE( XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME) , NULL , NULL,
XX_AP_INV_DESC_FUNCTION(B.APPLICATION_ID,B.DOC_SEQUENCE_VALUE, D.LEGAL_ENTITY_ID,B.JE_CATEGORY_NAME)||'.' ) ,
XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4)
--)

--====================================================================





-- XXKSRM Inventory Stock (LE Wise)  prepared by baten vai
/*
PARAMETER:
p_legal_entity_id='26287'
P_OPERATING_UNIT='108'
P_ITEM_TYPE='TRADING ITEMS'
P_ITEM_GROUP='TRADING ITEMS'
P_TRANSACTION_DATE_FROM='2020/08/01 00:00:00'
P_TRANSACTION_DATE_TO='2020/08/31 00:00:00'
*/

WITH items
       AS (SELECT   xiv.le_id,
                    xiv.le_code,
                    xiv.le_name,
                    xiv.ou_id,
                    xiv.ou_code,
                    xiv.ou_name,
                    xiv.io_code,
                    xiv.io_name,
                    msik.organization_id,
                    msik.inventory_item_id,
                    msik.concatenated_segments item_code,
                    msik.description item_name,
                    msik.primary_uom_code p_uom_code,
                    msik.primary_unit_of_measure p_uom_name,
                    msik.secondary_uom_code s_uom_code,
                    mic.segment1 mjr_cat,
                    mic.segment2 mnr_cat
             FROM   mtl_system_items_kfv msik,
                    mtl_item_categories_v mic,
                    xx_inv_iooule_v xiv,
                    MTL_PARAMETERS_VIEW MPV
            WHERE       msik.organization_id = mic.organization_id
                    AND msik.inventory_item_id = mic.inventory_item_id
                    AND mic.segment1<>'DEFAULT'
                    AND msik.organization_id = MPV.organization_id
                    AND mic.structure_id = 101
                    AND msik.organization_id = xiv.io_id
                    AND xiv.LE_ID = :p_legal_entity_id
                    AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                    AND (:P_ORGANIZATION_ID IS NULL  OR  msik.organization_id = :P_ORGANIZATION_ID)
                    AND (:p_item_id IS NULL OR  msik.inventory_item_id = :p_item_id)
                    AND mic.segment1=NVL(:P_ITEM_TYPE,mic.segment1)
                    AND mic.segment2=NVL(:P_ITEM_GROUP,mic.segment2)
                    AND mic.segment3=NVL(:P_ITEM_SUB_GROUP,mic.segment3)
                    AND NVL(mic.CATEGORY_CONCAT_SEGS,'XXXX')=NVL(:P_FINANCE_CATEGORY,NVL(mic.CATEGORY_CONCAT_SEGS,'XXXX'))
                    ),
    trans
       AS (  SELECT   organization_id,
                      inventory_item_id,
                 SUM (NVL (opn_p_qty , 0))  opn_p_qty,
                 SUM (NVL (opn_s_qty , 0))  opn_s_qty,
                 SUM (NVL (opn_val   , 0))  opn_val,
                      SUM (NVL (normal_rcv_p_qty , 0) + NVL (trn_rcv_p_qty, 0) + NVL (transfer_in_p_qty, 0)) rcv_p_qty,
                      SUM (NVL (normal_rcv_s_qty , 0) + NVL (trn_rcv_s_qty, 0) + NVL (transfer_in_s_qty    , 0)) rcv_s_qty,
                      SUM (NVL (normal_rcv_val   , 0) + NVL (trn_rcv_val  , 0) + NVL (transfer_in_val  , 0))   rcv_val,
                      SUM (NVL (normal_rcv_p_qty , 0))  normal_rcv_p_qty  ,
                      SUM (NVL (normal_rcv_s_qty , 0))  normal_rcv_s_qty  ,
                      SUM (NVL (normal_rcv_val   , 0))  normal_rcv_val    ,                      
                      SUM (NVL (trn_rcv_p_qty    , 0))  trn_rcv_p_qty     ,
                      SUM (NVL (trn_rcv_s_qty    , 0))  trn_rcv_s_qty     ,
                      SUM (NVL (trn_rcv_val      , 0))  trn_rcv_val       ,
                      SUM (NVL (transfer_in_p_qty, 0))  transfer_in_p_qty ,
                      SUM (NVL (transfer_in_s_qty, 0))  transfer_in_s_qty ,
                      SUM (NVL (transfer_in_val  , 0))  transfer_in_val   ,
              ABS (SUM (NVL (normal_iss_p_qty, 0) + NVL (trn_iss_p_qty, 0) + NVL (transfer_out_p_qty, 0))) iss_p_qty,
              ABS (SUM (NVL (normal_iss_s_qty, 0) + NVL (trn_iss_s_qty, 0) + NVL (transfer_out_s_qty, 0))) iss_s_qty,
              ABS (SUM (NVL (normal_iss_val  , 0) + NVL (trn_iss_val  , 0) + NVL (transfer_out_val  , 0))) iss_val  ,
              ABS (SUM (NVL (normal_iss_p_qty, 0))) normal_iss_p_qty,
              ABS (SUM (NVL (normal_iss_s_qty, 0))) normal_iss_s_qty,
              ABS (SUM (NVL (normal_iss_val  , 0))) normal_iss_val  ,
              ABS (SUM (NVL (trn_iss_p_qty, 0))) trn_iss_p_qty,
              ABS (SUM (NVL (trn_iss_s_qty, 0))) trn_iss_s_qty,
              ABS (SUM (NVL (trn_iss_val  , 0)))  trn_iss_val ,
              ABS (SUM (NVL (transfer_out_p_qty, 0)))    transfer_out_p_qty,
              ABS (SUM (NVL (transfer_out_s_qty, 0)))    transfer_out_s_qty,
              ABS (SUM (NVL (transfer_out_val  , 0)))    transfer_out_val,
              SUM (NVL (cls_p_qty, 0)) cls_p_qty,
              SUM (NVL (cls_s_qty, 0)) cls_s_qty,
              SUM (NVL (cls_val, 0)) cls_val
                    FROM   ( SELECT   mmt.organization_id,
                                mmt.inventory_item_id,
                               --XX_INV_PKG.XX_INV_OPEN_QTY_WO_STG(MMT.ORGANIZATION_ID,NULL, MMT.INVENTORY_ITEM_ID ,:P_TRANSACTION_DATE_FROM) opn_p_qty,
                               mmt.primary_quantity opn_p_qty,
                                mmt.secondary_transaction_quantity opn_s_qty,
                                (case when MPV.PROCESS_ENABLED_FLAG='Y' then 
                                           mmt.primary_quantity * nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
                                      else cid.base_transaction_value end) opn_val,
                                TO_NUMBER (0) normal_rcv_p_qty,
                                TO_NUMBER (0) normal_rcv_s_qty,
                                TO_NUMBER (0) normal_rcv_val,  
                                TO_NUMBER (0) trn_rcv_p_qty,
                                TO_NUMBER (0) trn_rcv_s_qty,
                                TO_NUMBER (0) trn_rcv_val,
                    TO_NUMBER (0) transfer_in_p_qty,
                    TO_NUMBER (0) transfer_in_s_qty,
                    TO_NUMBER (0) transfer_in_val,
                                TO_NUMBER (0) normal_iss_p_qty,
                                TO_NUMBER (0) normal_iss_s_qty,
                                TO_NUMBER (0) normal_iss_val  ,
                                TO_NUMBER (0) trn_iss_p_qty,
                                TO_NUMBER (0) trn_iss_s_qty,
                                TO_NUMBER (0) trn_iss_val,
                    TO_NUMBER (0) transfer_out_p_qty,
                    TO_NUMBER (0) transfer_out_s_qty,
                    TO_NUMBER (0) transfer_out_val,                                
                                TO_NUMBER (0) cls_p_qty,
                                TO_NUMBER (0) cls_s_qty,
                                TO_NUMBER (0) cls_val
                         FROM   mtl_material_transactions mmt,
                                cst_inv_distribution_v cid,
                                xx_inv_iooule_v xiv,
                                MTL_PARAMETERS_VIEW MPV
                        WHERE       mmt.organization_id = xiv.io_id
                        and mmt.organization_id = cid.organization_id (+)
                        and mmt.transaction_id = cid.transaction_id(+)
                        AND MMT.organization_id = MPV.organization_id
                        and cid. ACCOUNTING_LINE_TYPE (+) = 1
                        AND TRUNC (mmt.transaction_date) < :P_TRANSACTION_DATE_FROM
                        AND xiv.LE_ID = :p_legal_entity_id
                        AND MMT.TRANSACTION_TYPE_ID NOT IN (59,76)
                        AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                        AND (:P_ORGANIZATION_ID IS NULL  OR  MMT.organization_id = :P_ORGANIZATION_ID)
                        AND (:p_item_id IS NULL OR  MMT.inventory_item_id = :p_item_id)
--                        AND (:p_si_code IS NULL OR mmt.subinventory_code = :p_si_code)
                               AND mmt.transaction_type_id NOT IN (2,52,59, 76,80,10008)        --- ADDED BY MD SOHEL HOSSAIN
         UNION ALL       --- RCV PART------
                    SELECT   mmt.organization_id,
                                 mmt.inventory_item_id,
                                TO_NUMBER (0) opn_p_qty,
                                TO_NUMBER (0) opn_s_qty,
                                TO_NUMBER (0) opn_val,
                               -- (CASE WHEN mtt.transaction_action_id = 27 AND MTT.transaction_source_type_id NOT IN (5,7, 8) THEN mmt.primary_quantity  ELSE 0 END) normal_rcv_p_qty,
                                NVL((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID AND PRIMARY_QUANTITY>0),0) normal_rcv_p_qty,
                                (CASE WHEN mtt.transaction_action_id = 27 AND MTT.transaction_source_type_id NOT IN (5,7, 8) THEN mmt.secondary_transaction_quantity ELSE 0 END) normal_rcv_s_qty,
                                (CASE WHEN mtt.transaction_action_id = 27 AND MTT.transaction_source_type_id NOT IN (5,7, 8) THEN
                                       (case when MPV.PROCESS_ENABLED_FLAG='Y' then mmt.primary_quantity 
                                       * nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
                                      else cid.base_transaction_value end)  ELSE 0 END)  normal_rcv_val,
                                (CASE WHEN  mtt.transaction_source_type_id IN (5) AND SIGN (mmt.primary_quantity) = 1--mtt.transaction_type_id IN (2,3,12,21,35,43)
                                    THEN mmt.primary_quantity ELSE 0 END) trn_rcv_p_qty,
                                (CASE WHEN  mtt.transaction_source_type_id IN (5) AND SIGN (mmt.primary_quantity) = 1--mtt.transaction_type_id IN (2,3,12,21,35,43) 
                                    THEN mmt.secondary_transaction_quantity ELSE 0 END) trn_rcv_s_qty,
                                (CASE WHEN   mtt.transaction_source_type_id IN (5) AND SIGN (mmt.primary_quantity) = 1--mtt.transaction_type_id IN (2,3,12,21,35,43)
                                    THEN (case when MPV.PROCESS_ENABLED_FLAG='Y' then 
                                            mmt.primary_quantity * nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
                                      else cid.base_transaction_value end) ELSE 0  END) trn_rcv_val,
-------Transfer in-----                                      
(CASE WHEN  mtt.transaction_source_type_id IN (7,8,13) AND mtt.transaction_action_id <> 27 AND SIGN (mmt.primary_quantity) = 1
      THEN mmt.primary_quantity ELSE 0 END) transfer_in_p_qty,
(CASE WHEN  mtt.transaction_source_type_id IN (7,8,13) AND mtt.transaction_action_id <> 27 AND SIGN (mmt.primary_quantity) = 1
      THEN mmt.secondary_transaction_quantity ELSE 0 END) transfer_in_s_qty,
(CASE WHEN  mtt.transaction_source_type_id IN (7,8,13) AND mtt.transaction_action_id <> 27 AND SIGN (mmt.primary_quantity) = 1
      THEN (case when MPV.PROCESS_ENABLED_FLAG='Y' 
      THEN  mmt.primary_quantity * nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
             else cid.base_transaction_value end) ELSE 0  END) transfer_in_val,
-------Transfer in-----              
                                TO_NUMBER (0) normal_iss_p_qty,
                                TO_NUMBER (0) normal_iss_s_qty,
                                TO_NUMBER (0) normal_iss_val  ,
                                TO_NUMBER (0) trn_iss_p_qty,
                                TO_NUMBER (0) trn_iss_s_qty,
                                TO_NUMBER (0) trn_iss_val,
                    TO_NUMBER (0) transfer_out_p_qty,
                    TO_NUMBER (0) transfer_out_s_qty,
                    TO_NUMBER (0) transfer_out_val, 
                                TO_NUMBER (0) cls_p_qty,
                                TO_NUMBER (0) cls_s_qty,
                                TO_NUMBER (0) cls_val
                         FROM   mtl_material_transactions mmt,
                                mtl_transaction_types mtt,
                                cst_inv_distribution_v cid,
                                xx_inv_iooule_v xiv,
                                MTL_PARAMETERS_VIEW MPV
                        WHERE   mmt.transaction_type_id =  mtt.transaction_type_id
                                AND mmt.organization_id = xiv.io_id
                                and mmt.organization_id = cid.organization_id (+)
                                and mmt.transaction_id = cid.transaction_id(+)
                                AND MMT.organization_id = MPV.organization_id
                                and cid. ACCOUNTING_LINE_TYPE(+) = 1
--                                AND MTT.transaction_action_id=27
                                AND TRUNC (mmt.transaction_date) BETWEEN :P_TRANSACTION_DATE_FROM  AND  :P_TRANSACTION_DATE_TO
                                AND xiv.LE_ID = :p_legal_entity_id
                        AND MMT.TRANSACTION_TYPE_ID NOT IN (59,76)
                                AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                                AND (:P_ORGANIZATION_ID IS NULL  OR  MMT.organization_id = :P_ORGANIZATION_ID)
                                AND (:p_item_id IS NULL OR  MMT.inventory_item_id = :p_item_id)
--                                AND (:p_si_code IS NULL OR mmt.subinventory_code = :p_si_code)
                           --     AND MTT.transaction_action_id <> 28
            UNION ALL
                        SELECT   mmt.organization_id,
                                 mmt.inventory_item_id,
                                TO_NUMBER (0) opn_p_qty,
                                TO_NUMBER (0) opn_s_qty,
                                TO_NUMBER (0) opn_val,
                                TO_NUMBER (0) normal_rcv_p_qty,
                                TO_NUMBER (0) normal_rcv_s_qty,
                                TO_NUMBER (0) normal_rcv_val  ,
                                TO_NUMBER (0) trn_rcv_p_qty,
                                TO_NUMBER (0) trn_rcv_s_qty,
                                TO_NUMBER (0) trn_rcv_val,
                    TO_NUMBER (0) transfer_in_p_qty,
                    TO_NUMBER (0) transfer_in_s_qty,
                    TO_NUMBER (0) transfer_in_val,
                                (CASE WHEN MTT.transaction_action_id=1 AND MTT.transaction_source_type_id NOT IN (5,7, 8) THEN mmt.primary_quantity ELSE 0 END) normal_iss_p_qty,
                                (CASE WHEN MTT.transaction_action_id=1 AND MTT.transaction_source_type_id NOT IN (5,7, 8) THEN mmt.secondary_transaction_quantity ELSE 0 END) normal_iss_s_qty,
                                (CASE WHEN MTT.transaction_action_id=1 AND MTT.transaction_source_type_id NOT IN (5,7, 8) THEN
                                       (case when MPV.PROCESS_ENABLED_FLAG='Y' then  mmt.primary_quantity *
                                            nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
                                      else cid.base_transaction_value end) ELSE 0 END) normal_iss_val,
                                (CASE WHEN  mtt.transaction_source_type_id IN (5) AND SIGN (mmt.primary_quantity) = -1--mtt.transaction_type_id IN (2,3,12,21,35,43) 
                                    THEN mmt.primary_quantity ELSE 0 END) trn_iss_p_qty,
                                (CASE WHEN  mtt.transaction_source_type_id IN (5) AND SIGN (mmt.primary_quantity) = -1--mtt.transaction_type_id IN (2,3,12,21,35,43) 
                                    THEN mmt.secondary_transaction_quantity ELSE 0 END) trn_iss_s_qty,
                                (CASE WHEN  mtt.transaction_source_type_id IN (5) AND SIGN (mmt.primary_quantity) = -1--mtt.transaction_type_id IN (2,3,12,21,35,43) 
                                    THEN (case when MPV.PROCESS_ENABLED_FLAG='Y' then  mmt.primary_quantity *
                                            nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
                                      else cid.base_transaction_value end) ELSE 0 END) trn_iss_val,
-------Transfer in-----                                      
(CASE WHEN  mtt.transaction_source_type_id IN (7,8,13) AND mtt.transaction_action_id <> 1 AND SIGN (mmt.primary_quantity) = -1
      THEN mmt.primary_quantity ELSE 0 END) transfer_out_p_qty,
(CASE WHEN  mtt.transaction_source_type_id IN (7,8,13) AND mtt.transaction_action_id <> 1 AND SIGN (mmt.primary_quantity) = -1
      THEN mmt.secondary_transaction_quantity ELSE 0 END) transfer_out_s_qty,
(CASE WHEN  mtt.transaction_source_type_id IN (7,8,13) AND mtt.transaction_action_id <> 1 AND SIGN (mmt.primary_quantity) = -1
      THEN (case when MPV.PROCESS_ENABLED_FLAG='Y' 
      THEN  mmt.primary_quantity * nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
             else cid.base_transaction_value end) ELSE 0  END) transfer_out_val,
-------Transfer in-----                                              
                                TO_NUMBER (0) cls_p_qty,
                                TO_NUMBER (0) cls_s_qty,
                                TO_NUMBER (0) cls_val
                         FROM   mtl_material_transactions mmt,
                                mtl_transaction_types mtt,
                                cst_inv_distribution_v cid,
                                xx_inv_iooule_v xiv,
                                MTL_PARAMETERS_VIEW MPV
                        WHERE   mmt.transaction_type_id =  mtt.transaction_type_id
                                AND mmt.organization_id = xiv.io_id
                                and mmt.organization_id = cid.organization_id (+)
                                and mmt.transaction_id = cid.transaction_id(+)
                                AND MMT.organization_id = MPV.organization_id
                                and cid. ACCOUNTING_LINE_TYPE(+) = 1
--                                AND MTT.transaction_action_id=1
                                AND TRUNC (mmt.transaction_date) BETWEEN :P_TRANSACTION_DATE_FROM  AND  :P_TRANSACTION_DATE_TO
                                AND xiv.LE_ID = :p_legal_entity_id
                                AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                                AND (:P_ORGANIZATION_ID IS NULL  OR  MMT.organization_id = :P_ORGANIZATION_ID)
                                AND (:p_item_id IS NULL OR  MMT.inventory_item_id = :p_item_id)
--                                AND (:p_si_code IS NULL OR mmt.subinventory_code = :p_si_code)
                                AND MTT.transaction_action_id <> 28
          UNION ALL
                        SELECT  mmt.organization_id,
                                mmt.inventory_item_id,
                                TO_NUMBER (0) opn_p_qty,
                                TO_NUMBER (0) opn_s_qty,
                                TO_NUMBER (0) opn_val,
                                TO_NUMBER (0) normal_rcv_p_qty,
                                TO_NUMBER (0) normal_rcv_s_qty,
                                TO_NUMBER (0) normal_rcv_val,  
                                TO_NUMBER (0) trn_rcv_p_qty,
                                TO_NUMBER (0) trn_rcv_s_qty,
                                TO_NUMBER (0) trn_rcv_val,
                    TO_NUMBER (0) transfer_in_p_qty,
                    TO_NUMBER (0) transfer_in_s_qty,
                    TO_NUMBER (0) transfer_in_val,
                                TO_NUMBER (0) normal_rcv_p_qty,
                                TO_NUMBER (0) normal_rcv_s_qty,
                                TO_NUMBER (0) normal_rcv_val  ,
                                TO_NUMBER (0) trn_iss_p_qty,
                                TO_NUMBER (0) trn_iss_s_qty,
                                TO_NUMBER (0) trn_iss_val,
                    TO_NUMBER (0) transfer_out_p_qty,
                    TO_NUMBER (0) transfer_out_s_qty,
                    TO_NUMBER (0) transfer_out_val,   
                                mmt.primary_quantity cls_p_qty,
                                mmt.secondary_transaction_quantity cls_s_qty,
                                (case when MPV.PROCESS_ENABLED_FLAG='Y' 
                                --AND mmt.primary_quantity > 0   ------------------hANDELING Closing val Positive where QTY is 0)
                               then mmt.primary_quantity *
                                            nvl(xx_inv_pkg.get_mfg_org_item_cost ( mmt.organization_id, mmt.inventory_item_id, TRUNC (mmt.transaction_date)),0)
                                      else cid.base_transaction_value end) cls_val
                         FROM   mtl_material_transactions mmt,
                         cst_inv_distribution_v cid,
                                xx_inv_iooule_v xiv,
                                MTL_PARAMETERS_VIEW MPV
                        WHERE   mmt.organization_id = xiv.io_id
                        and     mmt.organization_id = cid.organization_id (+)
                        and mmt.transaction_id = cid.transaction_id(+)
                        AND MMT.organization_id = MPV.organization_id
                        and cid. ACCOUNTING_LINE_TYPE(+) = 1
--                      AND mmt.transaction_type_id NOT IN (2,52, 59,76,80,10008)
                        AND TRUNC (mmt.transaction_date) <= :P_TRANSACTION_DATE_TO
                        AND xiv.LE_ID = :p_legal_entity_id
                        AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                        AND (:P_ORGANIZATION_ID IS NULL  OR  MMT.organization_id = :P_ORGANIZATION_ID)
                        AND (:p_item_id IS NULL OR  MMT.inventory_item_id = :p_item_id))
--                      AND (:p_si_code IS NULL OR mmt.subinventory_code = :p_si_code) )
           GROUP BY   organization_id, inventory_item_id)
SELECT i.le_name
         ,i.ou_name
         ,i.io_code
         ,i.io_name
         ,i.item_code
         ,i.item_name
         ,i.p_uom_code
         ,i.s_uom_code
         ,i.mjr_cat
         ,i.mnr_cat
         ,t.opn_p_qty
         ,t.opn_s_qty
         ,decode(t.opn_p_qty, 0, 0, t.opn_val/t.opn_p_qty) opn_cost
         ,t.opn_val
         ---------------Normal-------------------
         ,t.normal_rcv_p_qty
         ,t.normal_rcv_s_qty
         ,decode(t.normal_rcv_p_qty, 0, 0, t.normal_rcv_val/t.normal_rcv_p_qty) normal_rcv_cost
         ,t.normal_rcv_val
         ---------------WIP---------------------
         ,t.trn_rcv_p_qty
         ,t.trn_rcv_s_qty
         ,decode(t.trn_rcv_p_qty, 0, 0, t.trn_rcv_val/t.trn_rcv_p_qty) trn_rcv_cost
         ,t.trn_rcv_val
         -----------------Transfer in-----------
         ,t.transfer_in_p_qty
         ,t.transfer_in_s_qty
         ,decode(t.transfer_in_p_qty, 0, 0, t.transfer_in_val/t.transfer_in_p_qty) transfer_in_cost
         ,t.transfer_in_val
         ---------------------------------------
         ,t.rcv_p_qty
         ,t.rcv_s_qty
         ,decode(t.rcv_p_qty, 0, 0, t.rcv_val/t.rcv_p_qty) rcv_cost
         ,t.rcv_val         
          ---------------TTL_rcv_code------------
         ,(t.opn_p_qty + t.rcv_p_qty) stk_p_qty
         ,(t.opn_s_qty + rcv_s_qty) stk_s_qty
         ,decode((t.opn_p_qty + t.rcv_p_qty), 0, 0, (t.opn_val + t.rcv_val)/(t.opn_p_qty + t.rcv_p_qty)) stk_cost
         ,(t.opn_val + t.rcv_val) stk_val
         -------------Normal Issue----------------------
         ,normal_iss_p_qty
         ,normal_iss_s_qty
         ,decode(t.normal_iss_p_qty, 0, 0, t.normal_iss_val/t.normal_iss_p_qty) normal_iss_cost
         ,normal_iss_val
         -------------Wip Issue------------------------
         ,t.trn_iss_p_qty
         ,t.trn_iss_s_qty
         ,decode(t.trn_iss_p_qty, 0, 0, t.trn_iss_val/t.trn_iss_p_qty) trn_iss_cost
         ,t.trn_iss_val
         ---------------Transfer out-----------------------
         ,t.transfer_out_p_qty
         ,t.transfer_out_s_qty
         ,decode(t.transfer_out_p_qty, 0, 0, t.transfer_out_val/t.transfer_out_p_qty) transfer_out_cost
         ,t.transfer_out_val
         ---------------------------------------
         ,t.iss_p_qty
         ,t.iss_s_qty
         ,decode(t.iss_p_qty, 0, 0, t.iss_val/t.iss_p_qty) iss_cost
         ,t.iss_val
         --------------ttl_isseut----------------------
--         ,(t.iss_p_qty+trn_iss_p_qty+transfer_out_p_qty) ttl_iss_p_qty
--         ,(t.iss_s_qty+trn_iss_s_qty+transfer_out_s_qty) ttl_iss_s_qty
--         ,decode((t.iss_p_qty+trn_iss_p_qty+transfer_out_p_qty), 0, 0, (t.iss_val+trn_iss_val+transfer_out_val)/(t.iss_p_qty+trn_iss_p_qty+transfer_out_p_qty)) ttl_iss_cose
--         ,(t.iss_val+trn_iss_val+transfer_out_val) ttl_iss_val
--         ---------------------------------------
         ,t.cls_p_qty
         ,t.cls_s_qty
         ,decode(t.cls_p_qty, 0, 0, t.cls_val/t.cls_p_qty) cls_cost
         ,t.cls_val
         ,(t.opn_p_qty + t.rcv_p_qty) - ABS  (NVL (normal_iss_p_qty, 0) + NVL (trn_iss_p_qty, 0) + NVL (transfer_out_p_qty, 0)) closing_balance  -- ADDED BY MD SOHEL HOSSAIN
  FROM   items i, trans t
 WHERE   i.organization_id = t.organization_id
         AND i.inventory_item_id = t.inventory_item_id
 order by i.ou_id,i.organization_id,t.cls_val desc
 
 
 --=======================================================================================================
 
 
-- XXKSRM Item Transactions/ Bin Card
SELECT 
WIOD.OPERATING_UNIT_NAME OU_NAME,
 MMT.TRANSACTION_ID,
WIOD.INV_ORG_ADDRESS OU_ADD,
WIOD.INVENTORY_ORGANIZATION_NAME,
WXMD.ITEM_DESC,
WXMD.ITEM_CODE,
WXMD.UOM1 UOM,
WXMD.ITEM_TYPE,
WXMD.ITEM_GROUP,
WXMD.ITEM_SUB_GROUP,
XX_INV_PKG.XX_INV_OPEN_QTY(MMT.ORGANIZATION_ID,NULL, MMT.INVENTORY_ITEM_ID ,:P_DATE_FROM) OPEN_QTY,
----===========================================================================
MMT.SUBINVENTORY_CODE SUBINVENTORY,
NULL LOCATION,
TO_CHAR(MMT.TRANSACTION_DATE,'DD/MM/RRRR HH24:MI:SS')  TRANSACTION_DATE,
----MMT.TRANSACTION_DATE  TRANSACTION_DATE,
MMT.TRANSACTION_TYPE_ID,
(SELECT TRANSACTION_TYPE_NAME  FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID and TRANSACTION_TYPE_NAME  <> 'Logical Intransit Receipt'   ) TRANSACTION_TYPE,
MMT.TRANSACTION_ID,
DECODE(MMT.TRANSACTION_TYPE_ID,
                                    21,(SELECT SHIPMENT_NUMBER FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_SOURCE_TYPE_ID=13 AND TRANSACTION_TYPE_ID=21 AND TRANSACTION_ID=MMT.TRANSACTION_ID),
                                    XX_INV_PKG.XX_INV_TRANS_NO(MMT.TRANSACTION_ID)) TRANSACTION_NO,
-----==========================================================================================================
MMT.ORGANIZATION_ID,
MMT.TRANSACTION_DATE,
MMT.INVENTORY_ITEM_ID,
XX.ATTRIBUTE2 U_AREA_ID,
XX_GET_USE_AREA(XX.ATTRIBUTE2) U_ARE,
---==================================CALCULATION PART ==========================================================
NVL((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID AND PRIMARY_QUANTITY>0),0) RECEIVE_QTY,
NVL(ABS((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID AND PRIMARY_QUANTITY<0)),0) ISSUE_QTY, 
--(SELECT NVL(SUM(PRIMARY_QUANTITY),0)  FROM  MTL_MATERIAL_TRANSACTIONS WHERE  ORGANIZATION_ID=MMT.ORGANIZATION_ID AND INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID  AND TRANSACTION_ID <=MMT.TRANSACTION_ID) CLOSE_QTY,
(SELECT NVL(SUM(mm.PRIMARY_QUANTITY),0)  FROM   MTL_TRANSACTION_TYPES tt, MTL_MATERIAL_TRANSACTIONS mm
where mm.ORGANIZATION_ID=MMT.ORGANIZATION_ID 
 AND mm.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
  AND mm.TRANSACTION_ID <=MMT.TRANSACTION_ID
  and  tt.TRANSACTION_TYPE_NAME <> 'COGS Recognition' -- ADDED BY MD SOHEL HOSSAIN
and tt.TRANSACTION_TYPE_ID = mm.TRANSACTION_TYPE_ID and tt.TRANSACTION_TYPE_NAME <> 'Logical Intransit Receipt') CLOSE_QTY,
----======================================================================================
NULL REMARKS,
XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME ,
TO_DATE(:P_DATE_FROM) DATE_FROM,
TO_DATE(:P_DATE_TO) DATE_TO ,
gbh.batch_no
FROM 
MTL_MATERIAL_TRANSACTIONS MMT, 
WBI_INV_ORG_DETAIL WIOD,
WBI_XXKBGITEM_MT_D WXMD,
MTL_TXN_REQUEST_LINES XX,
gme_batch_header gbh
WHERE 
MMT.ORGANIZATION_ID=WIOD.INV_ORGANIZATION_ID
--=====================================
AND WXMD.INVENTORY_ITEM_ID =MMT.INVENTORY_ITEM_ID
AND WXMD.ORGANIZATION_ID= MMT.ORGANIZATION_ID
---=====================================
AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE) 
AND MMT.ORGANIZATION_ID=NVL(:P_ORG_ID, MMT.ORGANIZATION_ID)
AND XX.LINE_ID (+) =MMT.MOVE_ORDER_LINE_ID
and mmt.transaction_source_id = gbh.batch_id(+)
and mmt.organization_id = mmt.organization_id
and (SELECT TRANSACTION_TYPE_NAME  FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID  )  <> 'Logical Intransit Receipt' 
and    (SELECT TRANSACTION_TYPE_NAME  FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID  )  <> 'COGS Recognition'  -- ADDED BY MD SOHEL HOSSAIN
--AND XX.ATTRIBUTE2 IS NOT NULL
--AND TRUNC( TRANSACTION_DATE) BETWEEN TO_DATE(:P_DATE_FROM)OR TO_DATE(:P_DATE_FROM) IS NULL AND TO_DATE(:P_DATE_TO)
AND (TRUNC( TRANSACTION_DATE) BETWEEN :P_DATE_FROM and :P_DATE_TO or :P_DATE_FROM is null or :P_DATE_TO  is null)
 --AND MMT.transaction_action_id <> 28
ORDER BY MMT.TRANSACTION_ID

--============================================================================================================

--XXKSRM Store Ledger Group Wise
SELECT
DISTINCT WXMD.ORGANIZATION_ID
,WXMD.ORGANIZATION_CODE
,WXMD.ORGANIZATION_NAME
, (SELECT OPERATING_UNIT_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=WXMD.ORGANIZATION_ID)  ORGANIZATION_ADDRESS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
,NVL((SELECT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=:P_ORGANIZATION_ID),'KABIR GROUP') PORG_NAME
,NVL((SELECT OPERATING_UNIT_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID= :P_ORGANIZATION_ID),'Kabir Manzil,SK, Mujib Road,Agrabad,Chittagong,BD') PORG_ADDRESS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
,WXMD.INVENTORY_ITEM_ID
,WXMD.ITEM_TYPE
,WXMD.ITEM_GROUP
,WXMD.ITEM_SUB_GROUP
,WXMD.FINANCE_CATEGORY
,WXMD.ITEM_CODE
,WXMD.ITEM_DESC
,WXMD.UOM1 UOM
, :P_TRANSACTION_DATE_FROM DATE_FROM 
, :P_TRANSACTION_DATE_TO DATE_TO
,XX_INV_PKG.XX_INV_OPEN_QTY(WXMD.ORGANIZATION_ID,NULL, WXMD.INVENTORY_ITEM_ID,:P_TRANSACTION_DATE_FROM) OPENING_STOCK
----===============================================================================================================
,NVL((SELECT SUM(PRIMARY_QUANTITY) FROM MTL_MATERIAL_TRANSACTIONS  WHERE INVENTORY_ITEM_ID=WXMD.INVENTORY_ITEM_ID  AND ORGANIZATION_ID=WXMD.ORGANIZATION_ID AND TRANSACTION_TYPE_ID IN (12,61) AND    TRUNC( TRANSACTION_DATE) BETWEEN :P_TRANSACTION_DATE_FROM AND :P_TRANSACTION_DATE_TO),0) RECEIVED_QTY_INT_COM
,(XX_INV_PKG.XX_INV_RECV_QTY(WXMD.ORGANIZATION_ID,NULL, WXMD.INVENTORY_ITEM_ID,:P_TRANSACTION_DATE_FROM,:P_TRANSACTION_DATE_TO)
-NVL((SELECT SUM(PRIMARY_QUANTITY) FROM MTL_MATERIAL_TRANSACTIONS  WHERE INVENTORY_ITEM_ID=WXMD.INVENTORY_ITEM_ID  AND ORGANIZATION_ID=WXMD.ORGANIZATION_ID AND TRANSACTION_TYPE_ID  IN (12,61) AND    TRUNC( TRANSACTION_DATE) BETWEEN :P_TRANSACTION_DATE_FROM AND :P_TRANSACTION_DATE_TO),0)) RECEIVED_QTY_PO_OTH
-----===============================================================================================================
,ABS(NVL((SELECT SUM(PRIMARY_QUANTITY) FROM MTL_MATERIAL_TRANSACTIONS  WHERE INVENTORY_ITEM_ID=WXMD.INVENTORY_ITEM_ID  AND ORGANIZATION_ID=WXMD.ORGANIZATION_ID AND TRANSACTION_TYPE_ID IN  (35) AND   TRUNC( TRANSACTION_DATE) BETWEEN :P_TRANSACTION_DATE_FROM AND :P_TRANSACTION_DATE_TO),0)) ISSUED_QTY_PROD
,(XX_INV_PKG.XX_INV_ISSU_QTY(WXMD.ORGANIZATION_ID,NULL, WXMD.INVENTORY_ITEM_ID,:P_TRANSACTION_DATE_FROM,:P_TRANSACTION_DATE_TO)
+NVL((SELECT SUM(PRIMARY_QUANTITY) FROM MTL_MATERIAL_TRANSACTIONS  WHERE INVENTORY_ITEM_ID=WXMD.INVENTORY_ITEM_ID  AND ORGANIZATION_ID=WXMD.ORGANIZATION_ID AND TRANSACTION_TYPE_ID IN  (35) AND   TRUNC( TRANSACTION_DATE) BETWEEN :P_TRANSACTION_DATE_FROM AND :P_TRANSACTION_DATE_TO),0)) ISSUED_QTY_TRA_SAL_OTH
----================================================================================================================
,(XX_INV_PKG.XX_INV_OPEN_QTY(WXMD.ORGANIZATION_ID,NULL, WXMD.INVENTORY_ITEM_ID,:P_TRANSACTION_DATE_FROM) 
+XX_INV_PKG.XX_INV_RECV_QTY(WXMD.ORGANIZATION_ID,NULL, WXMD.INVENTORY_ITEM_ID,:P_TRANSACTION_DATE_FROM,:P_TRANSACTION_DATE_TO) 
-XX_INV_PKG.XX_INV_ISSU_QTY(WXMD.ORGANIZATION_ID,NULL, WXMD.INVENTORY_ITEM_ID,:P_TRANSACTION_DATE_FROM,:P_TRANSACTION_DATE_TO) ) CLOSING_STOCK
----================================================================================================================
,XX_INV_PKG.XXGET_ENAME(:P_USER) USER_NAME
FROM WBI_XXKBGITEM_MT_D WXMD---, MTL_MATERIAL_TRANSACTIONS MMT
WHERE 
--WXMD.ORGANIZATION_ID=MMT.ORGANIZATION_ID
--AND WXMD.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
----AND MMT.TRANSACTION_DATE BETWEEN :P_TRANSACTION_DATE_FROM AND :P_TRANSACTION_DATE_TO
WXMD.ORGANIZATION_ID=NVL(:P_ORGANIZATION_ID,WXMD.ORGANIZATION_ID)
AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE)
AND WXMD.ITEM_TYPE=NVL(:P_ITEM_TYPE,WXMD.ITEM_TYPE)
AND WXMD.ITEM_GROUP=NVL(:P_ITEM_GROUP,WXMD.ITEM_GROUP)
AND WXMD.ITEM_SUB_GROUP=NVL(:P_ITEM_SUB_GROUP,WXMD.ITEM_SUB_GROUP)
AND NVL(WXMD.FINANCE_CATEGORY,'ASDF')=NVL(:P_FINANCE_CATEGORY,NVL(WXMD.FINANCE_CATEGORY,'ASDF'))


--==============================================
-- SOME OF MY TESTING PURPOSE QUERY

--=================================================
select * from  MTL_MATERIAL_TRANSACTIONS
