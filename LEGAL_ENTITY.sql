SELECT
      DISTINCT  xep.legal_entity_id        "Legal Entity ID",
        xep.name                   "Legal Entity",
       hr_outl.name               "Organization Name"
     --  hr_outl.organization_id    "Organization ID",
     --  hr_loc.location_id         "Location ID",
     --  hr_loc.country             "Country Code",
   --    hr_loc.location_code       "Location Code"
     --  glev.flex_segment_value    "Company Code"
  FROM
       xle_entity_profiles            xep,
       xle_registrations              reg,
       hr_operating_units             hou,
       -- hr_all_organization_units      hr_ou,
       hr_all_organization_units_tl   hr_outl,
       hr_locations_all               hr_loc,
       gl_legal_entities_bsvs         glev
 WHERE
       1=1
   AND xep.transacting_entity_flag   =  'Y'
   AND xep.legal_entity_id           =  reg.source_id
   AND xep.legal_entity_id           =  hou.default_legal_context_id
   AND reg.location_id               =  hr_loc.location_id
   AND xep.legal_entity_id           =  glev.legal_entity_id
    --AND hr_ou.organization_id         =  hou.business_group_id
   AND hr_outl.organization_id       =  hou.organization_id
 ORDER BY hr_outl.name


--=============================================
SELECT
      DISTINCT  xep.legal_entity_id        "Legal Entity ID",
        xep.name                   "Legal Entity",
       hr_outl.name               "Organization Name"
     --  hr_outl.organization_id    "Organization ID",
     --  hr_loc.location_id         "Location ID",
     --  hr_loc.country             "Country Code",
   --    hr_loc.location_code       "Location Code"
     --  glev.flex_segment_value    "Company Code"
  FROM
       xle_entity_profiles            xep,
       xle_registrations              reg,
       --
       hr_operating_units             hou,
       -- hr_all_organization_units      hr_ou,
       hr_all_organization_units_tl   hr_outl,
       hr_locations_all               hr_loc,
       gl_legal_entities_bsvs         glev
 WHERE
       1=1
   AND xep.transacting_entity_flag   =  'Y'
   AND xep.legal_entity_id           =  reg.source_id
 --  AND reg.source_table              =  'XLE_ENTITY_PROFILES'
   --AND reg.identifying_flag          =  'Y'
   AND xep.legal_entity_id           =  hou.default_legal_context_id
   AND reg.location_id               =  hr_loc.location_id
   AND xep.legal_entity_id           =  glev.legal_entity_id
    --AND hr_ou.organization_id         =  hou.business_group_id
   AND hr_outl.organization_id       =  hou.organization_id
 ORDER BY hr_outl.name




--====================================
SELECT * FROM HR_OPERATING_UNITS


(SELECT DEFAULT_LEGAL_CONTEXT_ID, ORGANIZATION_ID,NAME FROM HR_OPERATING_UNITS) ORDER BY DEFAULT_LEGAL_CONTEXT_ID  

-- GET ALL BAL_SEG, BAL_SEG_NAME, LEDGER_ID, LEGAL_ENTITY_ID

select LEGAL_ENTITY_ID, BAL_SEG_NAME from XX_BAL_SEG_INFO 
ORDER BY LEGAL_ENTITY_ID 

--GET OU FROM INV_ORG
SELECT APPS.XX_GET_OU_NAME (121) OU FROM DUAL

--====================================

SELECT
       DISTINCT xep.name                   "Legal Entity",
       xep.legal_entity_id        "Legal Entity ID",
       hr_outl.name               "Organization Name",
       hr_outl.organization_id    "Organization ID",
       hr_loc.location_id         "Location ID",
       hr_loc.country             "Country Code",
       hr_loc.location_code       "Location Code"
     --  glev.flex_segment_value    "Company Code"
  FROM
       xle_entity_profiles            xep,
       xle_registrations              reg,
       --
       hr_operating_units             hou,
       -- hr_all_organization_units      hr_ou,
       hr_all_organization_units_tl   hr_outl,
       hr_locations_all               hr_loc,
       --
       gl_legal_entities_bsvs         glev
 WHERE
       1=1
   AND xep.transacting_entity_flag   =  'Y'
   AND xep.legal_entity_id           =  reg.source_id
   AND reg.source_table              =  'XLE_ENTITY_PROFILES'
   AND reg.identifying_flag          =  'Y'
   AND xep.legal_entity_id           =  hou.default_legal_context_id
   AND reg.location_id               =  hr_loc.location_id
   AND xep.legal_entity_id           =  glev.legal_entity_id
    --AND hr_ou.organization_id         =  hou.business_group_id
   AND hr_outl.organization_id       =  hou.organization_id
 ORDER BY hr_outl.name
 
 SELECT *  FROM GL_CODE_COMBINATIONS 
 
SELECT DISTINCT SEGMENT1 LEGAL_ENTITY_CODE,SEGMENT1||'-'||XX_GET_ACCT_FLEX_SEG_DESC (1, SEGMENT1) LEGAL_ENTITY_NAME FROM GL_CODE_COMBINATIONS

SELECT DISTINCT SEGMENT1 LEGAL_ENTITY_ID,SEGMENT1||'-'||XX_GET_ACCT_FLEX_SEG_DESC (1, SEGMENT1) LEGAL_ENTITY_NAME FROM GL_CODE_COMBINATIONS
 
 SELECT LEGAL_ENTITY_ID, NAME  FROM XLE_ENTITY_PROFILES ORDER BY LEGAL_ENTITY_ID
 
 SELECT * FROM XLE_ENTITY_PROFILES   XEP
 WHERE 1=1
 and LEGAL_ENTITY_ID = 26280
 ORDER BY LEGAL_ENTITY_IDENTIFIER
 
 select distinct LEGAL_ENTITY_ID from GL_ALOC_MST
 
 
 select  DISTINCT XEP.NAME  from GL_ALOC_MST GAM, xle_entity_profiles XEP
 WHERE GAM.LEGAL_ENTITY_ID = XEP.LEGAL_ENTITY_ID
 
 select * from hr_all_organization_units_tl 
 
 
 select * from   gl_legal_entities_bsvs   
 
 
-- CREATE OR REPLACE FUNCTION APPS.XX_GET_ACCT_FLEX_SEG_DESC (
--   P_SEQUENCE       IN NUMBER,
--   P_FLEX_CODE      IN VARCHAR2,
--   P_PARENT_VALUE      VARCHAR2 DEFAULT 'A')
--   RETURN VARCHAR2
--AS
--   V_DESCRIPTION   VARCHAR2 (240);
--   V_CODE VARCHAR2 (30);
--BEGIN
--   SELECT DESCRIPTION,FLEX_VALUE
--     INTO V_DESCRIPTION,V_CODE
--     FROM FND_FLEX_VALUES_VL
--    WHERE     FLEX_VALUE_SET_ID =
--                 DECODE (P_SEQUENCE,
--                         1, 1016487,
--                         2, 1016488,
--                         3, 1016489,
--                         4, 1016490,
--                         5, 1016491,
--                         6, 1016492,
--                         7, 1016493)
--          AND FLEX_VALUE = P_FLEX_CODE
--          AND NVL(PARENT_FLEX_VALUE_LOW,'A') =
--                 NVL (P_PARENT_VALUE, PARENT_FLEX_VALUE_LOW);
--   RETURN V_DESCRIPTION;
--EXCEPTION
--   WHEN OTHERS
--   THEN
--      RETURN P_FLEX_CODE;
--END XX_GET_ACCT_FLEX_SEG_DESC;
--/