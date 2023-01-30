--=======================
--REPORT FOR LCM
--=======================
Shipments Interface Import  ----> Inventory Administrator Responsibility
Landed cost Integration Manager ---> 



exec mo_global.set_policy_context( 'S',&Org_id);

SELECT DECODE (raet.event_type_name, 'RECEIVE', 1, 'LOGICAL_RECEIVE', 1, 'LDD_COST_ADJ_RCV', 3.1, 'LDD_COST_ADJ_DEL_ASSET', 3.2, 'RETURN_TO_RECEIVING', 6.1, 'RETURN_TO_VENDOR', 6.2) event_type,
       rsl.creation_date,
       sh.ship_header_id,
       mp.organization_id,
       mp.organization_code,
       fnd.meaning Cost_Method,
       sh.ship_num,
       sl.ship_line_group_id,
       sl.ship_line_num,
       rt.transaction_id rcv_transaction_id,
       rt.transaction_type rcv_transaction_type,
       raet.event_type_name transaction_type,
       NULL mmt_transaction_id,
       rsl.code_combination_id,
       cc.concatenated_segments account,
       rsl.accounting_line_type account_name,
       rsl.accounted_dr accounted_dr,
       rsl.accounted_cr accounted_cr
FROM fnd_lookup_values_vl fnd,
     gl_code_combinations_kfv cc,
     rcv_receiving_sub_ledger rsl,
     rcv_accounting_events rae,
     rcv_accounting_event_types raet,
     rcv_transactions rt,
     inl_ship_lines_all sl,
     mtl_parameters mp,
     inl_ship_headers_all sh
WHERE cc.code_combination_id = rsl.code_combination_id
AND rsl.rcv_transaction_id = rt.transaction_id
AND rae.accounting_event_id = rsl.accounting_event_id
AND raet.event_type_id = rae.event_type_id
AND raet.event_type_name IN ('RECEIVE', 'LOGICAL_RECEIVE', 'LDD_COST_ADJ_RCV', 'PAC_LCM_ADJ_DEL_REC', 'LDD_COST_ADJ_DEL_ASSET', 'PAC_LCM_ADJ_DEL_ASSET', 'RETURN_TO_RECEIVING', 'RETURN_TO_VENDOR')
AND rt.lcm_shipment_line_id = sl.ship_line_id
AND sl.ship_header_id = sh.ship_header_id
AND fnd.lookup_code = mp.primary_cost_method
AND fnd.lookup_type = 'MTL_PRIMARY_COST'
AND mp.organization_id = sh.organization_id
AND sh.ship_header_id = &&ship_header_id
UNION ALL
SELECT DECODE (mmt.transaction_type_id, 18, 2, 80, 3.3, 36, 6.1) event_type, 
       mta.creation_date,
       sh.ship_header_id,
       mp.organization_id,
       mp.organization_code,
       fnd.meaning Cost_Method,
       sh.ship_num,
       sl.ship_line_group_id,
       sl.ship_line_num,
       rt.transaction_id rcv_transaction_id,
       rt.transaction_type rcv_transaction_type,
       tt.transaction_type_name transaction_type,
       mmt.transaction_id mmt_transaction_id,
       mta.reference_account code_combination_id,
       cc.concatenated_segments account,
       mfg.meaning account_name,
       DECODE(SIGN(mta.base_transaction_value),-1,TO_NUMBER(NULL),mta.base_transaction_value) accounted_dr,
       DECODE(SIGN(mta.base_transaction_value),-1,ABS(mta.base_transaction_value),TO_NUMBER(NULL)) accounted_cr      
FROM fnd_lookup_values_vl fnd,
     gl_code_combinations_kfv cc,
     mtl_transaction_accounts mta,
     mtl_transaction_types tt,
     mtl_material_transactions mmt,
     rcv_transactions rt,
     inl_ship_lines_all sl,
     mtl_parameters mp,
     inl_ship_headers_all sh,
     mfg_lookups mfg   
