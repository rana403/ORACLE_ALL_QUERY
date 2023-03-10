--============
-- THIS QUERY WILL FINDOUT THE WRONG ASSET ACCOUNT AGAINST MOVE ORDER. WE KNOW THAT FOR ASSET WE NEVER CREATE MOVE ORDER. BECAUSE ASSET IS NOT STOCKABLE ITEMS SO 
--   JODI SEGMENT4 ASSET ACCOUNT HOE TAHOLE SETA MOVE ORDER A THEKBENA , JODI THAKE TAILE SETA VUL TRANSACTION .
-- PASHA PASHI EI TRANSACTION TA JE CREATE KORSE TAR NAME TAO EI QUERY TE ADD KORA HOISE 
--=============

SELECT 
MTRL.TO_ACCOUNT_ID,
(SELECT XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=MTRL.TO_ACCOUNT_ID) ACCOUNT,
 XX_GET_EMP_NAME_FROM_USER_ID (MMT.CREATED_BY) CREATED_BY, 
--XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) ACCOUNT_DESC, 
(SELECT DISTINCT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID) OU_NAME
,(SELECT DISTINCT OPERATING_UNIT_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID) OU_ADD
,(SELECT DISTINCT INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID) ORG_NAME
,MTRL.DATE_REQUIRED MO_DATE
,MTRL.REQUEST_NUMBER MO_NO
---,MTRL.TRANSACTION_TYPE_NAME
,WXMD.ITEM_CODE ITEM_CODE
,WXMD.ITEM_DESC ITEM_DESC
,MTRL.QUANTITY MO_QTY
----,MTRL.QUANTITY_DELIVERED ISSUE_QTY
,ABS(MMT.TRANSACTION_QUANTITY) ISSUE_QTY
----,MMT.PRIMARY_QUANTITY
,MMT.SUBINVENTORY_CODE SUBINVENTORY
, MTRL.TO_ACCOUNT_ID 
,(SELECT SEGMENT1|| '.' || SEGMENT2|| '.' || SEGMENT3|| '.' || SEGMENT4|| '.' || SEGMENT5|| '.' || SEGMENT6|| '.' || SEGMENT7|| '.' || SEGMENT8  FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=MTRL.TO_ACCOUNT_ID) ACCOUNT_COMBINATION
--,XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME
--,:P_FROM_DATE PFROM_DATE
--,:P_TO_DATE PTO_DATE
FROM 
MTL_MATERIAL_TRANSACTIONS MMT,
MTL_TXN_REQUEST_LINES_V MTRL,
WBI_XXKBGITEM_MT_D WXMD
WHERE 
MMT.TRANSACTION_SET_ID=MTRL.TRANSACTION_HEADER_ID
---AND MTRL.REQUEST_NUMBER LIKE 'MO%'---='MO-KSM-0002872'
---AND TRANSACTION_TYPE_NAME IN ('Returnable Item Issue','Sales Order Pick','Loan Given To External Company')
AND MTRL.TO_ACCOUNT_ID  IS NOT NULL
------------------------------------------------------------------------------------------------
AND WXMD.ORGANIZATION_ID=MMT.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
AND WXMD.ORGANIZATION_ID=MTRL.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MTRL.INVENTORY_ITEM_ID
------------------------------------------------------------------------------------------------
AND MTRL.ORGANIZATION_ID = NVL (:P_ORG, MTRL.ORGANIZATION_ID)
AND MTRL.REQUEST_NUMBER = NVL (:P_MO_NUMBER, MTRL.REQUEST_NUMBER)
AND (SELECT XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=MTRL.TO_ACCOUNT_ID) = 'Land and Land Developments'
--AND TRUNC(MTRL.DATE_REQUIRED) BETWEEN NVL(:P_FROM_DATE,TRUNC(MTRL.DATE_REQUIRED))  AND  NVL(:P_TO_DATE,TRUNC(MTRL.DATE_REQUIRED))
--AND MTRL.INVENTORY_ITEM_ID =NVL(:P_ITEM_ID,MTRL.INVENTORY_ITEM_ID)
--AND MTRL.TO_ACCOUNT_ID IN (1010102,
--1010115,
--1010105,
--1010107,
--1010108,
--1010109,
--1010110,
--1010111,
--1010101,
--1010114,
--1010113,
--1010112,
--1010103,
--1010104,
--1010106)
ORDER BY MTRL.DATE_REQUIRED,MTRL.REQUEST_NUMBER,MTRL.LINE_NUMBER
------------------------------------------------------------------------------------------------


select distinct segment4 from GL_CODE_COMBINATIONS WHERE SEGMENT4 IN(1010101,1010102,1010103,1010104,1010105,1010106,1010107,1010108,1010109,1010110,1010111,1010112,1010113,1010114,1010115)


select * from GL_CODE_COMBINATIONS WHERE SEGMENT4= 1010101