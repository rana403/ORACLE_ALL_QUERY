--=======================================================
--QUERY TO FIND CONCURRENT REQUEST RUNNING MORE THAN 2 HRS
--=======================================================

SELECT   fcr.request_id rqst_id
        ,fu.user_name
        ,fr.responsibility_name
        ,fcp.user_concurrent_program_name program_name
        ,TO_CHAR (fcr.actual_start_date, 'DD-MON-YYYY HH24:MI:SS')start_datetime
        ,DECODE (fcr.status_code, 'R', 'R:Running', fcr.status_code) status
        ,ROUND (((SYSDATE - fcr.actual_start_date) * 60 * 24), 2) runtime_min
        ,fcr.oracle_process_id "SPID"
        ,fcr.os_process_id os_pid
    FROM apps.fnd_concurrent_requests fcr
        ,apps.fnd_user fu
        ,apps.fnd_responsibility_vl fr
        ,apps.fnd_concurrent_programs_vl fcp
   WHERE fcr.status_code LIKE 'R'
     AND fu.user_id = fcr.requested_by
     AND fr.responsibility_id = fcr.responsibility_id
     AND fcr.concurrent_program_id = fcp.concurrent_program_id
     AND fcr.program_application_id = fcp.application_id
     AND ROUND (((SYSDATE - fcr.actual_start_date) * 60 * 24), 2) > 120
ORDER BY fcr.concurrent_program_id
        ,request_id DESC


--==============================================================
-- CANCEL PENDING REQUEST FROM A PARTICULAR USER IN ORACLE APPS
--==============================================================

--UPDATE fnd_concurrent_requests
SET phase_code = 'C', status_code = 'X'
WHERE request_id in (select cwr.request_id FROM apps.fnd_concurrent_worker_requests cwr, apps.fnd_concurrent_queues_tl cq, apps.fnd_user fu
WHERE (cwr.phase_code = 'P')   AND cwr.hold_flag != 'Y'   
--AND cwr.requested_start_date <= SYSDATE
AND cwr.concurrent_queue_id = cq.concurrent_queue_id   AND cwr.queue_application_id = cq.application_id  and cq.LANGUAGE='US'
AND cwr.requested_by = fu.user_id and fu.user_name='KG-4079'
and cwr.user_concurrent_program_name='&user_concurrent_program_name')


Select *  from FND_CONC_REQ_SUMMARY_V

where request_id = 'Your request ID'


--===========================================
-- TO GET RERQUEST ID AND PROGRAM NAME WHO RUN THE PROGRAM 
--===========================================

SELECT
   distinct user_concurrent_program_name,
       user_name,
    responsibility_name,
    request_date,
    argument_text,
    request_id,
    phase_code,
    status_code,
    logfile_name,
    outfile_name,
    output_file_type,
    hold_flag
FROM
    fnd_concurrent_requests fcr,
    fnd_concurrent_programs_tl fcp,
    fnd_responsibility_tl fr,
    fnd_user fu
WHERE
    fcr.CONCURRENT_PROGRAM_ID = fcp.concurrent_program_id
    and fcr.responsibility_id = fr.responsibility_id
    and fcr.requested_by = fu.user_id
    --and user_name = upper('HIMSINGH')
  --  and user_concurrent_program_name in('Active Users')
 --   and Phase_code='P'
ORDER BY REQUEST_DATE DESC

--===========================================
-- ALL COCCURRENT PROGRAM LIST QUERY 
-- DATE: 26-FEB-2019
--===========================================
SELECT
        fcpl.user_concurrent_program_name "Concurrent Program Name",
        fcp.concurrent_program_name "Short Name",
        fcp.EXECUTION_METHOD_CODE,
        fdfcuv.column_seq_num "Column Seq Number",
        fdfcuv.end_user_column_name "Parameter Name",
        fdfcuv.form_left_prompt "Prompt",
        fdfcuv.enabled_flag " Enabled Flag",
        fdfcuv.required_flag "Required Flag",
        fdfcuv.display_flag "Display Flag",
        fdfcuv.flex_value_set_id "Value Set Id",
        ffvs.flex_value_set_name "Value Set Name",
        flv.meaning "Default Type",
        fdfcuv.DEFAULT_VALUE "Default Value"
FROM
        fnd_concurrent_programs fcp,
        fnd_concurrent_programs_tl fcpl,
        fnd_descr_flex_col_usage_vl fdfcuv,
        fnd_flex_value_sets ffvs,
        fnd_lookup_values flv
