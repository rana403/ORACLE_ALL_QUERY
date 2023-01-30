

SELECT   ooha.header_id,ooha.order_number,ooha.flow_status_code, ooha.ordered_date,
         hp.party_name customer_name,msib.description item_desc,
         oola.ORDERED_QUANTITY,oola.ORDER_QUANTITY_UOM UOM,wdd.SHIPPED_QUANTITY Deliverd_Quantity,
         oola.attribute15 superseded_item, oola.order_quantity_uom,
         oola.ordered_quantity, oola.unit_selling_price
    FROM oe_order_headers_all ooha,
         oe_order_lines_all oola,
         oe_transaction_types_tl ottt,
         mtl_system_items_b msib,
         mtl_parameters mp,
         org_organization_definitions ood,
         hz_parties hp,
         hz_cust_accounts hca,
         wsh_new_deliveries wnd,
         wsh_delivery_assignments wda, 
         wsh_delivery_details wdd 
   WHERE
   wdd.SOURCE_HEADER_ID=ooha.HEADER_ID 
    --and ooha.ORDER_NUMBER=:p_salesorder 
    AND wdd.delivery_detail_id = wda.delivery_detail_id 
    AND wnd.delivery_id = wda.delivery_id 
    AND ooha.header_id = oola.header_id
    AND ottt.transaction_type_id(+) = ooha.order_type_id
     --AND ottt.LANGUAGE = USERENV (‘LANG’)
    AND hca.cust_account_id(+) = ooha.sold_to_org_id
    AND hp.party_id = hca.party_id
    AND ooha.org_id = oola.org_id(+)
    AND msib.inventory_item_id = oola.inventory_item_id
    AND msib.organization_id = mp.master_organization_id
    AND mp.organization_id = ood.organization_id
    AND mp.master_organization_id = mp.organization_id
     --AND ood.operating_unit = fnd_profile.VALUE (‘ORG_ID’)
    AND ooha.order_number = :sales_order_number
ORDER BY ottt.NAME, ooha.order_number, oola.line_number;


select * from oe_order_headers_all where order_number = 600001

select * from oe_order_lines_all

select * from wsh_new_deliveries

select distinct flow_status_code from oe_order_headers_all

select * from oe_order_headers_all where flow_status_code = 'CLOSED'

select* from wsh_delivery_details where DELIVERED_QUANTITY is not null SOURCE_HEADER_ID = 6002 


 select * from OEBV_HOLD_AUTHORIZATIONS
 