select  *  from MTL_SYSTEM_ITEMS_FVL where INVENTORY_ITEM_STATUS_CODE = 'Active' and ORGANIZATION_ID =0 and LIST_PRICE_PER_UNIT <> 1 

select  COUNT(DISTINCT(LIST_PRICE_PER_UNIT)),INVENTORY_ITEM_ID  from MTL_SYSTEM_ITEMS_FVL where LIST_PRICE_PER_UNIT = 1 group by INVENTORY_ITEM_ID

select LIST_PRICE_PER_UNIT from  MTL_SYSTEM_ITEMS_FVL where INVENTORY_ITEM_ID = 180 and  ORGANIZATION_ID <>0

select LIST_PRICE_PER_UNIT from mtl_system_items where ORGANIZATION_ID =0 and LIST_PRICE_PER_UNIT =1 -- and   INVENTORY_ITEM_ID=180

select * from ORG_ORGANIZATION_DEFINITIONS where ORGANIZATION_CODE = 'KIM'

TOTAL ITEM = 43,430
1 taka valu = 30,179
More than 1 taka value = 13,114
 


select LIST_PRICE_PER_UNIT,  from po_lines_all where item_id= 180 and LIST_PRICE_PER_UNIT = 0

select distinct unit_price  from PO_LINES_ALL where  item_id= 180  -- where unit_price = 65

select  * from PO_LINES_ALL where  item_id= 180  

select LIST_PRICE_PER_UNIT  from MTL_SYSTEM_ITEMS_FVL where   INVENTORY_ITEM_ID= 180  