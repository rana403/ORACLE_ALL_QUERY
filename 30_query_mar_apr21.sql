select * from org_organization_definitions -- 26281 --- KBIL

-- Query-01
--Update mtl_material_transactions table

UPDATE mtl_material_transactions t
SET opm_costed_flag = 'D'
WHERE transaction_date >= TO_DATE('01/03/21 00:00:00','dd/mm/yy hh24:mi:ss')
AND transaction_date <= TO_DATE('30/04/21 23:59:59','dd/mm/yy hh24:mi:ss')
AND EXISTS
(
SELECT 1
FROM mtl_parameters p, hr_organization_information hoi
WHERE p.process_enabled_flag = 'Y'
AND hoi.org_information2 = '&LE_ID'
AND hoi.org_information_context = 'Accounting Information'
AND p.organization_id = hoi.organization_id
AND p.organization_id = t.organization_id
)


-- Query-02
-- Update gmf_rcv_accounting_txns table
      
UPDATE gmf_rcv_accounting_txns grat
   SET accounted_flag = 'D'
 WHERE transaction_date >=
          TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND transaction_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND EXISTS
              (SELECT 1
                 FROM mtl_parameters p, hr_organization_information hoi
                WHERE p.process_enabled_flag = 'Y'
                      AND hoi.org_information2 = '&LE_ID'
                      AND hoi.org_information_context =
                             'Accounting Information'
                      AND p.organization_id = hoi.organization_id
                      AND p.organization_id = grat.organization_id);
                      


-- Query-03
-- Update gmf_invoice_distributions table
 
UPDATE gmf_invoice_distributions
   SET Accounted_flag = 'D', final_posting_date = NULL
 WHERE accounted_date >= TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND accounted_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND legal_entity_id = '&LE_ID';
       
       

-- Query-04  
--    Update transaction valuation table to set shipment_costed flag
--    back to NULL for event clases FOB_RCPT_SENDER_RCPT and FOB_SHIP_RECIPIENT_SHIP

UPDATE mtl_material_transactions t
   SET shipment_costed = NULL
 WHERE transaction_source_type_id IN (7, 8, 13)
       AND transaction_action_id IN (12, 21)
       AND transaction_date >=
              TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND transaction_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND EXISTS
              (SELECT 1
                 FROM mtl_parameters p, hr_organization_information hoi
                WHERE p.process_enabled_flag = 'Y'
                      AND hoi.org_information2 = '&LE_ID'
                      AND hoi.org_information_context =
                             'Accounting Information'
                      AND p.organization_id = hoi.organization_id
                      AND p.organization_id = t.organization_id)
                      
                      
                      
-- Query-05
-- Update incoming layers table (BatchesXperiods Enh.)

UPDATE gmf_incoming_material_layers giml
   SET accounted_flag = 'D', actual_posting_date = NULL
 WHERE layer_date >= TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND layer_date <= TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND EXISTS
              (SELECT 1
                 FROM mtl_parameters p, hr_organization_information hoi
                WHERE p.process_enabled_flag = 'Y'
                      AND hoi.org_information2 = '&LE_ID'
                      AND hoi.org_information_context =
                             'Accounting Information'
                      AND p.organization_id = hoi.organization_id
                      AND p.organization_id = giml.mmt_organization_id);
                      
                      

-- Query-06
-- Update resource transaction table
-- Decide what Flag to use when run in Draft Mode.

UPDATE gme_resource_txns
   SET posted_ind = 0
 WHERE trans_date >= TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND trans_date <= TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND organization_id IN
              (SELECT hoi.organization_id
                 FROM hr_organization_information hoi
                WHERE hoi.org_information2 = '&LE_ID'
                      AND hoi.org_information_context =
                             'Accounting Information')        
                             


-- Query-07
-- Update Batch Header table

UPDATE gme_batch_header
   SET gl_posted_ind = 0
 WHERE batch_close_date >=
          TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND batch_close_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND organization_id IN
              (SELECT hoi.organization_id
                 FROM hr_organization_information hoi
                WHERE hoi.org_information2 = '&LE_ID'
                      AND hoi.org_information_context =
                             'Accounting Information');
                             
                             
                             
-- Query-08
-- Now for lot cost method, update gmf_lot_cost_adjustmets table
-- For Actual/Standard methods, update gmf_period_balances table.

UPDATE gmf_lot_cost_adjustments
   SET gl_posted_ind = 0
 WHERE adjustment_date >=
          TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND adjustment_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND legal_entity_id = '&LE_ID';
       
       
       
-- Query-09
-- Update transaction valuation table