WHERE
        fcp.concurrent_program_id = fcpl.concurrent_program_id
       -- AND    fcpl.user_concurrent_program_name = :conc_prg_name
        AND    fdfcuv.descriptive_flexfield_name = '$SRS$.'
                 || fcp.concurrent_program_name
                 and ffvs.flex_value_set_name = 'FND_STANDARD_DATE'
             --    and fcp.concurrent_program_name like 'XXSYK%'
               -- and fcp.EXECUTION_METHOD_CODE ='H'
        AND    ffvs.flex_value_set_id = fdfcuv.flex_value_set_id
        AND    flv.lookup_type(+) = 'FLEX_DEFAULT_TYPE'
        AND    flv.lookup_code(+) = fdfcuv.default_type
        AND    fcpl.LANGUAGE = USERENV ('LANG')
        AND    flv.LANGUAGE(+) = USERENV ('LANG')
        and  fcp.concurrent_program_name like 'XX%'

--=====================================================

SELECT fcpt.user_concurrent_program_name ,
  fcp.concurrent_program_name short_name ,
  fat.application_name program_application_name ,
  fet.executable_name ,
  fat1.application_name executable_application_name ,
  flv.meaning execution_method ,
  fet.execution_file_name ,
  fcp.enable_trace
FROM fnd_concurrent_programs_tl fcpt ,
  fnd_concurrent_programs fcp ,
  fnd_application_tl fat ,
  fnd_executables fet ,
  fnd_application_tl fat1 ,
  FND_LOOKUP_VALUES FLV
WHERE 1                              =1
AND fcpt.user_concurrent_program_name='Supplier Audit Report'
AND fcpt.concurrent_program_id       = fcp.concurrent_program_id
AND fcpt.application_id              = fcp.application_id
AND fcp.application_id               = fat.application_id
AND fcpt.application_id              = fat.application_id
AND fcp.executable_id                = fet.executable_id
AND fcp.executable_application_id    = fet.application_id
AND fet.application_id               = fat1.application_id
AND flv.lookup_code                  = fet.execution_method_code
--AND FLV.LOOKUP_TYPE                  ='CP_EXECUTION_METHOD_CODE'
;

--=========================================
-- GET RTF template name from backend
--=======================================

Select  xddt.Data_source_name "TEMPLATE NAME"
     --,xl.lob_type
       ,xl.file_name "RTF FILE NAME"
     --,xtb.template_code
      ,fcr.request_id  "REQUEST ID"
from   xdo_lobs xl
      ,xdo_templates_b xtb
      ,xdo_ds_definitions_tl xddt
      ,fnd_concurrent_requests fcr
      ,fnd_concurrent_programs_tl fcpt
      ,fnd_concurrent_programs fcp
where xl.application_short_name = xtb.application_short_name
and   xl.lob_code = xtb.template_code
and   xtb.data_source_code = xddt.data_source_code
and   fcr.concurrent_program_id = fcpt.concurrent_program_id
and   fcp.concurrent_program_id = fcpt.concurrent_program_id
and   xddt.data_source_code = fcp.concurrent_program_name
and   xl.lob_type='TEMPLATE_SOURCE'
and xddt.Data_source_name like '%XX%'
--and   fcr.request_id='5095760' --PASS REQUEST ID

--===========================================

select
xl.lob_type,
xl.application_short_name,
xl.lob_code,
xl.file_name,
xl.language,
xl.territory
--xxen_util.blob_to_clob(xl.file_data) file_clob
from
 xdo_lobs xl
where
xl.file_name like '%.rtf' and
xl.lob_type in ('TEMPLATE','TEMPLATE_SOURCE');


--===========================================================

