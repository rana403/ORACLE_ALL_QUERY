/***************************************************
GET NAME POSITION FOR REQUISITION V2
******************************************************/

select MIN(SEQUENCE_NUM),OBJECT_ID,
PA.ACTION_CODE,
XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)||chr(10)||'Date: '||TO_CHAR(MIN(ACTION_DATE),'DD-MON-RRRR') NAME_POS
from PO_ACTION_HISTORY PA
WHERE PA.ACTION_CODE IS NOT NULL
AND OBJECT_TYPE_CODE='REQUISITION'
AND UPPER(ACTION_CODE) IN ('SUBMIT','APPROVE','FORWARD')
AND OBJECT_ID=1421811
GROUP BY EMPLOYEE_ID,OBJECT_ID,XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID),CREATION_DATE,PA.ACTION_CODE
ORDER BY MIN(SEQUENCE_NUM) ASC

/***************************************************
GET NAME POSITION FOR REQUISITION V1
******************************************************/
select MIN(SEQUENCE_NUM),OBJECT_ID,
PA.ACTION_CODE,
XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)||chr(10)||'Date: '||TO_CHAR(MIN(ACTION_DATE),'DD-MON-RRRR') NAME_POS
from PO_ACTION_HISTORY PA
WHERE PA.ACTION_CODE IS NOT NULL
AND OBJECT_TYPE_CODE='REQUISITION'
AND UPPER(ACTION_CODE) IN ('SUBMIT','APPROVE','FORWARD')
AND OBJECT_ID=1421811
GROUP BY EMPLOYEE_ID,OBJECT_ID,XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID),CREATION_DATE,PA.ACTION_CODE
ORDER BY CREATION_DATE DESC--MIN(SEQUENCE_NUM) ASC

/***************************************************
GET NAME POSITION FOR REQUISITION MAIN
******************************************************/
select MIN(SEQUENCE_NUM),OBJECT_ID, XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)||chr(10)||'Date: '||TO_CHAR(MIN(ACTION_DATE),'DD-MON-RRRR') NAME_POS
from PO_ACTION_HISTORY PA
WHERE PA.ACTION_CODE IS NOT NULL
AND OBJECT_TYPE_CODE='REQUISITION'
AND UPPER(ACTION_CODE) IN ('SUBMIT','APPROVE','FORWARD')
AND OBJECT_ID=1421811
GROUP BY EMPLOYEE_ID,OBJECT_ID,XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)
ORDER BY MIN(SEQUENCE_NUM) ASC


SELECT * FROM PO_ACTION_HISTORY PA
/***************************************************
-- APPROVAL PATH NAME  For Requisition 
/**************************************************/

select DISTINCT (select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID) HIERARCHY_NAME, PHA.SEGMENT1 REQ_NUMBER, OBJECT_ID,FIRST_NAME,OBJECT_TYPE_CODE, OBJECT_SUB_TYPE_CODE,pah.LAST_UPDATE_DATE, pah.CREATION_DATE, pah.CREATED_BY, XX_GET_EMP_NAME_FROM_USER_ID (PAH.CREATED_BY) CREATED_BY, ACTION_CODE, ACTION_DATE,
FULL_NAME, EMPLOYEE_NUMBER, AUTHORIZATION_STATUS, WF_ITEM_TYPE, WF_ITEM_KEY
FROM po_action_history pah,per_all_people_f papf,po_requisition_headers_all pha
where pah.employee_id = papf.person_id AND pah.object_id = pha.requisition_header_id
AND FIRST_NAME = 'KG-4079' 
--AND (select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID)  ='KBIL REQUISITION APPROVAL'
--AND ORG_ID=104
--and SEGMENT1 =10005935 






--- GET APPROVAL PATH FROM BACKEND FOR PO ------------------------

select OBJECT_TYPE_CODE, OBJECT_SUB_TYPE_CODE,pah.LAST_UPDATE_DATE, pah.CREATION_DATE, pah.CREATED_BY, XX_GET_EMP_NAME_FROM_USER_ID (PAH.CREATED_BY) CREATED_BY, ACTION_CODE, ACTION_DATE,
(select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID) HIERARCHY_NAME, FULL_NAME, EMPLOYEE_NUMBER, AUTHORIZATION_STATUS, COMMENTS, WF_ITEM_TYPE, WF_ITEM_KEY
FROM po_action_history pah,per_all_people_f papf,po_headers_all pha
where pah.employee_id = papf.person_id AND pah.object_id = pha.po_header_id
--AND ORG_ID=107
--and SEGMENT1 = :PO_Number
and (select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID)  like '%IMPORT%' 


