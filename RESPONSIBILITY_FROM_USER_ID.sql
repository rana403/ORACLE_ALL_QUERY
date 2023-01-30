-- GET ALL UNIQUE RESPONSIBILITY
--==========================

   select distinct RESPONSIBILITY_KEY, RESPONSIBILITY_NAME  from fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%'
   
   --=====================================================
 -- GET ALL UNIQUE RESPONSIBILITY for (101,102,103,104,105,106,201,202,203,401)
--=====================================================

   select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%101%' 
union all
   select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%102%' 
   union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%103%' 
       union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%104%' 
       union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%105%' 
       union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%106%' 
       union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%201%' 
       union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%202%' 
       union all
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%203%' 
       union all
       
    select * from  fnd_responsibility_vl fr where RESPONSIBILITY_KEY like '%XX%' and RESPONSIBILITY_NAME like '%LCM%100%' 
    
    

 --===================================================================
-- GET RESPONSIBILITY_NAME, MENU_NAME, FUNCTION_PROMPT_NAME, FUNCTION_NAME
--====================================================================

SELECT distinct fr.responsibility_name,
       fm.user_menu_name,
       fme.prompt prompt_name,
       fff.user_function_name
FROM   apps.fnd_menu_entries_vl fme,
       apps.fnd_menus_vl fm,
       apps.fnd_form_functions_vl fff,
       apps.fnd_form_vl ff,
       apps.fnd_responsibility_vl fr
WHERE  1 = 1
--AND    ff.form_name = 'formnamewithextension' 
AND    fme.function_id = fff.function_id
AND    fm.menu_id = fme.menu_id
AND    fr.menu_id = fm.menu_id
AND fr.responsibility_name= 'Purchasing Manager, 101-Sadarghat Lighter Jetty'
 
 --=============================================================
 -- GET ALL RESPONSIBILITY FROM USER ID
 --===============================================================
 
 
 SELECT fu.user_name                "User Name",
       frt.responsibility_name     "Responsibility Name",
       furg.start_date             "Start Date",
       furg.end_date               "End Date",      
       fr.responsibility_key       "Responsibility Key",
      --    fa.application_short_id   "Application Short ID",
       fa.application_short_name   "Application Short Name"
  FROM fnd_user_resp_groups_direct        furg,
       applsys.fnd_user                   fu,
       applsys.fnd_responsibility_tl      frt,
       applsys.fnd_responsibility         fr,
       applsys.fnd_application_tl         fat,
       applsys.fnd_application            fa
 WHERE furg.user_id             =  fu.user_id
   AND furg.responsibility_id   =  frt.responsibility_id
   AND fr.responsibility_id     =  frt.responsibility_id
   AND fa.application_id        =  fat.application_id
   AND fr.application_id        =  fat.application_id
   AND frt.language             =  USERENV('LANG')
   AND UPPER(fu.user_name)      =  UPPER('KG-4079')  -- <change it>
   -- AND (furg.end_date IS NULL OR furg.end_date >= TRUNC(SYSDATE))
 ORDER BY frt.responsibility_name;
 
 -- ***************************************************
 --GET ALL UNIQUE USERS
 --****************************************************

 SELECT distinct fuser.user_name "User Name"  ,papf.FULL_NAME , pjobs.name POSITION -- ,frg.request_group_name,
-- (SELECT    NVL(FULL_NAME, NULL) FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = fuser.user_name ) FULL_NAME, 5,392
     --  frt.responsibility_name     "Responsibility Name",  (CASE WHEN FU.END_DATE IS NULL THEN 'Active User' else 'Inactive User' End) User_Status
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
 AND FU.END_DATE is   NULL  --- for showing Active user
 --and  PAPF.first_name= 'KG-4079'
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
 --ORDER BY frt.responsibility_name


select * from  per_all_people_f papf WHERE FIRST_NAME IN('KG-4079', 'KG-4078')

SELECT * FROM FND_USER WHERE USER_NAME IN('KG-4079', 'KG-4078')
 
  --=======================================
  -- USER NAME WISE RESPONSIBILITY FOR MAMUN BOS
  --======================================

 SELECT fuser.user_id, fuser.user_name "User Name", papf.FULL_NAME, pjobs.name POSITION ,frg.request_group_name,
-- (SELECT    NVL(FULL_NAME, NULL) FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = fuser.user_name ) FULL_NAME, 5,392
       frt.responsibility_name     "Responsibility Name",  (CASE WHEN FU.END_DATE IS NULL THEN 'Active User' else 'Inactive User' End) User_Status,fat.APPLICATION_NAME,
      XXGET_EMP_DEPT_NO(fuser.USER_ID) Department,
            (SELECT DISTINCT  END_DATE  FROM   FND_USER_RESP_GROUPS_DIRECT WHERE RESPONSIBILITY_ID = FURGD.RESPONSIBILITY_ID and  user_id=  fuser.user_id ) END_DATE
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
 AND FU.END_DATE is   NULL  --- for showing Active user
 --and  PAPF.first_name= 'KG-4079'
  -- AND frt.responsibility_name = P_responsibility_name    -- Purchasing Manager, 100-Steel
 -- AND fuser.user_name like '%SYSADMIN%'
  --AND frg.request_group_name like '%MIS%'
    AND fuser.user_name  IN('KG-6359')
  AND  (SELECT DISTINCT  END_DATE  FROM   FND_USER_RESP_GROUPS_DIRECT WHERE RESPONSIBILITY_ID = FURGD.RESPONSIBILITY_ID and  user_id=  fuser.user_id ) is null -- TO restrict whos responsibility is added but end dated
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


SELECT * FROM fnd_application 

SELECT * FROM fnd_application_tl 

SELECT * FROM FND_USER WHERE USER_NAME = 'KG-4078'


select * from  FND_USER_RESP_GROUPS_DIRECT where user_id=1243

SELECT * FROM fnd_user_resp_groups_direct WHERE USER_ID = 1277




