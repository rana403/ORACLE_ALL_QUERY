

--============================================================
----- WRONG ACCOUNT CODE UPDATE  QUERY
--==========================================================
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
   --   and XGD.STATUS<>'Y'
      
 --     =====
 
--============================================================
----- WRONG ACCOUNT CODE UPDATE  Process
--==========================================================
 
 
     -- begin
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
      and XGD.STATUS<>'Y'
       )  loop
 update MTL_TXN_REQUEST_LINES set TO_ACCOUNT_ID = i.CORRCT_ACC_CODE where header_id=i.header_id and line_id=i.line_id and TO_ACCOUNT_ID=i.WORNG_ACC_CODE;
  update mtl_material_Transactions set DISTRIBUTION_ACCOUNT_ID =i.CORRCT_ACC_CODE where transaction_id=i.transaction_id and DISTRIBUTION_ACCOUNT_ID=i.WORNG_ACC_CODE;
--update apps.XXGLCODEUPDATE set STATUS ='Y' where TXN_ID=i.transaction_id and org_id=i.organization_id and status<>'Y';
 end loop;
 end;
 
 
 ======
 
 select * from MTL_MATERIAL_TRANSACTIONS where TRANSACTION_ID=1617234 

select * from GL_CODE_COMBINATIONS_KFV where CODE_COMBINATION_ID=78529