SELECT  *  FROM per_position_structures where name  like '%KOL%IMPORT%'  --POSITION_STRUCTURE_ID =  4070  --attribute1=81

select * from PER_ALL_POSITIONS where POSITION_ID IN (1361,
1317,
2595,
5464,
6963,
6983,
8486)
  --where name LIKE '%201.Information Communication%Technology.ERP.Assistant Manager.No'

 select * from per_positions 


select * from per_pos_structure_elements

select * from per_pos_structure_elements_v where PARENT_POSITION_ID = 2417

SELECT * FROM PER_POS_STRUCTURE_ELEMENTS  where POS_STRUCTURE_VERSION_ID = 25069

SELECT * FROM PER_POSITION_STRUCTURES where NAME  = 'KSPL BRAND PO APPROVAL'  -- POSITION_STRUCTURE_ID

SELECT DISTINCT A.NAME APPROVAL_PATH_NAME,A.ATTRIBUTE1 OU,C.NAME POSITION_NAME
--(SELECT DISTINCT FIRST_NAME FROM per_all_people_f WHERE PERSON_ID=D.PERSON_ID and sysdate between effective_start_date and effective_end_date and  D.primary_flag = 'Y'
--AND SYSDATE BETWEEN d.effective_start_date AND d.effective_end_date
--) KG
 FROM PER_POSITION_STRUCTURES A, PER_POS_STRUCTURE_ELEMENTS B,hr_all_positions_f_tl C, per_all_assignments_f D
WHERE A.POSITION_STRUCTURE_ID=B.POS_STRUCTURE_VERSION_ID 
--and a.NAME  = 'KPPL_PO_APPROVAL'
AND B.SUBORDINATE_POSITION_ID=C.POSITION_ID
AND C.POSITION_ID=D.POSITION_ID
AND B.SUBORDINATE_POSITION_ID=D.POSITION_ID
AND C.NAME  LIKE  '%102.Transport Operation.Transport Operation.Supervisor.No%'

--======================
-- GET NAME WITH KG_ID
--======================
SELECT lpad('->',8*(level-1)) ||
( select distinct full_name from per_all_people_f
where person_id = paf.person_id
and sysdate between effective_start_date and effective_end_date ) TREE, position_id,GET_POS_NAME_FROM_ID(POSITION_ID) POSITION_NAME,
GET_EMP_NAME_FROM_PERSON_ID(PERSON_ID) EMPLOYEE_NAME
FROM per_all_assignments_f paf
WHERE paf.person_id =225
AND paf.primary_flag = 'Y'
AND SYSDATE BETWEEN paf.effective_start_date AND paf.effective_end_date
CONNECT BY paf.person_id = PRIOR paf.supervisor_id
AND paf.primary_flag = 'Y'
AND SYSDATE BETWEEN paf.effective_start_date AND  paf.effective_end_date



KG-3023


SELECT * FROM per_all_assignments_f where PERSON_ID =225

SELECT  *  FROM hr_all_positions_f_tl where name='102.Transport Operation.Transport Operation.Supervisor.No'

SELECT * FROM per_all_people_f where  FIRST_NAME IN (
'KG-3023',
'KG-6673',
'KG-6230',
'KG-6229',
'KG-4654',
'KG-4048',
'KG-4718'
)



SELECT * FROM PER_ALL_PEOPLE_F WHERE FIRST_NAME = 'KG-4079'

--============== GET APPROBVAL PATH DETAILS WITH PO ===================================

SELECT * FROM HR_OPERATING_UNITS

SELECT DISTINCT
pah.object_id,
SUBSTR(XX_GET_HR_OPERATING_UNIT (PHA.ORG_ID),5) OPERATING_UNIT,
PHA.ORG_ID OU,
pha.segment1 AS PO_NUMBER,
pah.Action_Code,
pah.Action_Date,
 XX_GET_EMP_NAME_FROM_USER_ID (PHA.CREATED_BY) CREATED_BY,
