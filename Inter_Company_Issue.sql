


/***************************************************************/
Inter company Process Report List
/****************************************************************/
Step 1 : INV : Create Intercompany AR Invoices (From Inventory Administrator responsibility)
Step 2 : AR  : EBS AR Interface Update Process (From Receiveable  Responsibility)
Step 3 : AR  : Autoinvoice Import Program (From Receiveable  Responsibility)
Step 4 : INV : Create Intercompany AP Invoices (From Inventory Administrator Responsibility)
Step 5 : AP  : Payables Open Interface Import (From Payables Administrator Responsibility)

INCIAR

inciap.opc

SELECT INVOICE_NUM,VENDOR_ID, FROM AP_INVOICES_ALL WHERE VENDOR_ID IN(
234,
235,
50,
51,
521,
522,
698,
699,
700,
1031,
1032,
1033,
1034,
781,
782,
783,
1173,
1209,
7429,
440012,
451016,
451017,
514065,
514066,
629284)










select invoiced_flag from AR_RECEIVABLE_APPLICATIONS_ALL

select * from HR_OPERATING_UNITS

select * from org_organization_definitions where operating_unit=382

select * from org_organization_definitions where OPERATING_UNIT= 108   --ORGANIZATION_CODE='SBO'

SELECT *  FROM mtl_material_transactions where TRANSACTION_ID =  15048836  -- costed_flag

select * from mtl_transaction_flow_headers
WHERE ORGANIZATION_ID=224

where start_org_id =  283 -- 224 -- SBO

and end_org_id =383 --SLJ

select * from mtl_intercompany_parameters
--where ship_organization_id =110
WHERE sell_organization_id = 382

select * from AR_RECEIVABLE_APPLICATIONS_ALL




SELECT * FROM MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_ID=62


select * from mtl_material_transactions where  transaction_id =14936115

SELECT * FROM MTL_INTERCOMPANY_PARAMETERS where   CREATION_DATE between '01-JAN-2022' and '30-NOV-2022' --where ship_organization_id = :org_id;

