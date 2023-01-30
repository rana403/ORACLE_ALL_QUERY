
PO_LINES_SV4.get_inventory_orgid(PRL.ORG_ID)


SELECT * FROM MTL_PARAMETERS_VIEW WHERE ORGANIZATION_CODE = 'TRA'



SELECT * FROM gl_code_combinations   where CODE_COMBINATION_ID =13245


SELECT * FROM gl_code_combinations   where CODE_COMBINATION_ID IN(13243,13245,13246,13246,13251,13245,13244,13248,4041,13248,13250,13251,13252,13253,13253,13255,53526) --1182297,


UPDATE gl_code_combinations   
SET SEGMENT2 = '01'
where CODE_COMBINATION_ID IN(13243,13245,13246,13246,13251,13245,13244,13248,4041,13248,13250,13251,13252,13253,13253,13255,53526) 


SELECT  DISTRIBUTION_ACCOUNT_ID  FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID IN (14304403, 14304413)





SELECT  DISTRIBUTION_ACCOUNT_ID  FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID IN (14304403)

SELECT  *  FROM MTL_MATERIAL_TRANSACTIONS WHERE 1=1 -- DISTRIBUTION_ACCOUNT_ID is not null  
and INVENTORY_ITEM_ID IN  (819520,819521) and TRUNC(TRANSACTION_DATE) 
Between '01-MAR-2022' and '30-APR-2022'  order by TRANSACTION_DATE --TO_DATE('3/31/2022 12:25:00 PM', 'MM/DD/YYYY HH12:MI:SS PM') and TO_DATE('4/30/2022 12:25:00 PM', 'MM/DD/YYYY HH12:MI:SS PM') -- TRANSACTION_ID= 14304413




SELECT  *  FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID IN ( 14304403,14304413)

--update MTL_MATERIAL_TRANSACTIONS
--set DISTRIBUTION_ACCOUNT_ID = 25025
--WHERE TRANSACTION_ID IN (14304403,14304413)

select * from GMF_XLA_EXTRACT_HEADERS WHERE TRANSACTION_ID IN ( 14304403,14304413)


select * from GMF_XLA_EXTRACT_LINES WHERE EVENT_ID IN (
8600189
)

INVENTORY_ITEM_ID= 0
TRANSACTION_ACCOUNT_ID

select * from XLA_AE_HEADERS WHERE AE_HEADER_ID IN (
14273514,
14273810,
14273989
)



select * from XLA_AE_LINES WHERE AE_HEADER_ID IN (
46958231
)






--=========================================
-- ALL ACCOUNT CODE AND DESCRIPTION
--=========================================

SELECT  distinct SEGMENT4 ACCOUNT_CODE, XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4)  account_name 
FROM gl_code_combinations   
--WHERE XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) LIKE '%Satkania%'
WHERE SEGMENT4 IN (4030107) -- 2010101  


--====================================
--GET ALL PROJECT  NAME
--===================================
SELECT-- ffvs.flex_value_set_id ,
--ffvs.flex_value_set_name ,
--ffvs.description set_description ,
--ffvs.validation_type,
--ffv.flex_value,
distinct ffvt.description PROJECT_NAME,
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
and flex_value_set_name like '%XX_PROJECT_NEW%' --- VALUSET
--AND ENABLED_FLAG <> 'N'
AND ffvt.description <> 'Default'

--=========================================
-- ALL ACCOUNT CODE AND DESCRIPTION
--=========================================
SELECT  distinct SEGMENT1 ACCOUNT_CODE, XX_GET_ACCT_FLEX_SEG_DESC(6,SEGMENT6)  account_name 
FROM gl_code_combinations   
--WHERE SEGMENT4 = 6010104  


--=========================================
-- ALL ACCOUNT CODE  SUB ACCOUNT CODE DESCRIPTION
--=========================================

SELECT  distinct SEGMENT4 ACCOUNT_ID,SEGMENT3, XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4)  account_name , SEGMENT5 SUB_ACCOUNT_ID, XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT
FROM gl_code_combinations   
WHERE SEGMENT4= 6010242             


