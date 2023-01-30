-- Query to find Custom Oracle Alert
SELECT alr.application_id,
       alr.alert_id,
       alr.alert_name,
       alr.start_date_active,
       alr.description,
       alr.sql_statement_text
  FROM alr.alr_alerts alr
 WHERE 1=1
  -- AND alr.created_by <> 1      -- show only custom alerts
   AND alr.enabled_flag = 'Y'  -- show only enabled alerts
   
   -- http://appselangovan.blogspot.com/search/label/Alert
   
   