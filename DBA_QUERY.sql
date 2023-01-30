/*:::::::::::::::::::::: TO GET ALL TOAD USERS WHO ARE CONNECTED NOW IN TOAD:::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
SELECT SID,SERIAL#,STATUS, SCHEMANAME, OSUSER, MACHINE, TERMINAL, PROGRAM, PREV_EXEC_START, MODULE, SERVICE_NAME, USERNAME,TO_CHAR(LOGON_TIME,'DD-MON-RR hh24:mi')
LOGON_TIME,
TRUNC(LAST_CALL_ET/60) IDLE_MINS
FROM V$SESSION
WHERE USERNAME IS NOT NULL
AND OSUSER NOT IN ('applmgr' , 'appbit')

SELECT username, seconds_in_wait, machine, port, terminal, program, module, service_name
  FROM v$session
  WHERE type = 'USER'
  AND terminal is not null
  and program like '%Toad%'


--==========================================
-- QUERY TO GET CONCURRENT PROGRAM NAME AND SATTUS
--==============================================
SELECT distinct t.user_concurrent_program_name "Conc Program Name",
 r.REQUEST_ID "Request ID",
 to_char(r.ACTUAL_START_DATE,'dd-MON-yy hh24:mi:ss') "Started at",
 to_char(r.ACTUAL_COMPLETION_DATE,'dd-MON-yy hh24:mi:ss') "Completed at",
 decode(r.PHASE_CODE,'C','Completed','I','Inactive','P','Pending','R','Running','NA') "Phasecode",
 decode(r.STATUS_CODE, 'A','Waiting', 'B','Resuming', 'C','Normal', 'D','Cancelled', 'E','Error', 'F','Scheduled', 'G','Warning', 'H','On Hold', 'I','Normal', 'M',
 'No Manager', 'Q','Standby', 'R','Normal', 'S','Suspended', 'T','Terminating', 'U','Disabled', 'W','Paused', 'X','Terminated', 'Z','Waiting') "Status",r.argument_text "Parameters",
 u.user_name "Username",
 --ROUND ((v.actual_completion_date - v.actual_start_date) * 1440,
 --              2
  --            ) "Runtime (in Minutes)" 
 round(((nvl(v.actual_completion_date,sysdate)-v.actual_start_date)*24*60),2) "ElapsedTime(Mins)"
 FROM
 apps.fnd_concurrent_requests r ,
 apps.fnd_concurrent_programs p ,
 apps.fnd_concurrent_programs_tl t,
 apps.fnd_user u, apps.fnd_conc_req_summary_v v
 WHERE 
 r.CONCURRENT_PROGRAM_ID = p.CONCURRENT_PROGRAM_ID
 --AND r.actual_start_date >= (sysdate - $NO_DAYS)
 --AND r.requested_by=22378
 AND   r.PROGRAM_APPLICATION_ID = p.APPLICATION_ID
 AND t.concurrent_program_id=r.concurrent_program_id
 AND r.REQUESTED_BY=u.user_id
 AND v.request_id=r.request_id
 AND r.request_id =:P_REQ_ID
-- and  t.user_concurrent_program_name = 'XXKSRM Update Challan Temp For KOL'
 --and t.user_concurrent_program_name like '$CONC_PROG_NAME'
-- and decode(r.STATUS_CODE, 'A','Waiting', 'B','Resuming', 'C','Normal', 'D','Cancelled', 'E','Error', 'F','Scheduled', 'G','Warning', 'H','On Hold', 'I','Normal', 'M',
-- 'No Manager', 'Q','Standby', 'R','Normal', 'S','Suspended', 'T','Terminating', 'U','Disabled', 'W','Paused', 'X','Terminated', 'Z','Waiting') = 'pending'
-- order by to_char(r.ACTUAL_COMPLETION_DATE,'dd-MON-yy hh24:mi:ss') desc


select sys_context('userenv', 'server_host') from dual;

-- ============== TO GET HOST NAME OF A DATABASE =======================

SELECT  host_name
FROM    v$instance

--============= TO GET DB_NAME, USER_NAME , DB_HOST, USER_HOST==================

select sys_context ( 'USERENV', 'DB_NAME' ) db_name,
sys_context ( 'USERENV', 'SESSION_USER' ) user_name,
sys_context ( 'USERENV', 'SERVER_HOST' ) db_host,
sys_context ( 'USERENV', 'HOST' ) user_host
from dual


SELECT program FROM v$session WHERE program LIKE '%(PMON)%';






SELECT * FROM dba_temp_free_space;

select * from table_space

select * from database_properties WHERE PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE' ; 

select * from database_properties   --where PROPERTY_NAME='DEFAULT_TEMP_TABLESPACE';    

SELECT tablespace_name, file_name, bytes FROM dba_temp_files WHERE tablespace_name = 'TEMP2';


SELECT SESSION_KEY,INPUT_TYPE,STATUS,START_TIME,END_TIME,ELAPSED_SECONDS/3600 hrs
FROM V$RMAN_BACKUP_JOB_DETAILS












-- -- TO GET ALL DATABASE FORMS NAME WITH FUNCTION

select
fnf.application_id,
fa.APPLICATION_NAME,
ff.FUNCTION_NAME ,
ffl.USER_FUNCTION_NAME ,
ffl.description ,
fnf.form_name,
ff.parameters,
ff.type
from fnd_form_functions_tl ffl,
fnd_form_functions ff,
fnd_form fnf,
fnd_application_tl fa
where
--ff.function_name like ‘******’
ffl.FUNCTION_ID=ff.FUNCTION_ID
and ff.type='FORM'
and fnf.form_id=ff.form_id
and fa.application_id=fnf.application_id
and fa.APPLICATION_NAME like '%Purchas%'
--===========and fa.APPLICATION_ID========*








---





