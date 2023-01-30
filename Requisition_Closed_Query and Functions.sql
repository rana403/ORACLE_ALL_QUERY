--========= PENDING PR QUERY:  TO GET PR APPROVED  But  not PO===   
 
SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE = 'KB1'

select * from HR_OPERATING_UNITS "", 



SELECT   (SUBSTR(XX_GET_HR_OPERATING_UNIT(PRH.ORG_ID),5)) OU, 
 PRH.AUTHORIZATION_STATUS,
PRH.REQUISITION_HEADER_ID REQ_HEADER_ID,
PRL.REQUISITION_LINE_ID REQ_LINE_ID,
(PRH.SEGMENT1) "PR NUMBER",
  TO_CHAR(TRUNC(prh.APPROVED_DATE),'DD-MON-RRRR') "PR Approved Date",
  PRL.CLOSED_CODE,
 PRL.QUANTITY, PRL.QUANTITY_DELIVERED,
 INVORG_NAME_FROM_ID (PRL.DESTINATION_ORGANIZATION_ID) ORG_NAME,
  (SELECT NAME FROM HR_ALL_ORGANIZATION_UNITS WHERE ORGANIZATION_ID=PRL.DESTINATION_ORGANIZATION_ID) DEST_ORG_NAME ,
 MY_PACKAGE.GET_DEPARTMENT_FRM_USERKG(PRL.TO_PERSON_ID) USER_DEPT,
 MY_PACKAGE.GET_DEPT_FROM_EMP_ID(PRL.TO_PERSON_ID) USER_NAME,
