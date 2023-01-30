 SELECT RESPONSIBILITY_ID, responsibility_name ,
  request_group_name ,
  frg.description
   FROM fnd_request_groups frg,
  fnd_responsibility_vl frv
  WHERE frv.request_group_id = frg.request_group_id
  --AND request_group_name LIKE 'US SHRMS Reports % Processes'
 --AND responsibility_name LIKE '%Purchasing%Man%'
--AND responsibility_name LIKE '%OPM Financials%'
--AND responsibility_name LIKE '%LCM User, 103-KBIL%'
--and responsibility_name LIKE '%KSRM Reconciliation Responsibility%'
--and  responsibility_name LIKE  '%Zone%'
--and  responsibility_name LIKE  '%Product Development Security Manager%'
--and  responsibility_name LIKE  '%Financial Audit, Kabir Group%'
--and  responsibility_name LIKE '%KSBIL%'
and   responsibility_name like '%Audit%'
--AND  request_group_name like '%OPM GMF Request Group MIS%'



XX Purchase Requisition User
XX Purchase Req. Manager



XXKSRM Item Stock All

--======================================================================================================

select * from per_all_people_F where LAST_NAME like '%Tayef%'

XX Purchase Requisition User

select * from fnd_Concurrent_requests 


/*******************************************************************
GET ALL UNIQUE RESPONSIBILITY
********************************************************************/
SELECT * FROM  fnd_responsibility_vl frv where RESPONSIBILITY_NAME like '%Inventory%Admin%'



--========================================================================
--  GET HOW MANY REPORTS ARE ATTACHED IN A REQUEST GROUP
--========================================================================

SELECT distinct frv. responsibility_name , con_prog.user_concurrent_program_name, 
       DECODE(rgu.request_unit_type,
              'P', 'Program',
              'S', 'Set',
              rgu.request_unit_type)        "Type",
       cp.concurrent_program_name"CONCURRENT PROGRAM NAME",
       rg.request_group_name   ,
       appl_fat.application_name   "Application Name"
  FROM fnd_request_groups          rg,
       fnd_request_group_units     rgu,
       fnd_concurrent_programs     cp,
       fnd_concurrent_programs_tl  con_prog,
       fnd_application             appl_fa,
       fnd_application_tl          appl_fat,
        fnd_responsibility_vl frv
 WHERE 1=1
 AND  rg.request_group_id    =  rgu.request_group_id
 and   frv.request_group_id = rg.request_group_id
   AND rgu.request_unit_id  =  cp.concurrent_program_id
   AND cp.concurrent_program_id  =  con_prog.concurrent_program_id
   AND rg.application_id    =  appl_fat.application_id
   AND appl_fa.application_id         =  appl_fat.application_id
   --AND con_prog.user_concurrent_program_name  LIKE  '%GRN%LC%%' 
--   and    rg.request_group_name IN( 'XX General Ledger Manager') --
   --and    rg.request_group_name ='Cost Manager'
   --'%Create%Internal%' -- 'XXKSRM Customer Wise Cylinder Stock' -- 'XXKSRM Inter Company Receive'
   and   cp.concurrent_program_name like '%Admin%'
  
  
  --=======================================
  -- USER NAME WISE RESPONSIBILITY
  --=======================================

 SELECT fuser.user_name             "User Name",  frg.request_group_name,
 (SELECT DISTINCT   FULL_NAME FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = fuser.user_name ) FULL_NAME,
       frt.responsibility_name     "Responsibility Name",
       furgd.start_date            "Start Date",
       furgd.end_date              "End Date",
       fresp.responsibility_key    "Responsibility Key",
       fapp.application_short_name "Application Short Name"
  FROM fnd_user_resp_groups_direct furgd,
       fnd_user                    fuser,
       fnd_responsibility          fresp,
       fnd_request_groups frg,
       fnd_responsibility_tl       frt,
       fnd_application             fapp,
       fnd_application_tl          fat
 WHERE   fresp.request_group_id = frg.request_group_id
   AND furgd.user_id = fuser.user_id
   AND furgd.responsibility_id = frt.responsibility_id
   AND fresp.responsibility_id = frt.responsibility_id
   AND fapp.application_id = fat.application_id
   AND fresp.application_id = fat.application_id
   AND frt.responsibility_name ='Inventory Audit, Kabir Group' -- :P_responsibility_name    -- Purchasing Manager, 100-Steel
 -- AND fuser.user_name like '%KG-6578%'
--  AND frg.request_group_name like '%MIS%'
 --  AND fuser.user_name  IN('KG-6359')
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
 
 
 select * from PER_ALL_PEOPLE_F where first_name='KG-4079'
 
  --=======================================
  -- USER NAME WISE RESPONSIBILITY FOR MAMUN BOS
  --======================================

 SELECT fuser.user_name             "User Name", papf.FULL_NAME,
  pjobs.name "POSITION" ,
  frg.request_group_name,
-- (SELECT    NVL(FULL_NAME, NULL) FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = fuser.user_name ) FULL_NAME,
       frt.responsibility_name     "Responsibility Name",
      furgd.start_date            "Start Date",
      furgd.end_date              "End Date"
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
 and  PAPF.first_name= 'KG-3097'
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
 
 
 
 
 
 --====================================================================
 -- QUERY TO RETRIEVE THE USER CONCURRENT PROGRMS, RESPONSIBILITIES, MENUS, REQUEST GROUPS
 --====================================================================
 
