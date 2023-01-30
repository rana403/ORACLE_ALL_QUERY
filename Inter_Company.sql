
select * from HR_OPERATING_UNITS HOU1

select * from HR_OPERATING_UNITS HOU2

select * from MTL_PARAMETERS MP

select * from MTL_CATEGORIES_V MCV

select * from MTL_CATEGORY_SETS_B MCS

select * from MTL_CATEGORY_SET_VALID_CATS MCSVC

/*mtl_transaction_flow_headers_v     this view is maid by using above tables*/


select HEADER_ID, START_ORG_ID, START_ORG_NAME, END_ORG_ID,END_ORG_NAME,ORGANIZATION_ID,ORGANIZATION_CODE, START_DATE, CREATION_DATE, CREATED_BY
from mtl_transaction_flow_headers_v    
where 1=1
AND START_ORG_NAME = '101-KSRM Steel Plant Ltd (KSPL)'
AND END_ORG_NAME = '102-KSRM Steel Plant Ltd (Power)'


select HEADER_ID, FROM_ORG_ID,FROM_ORG_NAME,  TO_ORG_ID,TO_ORG_NAME, FROM_ORGANIZATION_ID, FROM_ORGANIZATION_CODE, TO_ORGANIZATION_ID,TO_ORGANIZATION_CODE, CREATION_DATE
from mtl_transaction_flow_lines_v 
where 1=1
AND FROM_ORG_NAME = '101-KSRM Steel Plant Ltd (KSPL)'
AND TO_ORG_NAME = '102-KSRM Steel Plant Ltd (Power)'


/* Query to update Transaction Flow */
--UPDATE MTL_TRANSACTION_FLOW_HEADERS
   SET START_DATE =
          TO_DATE ('7/14/2017 03:00:00 PM', 'MM/DD/YYYY HH:MI:SS PM')
 WHERE START_DATE = TO_DATE ('7/14/2017 9:30:27 PM', 'MM/DD/YYYY HH:MI:SS PM')
 AND START_ORG_ID = '81'
AND END_ORG_ID = '102'
AND ORGANIZATION_ID = '121'