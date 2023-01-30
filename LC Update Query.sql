
--========================================
--CASE: PO WILL BE CHANGED FROM LC FORM
--========================================
SELECT * FROM PO_HEADERS_ALL WHERE SEGMENT1= 40013193 AND ORG_ID= 104

SELECT * FROM XX_LC_DETAILS WHERE LC_NUMBER= '0731-21-02-0079'

--UPDATE XX_LC_DETAILS
--SET PO_HEADER_ID= 888468,
--PO_NUMBER = 40013193
--WHERE LC_ID=10919





/* 
CASE: User unfortunately forward the import PO to a Local PO Path, Then they return the PO and try to send actual Path but showing : 
Error: Line #1 1 Distribution # 1 Distribution is missing forign currency rate.

*/


--select * from po_headers_all where segment1= 40010359  and org_id =104

select * from po_headers_all where segment1= 40011731  and org_id =104 -- CHACKING RATE COLUMN IS EMPTY OR NOT 


SELECT * FROM PER_BUSINESS_GROUPS

SELECT * FROM PER_JOBS








--UPDATE po_headers_all
--SET RATE = NULL
--where segment1= 40011731  and org_id =104



select rate, rate_date from PO_DISTRIBUTIONS_ALL
where po_header_id = 880557 --and rate_date is not null and rate is null



 --FIND PO HEADER_ID FOR RATE UPDATE 
--==================

select rate from PO_DISTRIBUTIONS_ALL
where po_header_id = 880557 and rate_date is not null and rate is null


--TO UPDATE RATE OF THAT PO HEADER ID
--===============================

update PO_DISTRIBUTIONS_ALL
set rate=86
where po_header_id = 880557 and rate_date is not null and rate is null




------USER INFO---------------------------








-- DEEP SEA ITEMS 3 WAY MAKING PROCESS

SELECT SEGMENT1||'|'||SEGMENT2||'|'||SEGMENT3||'|'||SEGMENT4 ITEM_CODE, RECEIPT_REQUIRED_FLAG, INSPECTION_REQUIRED_FLAG, RECEIVING_ROUTING_ID  
FROM MTL_SYSTEM_ITEMS 
WHERE ORGANIZATION_ID = 166 --144 
AND RECEIPT_REQUIRED_FLAG = 'Y'
AND INSPECTION_REQUIRED_FLAG = 'N'
AND RECEIVING_ROUTING_ID  = 3


UPDATE mtl_system_items
SET RECEIPT_REQUIRED_FLAG = 'Y', 
INSPECTION_REQUIRED_FLAG = 'N', 
RECEIVING_ROUTING_ID  = 3
WHERE organization_id = 182




 -- 4546 -- inventory Item Id = 5, RM|CHEM|SMAN|000008

RECEIPT_REQUIRED_FLAG_MIR -- Y
INSPECTION_REQUIRED_FLAG -- N   
RECEIVING_ROUTING_ID_MIR -- 3  -- FOR DIRECT


select SEGMENT1||'|'||SEGMENT2||'|'||SEGMENT3||'|'||SEGMENT4 ITEM_NAME, Inventory_item_id from mtl_system_items where organization_id = 166 and  inventory_item_id = 2 --  for testing


select *  from mtl_system_items where organization_id = 144-- and inventory_item_id = 7755 -- DEFAULT_RECEIVING_SUBINV_MIR    -- OBJECT_VERSION_NUMBER = 2 all others are 1


--===============================
--CHANGE PO NUMBER FROM LC DETAILS TABLE
-- CASE: Johir vai Wrongly selected ADP instead og USD and make GRN , 
-- SLOUSION: Return to vendor the GRN , Cancel the PO, Create a New PO, Add the new PO in LC Updatinig the previous PO, Then create GRN and others Procedure 
--===============================

SELECT * FROM PO_HEADERS_ALL WHERE SEGMENT1= 40012889 AND org_id =104

SELECT * FROM XX_LC_DETAILS WHERE  PO_NUMBER = 40012889  AND org_id =104 --  OLD PO: 40011731, NEW PO: 40012889


--UPDATE XX_LC_DETAILS
--SET PO_HEADER_ID= 885882 ,
--PO_NUMBER= 40012889
--WHERE LC_ID = 11095
--AND  org_id =104








UPDATE XX_LC_DETAILS
SET LC_STATUS = 'O'
WHERE LC_NUMBER='2355-19-02-0041'


select *  from XX_LC_DETAILS where LC_ID=11084 --'1404-21-01-0009'


Johir vai LC issue
--==============

UPDATE XX_LC_DETAILS
SET LC_NUMBER = 0,
PO_NUMBER= 0
WHERE LC_ID=11084




select * from XX_LC_DETAILS