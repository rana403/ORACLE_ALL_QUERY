
--=============================
SELECT frt.responsibility_id,
       frt.responsibility_name, 
       psp.security_profile_name,
       fnd_prof_opt.USER_PROFILE_OPTION_NAME,
       fnd_prof_v.profile_option_value
FROM   apps.fnd_profile_option_values fnd_prof_v,
       apps.FND_PROFILE_OPTIONS_VL fnd_prof_opt,
       apps.per_security_profiles psp,
       apps.fnd_responsibility fr,
       apps.fnd_responsibility_tl frt
 WHERE TO_CHAR (psp.security_profile_id) = fnd_prof_v.profile_option_value
   AND fr.responsibility_id = frt.responsibility_id
   AND fnd_prof_opt.profile_option_id = fnd_prof_v.profile_option_id
   AND frt.responsibility_name LIKE '%Requisition%User%'
   AND fnd_prof_v.level_value = fr.responsibility_id

--==========================
-- SQL TO FIND APPLICATION_ID
--==========================
SELECT P.APPLICATION_ID,
decode(P.STATUS, 'I', 'Yes', 'S', 'Shared', 'N', 'No', P.status) inst_status,
A.APPLICATION_SHORT_NAME
FROM     FND_PRODUCT_INSTALLATIONS P, FND_APPLICATION A
WHERE A.APPLICATION_ID=P.APPLICATION_ID


--=================================================
-- SQL QUERY TO FIND ALL PROFILE SET AT RESPONSIBILITY LEVEL
--=======================================================
SELECT distinct fpo.profile_option_name SHORT_NAME,
         fpot.user_profile_option_name NAME,
        frtl.responsibility_name,
         DECODE (fpov.level_id,
                 10001, 'Site',
                 10002, 'Application',
                 10003, 'Responsibility',
                 10004, 'User',
                 10005, 'Server',
                 'UnDef')
            LEVEL_SET,
         DECODE (TO_CHAR (fpov.level_id),
                 '10001', '',
                 '10002', fap.application_short_name,
                 '10003', frsp.responsibility_key,
                 '10005', fnod.node_name,
                 '10006', hou.name,
                 '10004', fu.user_name,
                 'UnDef')
            "CONTEXT",
         fpov.profile_option_value VALUE
    FROM fnd_profile_options fpo,
         fnd_profile_option_values fpov,
         fnd_profile_options_tl fpot,
         fnd_user fu,
         fnd_application fap,
         fnd_responsibility frsp,
         fnd_nodes fnod,
        fnd_responsibility_tl frtl,
         hr_operating_units hou
   WHERE     fpo.profile_option_id = fpov.profile_option_id(+)
         AND fpo.profile_option_name = fpot.profile_option_name
         AND fu.user_id(+) = fpov.level_value
         AND frsp.application_id(+) = fpov.level_value_application_id
         AND frsp.responsibility_id(+) = fpov.level_value
         AND fap.application_id(+) = fpov.level_value
         AND fnod.node_id(+) = fpov.level_value
         AND hou.organization_id(+) = fpov.level_value
             and fpot.language='US'
            and frtl.responsibility_id=frsp.responsibility_id
            and frtl.language ='US'
             and fpot.user_profile_option_name like '%MO: Security Profile%'
             AND          DECODE (TO_CHAR (fpov.level_id),
                 '10001', '',
                 '10002', fap.application_short_name,
                 '10003', frsp.responsibility_key,
                 '10005', fnod.node_name,
                 '10006', hou.name,
                 '10004', fu.user_name,
                 'UnDef')  = 'XX_PO_MANAGER_LIGHTER_SHIP'
          --  and frtl.responsibility_name  in ('Purchasing Manager, 101-Sadarghat Lighter Jetty')
        ORDER BY short_name