select distinct INVENTORY_ITEM_ID,SEGMENT1||'|'||SEGMENT2||'|'|| SEGMENT3||'|'|| SEGMENT4 ITEM_CODE, DESCRIPTION
 from MTL_SYSTEM_ITEMS_B where SEGMENT1||'|'||SEGMENT2||'|'|| SEGMENT3||'|'|| SEGMENT4 IN ( 'FG|G400|10MM|000023' , 'FG|G400|25MM|000029')
 
 
 
==================================================================================
 
 SELECT * FROM MTL_MATERIAL_TRANSACTIONS where transaction_id = 10830031 ---2098434
 
select * from GME_BATCH_HEADER where BATCH_ID = 729068

SELECT * FROM gme_material_details WHERE BATCH_ID = 729068  
 



--======================
10830031
10830089
--======================






 
C
10830089

 
 
 
 
 
 
 
 
 
 
 11079426
11097150
11097274

SF|BILT|500|000011

select * from MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID = 35

SELECT * FROM mtl_material_transactions WHERE TRANSACTION_ID =  11079426 

select * from GMF_XLA_EXTRACT_HEADERS WHERE TRANSACTION_ID =  11079426 

select * from GMF_XLA_EXTRACT_HEADERS WHERE EVENT_ID = 5438458 --IN ( 4906916, 4878396 )

select * from XLA_DISTRIBUTION_LINKS WHERE  AE_HEADER_ID= 47581095

--select * from GMF_XLA_EXTRACT_LINES where header_id= 7544794   

select * from XLA_AE_HEADERS WHERE AE_HEADER_ID= 47581095 --EVENT_ID=5445973

select * from XLA_AE_LINES WHERE AE_HEADER_ID= 47581095