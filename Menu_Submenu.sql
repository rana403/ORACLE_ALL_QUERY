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
AND fr.responsibility_name= 'Payables User, Kabir Group'


--  GET MENU NAME FROM A RESPONSIBILITY 
SELECT DISTINCT a.responsibility_name, c.user_menu_name
FROM apps.fnd_responsibility_tl a,
apps.fnd_responsibility b,
apps.fnd_menus_tl c,
apps.fnd_menus d,
apps.fnd_application_tl e,
apps.fnd_application f
WHERE a.responsibility_id(+) = b.responsibility_id
AND a.RESPONSIBILITY_NAME = 'KSRM Reconciliation Responsibility'
AND b.menu_id = c.menu_id
AND b.menu_id = d.menu_id
AND e.application_id = f.application_id
AND f.application_id = b.application_id
AND a.LANGUAGE = 'US' 

-- TO GET MENU NAME FROM A RESPONSIBILITY  v1
SELECT * FROM FND_RESPONSIBILITY_TL
WHERE RESPONSIBILITY_NAME ='KSRM Reconciliation Responsibility'

--===============================================
--LIST OF FUNCTIONS EXCLUDED FROM A GIVEN RESPONSIBILITY:
--===============================================
SELECT FRV.RESPONSIBILITY_NAME,
 FFFV.USER_FUNCTION_NAME
 FROM FND_RESP_FUNCTIONS FRF,
 FND_FORM_FUNCTIONS_VL FFFV,
 FND_RESPONSIBILITY_VL FRV
WHERE 1=1
and  FRF.RULE_TYPE = 'F'
 AND FRF.ACTION_ID = FFFV.FUNCTION_ID
 AND FRF.RESPONSIBILITY_ID = FRV.RESPONSIBILITY_ID
 --and FRV.RESPONSIBILITY_NAME = 'Order Management User, 102-KSRM'
 AND FRV.RESPONSIBILITY_NAME LIKE '%KSRM%'





select * from FND_MENUS_VL

SELECT * FROM FND_MENUS

SELECT * FROM FND_MENUS_TL

SELECT * FROM FND_MENU_ENTRIES

SELECT * FROM FND_MENU_ENTRIES_TL



SELECT c.prompt, 
       c.description
FROM apps.fnd_menus_tl a, 
     fnd_menu_entries_tl c
WHERE a.menu_id = c.menu_id  
AND a.user_menu_name = 'OPMNINVREP_MENU'


select * from apps.fnd_responsibility_tl




