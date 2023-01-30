

--============================================
--FIND ALL RESPONSIBILITY THROUGH QUERY
--============================================

SELECT fu.user_name,
      PAPF.FIRST_NAME||PAPF.LAST_NAME Employee_Name,
      fu.EMAIL_ADDRESS User_Attached_Email,
      papf.email_address Emp_attached_eamil,
       frv.responsibility_name,
       frv.responsibility_key,
       TO_CHAR (furgd.start_date, 'DD-MON-YYYY') "User_Resp_START_DATE",
       TO_CHAR (furgd.end_date, 'DD-MON-YYYY') "User_resp_END_DATE",
       fu.start_date User_start_date,
       fu.end_date User_End_date,
       frv.start_date resp_start_date,
       frv.End_date resp_End_date,
       PAPF.effective_start_date Emp_start_date,
       PAPF.EFFECTIVE_END_DATE Emp_end_date    
FROM apps.fnd_user fu,
  apps.fnd_user_resp_groups_direct furgd,
  apps.fnd_responsibility_vl frv, 
  APPS.PER_ALL_PEOPLE_F PAPF
WHERE fu.user_id                     = furgd.user_id
AND furgd.responsibility_id          = frv.responsibility_id
--and upper(frv.RESPONSIBILITY_NAME) like '%RESPONSIBILITY NAME IN CAPS%'
and fu.EMPLOYEE_ID                   =PAPF.PERSON_ID(+) -- IF USER IS AN EMPLOYEE THEN EMPLOYEE DETAILS
AND SYSDATE BETWEEN nvl(PAPF.effective_start_date,sysdate) AND nvl(PAPF.EFFECTIVE_END_DATE,sysdate) -- EMP ACTIVE CONDITION
AND SYSDATE BETWEEN nvl(furgd.start_date,sysdate) AND nvl(furgd.end_date,sysdate) -- USER RESPONSIBILITIES ACTIVE CONDITION
AND SYSDATE BETWEEN nvl(fu.start_date,sysdate) AND nvl(fu.end_date,sysdate) -- USER ACTIVE CONDITION
AND SYSDATE BETWEEN nvl(frv.start_date,sysdate) AND nvl(frv.end_date,sysdate) -- RESPONSIBILITY ACTIVE CONDITION
order by fu.user_name,frv.responsibility_name
;