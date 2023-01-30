-- TO UNDERSTAND THE QUERY FOR VALU SET:  XX_DLV_SHIP_NAME
SELECT SHIP_NAME, SHIP_CODE ,SUBSTR(LOOKUP_TYPE,3,3)
FROM XX_ONT_SHIP_NAME_V
WHERE 
END_DATE_ACTIVE IS NULL
AND SUBSTR(LOOKUP_TYPE,3,3)='KLM'
AND ENABLED_FLAG = 'Y'
ORDER BY SHIP_NAME 




select * from XX_ONT_SHIP_NAME_V


  WHERE nvl(OU_ID,'all')=
  case 
   when ou_id = FND_GLOBAL.ORG_ID then ou_id else
   'all'
  end
  
 SELECT TAG FROM FND_LOOKUP_VALUES_VL
WHERE LOOKUP_TYPE='XX_OM_SD_TERRITORY'
AND LOOKUP_CODE IN (SELECT TAG FROM FND_LOOKUP_VALUES_VL
WHERE LOOKUP_TYPE='XX_OM_TER_THA'
AND MEANING=:$FLEX$.XX_OM_CD_THANA

SELECT SHIP_NAME FROM XX_ONT_SHIP_NAME_V 
WHERE LOOKUP_TYPE =(SELECT (
CASE WHEN XXKSRM_MO_ORG= 222 THEN LOOKUP_TYPE = 'XXKLO_SCRAP_SHIPNAME' 
          WHEN XXKSRM_MO_ORG=177 THEN LOOKUP_TYPE = 'XXKLM_SCRAP_SHIPNAME'
           WHEN XXKSRM_MO_ORG=179 THEN LOOKUP_TYPE= 'XXKWM_SCRAP_SHIPNAME'
           WHEN XXKSRM_MO_ORG=223 THEN LOOKUP_TYPE='XXKWN_SCRAP_SHIPNAME'
ELSE NULL END)
FROM XX_ONT_SHIP_NAME_V
) 
  
  
 select * from ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE= 'KWN'

--========================ERROR SOLVE For DFF ========================
--Oracle error 904: ORA-00904: : invalid identifier
--ORA-06512: at "SYSTEM.AD_DDL", line 160
--ORA-06512: at line 1 has been detected in afuddl() [3_xdd].
--do_ddl(APPLSYS, ...


--https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=104995728297785&id=751763.1&_afrWindowMode=0&_adf.ctrl-state=z8sru2ki6_4
--===============================================

SELECT f1.descriptive_flexfield_name dff_name,
       descriptive_flex_context_code dff_context,
       end_user_column_name dff_segment_name,
       application_column_name dff_column, form_left_prompt
  FROM apps.fnd_descr_flex_col_usage_vl f1, applsys.fnd_descriptive_flexs f2
 WHERE f2.concatenated_segs_view_name = 'PO_HEADERS_ALL_DFV' -- PO_LINES_ALL_DFV
   AND f1.application_id = f2.application_id
   AND f1.descriptive_flexfield_name = f2.descriptive_flexfield_name
   AND f1.enabled_flag = 'Y'
   AND EXISTS (SELECT 'x'
                 FROM v$reserved_words rw
                WHERE rw.keyword = UPPER (f1.end_user_column_name))
                
            
                       
 select * from PO_HEADERS_ALL_DFV WHERE CONTEXT ='Branding_Info' -- IS NOT NULL
                
 select * from PO_LINES_ALL_DFV WHERE CONTEXT IS NOT NULL