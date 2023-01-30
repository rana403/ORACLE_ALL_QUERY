

select * from PO_HEADERS_ALL where VENDOR_ID = (SELECT vendor_id from ap_suppliers where segment1= 1398) 

select * from ap_invoices_all where VENDOR_ID = (SELECT vendor_id from ap_suppliers where segment1= 3863) 