UPDATE gmf_period_balances
   SET costed_flag = 'D'
 WHERE period_balance_id IN
          (SELECT xte.SOURCE_ID_INT_1
             FROM xla.xla_transaction_entities xte,
                  xla_events xe,
                  gmf_xla_extract_headers geh
            WHERE     xte.entity_id = xe.entity_id
                  AND xe.event_id = geh.event_id
                  AND xe.application_id = 555
                  AND geh.transaction_date >=
                         TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
                  AND geh.transaction_date <=
                         TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
                  AND geh.event_type_code = 'COSTREVAL'
                  AND geh.legal_entity_id = '&LE_ID');
                  
                  
                  
-- Query-10              
-- Update Actual Cost Adjustments

UPDATE cm_adjs_dtl
   SET gl_posted_ind = 0
 WHERE adjustment_date >=
          TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND adjustment_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
       AND organization_id IN
              (SELECT hoi.organization_id
                 FROM hr_organization_information hoi
                WHERE hoi.org_information2 = '&LE_ID'
                      AND hoi.org_information_context =
                             'Accounting Information');
                             
                             
                             
-- Query-11                        
-- Update Cost Allocations

UPDATE gl_aloc_dtl
   SET gl_posted_ind = 0
 WHERE allocdtl_id IN
          (SELECT xte.SOURCE_ID_INT_1
             FROM xla.xla_transaction_entities xte,
                  xla_events xe,
                  gmf_xla_extract_headers geh
            WHERE     xte.entity_id = xe.entity_id
                  AND xe.event_id = geh.event_id
                  AND xe.application_id = 555
                  AND geh.transaction_date >=
                         TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
                  AND geh.transaction_date <=
                         TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
                  AND geh.event_type_code = 'GLCOSTALOC'
                  AND geh.legal_entity_id = '&LE_ID');
                  
                  
                  
                  
                  
-- Query-12
--START changes V2 Dt. 01-Jul-2015
--Applicable FOR OPM-LCM integration FOR RELEASE 12.1 AND later
--START UPDATE OPM-LCM integration TABLES

