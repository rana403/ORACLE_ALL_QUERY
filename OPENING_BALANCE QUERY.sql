
--FOR OPENING BALANCE SUMMARY WE CAN CREATE A FUNCTION TO GET ORG WISE OPENING BALANCE 
--CREATE OR REPLACE FUNCTION GET_INVWISE_OPEN_BALANCE(p_org_id IN NUMBER, p_item_id IN NUMBER, p_sinv_code IN NUMBER , P_DATE_FROM DATE )
RETURN NUMBER 
IS
V_QTY NUMBER;
BEGIN
SELECT SUM(mmt.primary_quantity)  INTO V_QTY
              FROM   mtl_material_transactions mmt
              WHERE   1 = 1
                     AND (p_org_id IS NULL OR mmt.organization_id = p_org_id)
                     AND (p_item_id IS NULL OR mmt.inventory_item_id = p_item_id)
                     AND (p_sinv_code IS NULL OR mmt.subinventory_code = p_sinv_code)
                     AND TRUNC (mmt.transaction_date) < P_DATE_FROM
                     AND mmt.transaction_type_id NOT IN   (10008,80);
                     RETURN V_QTY;
EXCEPTION WHEN OTHERS THEN
RETURN NULL;
END;





SELECT SUM(mmt.primary_quantity)     bal_qty
              FROM   mtl_material_transactions mmt
              WHERE   1 = 1
                     AND (:p_org_id IS NULL OR mmt.organization_id = :p_org_id)
                     AND (:p_item_id IS NULL OR mmt.inventory_item_id = :p_item_id)
                     AND (:p_sinv_code IS NULL OR mmt.subinventory_code = :p_sinv_code)
                     AND TRUNC (mmt.transaction_date) < :P_DATE_FROM
                     AND mmt.transaction_type_id NOT IN   (10008,80)



--=================================================================================================

---- FOR OPENING BALANCE SUMMARY IN  HEADER  LEVEL(WE CAN CREATE A FUNCTION TO GET ORG WISE OPENING BALANCE ) 
SELECT SUM(mmt.primary_quantity)     bal_qty
              FROM   mtl_material_transactions mmt
              WHERE   1 = 1
                     AND (:p_org_id IS NULL OR mmt.organization_id = :p_org_id)
                     AND (:p_item_id IS NULL OR mmt.inventory_item_id = :p_item_id)
                     AND (:p_sinv_code IS NULL OR mmt.subinventory_code = :p_sinv_code)
                     AND TRUNC (mmt.transaction_date) < :P_DATE_FROM
                     AND mmt.transaction_type_id NOT IN   (10008,80)
 

SELECT      --- FOR OPENING BALANCE SUMMARY IN LINE LEVEL 
                     mmt.organization_id,
                     mmt.inventory_item_id,
                     mmt.transaction_uom,
                     NULL             subinventory_code,
                     NULL             trn_date,
                     NULL             trn_id,
                     NULL             trn_src_id,
                     'Opening'             trn_type
                    ,to_number(0)       normal_rcv_p_qty
                    ,to_number(0)       misc_rcv_p_qty
                    ,to_number(0)       issue_return_rcv_p_qty
                    ,to_number(0)       trn_rcv_p_qty
                    ,to_number(0)       mo_rcv_p_qty
                    ,to_number(0)       iso_in_p_qty
                    ,to_number(0)       iot_in_p_qty
-------------------------------------------------------------- 
                    ,to_number(0)       sales_order_issue_p_qty
                    ,to_number(0)       return_to_vend_issue_p_qty              
                    ,to_number(0)       trn_issue_p_qty
                    ,to_number(0)       mo_issue_p_qty
                    ,to_number(0)       iso_out_p_qty
                    ,to_number(0)       iot_out_p_qty
                    ,to_number(0)       other_issue_p_qty
--------------------------------------------------------------                                        
                    ,to_number(0)        rcv_qty
                    ,to_number(0)        iss_qty
                    --,to_number(0)        normal_iss_p_qty
                    --,to_number(0)        trn_iss_p_qty
                    --,to_number(0)        transfer_out_p_qty
                    ,SUM(mmt.primary_quantity)     bal_qty
              FROM   mtl_material_transactions mmt
              WHERE   1 = 1
                     AND (:p_org_id IS NULL OR mmt.organization_id = :p_org_id)
                     AND (:p_item_id IS NULL OR mmt.inventory_item_id = :p_item_id)
                     AND (:p_sinv_code IS NULL OR mmt.subinventory_code = :p_sinv_code)
                     AND TRUNC (mmt.transaction_date) < :P_DATE_FROM
                     AND mmt.transaction_type_id NOT IN   (10008,80)
                     GROUP BY     --- FOR OPENING BALANCE
                     mmt.organization_id,
                     mmt.inventory_item_id,
                     mmt.transaction_uom,
                     NULL ,            
                     NULL   ,         
                     NULL  ,        
                     NULL   ,         
                     'Opening'          
                    ,to_number(0)      
                    ,to_number(0)       
                    ,to_number(0)      
                    ,to_number(0)       
                    ,to_number(0)    
                    ,to_number(0)     
                    ,to_number(0)     
-------------------------------------------------------------- 
                    ,to_number(0)      
                    ,to_number(0)              
                    ,to_number(0)       
                    ,to_number(0)      
                    ,to_number(0)      
                    ,to_number(0)      
                    ,to_number(0)       
--------------------------------------------------------------                                        
                    ,to_number(0)        
                    ,to_number(0)       
--===============================================================================================
                
                
-- OPENING BALANCE DETAILS 
SELECT   1 sl,
                     mmt.organization_id,
                     mmt.inventory_item_id,
                     mmt.transaction_uom,
                     NULL             subinventory_code,
                     NULL             trn_date,
                     NULL             trn_id,
                     NULL             trn_src_id,
                     'Opening'             trn_type
                    ,to_number(0)       normal_rcv_p_qty
                    ,to_number(0)       misc_rcv_p_qty
                    ,to_number(0)       issue_return_rcv_p_qty
                    ,to_number(0)       trn_rcv_p_qty
                    ,to_number(0)       mo_rcv_p_qty
                    ,to_number(0)       iso_in_p_qty
                    ,to_number(0)       iot_in_p_qty
-------------------------------------------------------------- 
                    ,to_number(0)       sales_order_issue_p_qty
                    ,to_number(0)       return_to_vend_issue_p_qty              
                    ,to_number(0)       trn_issue_p_qty
                    ,to_number(0)       mo_issue_p_qty
                    ,to_number(0)       iso_out_p_qty
                    ,to_number(0)       iot_out_p_qty
                    ,to_number(0)       other_issue_p_qty
--------------------------------------------------------------                                        
                    ,to_number(0)        rcv_qty
                    ,to_number(0)        iss_qty
                    --,to_number(0)        normal_iss_p_qty
                    --,to_number(0)        trn_iss_p_qty
                    --,to_number(0)        transfer_out_p_qty
                    ,mmt.primary_quantity     bal_qty
              FROM   mtl_material_transactions mmt
              WHERE   1 = 1
                     AND (:p_org_id IS NULL OR mmt.organization_id = :p_org_id)
                     AND (:p_item_id IS NULL OR mmt.inventory_item_id = :p_item_id)
                     AND (:p_sinv_code IS NULL OR mmt.subinventory_code = :p_sinv_code)
                     AND TRUNC (mmt.transaction_date) < :P_DATE_FROM
                     AND mmt.transaction_type_id NOT IN   (10008,80)