--FET EMPLOYEE BRTH DAY
--============================

SELECT * FROM PER_BUSINESS_GROUPS

SELECT * FROM PER_JOBS

SELECT FIRST_NAME, LAST_NAME, FULL_NAME,TO_CHAR(TRUNC(DATE_OF_BIRTH),'DD-MON-RRRR') DATE_OF_BIRTH,CREATION_DATE
 FROM PER_ALL_PEOPLE_F ORDER BY CREATION_DATE

SELECT * FROM PER_ALL_PEOPLE_F WHERE  FIRST_NAME = 'KG-4078'

SELECT FULL_NAME, ATTRIBUTE2 BLAD_GROUP, ATTRIBUTE5 CONTACT_NUMBER , ATTRIBUTE13 ADDRESS   FROM PER_ALL_PEOPLE_F  WHERE ATTRIBUTE2 = 'A+' -- BLAD GROUP

SELECT * FROM PER_ALL_PEOPLE_F WHERE LAST_NAME LIKE '%Miraq%'

select * from PER_PEOPLE_F where PERSON_ID = 2415

SELECT * FROM PER_ALL_ASSIGNMENTS_F WHERE PERSON_ID = 226

SELECT * FROM HR_POSITIONS_F


SELECT ppf.full_name emp_name
      ,ppf1.full_name supervisor_name,ppf1.last_name
FROM per_all_people_f ppf
,per_all_assignments_f paaf
,per_all_people_f ppf1
WHERE 1=1
AND ppf.person_id=paaf.person_id
--AND ppf.employee_number IS NOT NULL
--AND ppf.person_id=968956
AND sysdate BETWEEN paaf.effective_start_date AND paaf.effective_end_date
--AND paaf.supervisor_id=ppf1.person_id
--AND ppf.person_id = :P_ID   --981
AND TRUNC(SYSDATE) BETWEEN TRUNC(PPF.effective_start_date) AND   TRUNC(NVL(PPF.effective_end_date,SYSDATE))
AND TRUNC(SYSDATE) BETWEEN TRUNC(PPF1.effective_start_date) AND  TRUNC(NVL(PPF1.effective_end_date,SYSDATE))
ORDER BY 1


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SELECT   SEGMENT1 REQUISITION_NUM, PHL.ITEM_DESCRIPTION,POAH.EMPLOYEE_ID, PAPF.FULL_NAME
   FROM   PO_ACTION_HISTORY POAH,
    PO_REQUISITION_HEADERS_ALL PHA,
    PO_REQUISITION_LINES_ALL PHL,
     PER_ALL_PEOPLE_F PAPF
  WHERE PHA.REQUISITION_HEADER_ID = PHL.REQUISITION_HEADER_ID  
  AND POAH.OBJECT_TYPE_CODE = 'REQUISITION'
    AND   POAH.OBJECT_SUB_TYPE_CODE = 'PURCHASE'
    AND   POAH.ACTION_CODE = 'APPROVE'
   and segment1 = '11610100166'      --'11610100586'
    --AND   PHA.REQUISITION_HEADER_ID = 477236
    AND   POAH.OBJECT_ID = PHA.REQUISITION_HEADER_ID
    AND   POAH.ACTION_DATE = ( SELECT MAX(ACTION_DATE) FROM PO_ACTION_HISTORY B
                               WHERE B.OBJECT_ID = POAH.OBJECT_ID
                               AND   B.ACTION_CODE = POAH.ACTION_CODE
                               AND   B.OBJECT_TYPE_CODE = POAH.OBJECT_TYPE_CODE
                               AND   B.OBJECT_SUB_TYPE_CODE = POAH.OBJECT_SUB_TYPE_CODE )
    AND   PAPF.PERSON_ID = POAH.EMPLOYEE_ID;
    

    
    -- ========================================================================================================
    
    
    SELECT distinct PAPF.FIRST_NAME ,pa.agent_id, papf.person_id, papf.employee_number, papf.email_address,
       pa.category_id, pa.location_id, papf.effective_start_date,
       papf.effective_end_date
  FROM po_agents pa, per_all_people_f papf, hr_all_organization_units haou
 WHERE pa.agent_id = papf.person_id
   AND papf.business_group_id = haou.business_group_id
   AND TRUNC (SYSDATE) BETWEEN papf.effective_start_date
                           AND papf.effective_end_date
                           and PAPF.FIRST_NAME= 'KG-4079'
--AND    email_address = 'user@oag.com'
--AND PAPF.EFFECTIVE_END_DATE > SYSDATE
--AND HAOU.BUSINESS_GROUP_ID = 100

--=====================================

select * from po_requisition_lines_all



select * from per_positions   
where POSITION_DEFINITION_ID = 13065

select * from per_all_people_f


select * from Per_position_definitions
where segment4 = 'ERP'
and segment5 = 'Asst Manager'
 
select * from per_jobs 

select * from per_job_definitions

select * from per_all_people_f ppf
where LAST_NAME like '%Sohel%'

Select * from per_all_assignments_f 

select* from per_positions

select* from per_position_definitions


--============================================
-- GET SALARY INFO
--=============================================
SELECT   ppt.user_person_type person_type, papf.full_name employee_name,
         papf.employee_number employee_number, pap.payroll_name, ppb.NAME pay,
         ppb.pay_basis
    FROM per_all_people_f papf,
         per_all_assignments_f paaf,
         per_person_types_tl ppt,
         per_pay_bases ppb,
         pay_all_payrolls_f pap
   WHERE papf.person_id = paaf.person_id
     AND paaf.primary_flag = 'Y'
     AND papf.current_employee_flag = 'Y'
     AND papf.business_group_id = paaf.business_group_id
     AND papf.person_type_id = ppt.person_type_id
     AND paaf.pay_basis_id = ppb.pay_basis_id
     -- AND PAPF.EMPLOYEE_NUMBER = '30987'
     AND paaf.payroll_id = pap.payroll_id
     AND TRUNC (SYSDATE) BETWEEN papf.effective_start_date
                             AND papf.effective_end_date
     AND TRUNC (SYSDATE) BETWEEN pap.effective_start_date
                             AND pap.effective_end_date
     AND TRUNC (SYSDATE) BETWEEN paaf.effective_start_date
                             AND paaf.effective_end_date
--   AND PAPF.FULL_NAME LIKE 'A%'
ORDER BY papf.full_name
