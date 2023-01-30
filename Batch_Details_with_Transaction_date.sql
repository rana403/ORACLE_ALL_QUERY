





-- BATCH CLOSE QUERY FROMREAZ VAI--      DATE :9-NOV-2021

--Query 1
/*Query to find all batches with their Status completed or closed*/  
--BATCH_STATUS = 2 (WIP-Work In Process)--BATCH_STATUS = 1 (Pending)
--BATCH_STATUS = 3 (Completed--BATCH_STATUS = 4 (Closed)
--BATCH_STATUS = -1 (Cancelled)
------------
select *
from GME_BATCH_HEADER 
where --batch_id in ()
--BATCH_NO=2831 and 
ORGANIZATION_ID=121
and to_char(ACTUAL_START_DATE,'MM-YYYY')='04-2022'
--AND BATCH_STATUS=1
--AND BATCH_STATUS=2
--and BATCH_STATUS=3
--AND BATCH_STATUS=4





--Query 2
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
       AND GBH.ORGANIZATION_ID = 121
    --   and to_char (trunc (TRANSACTION_DATE),'MON-YYYY')='FEB-2022'  --ACTUAL_CMPLT_DATE, ACTUAL_START_DATE
--        AND GBH.BATCH_NO in (2831)
AND TRUNC(ACTUAL_CMPLT_DATE)  between '01-APR-2022' and '30-APR-2022'


--Query 3
select * from MTL_MATERIAL_TRANSACTIONS
where TRANSACTION_ID in (
13072834,
13072881,
13072831,
13072887,
13072833,
13072891,
13072832,
13072889
)
--and to_char (trunc (TRANSACTION_DATE),'MON-YYYY')='JAN-2022' 




--create table mtl_material_trans_temp_jan21 as


/*Pending Check*/
  select * from   MTL_MATERIAL_TRANSACTIONS_TEMP
  where to_char (transaction_date,'MON-YYYY')='APR-2022'
  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)
  
  select * from MTL_TRANSACTIONS_INTERFACE
where to_char (transaction_date,'MON-YYYY')='APR-2022'
AND ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)
  
  


create table mtl_material_trans_temp_aug21 as
select *
 from MTL_MATERIAL_TRANSACTIONS_TEMP
  where to_char (transaction_date,'MON-YYYY')='AUG-2021'
  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)
  
  select * from   mtl_material_trans_temp_aug21
  
  
  
--  delete from MTL_MATERIAL_TRANSACTIONS_TEMP
--    where to_char (transaction_date,'MON-YYYY')='AUG-2021'
--  and ORGANIZATION_ID in (121,150,149,148,147,146,145,144,143,142,141)