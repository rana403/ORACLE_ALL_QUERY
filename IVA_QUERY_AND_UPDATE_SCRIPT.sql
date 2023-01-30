/*This below code from SOHEL Bhai, It's working Excellent, Follow this Query to update GL COde COmbinations*/

--Wrong Account code update process: 


SELECT * FROM XXGLCODEUPDATE  

--DELETE FROM XXGLCODEUPDATE

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
 WHERE     mmt.organization_id = mtrh.organization_id(+)
       AND mmt.transaction_source_id= mtrh.header_id(+)
       AND mmt.trx_source_line_id= mtrl.line_id(+)
       AND mtrh.HEADER_ID = mtrl.HEADER_ID(+)
       AND mmt.transaction_id = xgd.txn_id
       AND mmt.organization_id = xgd.org_id
       AND mmt.inventory_item_id = xgd.inventory_item_id
       AND mmt.transaction_type_id = xgd.TRX_TYPE_ID
--       and mmt.transaction_id IN (4434056,
--4454916) --896031
    --  and XGD.STATUS<>'Y'
      
     -- =================================================
     
      begin
for i in ( SELECT mmt.transaction_id,mmt.organization_id ,mmt.transaction_source_id header_id,
       mmt.trx_source_line_id line_id,
       mmt.DISTRIBUTION_ACCOUNT_ID,
       mtrl.TO_ACCOUNT_ID,
       (select CODE_COMBINATION_ID from  GL_CODE_COMBINATIONS_KFV where CONCATENATED_SEGMENTS=xgd.WORNG_ACC_CODE) WORNG_ACC_CODE,
              (select CODE_COMBINATION_ID from  GL_CODE_COMBINATIONS_KFV where CONCATENATED_SEGMENTS=xgd.CORRCT_ACC_CODE) CORRCT_ACC_CODE    
  FROM mtl_material_Transactions mmt,
       MTL_TXN_REQUEST_HEADERS mtrh,
       MTL_TXN_REQUEST_LINES mtrl,
       apps.XXGLCODEUPDATE xgd
 WHERE     mmt.organization_id = mtrh.organization_id(+)
       AND mmt.transaction_source_id= mtrh.header_id(+) 
       AND mmt.trx_source_line_id= mtrl.line_id(+)
       AND mtrh.HEADER_ID = mtrl.HEADER_ID(+)
       AND mmt.transaction_id = xgd.txn_id
       AND mmt.organization_id = xgd.org_id
       AND mmt.inventory_item_id = xgd.inventory_item_id
       AND mmt.transaction_type_id = xgd.TRX_TYPE_ID
      -- and mmt.transaction_id=896031
     -- and XGD.STATUS<>'Y'
       ) loop
 update MTL_TXN_REQUEST_LINES set TO_ACCOUNT_ID = i.CORRCT_ACC_CODE where header_id=i.header_id and line_id=i.line_id and TO_ACCOUNT_ID=i.WORNG_ACC_CODE;
  update mtl_material_Transactions set DISTRIBUTION_ACCOUNT_ID =i.CORRCT_ACC_CODE where transaction_id=i.transaction_id and DISTRIBUTION_ACCOUNT_ID=i.WORNG_ACC_CODE;
--update apps.XXGLCODEUPDATE set STATUS ='Y' where TXN_ID=i.transaction_id and org_id=i.organization_id and status<>'Y';
 end loop;
 end;
 
 
 
 
 
 select * from    mtl_material_Transactions where transaction_id=911493 and organization_id = 160 and transaction_source_id = 540998 and trx_source_line_id = 328621
 
 
 ======
 select * from MTL_MATERIAL_TRANSACTIONS where TRANSACTION_ID=1226465

select * from GL_CODE_COMBINATIONS_KFV where CODE_COMBINATION_ID=77527 


select * from XXGLCODEUPDATE

delete from XXGLCODEUPDATE

select * from gl_code_combinations_kfv
where CODE_COMBINATION_ID=25005
--AND CONCATENATED_SEGMENTS='101.01.0000.1030101.002.0001.000.000.000.000'

alter table XXGLCODEUPDATE modify WORNG_ACC_CODE null;

alter table XXGLCODEUPDATE modify WORNG_ACC_CODE null

commit;





select * from GL_CODE_COMBINATIONS_KFV
where CONCATENATED_SEGMENTS = '102.02.1008.6010203.003.0000.000.000.000.000'

102.02.1008.6010203.003.0000.000.000.000.000







/*This below code from Irfan Bhai, Its not able to find all transactions, Follow the above Query to find all transactions*/

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
--      and XGD.STATUS<>'Y'
      
      =====
      begin
for i in ( SELECT mmt.transaction_id,mmt.organization_id ,mmt.transaction_source_id header_id,
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
--      and XGD.STATUS<>'Y'
       )  loop
 update MTL_TXN_REQUEST_LINES set TO_ACCOUNT_ID = i.CORRCT_ACC_CODE where header_id=i.header_id and line_id=i.line_id and TO_ACCOUNT_ID=i.WORNG_ACC_CODE;
  update mtl_material_Transactions set DISTRIBUTION_ACCOUNT_ID =i.CORRCT_ACC_CODE where transaction_id=i.transaction_id and DISTRIBUTION_ACCOUNT_ID=i.WORNG_ACC_CODE;
--update apps.XXGLCODEUPDATE set STATUS ='Y' where TXN_ID=i.transaction_id and org_id=i.organization_id and status<>'Y';
 end loop;
 end;
 
 
 ======
 select * from MTL_MATERIAL_TRANSACTIONS where TRANSACTION_ID=1617234

select * from GL_CODE_COMBINATIONS_KFV where CODE_COMBINATION_ID=78529