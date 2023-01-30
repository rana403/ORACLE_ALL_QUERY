--***************************************
--GET USER NAME FROM KG-ID
--*****************************************
SELECT PAPF.LAST_NAME   ,PAPF.FULL_NAME , PAPF.EMPLOYEE_NUMBER, PAPF.PERSON_ID
FROM PER_ALL_PEOPLE_F PAPF,
PER_ALL_ASSIGNMENTS_F PAAF,
HR_ALL_ORGANIZATION_UNITS_TL HAO,
FND_USER FU
WHERE PAPF.PERSON_ID=PAAF.PERSON_ID
AND PAAF.ORGANIZATION_ID=HAO.ORGANIZATION_ID
AND FU.EMPLOYEE_ID=PAPF.PERSON_ID
AND FU.EMPLOYEE_ID=PAAF.PERSON_ID
AND FU.PERSON_PARTY_ID=PAPF.PARTY_ID
AND TRUNC(SYSDATE) BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
AND TRUNC(SYSDATE) BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE
AND FU.USER_NAME='KG-3297'

select * from FND_DOC_SEQUENCE_ASSIGNMENTS where 


select * from HR_OPERATING_UNITS

-- XX_ONT_GET_ENAME(:P_USER)  
----------------------------

SELECT * FROM FND_USER FU  --KG-6866

select * from PER_ALL_ASSIGNMENTS_F



CREATE OR REPLACE FUNCTION APPS.XX_ONT_GET_ENAME(P_PERSON_ID IN VARCHAR2)
RETURN CHAR
IS
V_ENAME VARCHAR2(200);
BEGIN
SELECT PAPF.LAST_NAME   -- PAPF.FULL_NAME 
INTO V_ENAME  
FROM PER_ALL_PEOPLE_F PAPF,
PER_ALL_ASSIGNMENTS_F PAAF,
HR_ALL_ORGANIZATION_UNITS_TL HAO,
FND_USER FU
WHERE PAPF.PERSON_ID=PAAF.PERSON_ID
AND PAAF.ORGANIZATION_ID=HAO.ORGANIZATION_ID
AND FU.EMPLOYEE_ID=PAPF.PERSON_ID
AND FU.EMPLOYEE_ID=PAAF.PERSON_ID
AND FU.PERSON_PARTY_ID=PAPF.PARTY_ID
AND TRUNC(SYSDATE) BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
AND TRUNC(SYSDATE) BETWEEN PAAF.EFFECTIVE_START_DATE AND PAAF.EFFECTIVE_END_DATE
AND FU.USER_ID=P_PERSON_ID;
RETURN(V_ENAME);
EXCEPTION WHEN OTHERS THEN
RETURN(NULL);
END;
/




 
  --=======================================
  --  USER NAME WISE RESPONSIBILITY FOR MAMUN BOS (ACTIVE AND INACTIVE )
  --======================================

 SELECT fuser.user_name "User Name", papf.FULL_NAME, pjobs.name POSITION ,frg.request_group_name, (CASE WHEN FU.END_DATE IS NULL THEN 'Active_User' else 'Inactive_User' End) User_Status,
-- (SELECT    NVL(FULL_NAME, NULL) FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = fuser.user_name ) FULL_NAME, 5,392
       frt.responsibility_name     "Responsibility Name"
--       furgd.start_date            Start Date,
--       furgd.end_date              End Date
     --  fresp.responsibility_key    Responsibility Key,
     --  fapp.application_short_name Application Short Name
  FROM fnd_user_resp_groups_direct furgd, FND_USER FU,
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
 AND FU.USER_ID=furgd.USER_ID
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
  -- AND frt.responsibility_name = P_responsibility_name    -- Purchasing Manager, 100-Steel
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
--AND (furgd.end_date IS NULL OR furgd.end_date = TRUNC(SYSDATE))
 ORDER BY frt.responsibility_name

 select * from fnd_user_resp_groups_direct