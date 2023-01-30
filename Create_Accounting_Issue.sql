CReate Accounting Issue:
=====================

   select fnd_profile.value ('FND_CONNECTION_TAGGING') from dual
   
   
--    use the following queries and log a service request (SR) against the respective product team (e.g., AR, AP, FA) to have the extracted data corrected.  Obtain the Transaction Diagnostics report if it is available for that product:
    select xe.application_id ,
    xte.entity_code "Transaction Type" ,
    xte.source_id_int_1 "Transaction Id",
    xte.transaction_number "Transaction Number",
    xe.event_id,
    xet.event_class_code ,
    xe.event_type_code ,
    xe.event_status_code ,
    xe.process_status_Code ,
    xe.budgetary_control_flag
    from xla_events xe
    , xla_transaction_entities_upg xte
    , xla_event_types_b xet
    where xte.application_id = 200 --P_APPLICATION_ID
    and xte.entity_id = xe.entity_id
    and xet.application_id = xe.application_id
    and xet.event_type_code = xe.event_type_code
    and xe.application_id = 200 --P_APPLICATION_ID
    and xe.request_id = 9633895P_CREATE_ACCT_REQUEST_ID
    and NOT EXISTS
    ( select 1
    from xla_ae_headers xah
    where xah.event_id = xe.event_id
    and xah.application_id = 200 );
    
    
    SELECT * FROm xla_transaction_entities_upg xte where LEDGER_ID = 2043
    
    
    select * from xla_events where trunc(LAST_UPDATE_DATE) between  '01-OCT-2022' and  '02-OCT-2022'
   
   