SELECT DISTINCT  FRV.RESPONSIBILITY_NAME ,
          USR.USER_NAME ,
          EMP.FULL_NAME ,
          HRO.name ,
        --  FAT.APPLICATION_ID ,
          FAT.APPLICATION_NAME ,
        --  FCP.CONCURRENT_PROGRAM_ID ,
          FCP.CONCURRENT_PROGRAM_NAME ,
          FCPT.USER_CONCURRENT_PROGRAM_NAME ,
        --  FRV.RESPONSIBILITY_ID ,
          FRT.DESCRIPTION RESPONSIBILITY_DESC ,
        --  frg.REQUEST_GROUP_ID ,
          FRG.REQUEST_GROUP_NAME ,
          FRG.DESCRIPTION REQUEST_GROUP_DESCRIPTION ,
        --  FMT.MENU_ID ,
          FMT.USER_MENU_NAME ,
          FMT.DESCRIPTION MENU_DESCRIPTION
FROM
          FND_USER_RESP_GROUPS_ALL URGV ,
          FND_USER USR ,
          PER_ALL_PEOPLE_F EMP ,
          HR_ALL_ORGANIZATION_UNITS_TL HRO ,
          PER_ALL_ASSIGNMENTS_F HRA ,
          APPS.FND_REQUEST_GROUPS FRG ,
          APPS.FND_REQUEST_GROUP_UNITS FRGU ,
          APPS.FND_RESPONSIBILITY_VL FRV ,
          APPS.FND_RESPONSIBILITY_TL FRT ,
          APPS.FND_RESPONSIBILITY FRB ,
          APPS.fnd_menus_tl fmt ,
          APPS.FND_MENUS FMS ,
          APPS.FND_APPLICATION_TL FAT ,
          APPS.FND_APPLICATION FAL ,
          APPS.FND_CONCURRENT_PROGRAMS FCP ,
          APPS.FND_CONCURRENT_PROGRAMS_TL FCPT
WHERE     1 = 1
        AND URGV.RESPONSIBILITY_ID        = FRT.responsibility_id
        AND URGV.USER_ID                  = USR.USER_ID
        AND usr.employee_id               = emp.person_id
        AND usr.end_date                 IS NULL
        AND emp.person_id                 = hra.person_id
        AND HRO.ORGANIZATION_ID           = HRA.ORGANIZATION_ID
        AND HRA.ASSIGNMENT_STATUS_TYPE_ID = 1
        AND FRV.REQUEST_GROUP_ID          = FRG.REQUEST_GROUP_ID
        AND frgu.request_group_id         = frg.request_group_id
        AND FRV.RESPONSIBILITY_ID(+)      = FRB.RESPONSIBILITY_ID
        AND FRT.responsibility_id         = frb.responsibility_id
        AND FRB.MENU_ID                   = FMT.MENU_ID
        AND frb.menu_id                   = fms.menu_id
        AND fat.application_id            = fal.application_id
        AND fal.application_id            = frb.application_id
        AND frgu.request_unit_id          = fcp.concurrent_program_id
        AND FCP.CONCURRENT_PROGRAM_ID     = FCPT.CONCURRENT_PROGRAM_ID
      --  AND USR.USER_NAME LIKE '%KG-4079%'
        AND  FRV.RESPONSIBILITY_NAME like '%%KSBIL%'
        
        
--===================================
--CREATE / ADD A NEW USER FROM BACKEND
--=================================

 DECLARE
  v_user_name  VARCHAR2(30):=UPPER('MG-4079');
  v_password   VARCHAR2(30):='12345';
  v_session_id INTEGER     := USERENV('sessionid');
BEGIN
  fnd_user_pkg.createuser (
    x_user_name => v_user_name,
    x_owner => NULL,
    x_unencrypted_password => v_password,
    x_session_number => v_session_id,
    x_start_date => SYSDATE,
    x_end_date => NULL
  );
  COMMIT;
  DBMS_OUTPUT.put_line ('User:'||v_user_name||'Created Successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line ('Unable to create User due to'||SQLCODE||' '||SUBSTR(SQLERRM, 1, 100));
    ROLLBACK;
END;


 --=============================================================
 -- GET ALL RESPONSIBILITY FROM USER ID
 --===============================================================
 
 
 SELECT fu.user_name                "User Name",
       frt.responsibility_name     "Responsibility Name",
       furg.start_date             "Start Date",
       furg.end_date               "End Date",      
       fr.responsibility_key       "Responsibility Key",
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
   AND UPPER(fu.user_name)      =  UPPER('KG-6578')  -- <change it>
   -- AND (furg.end_date IS NULL OR furg.end_date >= TRUNC(SYSDATE))
 ORDER BY frt.responsibility_name

--===================================
-- ADD  NEW RESPONSIBILITY FROM BACKEND 
-- UPORER QUERY TA RUN KORE  USER ID, APPLICATION SHORT NAME , RESPONSIBILITY KEY BOSATE HOBE 
--=====================================

BEGIN
fnd_user_pkg.addresp ('MG-4079', --- USER ID KG-4079
'INV', --- APPLICATION SHORT NAME 
'XX_INV_ADMIN', --- RESPONSIBILITY KEY
'STANDARD', --- ALWAYS STANDERD
'Add Responsibility to USER using pl/sql',SYSDATE,SYSDATE + 100);
commit;
dbms_output.put_line('Responsibility Added Successfully');
exception
        WHEN others THEN
                dbms_output.put_line('Responsibility is not added due to ' || SQLCODE || substr(SQLERRM, 1, 100));
                ROLLBACK;
END;



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
