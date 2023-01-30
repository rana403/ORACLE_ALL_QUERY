--===========================================
-- KSRM VIEW APPS.XX_SALESREP_ROLE_TERRITORY_V1
--===========================================
DROP VIEW APPS.XX_SALESREP_ROLE_TERRITORY_V1;

/* Formatted on 6/6/2017 10:27:01 AM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW APPS.XX_SALESREP_ROLE_TERRITORY_V1
(
   RESOURCE_ID,
   RESOURCE_NUMBER,
   RESOURCE_NAME,
   SOURCE_NUMBER,
   SOURCE_NAME,
   SOURCE_JOB_TITLE,
   SOURCE_PHONE,
   CATEGORY,
   ROLE_CODE,
   ROLE_NAME,
   ROLE_DESC,
   SALESREP_ID,
   SALESREP_NUMBER,
   SALESREP_NAME,
   ORG_ID,
   TERRITORY_ID,
   COUNTRY,
   ZONE,
   REGION,
   AREA,
   TERRITORY,
   FUTURE1,
   FUTURE2,
   TERRITORY_NAME,
   PERSON_ID
)
AS
   SELECT s.RESOURCE_ID,
          S.RESOURCE_NUMBER,
          S.RESOURCE_NAME,
          S.SOURCE_NUMBER,
          S.SOURCE_NAME,
          S.SOURCE_JOB_TITLE,
          XX_SP_PHONE_NO (SOURCE_NUMBER) SOURCE_PHONE,
          s.category,
          RL.ROLE_CODE,
          RL.ROLE_NAME,
          RL.ROLE_DESC,
          SR.SALESREP_ID,
          SR.SALESREP_NUMBER,
          SR.NAME SALESREP_NAME,
          SR.ORG_ID,
          ST.TERRITORY_ID,
          tkfv.SEGMENT1 COUNTRY,
          tkfv.SEGMENT2 ZONE,
          tkfv.SEGMENT3 REGION,
          tkfv.SEGMENT4 AREA,
          tkfv.SEGMENT5 TERRITORY,
          tkfv.SEGMENT6 FUTURE1,
          tkfv.SEGMENT7 FUTURE2,
          tkfv.concatenated_segments territory_name,
          SR.PERSON_ID
     --st.ATTRIBUTE1 TERRITORY_PRODUCT
     /*XX_TERR_VALUE_SET_ID (1016228, tkfv.SEGMENT1) CNTRY_ID,
     XX_TERR_VALUE_SET_ID (1016376, tkfv.SEGMENT2) DIV_ID,
     XX_TERR_VALUE_SET_ID (1016378, tkfv.SEGMENT3) ZONE_ID,
     XX_TERR_VALUE_SET_ID (1016379, tkfv.SEGMENT4) AREA_ID*/
     FROM JTF_RS_DEFRESOURCES_VL s,
          jtf_rs_role_relations RR,
          jtf_rs_roles_vl RL,
          fnd_lookups lkp,
          JTF_RS_SALESREPS SR,
          ra_salesrep_territories st,
          ra_territories_kfv tkfv
    WHERE     s.resource_id = rr.role_resource_id
          AND RR.ROLE_ID = RL.ROLE_ID
          AND RR.DELETE_FLAG = 'N'
          AND RL.ROLE_TYPE_CODE = LKP.LOOKUP_CODE
          AND lkp.lookup_type = 'JTF_RS_ROLE_TYPE'
          AND S.RESOURCE_ID = SR.RESOURCE_ID
          --AND S.RESOURCE_NUMBER <> 10000                     --No Sales Credit
          AND SR.SALESREP_ID = ST.SALESREP_ID(+)
          AND ST.TERRITORY_ID = tkfv.TERRITORY_ID(+)
          --AND S.RESOURCE_NAME = 'Sapan Kumar,'
          AND TRUNC (SYSDATE) BETWEEN NVL (S.START_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
                                  AND NVL (S.END_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
          AND TRUNC (SYSDATE) BETWEEN NVL (RR.START_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
                                  AND NVL (RR.END_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
          AND TRUNC (SYSDATE) BETWEEN NVL (SR.START_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
                                  AND NVL (SR.END_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
          AND TRUNC (SYSDATE) BETWEEN NVL (ST.START_DATE_ACTIVE,
                                           TRUNC (SYSDATE))
                                  AND NVL (ST.END_DATE_ACTIVE,
                                           TRUNC (SYSDATE));
                                           
                                           
 -----------------------------------------------
 --KSRM VIEW APPS.XX_SALESREP_ROLE_TERRITORY_V1 er Function
 -----------------------------------------------
 
 CREATE OR REPLACE FUNCTION APPS.XX_SP_PHONE_NO (P_NUMBER IN VARCHAR)
      RETURN VARCHAR2
   IS
      V_PH VARCHAR2(100);
      BEGIN
SELECT ATTRIBUTE6
INTO V_PH
FROM PER_ALL_PEOPLE_F
WHERE EMPLOYEE_NUMBER=P_NUMBER
   AND SYSDATE BETWEEN effective_start_date AND effective_end_date;
      RETURN V_PH;
      EXCEPTION WHEN OTHERS THEN
      RETURN NULL;
   END;
/
