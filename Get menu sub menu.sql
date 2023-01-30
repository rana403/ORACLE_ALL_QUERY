--====================================================
 --to get the Menu and Submenu list against a responsibility
 
 --===============================================

SELECT FRV.responsibility_name,
  fm.menu_name,
  FMEV.ENTRY_SEQUENCE,
  FMEV.PROMPT,
  FMEV.DESCRIPTION,
  SUB_MENU_FMEV.USER_MENU_NAME SUB_MENU_NAME,
  SUB_MENU_FMEV.DESCRIPTION SUB_MENU_DESCRIPTION,
  FFFT.USER_FUNCTION_NAME,
  FMEV.GRANT_FLAG
FROM apps.FND_MENU_ENTRIES_VL FMEV,
  apps.FND_MENUS_TL SUB_MENU_FMEV,
  APPS.FND_FORM_FUNCTIONS_TL FFFT,
  apps.FND_RESPONSIBILITY_VL FRV,
  apps.fnd_menus fm
WHERE FRV.MENU_ID             = fm.menu_id
AND fm.menu_id                = FMEV.menu_id
AND SUB_MENU_FMEV.MENU_ID(+)  = FMEV.SUB_menu_id
AND SUB_MENU_FMEV.LANGUAGE(+) = 'US'
AND FFFT.FUNCTION_ID(+)       = FMEV.FUNCTION_ID
AND FFFT.LANGUAGE(+)          = 'US'
  AND FRV.responsibility_name   = 'Purchasing Manager, 101-KSPL'
ORDER BY FMEV.entry_sequence; 