--pha.created_by,
papf.full_name AS Approved_by,
pah.Note,
pha.amount_limit,
pha.currency_code,
pha.rate,
pha.blanket_total_amount,
(pha.rate * pha.blanket_total_amount) AS BLANKET_TOTAL_AMOUNT_CAD,
abc.second_sign,
pah.object_revision_num AS Revision_Number
FROM po_action_history pah,
per_all_people_f papf,
po_headers_all pha,
( SELECT object_id,
Action_Code,
object_revision_num,
CASE WHEN COUNT (Action_Code) <= 1 THEN 'N' ELSE 'Y' END
AS SECOND_SIGN
FROM po_action_history
WHERE 1 = 1
AND Action_Code = 'FORWARD'
--AND object_sub_type_code = 'BLANKET'
GROUP BY object_id, Action_Code, object_revision_num
HAVING COUNT (Action_Code) > 0) abc
WHERE 1=1
--and pah.action_code = 'APPROVE'
AND pah.employee_id = papf.person_id
AND pah.object_id = pha.po_header_id
AND pah.object_id = abc.object_id
AND pah.object_revision_num = abc.object_revision_num
-- AND pha.segment1 = 10000174
-- and PHA.ORG_ID= 81
--AND pha.segment1 = 'XX_PO_NUMBER' -- PO Number
--AND pah.object_sub_type_code = 'BLANKET'
ORDER BY pha.segment1 ASC, pah.object_revision_num



SELECT ORGANIZATION_ID , NAME FROM HR_OPERATING_UNITS

SELECT * FROM per_position_structures where name like '%CCM%'

/***************************************************************
-- GET APPROVAL PATH NAME FOR ALL PR AND PO
***************************************************************/

SELECT * FROM per_position_structures pos  WHERE NAME LIKE '%BRAND%'  --- wf_item_attribute_values av   --, per_position_structures pos

----------------------------------------------
-- APPROVAL PATH NAME  For PO
-----------------------------------------------
select * from HR_OPERATING_UNITS

SELECT ATTRIBUTE1 OPERATING_UNIT , NAME APPROVAL_PATH_NAME   FROM  per_position_structures 
where 1=1
and ATTRIBUTE1 = 81  -- 81 ORG_ID

SELECT ATTRIBUTE1 OPERATING_UNIT , NAME APPROVAL_PATH_NAME   FROM  per_position_structures 
where 1=1
and ATTRIBUTE1 = 107  -- 81 ORG_ID


select * from PO_REQUISITION_HEADERS_ALL

select * from per_position_structures

select * from wf_item_attribute_values

-- APPROVAL PATH NAME  For Purchase Order
select distinct pos.name
from po_headers_all poh, wf_item_attribute_values av, per_position_structures pos
where av.item_type = poh.wf_item_type
and av.item_key = poh.wf_item_key
and av.name = 'APPROVAL_PATH_ID'
and to_number(av.NUMBER_VALUE) = pos.position_structure_id
and poh.org_id = 81
and pos.name LIKE  '%BR%'
--and poh.po_header_id = 1324;  

--==============================
/*Koronar karone selim sir kisu din office korte paren ni, sei somoe sir er id te je PR, IR ashse segulo query kore ber koresi ei query er modhe*/

select poh.org_id, substr(XX_GET_HR_OPERATING_UNIT(poh.org_id),5) , poh.AUTHORIZATION_STATUS Apprival_status,poh.TYPE_LOOKUP_CODE ,
 poh.SEGMENT1, pol.ITEM_DESCRIPTION, pol.UNIT_MEAS_LOOKUP_CODE,pol.QUANTITY  from po_REQUISITION_HEADERS_ALL  poh, po_REQUISITION_LINES_ALL pol
where poh.REQUISITION_HEADER_ID = pol.REQUISITION_HEADER_ID
--and poh.CREATION_DATE  between '20-AUG-2020' and '25-AUG-2020' 
and  poh.AUTHORIZATION_STATUS = 'IN PROCESS'


--approver hisabe sarwar sir jotogulo pr ir approve korse anbong selim sir er kase forward korsen  segulo date range er modhe kotogulo sir er kase ase segulo dekhabe
select MIN(SEQUENCE_NUM),OBJECT_ID, XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)||chr(10)||'Date: '||TO_CHAR(MIN(ACTION_DATE),'DD-MON-RRRR') NAME_POS, EMPLOYEE_ID
from PO_ACTION_HISTORY PA
WHERE PA.ACTION_CODE IS NOT NULL
AND OBJECT_TYPE_CODE='REQUISITION'
AND UPPER(ACTION_CODE)='APPROVE' -- IN ('SUBMIT','APPROVE','FORWARD')
and ACTION_DATE between '22-AUG-2020' and '25-AUG-2020'
  -- and employee_id=101   -- Selim Sir
   and employee_id=1204  -- Sorwar Sir
--AND OBJECT_ID=467016
GROUP BY EMPLOYEE_ID,OBJECT_ID,XX_P2P_EMP_INFO.GET_EMPNP_EMP_ID(ACTION_DATE,EMPLOYEE_ID)
ORDER BY MIN(SEQUENCE_NUM) ASC







--====================================================================================================== 





 