SELECT  distinct SEGMENT4 ACCOUNT_ID,SEGMENT3,XX_GET_ACCT_FLEX_SEG_DESC(3,SEGMENT3)  COST_CENTER , XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4)  account_name , SEGMENT5 SUB_ACCOUNT_ID, XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT
FROM gl_code_combinations   
WHERE SEGMENT4= 6010242  ORDER BY        SEGMENT5

SELECT * FROM gl_code_combinations  where segment3= 2037
 


--=========================================
-- ALL ACCOUNT CODE AND DESCRIPTION
--=========================================
SELECT  distinct SEGMENT1 ACCOUNT_CODE, XX_GET_ACCT_FLEX_SEG_DESC(6,SEGMENT6)  account_name 
FROM gl_code_combinations   
--WHERE SEGMENT4 = 6010104  


--=========================================
-- GET ALL COST CENTER LIST
--=========================================

SELECT  distinct SEGMENT3, XX_GET_ACCT_FLEX_SEG_DESC(3,SEGMENT3)  Cost_Center -- , SEGMENT5 SUB_ACCOUNT_ID, XX_GET_ACCT_FLEX_SEG_DESC (5, SEGMENT5,SEGMENT4) SUB_ACCOUNT
FROM gl_code_combinations 
WHERE   SEGMENT3 <>0000

WHERE SEGMENT4= 6010242             


SELECT * FROM XXKSRM_USE_AREA_WISE

SELECT * FROM gl_code_combinations  where segment3= 2037
 






WHERE SEGMENT1= 1016487   

SELECT * FROM  gl_code_combinations  WHERE CODE_COMBINATION_ID IN(
4030107) --25011




SELECT CODE_COMBINATION_ID,  SEGMENT1||'.'||SEGMENT2||'.'||SEGMENT3||'.'||SEGMENT4||'.'||SEGMENT5||'.'||SEGMENT6||'.'||SEGMENT7||'.'||SEGMENT8  GL_CODE_COMBINATION
FROM GL_CODE_COMBINATIONS 
WHERE SEGMENT1||'.'||SEGMENT2||'.'||SEGMENT3||'.'||SEGMENT4||'.'||SEGMENT5||'.'||SEGMENT6||'.'||SEGMENT7||'.'||SEGMENT8||'.'||SEGMENT9||'.'||SEGMENT10 =
'101.01.0000.4030107.001.0000.000.000.000.000'




SELECT SEGMENT1||'.'||SEGMENT2||'.'||SEGMENT3||'.'||SEGMENT4||'.'||SEGMENT5||'.'||SEGMENT6||'.'||SEGMENT7||'.'||SEGMENT8 CODE_COMBINATION FROM GL_CODE_COMBINATIONS where CODE_COMBINATION_ID=124543

 SELECT * FROM MTL_TXN_REQUEST_HEADERS mtrh where REQUEST_NUMBER = 'MO-KBM-0127585' 
 
  SELECT * FROM MTL_TXN_REQUEST_LINES mtrh where HEADER_ID = 1908444
  
  
  --===========================TO UPDATE Wrong Code combination Manually================================================
  -- TWO TABLE NEED TO UPDATE 
 -- 1. MTL_TXN_REQUEST_LINES
  --2. MTL_MATERIAL_TRANSACTIONS
 --======================================================================================================== 
  
  SELECT * FROM MTL_TXN_REQUEST_HEADERS mtrh where REQUEST_NUMBER = 'MO-KBM-0127585' -- TO GET HEADER ID
 
 
  
  SELECT * FROM MTL_TXN_REQUEST_LINES WHERE HEADER_ID= 1908444
  
--  UPDATE MTL_TXN_REQUEST_LINES
--  SET TO_ACCOUNT_ID =366545
--  WHERE HEADER_ID = 1908444


SELECT * FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID IN (12433214,
12433215)


--UPDATE mtl_material_Transactions
--SET DISTRIBUTION_ACCOUNT_ID = 366545
--WHERE TRANSACTION_ID  IN(12433214,
--12433215)

 
 
 SELECT * FROM GL_CODE_COMBINATIONS_V  WHERE SEGMENT1||'.'||SEGMENT2||'.'||SEGMENT3||'.'||SEGMENT4||'.'||SEGMENT5||'.'||SEGMENT6||'.'||SEGMENT7||'.'||SEGMENT8||'.'||SEGMENT9||'.'||SEGMENT10 =
'102.01.0000.6010205.001.0000.000.000.000.000'