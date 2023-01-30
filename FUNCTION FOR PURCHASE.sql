/*<TOAD_FILE_CHUNK>*/
--===========================================
-- KSRM  FUNCTION FOR PURCHASE
--===========================================

CREATE OR REPLACE FUNCTION APPS.XX_30_DAYS_CONSUM_FN (P_PR_APP_DT IN DATE,P_ITEM IN  NUMBER,P_ORG IN NUMBER)
RETURN number IS
V_QTY number(10) :=0;
BEGIN
SELECT NVL(SUM(NVL(PRIMARY_QUANTITY,0)),0)  INTO V_QTY 
FROM MTL_MATERIAL_TRANSACTIONS
WHERE TRUNC(TRANSACTION_DATE) BETWEEN (TRUNC(P_PR_APP_DT)-30) AND TRUNC(P_PR_APP_DT)
AND INVENTORY_ITEM_ID=P_ITEM
AND ORGANIZATION_ID=P_ORG
AND TRANSACTION_ACTION_ID=1;
RETURN V_QTY;
EXCEPTION 
WHEN OTHERS THEN
RETURN 0;
END;
/


--==========================================================

CREATE OR REPLACE PACKAGE BODY APPS.XX_P2P_EMP_INFO 
AS
FUNCTION GET_EMPNP_EMP_ID(p_date_f date,P_Eid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_Eid
   AND  paaf.person_id=P_Eid
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2)||'.'||INITCAP(pd.segment3) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP_MAIL(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||'.'||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNPID_MAIL(p_date_f date,P_EMP_ID IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_EMP_ID
   AND  paaf.person_id=P_EMP_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_ONLY_EMPN(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name) EMP_NAME
       into v_emp_name
from   per_people_f ppf
where to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=p_uid;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION GET_FND_EMP(U_ID IN NUMBER)
   RETURN NUMBER
IS
   V_EMP_ID NUMBER;
BEGIN
   SELECT EMPLOYEE_ID
     INTO V_EMP_ID
     FROM FND_USER
    WHERE USER_ID = U_ID;
   RETURN (V_EMP_ID);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN (000000);
END;

FUNCTION XX_P2P_GET_DEPT(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_dept varchar2(200);
Begin
select DISTINCT pd.segment3
       into v_dept
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_dept);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;  
END XX_P2P_EMP_INFO;

/

/* ======================================
Function For HR and employeeInfo 
=========================================
*/

CREATE OR REPLACE PACKAGE BODY APPS.XX_P2P_EMP_INFO 
AS
FUNCTION GET_EMPNP_EMP_ID(p_date_f date,P_Eid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2)||'.'||INITCAP(pd.segment3) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_Eid
   AND  paaf.person_id=P_Eid
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2)||'.'||INITCAP(pd.segment3) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP_MAIL(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||'.'||INITCAP(pd.segment3)||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNPID_MAIL(p_date_f date,P_EMP_ID IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||'.'||INITCAP(pd.segment3)||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_EMP_ID
   AND  paaf.person_id=P_EMP_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_ONLY_EMPN(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name) EMP_NAME
       into v_emp_name
from   per_people_f ppf
where to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid);
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION GET_FND_EMP(U_ID IN NUMBER)
   RETURN NUMBER
IS
   V_EMP_ID NUMBER;
BEGIN
   SELECT EMPLOYEE_ID
     INTO V_EMP_ID
     FROM FND_USER
    WHERE USER_ID = U_ID;
   RETURN (V_EMP_ID);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN (000000);
END;

FUNCTION XX_P2P_GET_DEPT(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_dept varchar2(200);
Begin
select DISTINCT pd.segment3
       into v_dept
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_dept);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;  
END XX_P2P_EMP_INFO;
/

--=====================================================================================

CREATE OR REPLACE PACKAGE BODY APPS.XX_P2P_EMP_INFO 
AS
FUNCTION GET_EMPNP_EMP_ID(p_date_f date,P_Eid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_Eid
   AND  paaf.person_id=P_Eid
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2)||'.'||INITCAP(pd.segment3) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP_MAIL(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||'.'||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNPID_MAIL(p_date_f date,P_EMP_ID IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_EMP_ID
   AND  paaf.person_id=P_EMP_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_ONLY_EMPN(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name) EMP_NAME
       into v_emp_name
from   per_people_f ppf
where to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=p_uid;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION GET_FND_EMP(U_ID IN NUMBER)
   RETURN NUMBER
IS
   V_EMP_ID NUMBER;
BEGIN
   SELECT EMPLOYEE_ID
     INTO V_EMP_ID
     FROM FND_USER
    WHERE USER_ID = U_ID;
   RETURN (V_EMP_ID);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN (000000);
END;

FUNCTION XX_P2P_GET_DEPT(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_dept varchar2(200);
Begin
select DISTINCT pd.segment3
       into v_dept
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_dept);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;  
END XX_P2P_EMP_INFO;
/








/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE FUNCTION APPS.xx_pend_req_qty_fn(P_LINE_ID IN number)
RETURN number
IS
V_QTY number;
Begin
select NVL(SUM(NVL(QUANTITY,0)),0) into V_QTY
 from po_requisition_lines_all
 where nvl(reqs_in_pool_flag,'N')='N'
 AND REQUISITION_LINE_ID=P_LINE_ID;
 RETURN V_QTY;
EXCEPTION
WHEN OTHERS THEN
RETURN 0;
END;
/
--=========================================================================

--========================XX_P2P_EMP_INFO =====================================

CREATE OR REPLACE PACKAGE BODY APPS.XX_P2P_EMP_INFO 
AS
FUNCTION GET_EMPNP_EMP_ID(p_date_f date,P_Eid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_Eid
   AND  paaf.person_id=P_Eid
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name)||chr(10)||pd.segment1||'.'||INITCAP(pd.segment2)||'.'||INITCAP(pd.segment3) P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNP_MAIL(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||'.'||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(P_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_EMPNPID_MAIL(p_date_f date,P_EMP_ID IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select Initcap(ppf.first_name)||' '||Initcap(MIDDLE_NAMES)||' '||Initcap(last_name)||chr(10)||pd.segment1||'.'||Initcap(pd.segment2)||chr(10)||ppf.EMAIL_ADDRESS P_name
       into v_emp_name
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=P_EMP_ID
   AND  paaf.person_id=P_EMP_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION XX_P2P_GET_ONLY_EMPN(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_emp_name varchar2(200);
Begin
select INITCAP(ppf.first_name)||' '||INITCAP(MIDDLE_NAMES)||' '||INITCAP(last_name) EMP_NAME
       into v_emp_name
from   per_people_f ppf
where to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=p_uid;
   RETURN (v_emp_name);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;
FUNCTION GET_FND_EMP(U_ID IN NUMBER)
   RETURN NUMBER
IS
   V_EMP_ID NUMBER;
BEGIN
   SELECT EMPLOYEE_ID
     INTO V_EMP_ID
     FROM FND_USER
    WHERE USER_ID = U_ID;
   RETURN (V_EMP_ID);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN (000000);
END;

FUNCTION XX_P2P_GET_DEPT(p_date_f date,P_uid IN VARCHAR2)
 RETURN varchar2
IS
   v_dept varchar2(200);
Begin
select DISTINCT pd.segment3
       into v_dept
from   per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       PER_all_positions pp,
       PER_position_definitions pd
where  to_date(p_date_f) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND to_date(p_date_f) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND  ppf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND  paaf.person_id=XX_P2P_EMP_INFO.GET_fnd_emp(p_uid)
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   and pp.position_id=paaf.position_id
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID;
   RETURN (v_dept);
EXCEPTION
   WHEN others
   THEN
      RETURN (null);
END;  
END XX_P2P_EMP_INFO;
/




/*<TOAD_FILE_CHUNK>*/

CREATE OR REPLACE FUNCTION APPS.xx_last_po_info_fn(P_TYPE IN number,P_ITEM IN number,P_ORG IN number,P_DATE IN date)
RETURN VARCHAR2
IS
V_NO VARCHAR2(240 BYTE);
BEGIN
SELECT DECODE(P_TYPE,1,APPROVED_DATE,2,UNIT_PRICE,3,VENDOR_NAME,4,SEGMENT1,5,QUANTITY,NULL) LAST_INFO INTO V_NO
 FROM 
(SELECT TO_CHAR(POH.APPROVED_DATE,'DD-MON-RRRR') APPROVED_DATE,POL.UNIT_PRICE,AP.VENDOR_NAME,POH.SEGMENT1,POL.QUANTITY
FROM PO_HEADERS_ALL POH,
PO_LINES_ALL POL,
AP_SUPPLIERS AP
WHERE POH.PO_HEADER_ID=POL.PO_HEADER_ID
AND POH.VENDOR_ID=AP.VENDOR_ID
AND NVL(AUTHORIZATION_STATUS,'INCOMPLETE')='APPROVED'
AND NVL(POL.CANCEL_FLAG,'N')='N'
AND POL.ITEM_ID=P_ITEM
AND POH.ORG_ID=P_ORG
AND POH.APPROVED_DATE <= trunc(P_DATE)
ORDER BY APPROVED_DATE DESC)
WHERE rownum <2;
RETURN V_NO;
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/



/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE FUNCTION APPS.XX_GET_HR_OPERATING_UNIT (P_ORG_ID IN NUMBER)
      RETURN VARCHAR2
   IS
      V_UNIT_NAME   HR_OPERATING_UNITS.NAME%TYPE := '';

      CURSOR P_UNIT_CURSOR
      IS
         SELECT NAME
           FROM HR_OPERATING_UNITS
          WHERE ORGANIZATION_ID = P_ORG_ID;
   BEGIN
      OPEN P_UNIT_CURSOR;

      FETCH P_UNIT_CURSOR INTO V_UNIT_NAME;

      CLOSE P_UNIT_CURSOR;

      RETURN V_UNIT_NAME;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END;
/