-- to_char(trunc(prh.creation_date) "CREATED ON",
-- trunc(prl.creation_date) "Line Creation Date" ,
--msi.segment1 "Item Num",
PRL.ITEM_DESCRIPTION "Description",
prl.quantity "Qty",
prl.attribute2 ORIGIN,prl.
attribute3 use_of_area, 
(to_date(SYSDATE, 'dd-mm-yy') - to_date(prh.APPROVED_DATE, 'dd-mm-yy')) Lead_time,
PPF1.FULL_NAME "PREPARER"
--XXKG_COM_PKG.GET_DEPT_NAME (prh.PREPARER_ID) Department
--ppf2.agent_name "BUYER"
FROM
PO.PO_REQUISITION_HEADERS_ALL PRH,
PO.PO_REQUISITION_LINES_ALL PRL,
APPS.PER_PEOPLE_F PPF1,
(SELECT DISTINCT AGENT_ID,AGENT_NAME FROM APPS.PO_AGENTS_V ) PPF2,
PO.PO_REQ_DISTRIBUTIONS_ALL PRD,
INV.MTL_SYSTEM_ITEMS_B MSI,
PO.PO_LINE_LOCATIONS_ALL PLL,
PO.PO_LINES_ALL PL,
PO.PO_HEADERS_ALL PH
WHERE
PRH.REQUISITION_HEADER_ID = PRL.REQUISITION_HEADER_ID
AND PRL.REQUISITION_LINE_ID = PRD.REQUISITION_LINE_ID
AND PPF1.PERSON_ID = PRH.PREPARER_ID
AND PRH.CREATION_DATE BETWEEN PPF1.EFFECTIVE_START_DATE AND PPF1.EFFECTIVE_END_DATE AND PPF2.AGENT_ID(+) = MSI.BUYER_ID
AND MSI.INVENTORY_ITEM_ID = PRL.ITEM_ID
AND MSI.ORGANIZATION_ID = PRL.DESTINATION_ORGANIZATION_ID
AND PLL.LINE_LOCATION_ID(+) = PRL.LINE_LOCATION_ID
AND PLL.PO_HEADER_ID = PH.PO_HEADER_ID(+)
AND PLL.PO_LINE_ID = PL.PO_LINE_ID(+)
AND PRH.AUTHORIZATION_STATUS = 'APPROVED'
AND PLL.LINE_LOCATION_ID IS NULL
AND PRL.CLOSED_CODE IS NULL
--AND PRL.MODIFIED_BY_AGENT_FLAG is not  null     --- MODIFIED GLAG Y line no need to cancel 
AND NVL(PRL.CANCEL_FLAG,'N') <> 'Y'
and MODIFIED_BY_AGENT_FLAG is null
AND PRH.TYPE_LOOKUP_CODE <> 'INTERNAL'         
--AND PRH.APPROVED_DATE  BETWEEN '01-JAN-21' AND  '31-AUG-21'
--AND PRH.ORG_ID =  :P_OU  
AND (:P_PRAPPROVE_FROM_DT IS NULL OR TRUNC(PRH.APPROVED_DATE) BETWEEN :P_PRAPPROVE_FROM_DT AND :P_PRAPPROVE_TO_DT) 
AND    (SELECT NAME FROM HR_ALL_ORGANIZATION_UNITS WHERE ORGANIZATION_ID=PRL.DESTINATION_ORGANIZATION_ID) NOT  LIKE '%Deep Sea%'
--AND   MY_PACKAGE.GET_DEPARTMENT_FRM_USERKG(PRL.TO_PERSON_ID) = 'Store'
--and prh.segment1 = 10000232
--ORDER BY prh.segment1
--and prh.segment1  IN(
--10002938,
--10002946,            
--10002973 ,                               
--10003633            
--)  --3823 -- 'Incomplete'
ORDER BY  PRH.SEGMENT1  --1,2 




--=========================================================================
 
SELECT * FROM HR_OPERATING_UNITS 

select* FROM PO_REQUISITION_HEADERS_ALL WHERE SEGMENT1= 10002946   and ORG_ID= 104

SELECT * FROM PO_REQUISITION_LINES_ALL WHERE REQUISITION_HEADER_ID =  1375142

SELECT * FROM po_headers_all WHERE segment1= 40000409 AND org_id= 102

SELECT * FROM po_lines_all where po_header_id= 868626 

select ATTRIBUTE1, ATTRIBUTE2  from PO_LINE_LOCATIONS_ALL where  ATTRIBUTE1= 1397622

select * from PO_DISTRIUTIONS_ALL WHERE 

SELECT * FROM PO_REQ_DISTRIBUTIONS_ALL


select * from po_distributions_all  


-- =============== PENDING PR CANCEL API . IT WILL CLOSE ALL PR LINES WHICH ARE NOT PO . PARAMETER: ORG_ID AND SEGMENT1 =====000======= 

DECLARE
X_req_control_error_rc  VARCHAR2 (500);
l_org_id NUMBER := :P_OU_ID ; -- Enter the Operating_Unit Here
cnt number := 0;

CURSOR C_REQ_CANCEL is

SELECT
prh.segment1 requisition_num,
prh.requisition_header_id,
prh.org_id,
prl.requisition_line_id,
prh.preparer_id,
prh.type_lookup_code,
pdt.document_type_code,
prh.authorization_status,
prl.line_location_id
FROM
apps.po_requisition_headers_all prh,
apps.po_requisition_lines_all prl,
apps.po_document_types_all pdt
WHERE 1 = 1
AND prh.org_id = l_org_id
AND pdt.document_type_code = 'REQUISITION'
AND prh.authorization_status = 'APPROVED'
AND prl.line_location_id is null
AND  MODIFIED_BY_AGENT_FLAG is null
AND PRH.TYPE_LOOKUP_CODE <> 'INTERNAL'    
AND NVL(PRL.CANCEL_FLAG,'N') <> 'Y'
AND prh.requisition_header_id = prl.requisition_header_id
AND prh.type_lookup_code = pdt.document_subtype
AND prh.org_id = pdt.org_id
and prh.segment1 IN(
10002938,
10002946,            
10002973 ,           
10002995,          
10003060,           
10003159,           
10003189,            
10003238,            
10003244,            
10003249 ,           
10003358  ,          
10003370,            
10003394,            
10003411,            
10003439,            
10003488 ,           
10003524,            
10003552,            
10003631,            
10003633 
);
--AND prh.segment1 = '10000201'; -- Enter The Requisition Number

BEGIN

fnd_global.apps_initialize (user_id => 2083,
resp_id => 20707,
resp_appl_id => 201);

mo_global.init ('PO');
mo_global.set_policy_context ('S', l_org_id);

FOR i IN C_REQ_CANCEL
LOOP
--dbms_output.put_line (' Calling po_reqs_control_sv.update_reqs_status to cancel the Requisition=>' i.requisition_num);
--dbms_output.put_line ('======================================================');
po_reqs_control_sv.update_reqs_status(
X_req_header_id => i.requisition_header_id
, X_req_line_id => i.requisition_line_id
, X_agent_id => i.preparer_id
, X_req_doc_type => i.document_type_code
, X_req_doc_subtype => i.type_lookup_code
, X_req_control_action => 'CANCEL'
, X_req_control_reason => 'MAIL FROM  Mr Abu Chowdhury FOR CANCEL  PR FROM 01-JAN-2021 TO 30-JUN-2021 ,Mail DATE: 30-OCT-2021 '
, X_req_action_date => SYSDATE
, X_encumbrance_flag => 'N'
, X_oe_installed_flag => 'Y'
, X_req_control_error_rc => X_req_control_error_rc);
--DBMS_OUTPUT.PUT_LINE ( 'Status Found:=>' X_req_control_error_rc);
--DBMS_OUTPUT.PUT_LINE ('Requisition Number cancelled is :=>' i.Requisition_num);
cnt := cnt+1;
END LOOP;
--DBMS_OUTPUT.PUT_LINE('Count is :=>' cnt);
END;

--===============================================================================================

--
----===================== UPDATE STATEMENT=====================
--
--
--UPDATE PO_REQUISITION_LINES_ALL 
--SET CANCEL_FLAG = 'Y'
--CLOSED_REASON = 'As per Mail from Abu Chowdhury (Dated on 19-MAR-2020)',
--CLOSED_DATE = TO_DATE('3/21/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
--WHERE 1=1
--and REQUISITION_HEADER_ID in
--(1213055,
--1205042,
--1203042,
--1227043
--)
--and LINE_LOCATION_ID is null
--AND QUANTITY_DELIVERED = 0
--and org_id=104
--
--
--
--
--
--
--
--
--
--
--
--UPDATE PO_REQUISITION_LINES_ALL 
--SET CLOSED_CODE = 'FINALLY CLOSED',
--CLOSED_REASON = 'As per Mail from Abu Chowdhury (Dated on 19-MAR-2020)',
--CLOSED_DATE = TO_DATE('3/21/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
--WHERE 1=1
--and REQUISITION_HEADER_ID in
--(1213055,
--1205042,
--1203042,
--1227043
--)
--and LINE_LOCATION_ID is null
--AND QUANTITY_DELIVERED = 0
--and org_id=104
--
--
