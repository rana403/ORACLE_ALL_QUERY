--=======================================
-- GET EMPLOYEE NAME AND POSITIONS
--=======================================
select  distinct
         papf.employee_number,
         FU.USER_ID, -- CREATED BY 
         hapf.JOB_ID,
          paaf.POSITION_ID,
          Paaf.ASSIGNMENT_ID,
         PAPF.first_name,
         papf.full_name,
         hapf.NAME positions,
         paaf.ASS_ATTRIBUTE1 DFF
 from    per_all_assignments_f paaf,FND_USER FU,
         per_all_people_f papf,
         hr_all_positions_f hapf
 where   paaf.person_id = papf.person_id
  AND FU.USER_NAME=papf.FIRST_NAME
 and     paaf.POSITION_ID = hapf.POSITION_ID
 and     sysdate between papf.EFFECTIVE_START_DATE and  papf.EFFECTIVE_END_DATE
 and  PAPF.first_name IN ('KG-5845') 
 
 
 
select * from     hr_all_positions_f hapf

SELECT * FROM per_all_assignments_f paaf

SELECT * FROM FND_USER WHERE USER_ID= 1458 --USER_NAME IN ('KG-5298') 


select * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE = 'TRA'





--====================================
-- GET EMPLOYEE NAME AND DEPARTMENT
--=================================
select MIN(SEQUENCE_NUM),OBJECT_ID, XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)||chr(10)||'Date: '||TO_CHAR(MIN(ACTION_DATE),'DD-MON-RRRR') NAME_POS
from PO_ACTION_HISTORY PA
WHERE PA.ACTION_CODE IS NOT NULL
AND OBJECT_TYPE_CODE='REQUISITION'
AND UPPER(ACTION_CODE) IN ('SUBMIT','APPROVE','FORWARD')
--AND OBJECT_ID=467016
GROUP BY EMPLOYEE_ID,OBJECT_ID,XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)
ORDER BY MIN(SEQUENCE_NUM) ASC


--=================================
--QUERY TO GET Previous ALL EMPLOYEES Information 
--=================================
SELECT PAPF.PERSON_ID,
PAPF.FIRST_NAME AS FIRST_NAME,
PAPF.LAST_NAME AS LAST_NAME,
PAPF.EMPLOYEE_NUMBER AS EMPLOYEE_NUMBER,
TO_CHAR(PAPF.EFFECTIVE_START_DATE) AS EFFECTIVE_START_DATE,
TO_CHAR(PAPF.EFFECTIVE_END_DATE) AS EFFECTIVE_END_DATE,
PAPF.BUSINESS_GROUP_ID AS BUSINESS_GROUP_ID,
ppt.user_person_type
FROM
PER_ALL_PEOPLE_F PAPF,
hr.per_person_type_usages_f pptu,
hr.per_person_types ppt
WHERE --PAPF.business_group_id = :$PROFILE$.PER_BUSINESS_GROUP_ID
--and 
trunc(sysdate) between papf.effective_start_date and PAPF.EFFECTIVE_END_DATE
and papf.person_id = pptu.person_id
and pptu.effective_start_date between
papf.effective_start_date and papf.effective_end_date
and papf.person_type_id = pptu.person_type_id
and pptu.person_type_id = ppt.person_type_id
and papf.person_type_id = ppt.person_type_id
and papf.business_group_id = ppt.business_group_id
-- modify this according to your requirement
AND ppt.system_person_type in ('EMP','EMP_APL','EX_EMP') 

