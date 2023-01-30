select * from PO_HEADERS_ALL where segment1 = 40000705    and org_id = 81  -- TO SEE THE STATUS

update PO_HEADERS_ALL   --- TO UPDATE THE SUPPLIER NAME
SET VENDOR_ID = 1322 
WHERE SEGMENT1 = 40000710
 and org_id = 81;

 --commit;
 