select
xtv.template_name,
xtv.template_code,
(
select
xl.file_name
from
xdo_lobs xl
where
xtv.template_code=xl.lob_code and
xtv.application_short_name=xl.application_short_name and
(
(
xl.lob_type='TEMPLATE' and
xl.xdo_file_type<>'RTF' and
xtv.template_type_code=xl.xdo_file_type
or
xl.lob_type='TEMPLATE_SOURCE' and
xl.xdo_file_type in ('RTF','RTF-ETEXT')
) and
xtv.default_language=xl.language and
xtv.default_territory=xl.territory
or
xl.lob_type='TEMPLATE_SOURCE' and
xl.xdo_file_type='RTF' and
xtv.mls_language=xl.language and
xtv.mls_territory=xl.territory and
exists (
select null from xdo_lobs xl2
where xl2.lob_type='MLS_TEMPLATE' and
xtv.application_short_name=xl2.application_short_name and
xtv.template_code=xl2.lob_code and
xtv.default_language=xl2.language and
xtv.default_territory=xl2.territory) and
not exists (
select null from xdo_lobs xl3
where
xl3.lob_type='TEMPLATE_SOURCE' and
xtv.application_short_name=xl3.application_short_name and
xtv.template_code=xl3.lob_code and
xtv.default_language=xl3.language and
xtv.default_territory=xl3.territory)
)
) default_template_file,
(select xl.file_name from xdo_lobs xl where xl.lob_type='TEMPLATE_SOURCE' and xtv.application_short_name=xl.application_short_name and xtv.template_code=xl.lob_code and xtv.mls_language=xl.language and xtv.mls_territory=xl.territory) mls_template_file
from
xdo_templates_vl xtv


--=====================================

--CONCURRENT PROGRAM RFPORT NAME

SELECT fl.meaning
     , fu.user_name
     , fu.description requestor
     , fu.end_date
     , NVL(fu.email_address, 'n/a') email_address
     , fcr.request_id
     , fcr.number_of_copies
     , fcr.printer
     , fcr.request_date
     , fcr.requested_start_date
     , fcp.description
     , fcr.argument_text
     , frt.responsibility_name
  FROM apps.fnd_concurrent_requests fcr
     , apps.fnd_user fu
     , apps.fnd_lookups fl
     , apps.fnd_concurrent_programs_vl fcp
     , apps.fnd_responsibility_tl frt
 WHERE fcr.requested_by = fu.user_id
   AND fl.lookup_type = 'CP_STATUS_CODE'
   AND fcr.status_code = fl.lookup_code
   AND fcr.program_application_id = fcp.application_id
   AND fcr.concurrent_program_id = fcp.concurrent_program_id
   AND fcr.responsibility_id = frt.responsibility_id
   AND fcr.phase_code = 'P' 
   
   
   --========================================================
 --  Currently running concurrent program details along with user and responsibility
   --===========================================================
   
   SELECT fcp.user_concurrent_program_name,
  fcr.request_id,
  fcr.request_date,
  fu.user_name Requested_By ,
  fr.responsibility_name,
  TO_CHAR(fcr.actual_start_date,'DD-MON-YYYY HH24:MI:SS') actual_start_date
FROM fnd_concurrent_requests fcr ,
  fnd_concurrent_programs_tl fcp ,
  fnd_user fu ,
  fnd_responsibility_tl fr
WHERE 1                       =1
AND fcr.phase_code            ='R'
AND fcr.concurrent_program_id = fcp.concurrent_program_id
AND fcr.requested_by          = fu.user_id
AND FCR.RESPONSIBILITY_ID     = FR.RESPONSIBILITY_ID


--=========================================================================
-- Run the following query to check the status of all service components including Workflow Notification Mailer

SELECT sc.component_type, 
         sc.component_name,
         fnd_svc_component.get_component_status(sc.component_name) component_status
    FROM fnd_svc_components sc
ORDER BY sc.component_type,
         sc.component_name;   
         
         --==========================================================
         
          select ig.user_name integrator,
         fa.application_name application
    from bne_integrators_vl ig, 
         fnd_application_vl fa
   where ig.enabled_flag = 'Y'
     and ig.application_id = fa.application_id
order by ig.application_id;

--======================================================

select DEVELOPER_PARAMETERS from FND_CP_SERVICES
where SERVICE_ID = (select MANAGER_TYPE from FND_CONCURRENT_QUEUES
where CONCURRENT_QUEUE_NAME = 'FNDCPOPP');


SELECT distinct a.segment_name,
 a.SEGMENT_TYPE,
 a.TABLESPACE_NAME,
 a.file_id,
 b.file_name Datafile_name
 FROM dba_extents a, dba_data_files b
 WHERE a.file_id = b.file_id
 --AND b.file_id = <data file id>;
 
 select * from dba_extents

select * from dba_data_files


--=========================================

--==============================================================================

SELECT fcpa.concurrent_request_id request_id, fcp.node_name node_name, fcp.logfile_name logfile_path
  FROM fnd_conc_pp_actions fcpa, fnd_concurrent_processes fcp
 WHERE fcpa.processor_id = fcp.concurrent_process_id
   AND fcpa.action_type = 6
   -- AND fcpa.concurrent_request_id = :REQUEST_ID
   
   
--=================================================================
   
   
   



