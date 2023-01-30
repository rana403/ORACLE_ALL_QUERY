--==============================================
--QUERY TO FIND THE SCHEDULED CONCURRENT PROGRAMS
--==============================================
SELECT   fcr.REQUEST_ID
        ,NVL(fcr.DESCRIPTION,CPT.USER_CONCURRENT_PROGRAM_NAME) CONCURRENT_PROGRAM_NAME
        ,SUBSTR (fcr.ARGUMENT_TEXT, 1, 30) ARGUMENT_TEXT
        ,USR.USER_NAME REQUESTED_BY
        ,RESPT.RESPONSIBILITY_NAME
        ,fcrc.DATE1 START_DATE
        ,fcrc.DATE2 END_DATE
        ,DECODE(fcrc.class_type,
              'P', 'Periodic',
              'S', 'On Specific Days',
              'X', 'Advanced',
              fcrc.CLASS_TYPE
             ) SCHEDULE_TYPE
        ,CASE
         when fcrc.class_type = 'P' then
            'Repeat every ' ||
             substr(fcrc.class_info, 1, instr(fcrc.class_info, ':') - 1) ||
             DECODE(SUBSTR(fcrc.CLASS_INFO, INSTR(fcrc.CLASS_INFO, ':', 1, 1) + 1, 1),
                   'N', ' minutes',
                   'M', ' months',
                   'H', ' hours',
                   'D', ' days') ||
             decode(substr(fcrc.class_info, instr(fcrc.class_info, ':', 1, 2) + 1, 1),
                  'S', ' from the start of the prior run',
                  'C', ' from the completion of the prior run')
         WHEN fcrc.CLASS_TYPE = 'S' THEN 
              DECODE(SUBSTR(fcrc.CLASS_INFO, 32, 1), '1', 'Last day of month ') ||
              decode(sign(to_number(substr(fcrc.class_info, 33))),
                    '1',  'Days of week: ' ||
                    decode(substr(fcrc.class_info, 33, 1), '1', 'Su ') ||
                    decode(substr(fcrc.class_info, 34, 1), '1', 'Mo ') ||
                    decode(substr(fcrc.class_info, 35, 1), '1', 'Tu ') ||
                    decode(substr(fcrc.class_info, 36, 1), '1', 'We ') ||
                    decode(substr(fcrc.class_info, 37, 1), '1', 'Th ') ||
                    decode(substr(fcrc.class_info, 38, 1), '1', 'Fr ') ||
                    DECODE(SUBSTR(fcrc.CLASS_INFO, 39, 1), '1', 'Sa '))
        END SCHEDULE,
        fcrc.CLASS_INFO "Class Info"
    FROM fnd_concurrent_requests fcr,
         fnd_concurrent_programs_tl cpt,
         fnd_responsibility_tl RESPT,
         fnd_conc_release_classes fcrc,
         fnd_user usr
   WHERE fcr.concurrent_program_id = cpt.concurrent_program_id
     AND fcr.program_application_id = cpt.application_id
     AND fcr.responsibility_id = respt.responsibility_id
     AND fcr.requested_by = usr.user_id
     AND fcr.STATUS_CODE IN ('Q','I')-- 'P'
    -- AND RESPT.RESPONSIBILITY_NAME = :RESPONSIBILITY_NAME
     AND fcr.RELEASE_CLASS_APP_ID = fcrc.APPLICATION_ID
     AND fcr.RELEASE_CLASS_ID = fcrc.RELEASE_CLASS_ID
     AND fcrc.CLASS_TYPE IS NOT NULL
    --AND fcr.concurrent_program_id = 36888
    --AND TRUNC (actual_start_date) >= TRUNC (SYSDATE) - 1
ORDER BY 1 DESC