WHERE mfg.lookup_type = 'CST_ACCOUNTING_LINE_TYPE'
AND mfg.lookup_code = mta.accounting_line_type
AND cc.code_combination_id = mta.reference_account
AND mta.transaction_id = mmt.transaction_id 
AND tt.transaction_type_id = mmt.transaction_type_id
AND ((mmt.transaction_source_type_id = 1 AND mmt.rcv_transaction_id = rt.transaction_id  AND rt.transaction_type = 'DELIVER') OR (mmt.transaction_source_name = 'LCM ADJUSTMENT' AND mmt.trx_source_line_id = rt.transaction_id))
AND rt.lcm_shipment_line_id = sl.ship_line_id
AND sl.ship_header_id = sh.ship_header_id
AND fnd.lookup_code = mp.primary_cost_method
AND fnd.lookup_type = 'MTL_PRIMARY_COST'
AND mp.organization_id = sh.organization_id
AND sh.ship_header_id = &&ship_header_id
UNION ALL
SELECT DECODE(ai.invoice_type_lookup_code, 'STANDARD', (DECODE (al.line_type_lookup_code, 'ITEM', 4, 'FREIGHT', 5, 'MISCELLANEOUS', 5)), 'DEBIT' ,7) event_type,
       aidv.creation_date,
       sh.ship_header_id,
       mp.organization_id,
       mp.organization_code,
       fnd.meaning Cost_Method,
       sh.ship_num,
       sl.ship_line_group_id,
       sl.ship_line_num,
       rt.transaction_id rcv_transaction_id,
       rt.transaction_type rcv_transaction_type,
       DECODE (ai.invoice_type_lookup_code, 'STANDARD',(al.line_type_lookup_code||' Invoice'), 'DEBIT', al.line_type_lookup_code||' Debit Memo') transaction_type ,
       NULL mmt_transaction_id,
       aidv.dist_code_combination_id,
       cc.concatenated_segments account,
       DECODE (aidv.line_type_lookup_code, 'ACCRUAL', 'AP Accrual', 'FREIGHT', 'LCM Default Charge', 'MISCELLANEOUS EXPENSE', 'LCM Default Charge', 'IPV', 'LCM Invoice Price Variance', 'LIABILITY', 'AP Liability', 'NONREC_TAX', 'AP Accrual', 'REC_TAX', 'Recoverable Tax', 'TIPV', 'LCM Tax Variance', 'ERV', 'LCM Exchange Rate Variance', 'TERV', 'LCM Tax Exchange Rate Variance')  account_name,
       (aidv.amount) accounted_dr,
       (null) accounted_cr
FROM fnd_lookup_values_vl fnd,
     gl_code_combinations_kfv cc,
     ap_invoices_all ai,
     ap_invoice_distributions_v aidv,
     ap_invoice_lines_all al,
     rcv_transactions rt,
     inl_ship_lines_all sl,
     mtl_parameters mp,
     inl_ship_headers_all sh
WHERE cc.code_combination_id = aidv.dist_code_combination_id
AND al.line_number = 1
AND al.invoice_id = ai.invoice_id
AND ai.invoice_id = aidv.invoice_id
AND aidv.invoice_id  IN (
SELECT DISTINCT (invoice_id)
FROM ap_invoice_distributions_all
WHERE invoice_distribution_id IN
  (SELECT DISTINCT from_parent_table_id
  FROM inl_matches
  WHERE ship_header_id = &&ship_header_id
  ))
AND rt.transaction_type = 'RECEIVE'
AND rt.lcm_shipment_line_id = sl.ship_line_id
AND sl.ship_header_id = sh.ship_header_id
AND fnd.lookup_code = mp.primary_cost_method
AND fnd.lookup_type = 'MTL_PRIMARY_COST'
AND mp.organization_id = sh.organization_id
AND sh.ship_header_id = &&ship_header_id
UNION ALL
SELECT DECODE(ai.invoice_type_lookup_code, 'STANDARD', (DECODE (al.line_type_lookup_code, 'ITEM', 4, 'FREIGHT', 5, 'MISCELLANEOUS', 5)), 'DEBIT' ,7) event_type,
       ai.creation_date,
       sh.ship_header_id,
       mp.organization_id,
       mp.organization_code,
       fnd.meaning Cost_Method,
       sh.ship_num,
       sl.ship_line_group_id,
       sl.ship_line_num,
       rt.transaction_id rcv_transaction_id,
       rt.transaction_type rcv_transaction_type,
       DECODE (ai.invoice_type_lookup_code, 'STANDARD',(al.line_type_lookup_code||' Invoice'), 'DEBIT', al.line_type_lookup_code||' Debit Memo') transaction_type ,
       NULL mmt_transaction_id,
       ai.accts_pay_code_combination_id,
       cc.concatenated_segments account,
       ('AP Liability') account_name,
       (null) accounted_dr,
       (ai.invoice_amount) accounted_cr
FROM fnd_lookup_values_vl fnd,
     gl_code_combinations_kfv cc,
     ap_invoices_all ai,
     ap_invoice_lines_all al,
     rcv_transactions rt,
     inl_ship_lines_all sl,
     mtl_parameters mp,
     inl_ship_headers_all sh
WHERE cc.code_combination_id = ai.accts_pay_code_combination_id
AND al.line_number = 1
AND al.invoice_id = ai.invoice_id
AND ai.invoice_id  IN (
SELECT DISTINCT (invoice_id)
FROM ap_invoice_distributions_all
WHERE invoice_distribution_id IN
  (SELECT DISTINCT from_parent_table_id
  FROM inl_matches
  WHERE ship_header_id = sh.ship_header_id
  ))
AND rt.transaction_type = 'RECEIVE'
AND rt.lcm_shipment_line_id = sl.ship_line_id
AND sl.ship_header_id = sh.ship_header_id
AND fnd.lookup_code = mp.primary_cost_method
AND fnd.lookup_type = 'MTL_PRIMARY_COST'
AND mp.organization_id = sh.organization_id
AND sh.ship_header_id = &&ship_header_id
ORDER BY ship_line_num, event_type, creation_date, mmt_transaction_id;