--=================================
--QUERY TO GET X EMPLOYEES
--=================================
SELECT PAAF.ASSIGNMENT_ID,PAPF.PERSON_ID AS PERSON_ID2,PAPF.FIRST_NAME AS FIRST_NAME,PAPF.LAST_NAME AS LAST_NAME,PAPF.EMAIL_ADDRESS AS EMAIL_ADDRESS,TO_CHAR(PPS.ACTUAL_TERMINATION_DATE) AS ACTUAL_TERMINATION_DATE,
TO_CHAR(PAPF.EFFECTIVE_START_DATE) AS EFFECTIVE_START_DATE,PAPF.EMPLOYEE_NUMBER AS EMPLOYEE_NUMBER,TO_CHAR(PAPF.EFFECTIVE_END_DATE) AS EFFECTIVE_END_DATE,
PAPF.BUSINESS_GROUP_ID AS BUSINESS_GROUP_ID,PAAF.SUPERVISOR_ID AS SUPERVISOR_ID ,PAPF.LAST_UPDATE_DATE papf_update_date,PAAF.LAST_UPDATE_DATE paaf_update_date,ppt.user_person_type
FROM
PER_ALL_PEOPLE_F PAPF,
PER_ALL_ASSIGNMENTS_F PAAF,
PER_PERIODS_OF_SERVICE PPS,
hr.per_person_type_usages_f pptu,
hr.per_person_types ppt
WHERE PAAF.PERSON_ID = PAPF.PERSON_ID
AND PAAF.PRIMARY_FLAG = 'Y'
--AND PAPF.CURRENT_EMPLOYEE_FLAG = 'Y'
and paaf.assignment_type != 'B' --conditional
and pptu.effective_start_date between
papf.effective_start_date and papf.effective_end_date
and papf.person_id = pptu.person_id
and papf.person_type_id = pptu.person_type_id
and pptu.person_type_id = ppt.person_type_id
and papf.person_type_id = ppt.person_type_id
and papf.business_group_id = ppt.business_group_id
AND PAAF.period_of_service_id = PPS.period_of_service_id
and papf.person_id = pps.person_id
AND (
(ppt.user_person_type like 'Ex-employee%'
and PPS.ACTUAL_TERMINATION_DATE between paaf.effective_start_date and PAAF.EFFECTIVE_END_DATE)
or
( ppt.user_person_type like 'Employee%'
and trunc(sysdate) between paaf.effective_start_date and PAAF.EFFECTIVE_END_DATE )
)
--AND (
--(ppt.user_person_type like 'Ex-employee%'
--and PPS.ACTUAL_TERMINATION_DATE between papf.effective_start_date and PAPF.EFFECTIVE_END_DATE)
--or
--(ppt.user_person_type like 'Employee%' and
--trunc(sysdate) between papf.effective_start_date and PAPF.EFFECTIVE_END_DATE )
--) 



 
  --=======================================
  -- USER NAME WISE RESPONSIBILITY FOR MAMUN BOS
  --======================================

 SELECT fuser.user_name             "User Name", papf.FULL_NAME, pjobs.name "POSITION" ,frg.request_group_name,
-- (SELECT    NVL(FULL_NAME, NULL) FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = fuser.user_name ) FULL_NAME,
       frt.responsibility_name     "Responsibility Name"
--       furgd.start_date            "Start Date",
--       furgd.end_date              "End Date"
     --  fresp.responsibility_key    "Responsibility Key",
     --  fapp.application_short_name "Application Short Name"
  FROM fnd_user_resp_groups_direct furgd,
       fnd_user                    fuser,
       fnd_responsibility          fresp,
       fnd_request_groups frg,
       fnd_responsibility_tl       frt,
       fnd_application             fapp,
       fnd_application_tl          fat,
       per_all_assignments_f paaf,
         per_all_people_f papf,
         hr_all_positions_f hapf,
         per_jobs pjobs
 WHERE  pjobs.job_id(+) = paaf.job_id
 AND fresp.request_group_id = frg.request_group_id
 AND  papf.FIRST_NAME = fuser.user_name
   AND furgd.user_id = fuser.user_id
   AND furgd.responsibility_id = frt.responsibility_id
   AND fresp.responsibility_id = frt.responsibility_id
   AND fapp.application_id = fat.application_id
   AND fresp.application_id = fat.application_id
   AND    paaf.person_id = papf.person_id
 and     paaf.POSITION_ID = hapf.POSITION_ID
 and     sysdate between papf.EFFECTIVE_START_DATE and papf.EFFECTIVE_END_DATE
 --and  PAPF.first_name= 'KG-2163'
  -- AND frt.responsibility_name = :P_responsibility_name    -- Purchasing Manager, 100-Steel
 -- AND fuser.user_name like '%SYSADMIN%'
  --AND frg.request_group_name like '%MGT%'
--   AND fuser.user_name  IN('KG-6820',
--'KG-2246',
--'KG-1291',
--'KG-1284',
--'KG-4356',
--'KG-4357',
--'KG-7334',
--'KG-6692',
--'KG-7333',
--'KG-3197',
--'KG-4358',
--'KG-2245')
--   AND frt.language = USERENV('LANG')
--   AND UPPER(fuser.user_name) = UPPER('Enter_User_Name')
--AND (furgd.end_date IS NULL OR furgd.end_date >= TRUNC(SYSDATE))
 ORDER BY frt.responsibility_name
 