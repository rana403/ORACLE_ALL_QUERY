--EBS P2P Status Summary Report

select distinct aia.org_id,
SUBSTR(XX_GET_HR_OPERATING_UNIT (AIA.ORG_ID),5) OPERATING_UNIT,
XX_ONT_GET_ENAME(:P_USER) PRINTED_BY ,
XX_INV_PKG.XXGET_ORG_LOCATION (AIA.ORG_ID) ORG_ADDRESS,
aia.invoice_num,
 aia.invoice_date,
 aia.gl_date,
 aia.invoice_amount, 
 aia.doc_sequence_value inv_voucher_no,
 XX_GET_EMP_NAME_FROM_USER_ID (AIA.CREATED_BY) INV_CREATED_BY,
 ( SELECT concatenated_segments
 FROM gl_code_combinations_kfv
 WHERE code_combination_id = aida.dist_code_combination_id
 ) dist_gl_code,
 aps.vendor_name,
 aps.segment1 vendor_no,
 apss.vendor_site_code,
 poh.segment1 po_number,
 poh.creation_date po_date,
 (
  SELECT SUM ( (pla.unit_price * pla.quantity)) price
   FROM po_lines_all pla, po_headers_all pha
   WHERE pla.po_header_id = pha.po_header_id
   and pha.org_id = aia.org_id
   and pha.SEGMENT1 =poh.SEGMENT1
         ) po_amount,
 rsh.receipt_num GRN_Number, 
 rsh.creation_date GRN_date,
 (
 SELECT concatenated_segments
 FROM gl_code_combinations_kfv
 WHERE code_combination_id = pda.code_combination_id
 ) dist_po_code,
 aia.doc_sequence_value voucher_no,
 (
 SELECT segment1||'.'||segment2||'.'||segment3||'.'||segment4
 FROM mtl_system_items_b
 WHERE inventory_item_id = pol.item_id
 AND organization_id = pll.SHIP_TO_ORGANIZATION_ID
 ) item_code,
  (
 SELECT description
 FROM mtl_system_items_b
 WHERE inventory_item_id = pol.item_id
 AND organization_id = pll.SHIP_TO_ORGANIZATION_ID
 ) item_description,
 aida.accounting_date
 /* ,(
 select SERVICE_TAX_REGNO
 FROM JAI_CMN_VENDOR_SITES
 WHERE vendor_id = aia.vendor_id
 AND vendor_site_id = aia.vendor_site_id
 ) st_reg_no,
 (
 SELECT pan_no
 FROM JAI_AP_TDS_VENDOR_HDRS
 where vendor_id = aia.vendor_id
 AND vendor_site_id = aia.vendor_site_id
 ) pan_no,
 -- jtl.UNROUND_TAXABLE_AMT_TRX_CURR,
 -- jtl. */
,ACA.CHECK_NUMBER INSTRUMENT_NO
,ACA.CHECK_DATE INSTURMENT_DATE
,ACA.VENDOR_NAME PAY_PARTY_NAME
,ACA.DOC_SEQUENCE_VALUE PAYMENT_VOUCHER
,ACA.CREATION_DATE PAY_CREATE_DATE
,ACA.DOC_CATEGORY_CODE PAYMENT_TYPE
,ACA.STATUS_LOOKUP_CODE PAYMENT_STATUS
--,CF.CASHFLOW_STATUS_CODE CASH_STATUS
,ACA.CURRENCY_CODE PAY_CURRENCY_CODE
,ACA.AMOUNT PAY_AMOUNT
,ACA.CLEARED_AMOUNT 
,ACA.CLEARED_DATE
,ACA.BANK_ACCOUNT_NAME
--,CF.CLEARED_DATE
--,CF.CLEARED_AMOUNT
from ap_invoices_All aia,
 ap_invoice_lines_all aila,
 ap_suppliers aps,
 ap_supplier_sites_all apss,
 ap_invoice_distributions_all aida,
 po_headers_all poh,
 po_lines_all pol,
 po_line_locations_All pll,
 po_distributions_All pda,
 rcv_transactions rt,
 rcv_shipment_headers rsh,
AP_INVOICE_PAYMENTS_ALL AIPA, -- newly added
AP_CHECKS_ALL ACA-- newly added
-- , jai_tax_lines jtl
where aia.invoice_id = aila.invoice_id
AND aila.org_id = aia.org_id
AND aila.po_header_id = poh.po_header_id
AND aila.po_line_id = pol.po_line_id
AND aila.invoice_id =aida.invoice_id
AND aia.vendor_id = aps.vendor_id
AND aia.vendor_site_id = apss.vendor_site_id
AND aia.vendor_id = apss.vendor_id
AND apss.org_id = aia.org_id
AND aida.invoice_line_number = aila.line_number
and aida.org_id= aila.org_id
AND poh.po_header_id = pol.po_header_id
AND pll.po_header_id = poh.po_header_id
AND pll.po_line_id = pol.po_line_id
AND pll.line_location_id = pda.line_location_id
AND pll.po_header_id = pda.po_header_id
AND pll.po_line_id = pda.po_line_id
AND pol.org_id = pda.org_id
AND poh.org_id = pll.org_id
AND aila.rcv_transaction_id = rt.transaction_id
AND rt.shipment_header_id = rsh.shipment_header_id
AND AIA.INVOICE_ID=AIPA.INVOICE_ID(+)
AND AIPA.CHECK_ID=ACA.CHECK_ID(+)
--AND ACA.BANK_ACCOUNT_ID=CF.CASHFLOW_BANK_ACCOUNT_ID(+)
AND (:P_ORG_ID IS NULL OR AIA.ORG_ID = :P_ORG_ID) --AP org id
AND (:P_VENDOR_NO IS NULL OR aps.segment1 = :P_VENDOR_NO) --aps.segment1 for supplier/vendor name
AND (:P_INV_FROM_DT IS NULL OR TRUNC(aia.invoice_date) BETWEEN :P_INV_FROM_DT AND :P_INV_TO_DT) --AP INV Creation from date, to date
AND (:P_FROM_INV_VOU IS NULL OR aia.doc_sequence_value BETWEEN :P_FROM_INV_VOU AND :P_TO_INV_VOU) --AP  INV voucher from - to 
AND (:P_PO_NO IS NULL OR poh.segment1 = :P_PO_NO) 
AND (:P_GRN_NO IS NULL OR rsh.receipt_num = :P_GRN_NO)



--Date Report er modhe show koranor jonno

SELECT (' From '||TO_CHAR(TO_DATE(:P_F_PO_DT,'DD-MON-RRRR'),'DD-MON-RRRR')||' To '||TO_CHAR(TO_DATE(:P_T_PO_DT,'DD-MON-RRRR'),'DD-MON-RRRR')) PO_DT
FROM DUAL;