UPDATE gmf_lc_actual_cost_adjs
   SET accounted_flag = 'N', final_posting_date = NULL
 WHERE adj_transaction_id IN
          (SELECT adj_transaction_id
             FROM gmf_lc_adj_transactions
            WHERE legal_entity_id = '&LE_ID'
                  AND transaction_date >=
                         TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
                  AND transaction_date <=
                         TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss'));
                         


-- Query-13

UPDATE gmf_lc_lot_cost_adjs
   SET accounted_flag = 'N', final_posting_date = NULL
 WHERE adj_transaction_id IN
          (SELECT adj_transaction_id
             FROM gmf_lc_adj_transactions
            WHERE legal_entity_id = '&LE_ID'
                  AND transaction_date >=
                         TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
                  AND transaction_date <=
                         TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss'));
                         
                         
-- Query-14

UPDATE gmf_lc_adj_transactions
   SET accounted_flag = 'D'
 WHERE legal_entity_id = '&LE_ID'
       AND transaction_date >=
              TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
       AND transaction_date <=
              TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
              
              
                 
-- Query-15
-- Delete transaction valuation rows

DELETE FROM gmf_transaction_valuation
      WHERE transaction_date >=
               TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
            AND transaction_date <=
                   TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
            AND legal_entity_id = '&LE_ID';
            
            
            
            
-- Query-16 (to delete xla_events_bck_kbil_Sep_18_19)

CREATE TABLE xla_events_bck_kspl3421
AS
   SELECT xe.*
     FROM xla_events xe, gmf_xla_extract_headers gmf
    WHERE xe.application_id = 555 AND xe.event_id = gmf.event_id
          AND gmf.transaction_date >=
                 TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
          AND gmf.transaction_date <=
                 TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
          AND gmf.legal_entity_id = '&LE_ID';
          
          
          
-- Query-17

CREATE TABLE xla_ae_headers_bck_kspl3421
AS
   SELECT *
     FROM xla_ae_headers
    WHERE application_id = 555
          AND event_id IN (SELECT event_id FROM xla_events_bck_kspl3421);
          
          
          
-- Query-18

CREATE TABLE xla_ae_lines_bck_kspl3421
AS
   SELECT *
     FROM xla_ae_lines
    WHERE application_id = 555
          AND ae_header_id IN
                 (SELECT ae_header_id FROM xla_ae_headers_bck_kspl3421);
                 
                 


-- Query-19

CREATE TABLE xla_dist_link_bck_kspl3421
AS
   SELECT *
     FROM xla_distribution_links
    WHERE application_id = 555
          AND ae_header_id IN
                 (SELECT ae_header_id FROM xla_ae_headers_bck_kspl3421);
                 
                 
-- Query-20

CREATE TABLE xla_ae_seg_val_bck_kspl3421
AS
   SELECT *
     FROM xla_ae_segment_values
    WHERE ae_header_id IN
             (SELECT ae_header_id FROM xla_ae_headers_bck_kspl3421);
             
             
             
-- Query-21

CREATE TABLE xla_trans_enti_upg_bck_kspl21
AS
   SELECT *
     FROM XLA_TRANSACTION_ENTITIES_UPG
    WHERE     application_id = 555
          AND LEGAL_ENTITY_ID = '&LE_ID'
          AND ENTITY_ID IN (SELECT ENTITY_ID FROM xla_ae_headers_bck_kspl3421);
          
          
-- Query-22
-- delete data from xla tables

DELETE FROM xla_distribution_links
      WHERE application_id = 555
            AND ae_header_id IN
                   (SELECT DISTINCT ae_header_id
                      FROM xla_dist_link_bck_kspl3421);
                      
                      
                      
-- Query-23

DELETE FROM xla_ae_lines
      WHERE application_id = 555
            AND ae_header_id IN
                   (SELECT DISTINCT ae_header_id FROM xla_ae_lines_bck_kspl3421);
                   
                   
-- Query-24

DELETE FROM xla_ae_segment_values
      WHERE ae_header_id IN
               (SELECT DISTINCT ae_header_id FROM xla_ae_seg_val_bck_kspl3421);
               
               
-- Query-25

DELETE FROM xla_ae_headers
      WHERE application_id = 555
            AND ae_header_id IN
                   (SELECT ae_header_id FROM xla_ae_headers_bck_kspl3421);
                   
                   
-- Query-26

DELETE FROM xla_events
      WHERE application_id = 555
            AND event_id IN (SELECT event_id FROM xla_events_bck_kspl3421);
            
            
-- Query-27

DELETE FROM XLA_TRANSACTION_ENTITIES_UPG
      WHERE APPLICATION_ID = 555 AND LEGAL_ENTITY_ID = '&LE_ID'
            AND ENTITY_ID IN
                   (SELECT ENTITY_ID FROM xla_ae_headers_bck_kspl3421);
                   
                   
-- Query-28
-- Delete extract lines

DELETE FROM gmf_xla_extract_lines
      WHERE header_id IN
               (SELECT header_id
                  FROM gmf_xla_extract_headers
                 WHERE transaction_date >=
                          TO_DATE ('01/03/21 00:00:00',
                                   'dd/mm/yy hh24:mi:ss')
                       AND transaction_date <=
                              TO_DATE ('30/04/21 23:59:59',
                                       'dd/mm/yy hh24:mi:ss')
                       AND legal_entity_id = '&LE_ID');
                       
          
      
                   
-- Query-29
-- Delete extract headers

DELETE FROM gmf_xla_extract_headers
      WHERE transaction_date >=
               TO_DATE ('01/03/21 00:00:00', 'dd/mm/yy hh24:mi:ss')
            AND transaction_date <=
                   TO_DATE ('30/04/21 23:59:59', 'dd/mm/yy hh24:mi:ss')
            AND legal_entity_id = '&LE_ID';
            
            
            
            
            
            
 -- Query-30
            
SELECT * FROM gmf_period_statuses ---
 

/*   a) Identify period_id of the costing period. Run the script for proper
      cost calendar code, period code and cost method code. */

     SELECT s.*
     FROM gmf_period_statuses s, cm_mthd_mst m
     WHERE s.calendar_code = '&cost_calendar_code'  --- 19-20
     AND s.period_code = '&cost_period_code'  --- SEP-19
     AND s.cost_type_id = m.cost_type_id     
     AND m.cost_mthd_code = '&cost_method_code'  ---  KSRM_ACT
     AND LEGAL_ENTITY_ID= '&LE_ID'


/*  b) Reset gl_item_cst.final_flag to 0    */  

      UPDATE gl_item_cst
      SET final_flag = 0
      WHERE period_id  in (361) --- <period_id FROM query a>
      AND   final_flag = 1;
  

/*  c) Reset cm_cmpt_dtl.rollover_ind to 0  */
   
      UPDATE cm_cmpt_dtl
      SET rollover_ind = 0
      WHERE period_id = 361  ----<period_id FROM query a>
      AND   rollover_ind = 1;
  

/*   d) Resets costing period status to 'OPEN'  */
   
      UPDATE gmf_period_statuses
      SET period_status = 'O'
      WHERE period_id =361 ---- <period_id FROM query a>
      AND   period_status IN ('F','C');
  

/*   e) Commit;     */
   
      
   
UPDATE org_acct_periods
SET open_flag = 'Y',
period_close_date = NULL,
summarized_flag = 'N'
WHERE organization_id IN (select distinct organization_id from ORG_ORGANIZATION_DEFINITIONS where LEGAL_ENTITY= '&LE_ID')  --- :organization_id
AND PERIOD_NAME='Apr-21'


