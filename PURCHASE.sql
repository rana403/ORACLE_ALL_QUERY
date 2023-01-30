--*********************************************
-- Import PO Rate problem after amendment
--*********************************************

SELECT * FROM PO_HEADERS_ALL WHERE SEGMENT1= 40000657 and ORG_ID=102

SELECT rate FROM PO_HEADERS_ALL WHERE SEGMENT1= 40000657 and ORG_ID=102


select rate_date, rate from PO_DISTRIBUTIONS_ALL
where po_header_id = 894638 and rate_date is not null and rate is not  null


select * from PER_ALL_PEOPLE_F WHERE FULL_NAME LIKE '%Tanvir%'

SELECT * FROM HR_OPERATING_UNITS



--TO UPDATE RATE OF THAT PO HEADER ID
--===============================

update PO_DISTRIBUTIONS_ALL
set rate=105
where po_header_id = 894638 and rate_date is not null and rate is null








--get LAST PO PRICE 
--=====================
SELECT TO_CHAR(POH.APPROVED_DATE,'DD-MON-RRRR') APPROVED_DATE,POH.ORG_ID,POL.UNIT_PRICE,AP.VENDOR_NAME,POH.SEGMENT1,POL.QUANTITY,TRUNC(POH.APPROVED_DATE) APP_DT
FROM PO_HEADERS_ALL POH,
PO_LINES_ALL POL,
AP_SUPPLIERS AP
WHERE POH.PO_HEADER_ID=POL.PO_HEADER_ID
AND POH.VENDOR_ID=AP.VENDOR_ID
--AND NVL(AUTHORIZATION_STATUS,'INCOMPLETE')='APPROVED'
AND NVL(POL.CANCEL_FLAG,'N')='N'
AND POL.ITEM_ID=6721 --P_ITEM
--AND POH.ORG_ID=81 --P_ORG
--AND POH.APPROVED_DATE <= P_DATE-1
--ORDER BY APP_DT DESC)
--WHERE rownum <2


-- GET PO TERMS AND CONDITIONS
=============================
SELECT VL.DESCRIPTION,VL.LOOKUP_CODE
FROM FND_LOOKUP_TYPES_VL TY,FND_LOOKUP_VALUES_VL VL
WHERE VL.LOOKUP_TYPE=TY.LOOKUP_TYPE
AND VL.LOOKUP_TYPE='XX_PO_TERMS_AND_CONDITION'
AND NVL(ENABLED_FLAG,'N') = 'Y'
AND SYSDATE BETWEEN VL.START_DATE_ACTIVE AND NVL(VL.END_DATE_ACTIVE,SYSDATE)



  xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPO,










-- BRAND PO DATA 
--===============================

select  GET_OU_NAME_FROM_ID(A.ORG_ID) OU,A.SEGMENT1 PO_NUMBER, A.CREATED_BY, XX_GET_EMP_NAME_FROM_USER_ID (A.CREATED_BY) BUYER, A.CURRENCY_CODE,XX_AP_PKG.GET_VENDOR_NAME (A.VENDOR_ID) SUPPLIER ,A.AUTHORIZATION_STATUS STATUS , A.APPROVED_DATE,A.ATTRIBUTE_CATEGORY Contex_type,
B.ITEM_DESCRIPTION, B.UNIT_MEAS_LOOKUP_CODE UOM, B.UNIT_PRICE,B.QUANTITY, B.UNIT_PRICE*B.QUANTITY Amount 
 from  PO_HEADERS_ALL A, PO_LINES_ALL B
  WHERE A.PO_HEADER_ID= B.PO_HEADER_ID
AND A.ATTRIBUTE_CATEGORY = 'Branding_Info' 
AND A.AUTHORIZATION_STATUS  = 'APPROVED'


-- BRAND PO DATA  FOR THREE USERS: Created By=  6124 --> Sadman Tausif, KG-7148 , Created BY= 6348 ---> Enamul Hoque Rasel, KG-7197 , Created BY=  5701     --> Monir Hossain, KG-5889
--===============================

select  GET_OU_NAME_FROM_ID(A.ORG_ID) OU,A.SEGMENT1 PO_NUMBER, A.CREATED_BY, XX_GET_EMP_NAME_FROM_USER_ID (A.CREATED_BY) BUYER, A.CURRENCY_CODE,XX_AP_PKG.GET_VENDOR_NAME (A.VENDOR_ID) SUPPLIER ,A.AUTHORIZATION_STATUS STATUS , A.APPROVED_DATE,A.ATTRIBUTE_CATEGORY Contex_type,
B.ITEM_DESCRIPTION, B.UNIT_MEAS_LOOKUP_CODE UOM, B.UNIT_PRICE,B.QUANTITY, B.UNIT_PRICE*B.QUANTITY Amount 
 from  PO_HEADERS_ALL A, PO_LINES_ALL B
  WHERE A.PO_HEADER_ID= B.PO_HEADER_ID
--AND A.ATTRIBUTE_CATEGORY = 'Branding_Info' 
AND A.AUTHORIZATION_STATUS  = 'APPROVED'
AND A.CREATED_BY IN (6124,6348,5701) --> --Created By=  6124 --> Sadman Tausif, KG-7148 , Created BY= 6348 ---> Enamul Hoque Rasel, KG-7197 , Created BY=  5701     --> Monir Hossain, KG-5889
AND TRUNC(A.APPROVED_DATE)  BETWEEN '01-JAN-2022' AND '21-JUN-2022'

-- UPDATE DESTINATION_ORGANIZATION_ID AFTER APPROVE PR
--=========================================

select * from PO_REQUISITION_HEADERS_ALL WHERE ORG_ID= 81 and  SEGMENT1= 10005717

SELECT a.DESTINATION_ORGANIZATION_ID, a.*  FROM PO_REQUISITION_LINES_ALL a WHERE REQUISITION_HEADER_ID =1416693

SELECT a.DESTINATION_ORGANIZATION_ID, a.*  FROM PO_REQUISITION_LINES_ALL a WHERE  REQUISITION_LINE_ID = 1025628


UPDATE PO_REQUISITION_LINES_ALL 
SET DESTINATION_ORGANIZATION_ID = 144
Where REQUISITION_LINE_ID = 1025628


-- UPDATE PO SHIPMENT_ORG AFTER APPROVE PO
--==================================

SELECT * FROM PO_HEADERS_ALL WHERE SEGMENT1= 40012731  and ORG_ID= 104

SELECT * FROM PO_LINES_ALL WHERE PO_HEADER_ID = 885287  and ORG_ID= 104

SELECT * FROM PO_LINE_LOCATIONS_ALL WHERE PO_HEADER_ID = 885287    -- SHIP_TO_ORGANIZATION_ID

SELECT * FROM PO_DISTRIBUTIONS_ALL WHERE PO_HEADER_ID = 885287    -- DESTINATION_ORGANIZATION_ID

SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE = 'KBD'

SELECT SHIP_TO_ORGANIZATION_ID FROM PO_LINE_LOCATIONS_ALL WHERE PO_HEADER_ID = 885287 

UPDATE  
PO_LINE_LOCATIONS_ALL
SET SHIP_TO_ORGANIZATION_ID=166
 WHERE PO_HEADER_ID = 885287 

--======================================================
--CORRECTION INVENTORY ORG
--=======================================================

SELECT  DESTINATION_ORGANIZATION_ID  FROM PO_DISTRIBUTIONS_ALL WHERE PO_HEADER_ID = 885287  

UPDATE  
PO_DISTRIBUTIONS_ALL
SET DESTINATION_ORGANIZATION_ID=166
 WHERE PO_HEADER_ID = 885287 







--- GET APPROVAL PATH FROM BACKEND ------------------------

select OBJECT_TYPE_CODE, OBJECT_SUB_TYPE_CODE,pah.LAST_UPDATE_DATE, pah.CREATION_DATE, pah.CREATED_BY, ACTION_CODE, ACTION_DATE,
(select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID) HIERARCHY_NAME, FULL_NAME, EMPLOYEE_NUMBER, AUTHORIZATION_STATUS, COMMENTS, WF_ITEM_TYPE, WF_ITEM_KEY
FROM po_action_history pah,per_all_people_f papf,po_headers_all pha
where pah.employee_id = papf.person_id AND pah.object_id = pha.po_header_id
--and SEGMENT1 = :PO_Number
and (select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID)  like '%FPD%IMPORT%' 



--==============================================================================================================


select * from HR_OPERATING_UNITS



------ FOR PO FINALLY CLOSED  CHECKED AND DONE: PARAMETER:  ======== 

DECLARE
x_action constant varchar2(20) := 'FINALLY CLOSE'; -- Change this parameter as per requirement
x_calling_mode constant varchar2(2) := 'PO';
x_conc_flag constant varchar2(1) := 'N';
x_return_code_h varchar2(100);
x_auto_close constant varchar2(1) := 'N';
x_origin_doc_id number;
x_returned boolean;

CURSOR c_po_details IS

SELECT
pha.po_header_id,
pha.org_id,
pha.segment1,
pha.agent_id,
pdt.document_subtype,
pdt.document_type_code,
pha.closed_code,
pha.closed_date
FROM apps.po_headers_all pha, apps.po_document_types_all pdt
WHERE pha.type_lookup_code = pdt.document_subtype
AND pha.org_id = pdt.org_id
AND pdt.document_type_code = 'PO'
AND authorization_status = 'APPROVED'
--AND pha.closed_code <> 'FINALLY CLOSED'
AND PHA.ORG_ID= '108'
--AND pha.segment1 = '40000010'; -- Enter the PO Number if one PO needs to be finally closed/Closed

begin

fnd_global.apps_initialize (user_id => 1805,
resp_id => 20707,
resp_appl_id => 201);

for po_head in c_po_details

LOOP
mo_global.init (po_head.document_type_code);
mo_global.set_policy_context ('S', po_head.org_id);
--DBMS_OUTPUT.PUT_LINE ('Calling PO_Actions.close_po for Closing/Finally Closing PO =>' po_head.segment1);
x_returned :=
po_actions.close_po(
p_docid => po_head.po_header_id,
p_doctyp => po_head.document_type_code,
p_docsubtyp => po_head.document_subtype,
p_lineid => NULL,
p_shipid => NULL,
p_action => x_action,
p_reason => NULL,
p_calling_mode => x_calling_mode,
p_conc_flag => x_conc_flag,
p_return_code => x_return_code_h,
p_auto_close => x_auto_close,
p_action_date => SYSDATE,
p_origin_doc_id => NULL);

END LOOP;

END;



--======================= LC RELATED QUERY FOR ACCOUNTS LIAKOT VAI ====================================


SELECT * FROM PO_HEADERS_ALL POH,  RCV_SHIPMENT_LINES RSL
WHERE POH.PO_HEADER_ID=RSL.PO_HEADER_ID
AND POH.ORG_ID= 104
AND TRUNC(POH.APPROVED_DATE) BETWEEN '01-JAN-2022' and  '31-JAN-2022'


SELECT * FROM PO_HEADERS_ALL WHERE ORG_ID= 104 and currency_code <> 'BDT' AND TRUNC(APPROVED_DATE) BETWEEN '01-JAN-2022' and '31-JAN-2022'


SELECT * FROM PO_LINES_ALL WHERE ORG_ID= 104 


SELECT * FROM RCV_SHIPMENT_HEADERS WHERE SHIP_TO_ORG_ID= 166 and TRUNC(CREATION_DATE) between '01-JAN-2022' and '31-JAN-2022'


SELECT * FROM  RCV_SHIPMENT_LINES where TO_ORGANIZATION_ID = 166 and TRUNC(CREATION_DATE) between '01-JAN-2022' and '31-JAN-2022'


SELECT * FROM RCV_TRANSACTIONS WHERE ORGANIZATION_ID = 166 and TRUNC(TRANSACTION_DATE) between '01-JAN-2022' and '31-JAN-2022' AND TRANSACTION_TYPE = 'DELIVER'

SELECT * FROM TAB WHERE TABTYPE='VIEW' AND TNAME LIKE '%KBG%PO%GRN%'


SELECT OU_ID, GET_OU_NAME_FROM_ID(OU_ID) OU_NAME, LC_NUMBER,SUPPLIER_NAME, ITEM_DESCRIPTION,UOM,CURRENCY,PO_NUMBER,PO_QUANTITY,PRICE , GRN_NUMBER,GRN_QUANTITY,(GRN_QUANTITY*PRICE) GRN_VALUE FROM XXKBG_BI_PO_GRN WHERE OU_ID=104 
--AND GRN_DATE BETWEEN '01-FEB-2022' and '28-FEB-2022' 
and CURRENCY <>'BDT'


SELECT * FROM PO_HEADERS_ALL POH, PO_LINES_ALL POL,RCV_SHIPMENT_HEADERS RSH,RCV_SHIPMENT_LINES RSL,RCV_TRANSACTIONS RT
WHERE POH.PO_HEADER_ID = POL.PO_HEADER_ID
AND POH.PO_HEADER_ID= RSL.PO_HEADER_ID
AND RSL.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
AND RSL.SHIPMENT_LINE_ID= RT.SHIPMENT_LINE_ID
AND RT.TRANSACTION_TYPE = 'DELIVER'
AND TRUNC(TRANSACTION_DATE) between '01-JAN-2022' and '31-JAN-2022'
AND RT.ORGANIZATION_ID= 166
AND POH.currency_code <> 'BDT'

 
SELECT * FROM POHEADER







------ FOR PO  CLOSED  PREPARING  ======== 

/*oracle R12 : PO - Script to Close*/

DECLARE
x_action constant varchar2(20) := 'CLOSE'; -- Change this parameter as per requirement
x_calling_mode constant varchar2(2) := 'PO';
x_conc_flag constant varchar2(1) := 'N';
x_return_code_h varchar2(100);
x_auto_close constant varchar2(1) := 'N';
x_origin_doc_id number;
x_returned boolean;
CURSOR c_po_details IS
SELECT
pha.po_header_id,
pha.org_id,
pha.segment1,
pha.agent_id,
pdt.document_subtype,
pdt.document_type_code,
pha.closed_code,
pha.closed_date
FROM apps.po_headers_all pha, apps.po_document_types_all pdt
WHERE pha.type_lookup_code = pdt.document_subtype
AND pha.org_id = pdt.org_id
AND pdt.document_type_code = 'PO'
AND authorization_status = 'APPROVED'
AND pha.closed_code <> 'CLOSED'
AND pha.ORG_ID= '81'
AND segment1 = '40000098'; -- Enter the PO Number if only one PO needs to be finally closed/Closed
begin
fnd_global.apps_initialize (user_id => 1805,
resp_id => 20707,
resp_appl_id => 201);

for po_head in c_po_details
LOOP
mo_global.init (po_head.document_type_code);
mo_global.set_policy_context ('S', po_head.org_id);
--DBMS_OUTPUT.PUT_LINE ('Calling PO_Actions.close_po for Closing/Finally Closing PO =>' po_head.segment1);
x_returned :=
po_actions.close_po(
p_docid => po_head.po_header_id,
p_doctyp => po_head.document_type_code,
p_docsubtyp => po_head.document_subtype,
p_lineid => NULL,
p_shipid => NULL,
p_action => x_action,
p_reason => NULL,
p_calling_mode => x_calling_mode,
p_conc_flag => x_conc_flag,
p_return_code => x_return_code_h,
p_auto_close => x_auto_close,
p_action_date => SYSDATE,
p_origin_doc_id => NULL);
END LOOP;
END;

--===========================================




------ FOR PO CANCEL PREPARING ========

DECLARE

l_return_status VARCHAR2 (10);

CURSOR C_PO_CANCEL is
SELECT pha.po_header_id,
pha.org_id,
pha.segment1 po_number,
pha.type_lookup_code,
pha.cancel_flag,
pha.closed_code
FROM po_headers_all pha
WHERE 1=1
AND PHA.ORG_ID=81
AND pha.segment1 = 40001087 -- Enter The Purchase Order Number
AND nvl(pha.closed_code,'OPEN') = 'OPEN'
AND nvl(pha.cancel_flag, 'N') = 'N'
AND approved_flag = 'Y';
BEGIN
fnd_global.apps_initialize (user_id => 1804,
resp_id => 20707,
resp_appl_id => 201);

FOR i IN c_po_cancel
LOOP
mo_global.init ('PO');
mo_global.set_policy_context ('S',i.org_id );
--DBMS_OUTPUT.PUT_LINE (‘Calling API PO_DOCUMENT_CONTROL_PUB.CONTROL_DOCUMENT For Cancelling Documents’);
po_document_control_pub.control_document
(p_api_version => 1.0, -- p_api_version
p_init_msg_list => fnd_api.g_true,  --p_init_msg_list
p_commit => fnd_api.g_true, -- p_commit
x_return_status => l_return_status, --x_return_status
p_doc_type => 'PO', -- p_doc_type
p_doc_subtype => 'STANDARD', -- p_doc_subtype
p_doc_id => i.po_header_id, -- p_doc_id
p_doc_num => NULL, -- p_doc_num
p_release_id => NULL,  -- p_release_id
p_release_num => NULL, -- p_release_num
p_doc_line_id => NULL, -- p_doc_line_id
p_doc_line_num => NULL, -- p_doc_line_num
p_doc_line_loc_id => NULL, -- p_doc_line_loc_id
p_doc_shipment_num => NULL, -- p_doc_shipment_num
p_action => 'CANCEL', -- p_action
p_action_date => SYSDATE, -- p_action_date
p_cancel_reason => NULL, -- p_cancel_reason
p_cancel_reqs_flag => 'Y', --  p_cancel_reqs_flag
p_print_flag => NULL, -- p_print_flag
p_note_to_vendor => NULL, -- p_note_to_vendor
p_use_gldate =>NULL ,
p_org_id => i.org_id
);
COMMIT;
END LOOP;
END;


 --=================================================================== 0 =============
 -- PO APPROVED BUT NOT GRN
 -- IF  ADD THIS CONDITION THEN PARTIAL GRN WILL NOT SHOW ( and  pll.quantity_received  =  0 )
 --=================================================================== 0 =============
 
 select * from PO_HEADERS_ALL where segment1 = 40000010 -- and org_id= 81
 
 SELECT * FROM PO_HEADERS_ALL WHERE PO_HEADER_ID= 220012  --- 482281
 
 select * from PO_LINES_ALL WHERE PO_HEADER_ID=220012 -- 482281
 
 SELECT   pha.org_id , hou.NAME, ood.organization_code, ood.organization_name,
            pha.po_header_id, pha.segment1, PHA.CLOSED_CODE , pha.ATTRIBUTE1, TRUNC (pha.approved_date) po_approved_date,
            pla.item_id, ksiv.concatenated_segments, pla.item_description,
            m2.segment1 item_category, pll.need_by_date,
            aps.segment1 vendor_number, aps.vendor_name,
            pll.quantity quantity, pll.quantity_received quantity_received,
            pll.quantity_rejected quantity_rejected,
            pll.quantity_cancelled quantity_cancelled,
            (  pll.quantity
             - NVL (pll.quantity_received, 0)
             - NVL (pll.quantity_rejected, 0)
             - NVL (pll.quantity_cancelled, 0)
            ) quantity_backordered,
            pha.authorization_status,
            (pll.quantity * pla.unit_price) po_amount
       FROM po_headers_all pha,
            ap_suppliers aps,
            po_lines_all pla,
            po_line_locations_all pll,
            hr_operating_units hou,
            apps.org_organization_definitions ood,
            mtl_categories m2,
            mtl_system_items_kfv ksiv
      WHERE pha.vendor_id = aps.vendor_id
        AND pha.po_header_id = pla.po_header_id
        AND pla.po_line_id = pll.po_line_id
        AND pla.po_header_id = pll.po_header_id
        AND pha.org_id = hou.organization_id
        AND ood.operating_unit = hou.organization_id
        AND pll.ship_to_organization_id = ood.organization_id
        AND m2.category_id = pla.category_id
        AND ksiv.inventory_item_id = pla.item_id
        AND ksiv.organization_id = ood.organization_id
        AND PLL.Quantity > NVL(pll.quantity_received,0)+NVL(pll.quantity_cancelled,0)
        AND  pha.authorization_status = 'APPROVED' 
        AND PHA.CLOSED_CODE  not  like  '%CLOSED%'
        --AND PHA.CLOSED_CODE  NOT IN ( 'CLOSED', 'FINALLY CLOSED')
       and pha.ATTRIBUTE1  IN ( 'SIS','LFA','L') --> LOCAL
     --  and pha.ATTRIBUTE1  IN ('IL','INL',''IFA')  --> FOREIGN
       and  pll.quantity_received  < pll.quantity
      --  AND   pll.quantity_received  <> '0'
       --  and  pll.quantity_received  =  0
        AND pha.org_id = NVL(:P_OU_NAME, pha.org_id )
       AND (:P_POAPPROVE_FROM_DT IS NULL OR TRUNC(pha.approved_date) BETWEEN :P_POAPPROVE_FROM_DT AND :P_POAPPROVE_TO_DT) 
      --and pha.po_header_id= 112004
     --AND pha.segment1 ='40000043'  
   ORDER BY pha.org_id, pha.segment1  --aps.vendor_name, pla.item_description;

---=========================================================================

SELECT * FROM HR_OPERATING_UNITS ORDER BY NAME






-- NASIR VAI PROVIDED CURRENCY ISSUE RESOLVE QUERY

select * from po_headers_all where segment1= 40000010 --  and org_id =104

-- po_header_id = 862959

select * from PO_DISTRIBUTIONS_ALL
where po_header_id = 862959 and rate_date is not null and rate is null

update PO_DISTRIBUTIONS_ALL
set rate=85
where po_header_id = 862959 and rate_date is not null and rate is null


--UPDATE PO_REQUISITION_LINES_ALL 
--SET DESTINATION_ORGANIZATION_ID = 144
--WHERE REQUISITION_HEADER_ID =1409781


DESTINATION_ORGANIZATION_ID

select * from ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_ID = 162




select * from po_lines_all 

select * from PO_HEADERS_ALL where CURRENCY_CODE <> 'BDT'  and ATTRIBUTE1 = 'L'

select * from PO_HEADERS_ALL where CURRENCY_CODE =  'BDT'  and ATTRIBUTE1 NOT  IN ( 'L', 'LFA', 'SIS')

--====================================
-- HOW MANY PO ARE CREATED FROM ONE PR
--=====================================

SELECT distinct(ph.segment1) PO, prh.segment1 PR, pl.ITEM_DESCRIPTION , pl.QUANTITY  FROM
po_headers_all  ph
,po_lines_all  pl
,po_distributions_all pd,
po_requisition_headers_all prh,
po_requisition_lines_all prl,
po_req_distributions_all prd
where ph.po_header_id =pl.po_header_id
and ph.po_header_id =pd.po_header_id
and pd.REQ_DISTRIBUTION_ID =prd.DISTRIBUTION_ID
and prl.requisition_line_id=prd.requisition_line_id
and prh.requisition_header_id=prl.requisition_header_id
and prh.segment1= 10003844  
and prh.org_id= 108
--and pl.item_description like '%ALLEN KEY BOLT 16X110MM%'


select * from PO_REQUISITION_HEADERS_ALL where  segment1= 10004282  
and org_id= 81 

select * from PO_REQUISITION_LINES_ALL where  REQUISITION_HEADER_ID = 1395691 and ITEM_DESCRIPTION= 'ALLEN KEY BOLT 16X110MM'




--==================================================================
-- PR ER  STATUS DEKHAR JONNO 
--==================================================================

SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE LIKE  '%B'

select * -- b.AUTHORIZATION_STATUS  
from PO_REQUISITION_LINES_ALL a, PO_REQUISITION_HEADERS_ALL b
where a.REQUISITION_HEADER_ID=b.REQUISITION_HEADER_ID
--and  DESTINATION_ORGANIZATION_ID = 142
and b.AUTHORIZATION_STATUS =  'IN PROCESS'


--==================================================================
--KSRM ER  INFORMATION ER JONNO 
--==================================================================

select * from FND_LOOKUP_VALUES where lookup_type = 'KSRM_DEPT'  -- TOTAT DEPT OF KSRM  36 

select * from FND_LOOKUP_VALUES where lookup_type='KSRM_SECTION' -- TOTAL Section 87 ta

select * from FND_LOOKUP_VALUES where lookup_type = 'KSRM_DESIG' and enabled_flag='Y'  and meaning like '%Manager%'--TOTAL DESIG 190

select * from FND_LOOKUP_VALUES where lookup_type = 'KSRM_DESIG' and enabled_flag='Y'  and meaning like '%Director%'   ;

select * from FND_LOOKUP_VALUES where  lookup_type='KSRM_APPROVER' ; 

select * from FND_RESPONSIBILITY_TL where RESPONSIBILITY_NAME = 'Application Developer'  


select * from fnd_form_functions 

SELECT owner, table_name FROM all_tables

SELECT table_name FROM user_tables

select * from XX_SUPPLIER_DETAILS_UPLOAD1 

select * from XX_USER_MATRIX

select table_name from all_tables   

SELECT table_name FROM user_tables;

SELECT table_name, column_name
FROM cols
WHERE table_name LIKE 'EST%'
AND column_name LIKE '%CALLREF%';


select * from org_organization_definitions

select * from PO_REQUISITION_HEADERS_ALL where segment1 = '10000039' and org_id = 81

select * from po_requisition_lines_all where org_id=81 and requisition_header_id = 89002

select * from REQUISITION_distributions_all

 select  ppd_out.segment3  from fnd_user fu, per_people_x ppx, per_assignments_x pax, per_positions ppos, per_position_definitions ppd_in, (select distinct segment5, segment3 from per_position_definitions) ppd_out
 where  ppx.person_id = fu.employee_id
and     pax.person_id = ppx.person_id
and     ppos.position_id = pax.position_id
and     ppd_in.position_definition_id = ppos.position_definition_id
and     ppd_out.segment5 = ppd_in.segment5

   --===========================================================
-- PO AND GRN COMPLETED BUT NOT INVOICED DETAILS 04-AUG-2020
--===========================================================

/*
PARAMETER
===========
ORG: 81
FROM DATE: 7/1/2020 9:00:10 AM
TO DATE: 7/31/2020 11:59:00 PM */
SELECT 
distinct PHA.org_id,
SUBSTR(XX_GET_HR_OPERATING_UNIT (PHA.ORG_ID),5) OPERATING_UNIT,
--XX_INV_PKG.XXGET_ORG_LOCATION (PHA.ORG_ID) ORG_ADDRESS,
--RT.ORGANIZATION_ID INV_ORG,
INVORG_NAME_FROM_ID (RT.ORGANIZATION_ID) INV_ORG_NAME,
     pha.ATTRIBUTE1 PO_TYPE,
      PHA.SEGMENT1 PO_NUMBER,
 TO_CHAR(TRUNC( PHA.APPROVED_DATE),'DD-MON-RRRR') PO_APPROVED_DATE,
          RH.RECEIPT_NUM GRN_NUMBER, 
  TO_CHAR(TRUNC( RT.CREATION_DATE),'DD-MON-RRRR') GRN_DATE,
       ASP.VENDOR_NAME,
      -- ASP.SEGMENT1 VENDOR_NO,
       --PHA.APPROVED_DATE  PO_APPROVED_DATE,
           PLA.ITEM_DESCRIPTION,
 --    (PLA.UNIT_PRICE* PLA.QUANTITY) PO_AMOUNT,
            NULL INVOICE_NUM,
            NULL INVOICE_DATE,
            NULL GL_DATE,
            NULL INVOICE_AMOUNT,
            NULL INV_VOUCHER_NO,
            NULL INV_CREATED_BY,
          NULL DIST_GL_CODE,
          NULL PAYMENT_VOUCHER,
          NULL PAY_CREATE_DATE,
          NULL PAYMENT_TYPE,
          NULL PAYMENT_STATUS,
          NULL PAY_AMOUNT,
         XX_ONT_GET_ENAME(:P_USER) PRINTED_BY 
 from PO_HEADERS_ALL PHA, PO_LINES_ALL PLA, PO_LINE_LOCATIONS_ALL PLL,PO_DISTRIBUTIONS_ALL PDA, AP_SUPPLIERS ASP,
 RCV_TRANSACTIONS RT,RCV_SHIPMENT_LINES RL, RCV_SHIPMENT_HEADERS RH
 WHERE PHA.PO_HEADER_ID =PLA.PO_HEADER_ID
 and PHA.po_header_id = PLA.po_header_id
 and PLA.po_line_id= pll.po_line_id
 and PHA.po_header_id= pll.po_header_id
 and PHA.PO_HEADER_ID= PLA.PO_HEADER_ID
 AND PLA.PO_LINE_ID= PDA.PO_LINE_ID
 AND PLA.QUANTITY <> 0
 AND PHA.PO_HEADER_ID= RT.PO_HEADER_ID
 AND PLA.PO_LINE_ID= RT.PO_LINE_ID
 AND PDA.GL_CANCELLED_DATE is NULL
 AND RT.TRANSACTION_TYPE= 'DELIVER'
    AND PDA.PO_DISTRIBUTION_ID NOT IN
      (SELECT PO_DISTRIBUTION_ID FROM PO_DISTRIBUTIONS_ALL PDA
       WHERE PO_DISTRIBUTION_ID IN (SELECT DISTINCT  PO_DISTRIBUTION_ID FROM AP_INVOICE_DISTRIBUTIONS_ALL))
 AND RH.SHIPMENT_HEADER_ID= RT.SHIPMENT_HEADER_ID
 AND RH.SHIPMENT_HEADER_ID= RL.SHIPMENT_HEADER_ID
 AND RL.SHIPMENT_LINE_ID= RT.SHIPMENT_LINE_ID
 AND ASP.VENDOR_ID= PHA.VENDOR_ID
   AND (:P_ORG_ID IS NULL OR PHA.ORG_ID = :P_ORG_ID)
  AND (:P_GRN_FROM_DT IS NULL OR TRUNC(RT.CREATION_DATE) BETWEEN :P_GRN_FROM_DT AND :P_GRN_TO_DT) 
  AND (:P_PO_NO IS NULL OR PHA.segment1 = :P_PO_NO) 
  AND (:P_GRN_NO IS NULL OR rh.receipt_num = :P_GRN_NO) 
  ORDER BY INV_ORG_NAME ,GRN_NUMBER ASC -- RT.ORGANIZATION_ID 

/*
SELECT PHA.ORG_ID,
substr(XX_GET_HR_OPERATING_UNIT(PHA.ORG_ID),5) OU,
rt.ORGANIZATION_ID ,
MY_PACKAGE.GET_ORG_CODE_FROM_ID(rt.ORGANIZATION_ID) INV_ORG,
pha.ATTRIBUTE1 PO_TYPE,asp.vendor_name
     , RSL.SHIPMENT_HEADER_ID
     ,MY_PACKAGE.GET_GRN_FROM_GRNID(RSL.SHIPMENT_HEADER_ID) GRN_NUMBER
     ,RT.TRANSACTION_TYPE GRN_STATUS
      ,pha.segment1 PO_NUMBER 
      --,pha.creation_date po_date
      ,TO_CHAR(TRUNC(rt.CREATION_DATE),'DD-MON-RRRR') GRN_DATE
      ,pha.type_lookup_code
  FROM po_distributions_all pda
      ,po_headers_all pha
      ,rcv_shipment_lines rsl
      ,rcv_transactions rt
      ,ap_suppliers asp
      ,po_lines_all pla
 WHERE 1=1
   AND pda.po_header_id=pha.po_header_id
   AND pda.po_distribution_id NOT IN
      (SELECT po_distribution_id FROM po_distributions_all pda
       WHERE po_distribution_id IN (SELECT DISTINCT  po_distribution_id FROM ap_invoice_distributions_all))
   AND rsl.po_header_id=pha.po_header_id  
   AND asp.vendor_id=pha.vendor_id
   AND pha.po_header_id=pla.po_header_id
   AND pla.po_line_id=pda.po_line_id
   and pha.type_lookup_code <> 'BLANKET'
   and rt.shipment_header_id=rsl.shipment_header_id
   and rt.shipment_line_id= rsl.shipment_line_id
   and RT.TRANSACTION_TYPE = 'DELIVER'
  -- and pha.ATTRIBUTE1  =  'IL'
   --and pha.segment1=40003889
   AND pha.org_id = :P_OU_NAME
  -- and rsl.CREATION_DATE = NVL(:P_DATE_FROM ,rsl.CREATION_DATE)
   AND (:P_DATE_FROM IS NULL OR TRUNC(rt.CREATION_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO) 
 --  AND (:P_INV_FROM_DT IS NULL OR TRUNC(AIA.INVOICE_DATE) BETWEEN :P_INV_FROM_DT AND :P_INV_TO_DT) 
GROUP BY asp.vendor_name,pha.segment1,rt.CREATION_DATE,pha.type_lookup_code,RSL.SHIPMENT_HEADER_ID,PHA.ORG_ID,pha.ATTRIBUTE1,RT.TRANSACTION_TYPE,rt.ORGANIZATION_ID
ORDER BY RSL.SHIPMENT_HEADER_ID
*/

--=======================================================================
-- PR APPROVED BUT NOT PO
 -----list all Purchase Requisition without a Purchase Order that means  a PR has not been autocreated to PO. 
 -- ORG_ID : 81
 --================================================

select  distinct(prh.segment1) "PR NUM",
  substr(XX_GET_HR_OPERATING_UNIT(prh.org_id),5) OU,
  (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID) dest_org_name ,
-- to_char(trunc(prh.creation_date) "CREATED ON",
-- trunc(prl.creation_date) "Line Creation Date" ,
--msi.segment1 "Item Num",
prl.item_description "Description",
prl.quantity "Qty",
--prl.attribute2 ORIGIN,prl.
--attribute3 use_of_area, 
--to_char(trunc(prl.need_by_date)) "Need By Date",
-- to_char(prh.APPROVED_DATE) "PR Approved Date",
 TO_CHAR(TRUNC(prh.APPROVED_DATE),'DD-MON-RRRR') "PR Approved Date",
--(to_date(SYSDATE, 'dd-mm-yy') - to_date(prh.APPROVED_DATE, 'dd-mm-yy')) Lead_time,
ppf1.full_name "PREPARER"
--XXKG_COM_PKG.GET_DEPT_NAME (prh.PREPARER_ID) Department
--ppf2.agent_name "BUYER"
from
po.po_requisition_headers_all prh,
po.po_requisition_lines_all prl,
apps.per_people_f ppf1,
(select distinct agent_id,agent_name from apps.po_agents_v ) ppf2,
po.po_req_distributions_all prd,
inv.mtl_system_items_b msi,
po.po_line_locations_all pll,
po.po_lines_all pl,
po.po_headers_all ph
WHERE
prh.requisition_header_id = prl.requisition_header_id
and prl.requisition_line_id = prd.requisition_line_id
and ppf1.person_id = prh.preparer_id
and prh.creation_date between ppf1.effective_start_date and ppf1.effective_end_date and ppf2.agent_id(+) = msi.buyer_id
and msi.inventory_item_id = prl.item_id
and msi.organization_id = prl.destination_organization_id
and pll.line_location_id(+) = prl.line_location_id
and pll.po_header_id = ph.po_header_id(+)
AND PLL.PO_LINE_ID = PL.PO_LINE_ID(+)
AND PRH.AUTHORIZATION_STATUS = 'APPROVED'
AND PLL.LINE_LOCATION_ID IS NULL
AND PRL.CLOSED_CODE IS NULL
AND NVL(PRL.CANCEL_FLAG,'N') <> 'Y'
AND PRH.TYPE_LOOKUP_CODE <> 'INTERNAL'         
and prh.APPROVED_DATE  between '01-JAN-21' and  '31-AUG-21'
and prh.org_id =  :P_OU  --81
--and prh.segment1 = '10003597'
--and prh.segment1 = '11610100419'     --'11610100594'   --'11610100586' --'11610100476' --'11610100166' 11610100005
ORDER BY 1,2


SELECT * FROM PO_REQUISITION_HEADERS_ALL WHERE SEGMENT1 ='10000034' and org_id = 81

SELECT *  FROM PO_REQUISITION_LINES_ALL WHERE REQUISITION_HEADER_ID ='78002' and org_id = 81




--=======================================================================
-- IR APPROVED BUT NOT ISO
 -----list all Internal  Requisition without Sales Order  means  IR is not approved , it is incomplete, Inprocess, Rejected status 
 -- ORG_ID : 81
 --================================================

SELECT RQH.ORG_ID,
 substr(XX_GET_HR_OPERATING_UNIT(rqh.org_id),5) OU,
RQH.SEGMENT1,
RQH.CREATION_DATE,
RQH.APPROVED_DATE,
RQH.AUTHORIZATION_STATUS,
 XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(RQH.creation_date,RQH.created_by) creator_details,
RQH.TRANSFERRED_TO_OE_FLAG,
RQL.DESTINATION_ORGANIZATION_ID,
(select name from hr_all_organization_units where organization_id=rql.DESTINATION_ORGANIZATION_ID) dest_org_name ,
RQL.SOURCE_ORGANIZATION_ID,
(select name from hr_all_organization_units where organization_id=rql.SOURCE_ORGANIZATION_ID) Source_org_name ,
RQL.LINE_NUM,
RQL.REQUISITION_HEADER_ID,
RQL.REQUISITION_LINE_ID,
RQL.ITEM_ID,
RQL.UNIT_MEAS_LOOKUP_CODE,
RQL.UNIT_PRICE,
RQL.QUANTITY,
RQL.QUANTITY_CANCELLED,
RQL.QUANTITY_DELIVERED,
RQL.CANCEL_FLAG,
RQL.SOURCE_TYPE_CODE,
RQH.TRANSFERRED_TO_OE_FLAG
 FROM PO_REQUISITION_LINES_ALL RQL, PO_REQUISITION_HEADERS_ALL RQH
WHERE RQL.REQUISITION_HEADER_ID = RQH.REQUISITION_HEADER_ID
AND RQL.SOURCE_TYPE_CODE = 'INVENTORY'
AND RQL.SOURCE_ORGANIZATION_ID IS NOT NULL
AND NOT EXISTS
(SELECT 'existing internal order'
 FROM OE_ORDER_LINES_ALL LIN 
WHERE LIN.SOURCE_DOCUMENT_LINE_ID =
RQL.REQUISITION_LINE_ID
AND LIN.SOURCE_DOCUMENT_TYPE_ID = 10)
and NVL(RQH.ORG_ID, :P_OU) = :P_OU
and RQH.APPROVED_DATE  between '01-JAN-21' and  '31-AUG-21'
--and RQH.APPROVED_DATE  between '01-SEP-18' and  '30-SEP-18'
ORDER BY RQH.REQUISITION_HEADER_ID, RQL.LINE_NUM



--=======================================================================
-- IR APPROVED BUT NOT ISO
 -----list all Internal  Requisition without Sales Order  means  IR is  approved  but ISO Status is ENTERD
 -- ORG_ID : 81
 --================================================

SELECT RQH.ORG_ID,
 substr(XX_GET_HR_OPERATING_UNIT(rqh.org_id),5) OU,
RQH.SEGMENT1,
RQH.CREATION_DATE,
 TO_CHAR(TRUNC(RQH.APPROVED_DATE),'DD-MON-RRRR') "IR Approved Date",
RQH.AUTHORIZATION_STATUS,
 XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(RQH.creation_date,RQH.created_by) creator_details,
RQH.TRANSFERRED_TO_OE_FLAG,
(select name from hr_all_organization_units where organization_id=rql.DESTINATION_ORGANIZATION_ID) dest_org_name ,
(select name from hr_all_organization_units where organization_id=rql.SOURCE_ORGANIZATION_ID) Source_org_name ,
RQL.LINE_NUM,
RQL.REQUISITION_HEADER_ID,
RQL.REQUISITION_LINE_ID,
RQL.ITEM_ID,
RQL.UNIT_MEAS_LOOKUP_CODE,
RQL.UNIT_PRICE,
RQL.QUANTITY,
RQL.QUANTITY_CANCELLED,
RQL.QUANTITY_DELIVERED,
RQL.CANCEL_FLAG,
RQL.SOURCE_TYPE_CODE,
RQH.TRANSFERRED_TO_OE_FLAG
 FROM PO_REQUISITION_LINES_ALL RQL, PO_REQUISITION_HEADERS_ALL RQH
WHERE RQL.REQUISITION_HEADER_ID = RQH.REQUISITION_HEADER_ID
AND RQL.SOURCE_TYPE_CODE = 'INVENTORY'
AND RQL.SOURCE_ORGANIZATION_ID IS NOT NULL
AND  EXISTS
(SELECT 'existing internal order'
 FROM OE_ORDER_LINES_ALL LIN 
WHERE LIN.SOURCE_DOCUMENT_LINE_ID =
RQL.REQUISITION_LINE_ID
AND LIN.SOURCE_DOCUMENT_TYPE_ID = 10
and LIN.FLOW_STATUS_CODE = 'ENTERED')
and NVL(RQH.ORG_ID, :P_OU) = :P_OU
and RQH.APPROVED_DATE  between '01-JAN-21' and  '30-AUG-21'
--AND LIN.BOOKED_FLAG = 'Y')
ORDER BY RQH.REQUISITION_HEADER_ID, RQL.LINE_NUM


   

   
   
   --===========================================================
-- PO AND GRN COMPLETED BUT NOT INVOICED  DATE: 29-JUL-2020
--===========================================================

SELECT     DISTINCT MY_PACKAGE.GET_GRN_FROM_GRNID(RSL.SHIPMENT_HEADER_ID) GRN_NUMBER
--,PHA.ORG_ID
,GET_OU_NAME_FROM_ID(PHA.ORG_ID) OPERATING_UNIT
--, rt.ORGANIZATION_ID
,MY_PACKAGE.GET_ORG_CODE_FROM_ID(rt.ORGANIZATION_ID) INV_ORG
,pha.ATTRIBUTE1 TYPE,asp.vendor_name
     , RSL.SHIPMENT_HEADER_ID
     ,RT.TRANSACTION_TYPE GRN_STATUS
      ,pha.segment1 PO_NUMBER 
      --,pha.creation_date po_date
      ,TO_CHAR(TRUNC(rt.CREATION_DATE),'DD-MON-RRRR') GRN_DATE
      ,pha.type_lookup_code
  FROM po_distributions_all pda
      ,po_headers_all pha
      ,rcv_shipment_lines rsl
      ,rcv_transactions rt
      ,ap_suppliers asp
      ,po_lines_all pla
 WHERE 1=1
   AND pda.po_header_id=pha.po_header_id
   AND pda.po_distribution_id NOT IN
      (SELECT po_distribution_id FROM po_distributions_all pda
       WHERE po_distribution_id IN (SELECT DISTINCT  po_distribution_id FROM ap_invoice_distributions_all))
   AND rsl.po_header_id=pha.po_header_id  
   AND asp.vendor_id=pha.vendor_id
   AND pha.po_header_id=pla.po_header_id
   AND pla.po_line_id=pda.po_line_id
   and pha.type_lookup_code <> 'BLANKET'
   and rt.shipment_header_id=rsl.shipment_header_id
   and rt.shipment_line_id= rsl.shipment_line_id
   and RT.TRANSACTION_TYPE = 'DELIVER'
  -- and pha.ATTRIBUTE1  =  'IL'
   --and pha.segment1=40003889
   AND pha.org_id = :P_OU_NAME
  -- and rsl.CREATION_DATE = NVL(:P_DATE_FROM ,rsl.CREATION_DATE)
   AND (:P_DATE_FROM IS NULL OR TRUNC(rt.CREATION_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO) 
 --  AND (:P_INV_FROM_DT IS NULL OR TRUNC(AIA.INVOICE_DATE) BETWEEN :P_INV_FROM_DT AND :P_INV_TO_DT) 
GROUP BY asp.vendor_name,pha.segment1,rt.CREATION_DATE,pha.type_lookup_code,RSL.SHIPMENT_HEADER_ID,PHA.ORG_ID,pha.ATTRIBUTE1,RT.TRANSACTION_TYPE,rt.ORGANIZATION_ID
ORDER BY RSL.SHIPMENT_HEADER_ID
  
   XX_inv_PKG
   
   my_PACKAGE
   select * from RCV_TRANSACTIONS
   
   
   --===========================================================
-- PO AND GRN COMPLETED BUT NOT INVOICED
--===========================================================

SELECT asp.vendor_name
     , RSL.SHIPMENT_HEADER_ID
     ,MY_PACKAGE.GET_GRN_FROM_GRNID(RSL.SHIPMENT_HEADER_ID) GRN_NUMBER
      ,pha.segment1 PO_NUMBER 
      ,pha.creation_date po_date
      ,pha.type_lookup_code
      ,SUM(pla.unit_price* pla.quantity) po_amount
  FROM po_distributions_all pda
      ,po_headers_all pha
      ,rcv_shipment_lines rsl
      ,ap_suppliers asp
      ,po_lines_all pla
 WHERE 1=1
   AND pda.po_header_id=pha.po_header_id
   AND pda.po_distribution_id NOT IN
      (SELECT po_distribution_id FROM po_distributions_all pda
       WHERE po_distribution_id IN (SELECT DISTINCT  po_distribution_id FROM ap_invoice_distributions_all))
   AND rsl.po_header_id=pha.po_header_id  
   AND asp.vendor_id=pha.vendor_id
   AND pha.po_header_id=pla.po_header_id
   AND pla.po_line_id=pda.po_line_id
   and pha.type_lookup_code <> 'BLANKET'
   and pha.ATTRIBUTE1  =  'IL'
   and pha.segment1=40003889
   AND pha.org_id = :P_OU_NAME
GROUP BY asp.vendor_name,pha.segment1,pha.creation_date,pha.type_lookup_code,RSL.SHIPMENT_HEADER_ID
ORDER BY RSL.SHIPMENT_HEADER_ID








SELECT RECEIPT_NUM 
FROM RCV_SHIPMENT_HEADERS RH, RCV_SHIPMENT_LINES RL
WHERE RH.SHIPMENT_HEADER_ID = RL.SHIPMENT_HEADER_ID
and  RL.SHIPMENT_HEADER_ID= 1001278



   





   
 --=================================================
 -- LIST OF OPEN PO
 --Date 6_DEC_2018 
 --===================================================


SELECT h.org_id,
 substr(XX_GET_HR_OPERATING_UNIT(h.org_id),5) OU,
 XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(h.creation_date,h.created_by) creator_details,
   (select name from hr_all_organization_units where organization_id=d.DESTINATION_ORGANIZATION_ID) dest_org_name ,
h.segment1 "PO NUM",
h.approved_date,
h.authorization_status "STATUS",
l.line_num "SEQ NUM",
ll.line_location_id,
d.po_distribution_id,
h.type_lookup_code "TYPE",
h.closed_date
FROM po.po_headers_all h,
po.po_lines_all l,
 po.po_line_locations_all ll,
 po.po_distributions_all d
WHERE h.po_header_id = l.po_header_id
AND ll.po_line_id = l.po_Line_id
AND ll.line_location_id = d.line_location_id
AND h.closed_date IS NULL
AND h.type_lookup_code NOT IN ('QUOTATION')
AND h.authorization_status = 'APPROVED'
--and h.approved_date between '01-SEP-2018' and '04-SEP-2018'
AND  h.org_id = :P_OU

















--======================================
-- EBS Purchase Requisition Report
-- XXLOPR
--Date: 20-FEB-2019  ORG_CONSUMP_QTY IS UPDATED 26-feb-2019
--=====================================


SELECT prh.requisition_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       prl.ATTRIBUTE9 Department,
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PROJECT' and b.flex_value=prh.attribute1) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id,
       mst.item_code,
       mst.description,
       prl.QUANTITY Unit,
      XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,DESTINATION_ORGANIZATION_ID) CONSUM_QTYYY,
      ( XX_INV_DEPTM_ISS_QTY(DESTINATION_ORGANIZATION_ID,PRL.ITEM_ID,ADD_MONTHS(prh.creation_date,-1),prh.creation_date,upper(XX_P2P_GET_DEPT_INFO(prl.TO_PERSON_ID)))) CONSUM_QTY,
     --  (XX_INV_ORG_ISS_QTY(DESTINATION_ORGANIZATION_ID,PRL.ITEM_ID,ADD_MONTHS(prh.approved_date,-1),prh.approved_date)) ORG_CONSUM_QTY, 
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE, 
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
       paaf.job_id,
       pj.NAME,
       pj.job_definition_id,
      -- pjd.segment1 department,
       (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3 ) Use_of_Area,--use_area_type='XXKSRM_USE_AREA') Use_of_Area,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
       substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID)||' - '||HRO.ORGANIZATION_CODE dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION ,
       PRH.ATTRIBUTE_CATEGORY
  FROM po_requisition_headers_all prh,
       po_requisition_lines_all prl,
       mtl_units_of_measure_tl muom,
       per_people_f ppf,
       per_all_assignments_f paaf,
       pay_people_groups ppg,
       per_jobs pj,
       per_job_definitions pjd,
              PER_all_positions pp,
       PER_position_definitions pd,
       ORG_ORGANIZATION_DEFINITIONS HRO,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
        hr_operating_units HOU           
 WHERE prh.requisition_header_id = prl.requisition_header_id
   AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND prh.preparer_id = ppf.person_id
   AND prh.preparer_id = paaf.person_id
  AND HRL.LOCATION_ID=DELIVER_TO_LOCATION_ID
  AND HRL1.LOCATION_ID=PAAF.LOCATION_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND ppg.people_group_id(+) = paaf.people_group_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
 --  AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  AND PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
  AND HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID 
   AND prl.item_id = mst.inventory_item_id
   AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
      and prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
      and nvl(prl.CANCEL_FLAG,'N')= ('N')
 AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
 AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org,PRL.DESTINATION_ORGANIZATION_ID)
 AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
   --AND  prh.attribute15 = NVL(:P_PEIORITY,  prh.attribute15)
 AND PRH.TYPE_LOOKUP_CODE='PURCHASE'
 AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
  AND NVL(UPPER(PRH.ATTRIBUTE_CATEGORY),0) NOT IN ('SHIPPING INFORMATION')
   AND NVL(UPPER(PRL.ATTRIBUTE_CATEGORY),0) NOT IN ('BRANDING')
   AND prl.MODIFIED_BY_AGENT_FLAG is null
ORDER BY mst.description    
 --PRL.REQUISITION_LINE_ID

--======================================
--Pending Purchase Requisition(PR)   KSRM
--=====================================

SELECT prh.requisition_header_id,
        pha.po_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
        pha.segment1 po_no,
        pla.quantity po_qty,
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),      --old
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,     --old
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
   --    prl.ATTRIBUTE9 Department,     --old
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (SELECT DESCRIPTION||' ('||FLEX_VALUE||')' FROM FND_FLEX_VALUES_VL WHERE     FLEX_VALUE_SET_ID =1016512 AND PRH.ATTRIBUTE1=FND_FLEX_VALUES_VL.FLEX_VALUE) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id,
       mst.item_code,
       mst.description,
       prl.QUANTITY PR_QTY,
       pda.quantity_delivered,
       pda.quantity_billed,
       pda.quantity_cancelled,
       (select quantity_rejected from po_line_locations_all plla where plla.po_line_id=pla.po_line_id and plla.line_location_id=pda.line_location_id) quantity_rejected,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,PRL.DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
       paaf.job_id,
       pj.NAME,
       pj.job_definition_id,
      -- pjd.segment1 department,
       prL.ATTRIBUTE3 Use_of_Area,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
     --  substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,  --new
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,   --old
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,     --old
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,      --old
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,        --old
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,     --old
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,     --old
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID) dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION 
  FROM po_requisition_headers_all prh,
       po_requisition_lines_all prl,
       mtl_units_of_measure_tl muom,
       per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       ORG_ORGANIZATION_DEFINITIONS HRO,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '.' || segment2 || '.' || segment3
                        ) item_code
                   FROM mtl_system_items_b) mst,
        hr_operating_units HOU,
        po_headers_all pha,
        po_lines_all pla,   
        po_distributions_all pda,  
        po_req_distributions_all prda           
 WHERE pha.po_header_id = pda.po_header_id   
    AND pda.req_distribution_id = prda.distribution_id   
    AND prda.requisition_line_id = prl.requisition_line_id  
    AND prh.requisition_header_id = prl.requisition_header_id
    AND pla.po_line_id=pda.po_line_id
    AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
    AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
    AND prh.preparer_id = ppf.person_id
    AND prh.preparer_id = paaf.person_id
    AND HRL.LOCATION_ID=prl.DELIVER_TO_LOCATION_ID
    AND HRL1.LOCATION_ID=PAAF.LOCATION_ID
    AND ppf.person_id = paaf.person_id
    AND paaf.job_id(+) = pj.job_id
    AND pj.job_definition_id(+) = pjd.job_definition_id
    AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y' 
    AND PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID 
    AND prl.item_id = mst.inventory_item_id
    AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
    AND prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
    AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)    
    AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  --AND MST.item_code BETWEEN NVL(:P_ITEM_From,MST.item_code) AND NVL(:P_ITEM_To,MST.item_code)
    --AND nvl(PRL.ATTRIBUTE9,'x')=nvl(:P_DEPT,nvl(PRL.ATTRIBUTE9,'x'))
    --AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
    AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
    AND TRUNC(prh.creation_date) BETWEEN nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
    AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date)) 
    AND NVL(PRL.ATTRIBUTE_CATEGORY,0) NOT IN ('BRANDING','Shipping Information')
    ORDER BY PRL.REQUISITION_LINE_ID
    
--=======================================
-- SHOP PAINTING REPORT KSRM
--=======================================

SELECT
pha.attribute4 sizee,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
TO_CHAR (pha.APPROVED_DATE, 'DD-Mon-YYYY') po_APP_dt,
--pha.approved_date po_app_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
--pla.attribute12 zone,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_ZONE_1' and b.flex_value=pla.attribute12) zone,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_AREA_1' and b.flex_value=pla.attribute4) area,
pla.attribute13||' - '||(SELECT CUSTOMER_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE SITE_USE_CODE='BILL_TO' AND CUSTOMER_ID=pla.attribute13) customer,
pla.attribute14 contact ,
pla.attribute15 install_type,
ood.ORGANIZATION_CODE destinition,
pov.segment1 supplier_id,
pov.segment1||'-'||pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2 Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
SUBSTR(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,100) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_CODE IO,
XX_P2P_PKG.LC_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') release_date, 
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
'' css_no,
'' css_date,
pla.attribute1 brand,
pla.attribute2 origin,               
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
                   mtl_parameters MP
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pha.org_id = :p_org_id
   AND pha.po_header_id = nvl(:p_po_no,pha.po_header_id)
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
   AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID) 
   AND pla.attribute_category='BRANDING'
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1,
pla.ATTRIBUTE5,
PLA.ATTRIBUTE11,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-Mon-YYYY') ,
PHA.CURRENCY_CODE,
PHA.RATE,
PHA.ATTRIBUTE10,
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pla.attribute15,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_CODE,
pvs.EMAIL_ADDRESS,
--xx_com_pkg.get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
'',
'',
mst.item_code,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by),
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pla.attribute12,
pla.attribute4,
pla.attribute13,
pla.attribute14,
--PHA.ATTRIBUTE15,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'), 
PLA.UNIT_PRICE-NVL((NVL(NVL(PLA.ATTRIBUTE11,0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0),
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0)*(pll.quantity),
pha.REVISION_NUM,
PLA.UNIT_PRICE,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE)
UNION ALL
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPE, 
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
TO_CHAR (pha.APPROVED_DATE, 'DD-Mon-YYYY') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_ZONE_1' and b.flex_value=pla.attribute12) zone,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_AREA_1' and b.flex_value=pla.attribute4) area,
(SELECT CUSTOMER_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE SITE_USE_CODE='BILL_TO' AND CUSTOMER_ID=pla.attribute13) customer,
pla.attribute14 contact ,
pla.attribute15 install_type,
NULL destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2 Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
SUBSTR(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,100) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_CODE IO,
--(select organization_code from mtl_parameters where ORGANIZATION_ID=pll.ship_to_organization_id) IO,
TO_CHAR(NULL) LC_NO,
TO_NUMBER(NULL) release_num,   
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') rel_dt,
null,
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
'' css_no,
'' css_date,
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pla.attribute1 brand,
pla.attribute2 origin,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       PO_LINE_LOCATIONS_ALL PLL,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1, 
       (SELECT inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        )) mst,
                        mtl_parameters MP
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND UPPER(pll.SHIPMENT_TYPE)='PRICE BREAK'
   AND pha.org_id = :p_org_id
  AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
   AND pha.po_header_id = nvl(:p_po_no,pha.po_header_id)
   --AND 1=nvl2(:p_release,900,1)
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND :p_release IS NULL
   AND pla.attribute_category='BRANDING'
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE, 
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-Mon-YYYY') ,
PHA.CURRENCY_CODE,
PHA.RATE,
pla.attribute12,
pla.attribute4,
pla.attribute13,
pla.attribute14,
PHA.ATTRIBUTE10,
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
pvs.EMAIL_ADDRESS,
XX_GET_HR_OPERATING_UNIT(:p_org_id) ,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE,
MP.ORGANIZATION_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
pla.attribute15,
TO_CHAR(NULL),
pla.ATTRIBUTE5,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0),
TO_CHAR(NULL),
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
'' ,
'' ,
mst.item_code,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0),
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by),
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13, 
--PHA.ATTRIBUTE15,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'),
null, 
pha.REVISION_NUM,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE) 
 order by line_num
 
 
 --===================================================
 -- CS Report  KSRM      Parameter: Orgid: 81 rqfno: 16001
 --===================================================
 
 
 SELECT PRFQ.PO_HEADER_ID,
       DECODE (pol.unit_price*nvl(pha.rate,1),
               MIN (pol.unit_price*nvl(pha.rate,1)) OVER (PARTITION BY pol.item_id), 'Y',
               'N'
              ) price_ev, APT.NAME  TERM_NAME,
      prfq.po_line_id,
      PHA.CURRENCY_CODE,
      PRFQ.QUOTE_TYPE,
      PRFQ.COMMENTS,
       XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY(POL.PO_LINE_ID,:P_ORG_ID)+NVL(PLL_QTY,0) qty_req,
       prfq.rfq_num rfq_num, 
      TO_CHAR(prfq.rfq_cret_dt,'DD-MON-RRRR') rfq_cret_dt, 
       XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(prfq.rfq_cret_dt,prfq.created_by) Prepared_by,
       --XX_P2P_EMP_INFO.xx_P2P_GET_EMPNP_MAIL(substr(pha.attribute12,1,11),to_number(substr(pha.attribute12,13,50))) Checked_by,
       null Checked_by, 
       --XX_P2P_EMP_INFO.xx_P2P_GET_EMPNP_MAIL(substr(pol.attribute12,1,11),to_number(substr(pol.attribute12,13,50))) Approved_by,
       null Approved_by,
       POL.ATTRIBUTE7 USE_AREA,
           POL.ATTRIBUTE1 BRAND,  
           POL.ATTRIBUTE2 ORIGIN,  
           POL.ATTRIBUTE8 MAKE,  
        -- pol.ATTRIBUTE5 Discount,
         PHA.QUOTE_VENDOR_QUOTE_NUMBER SUPP_QUOTE,
         pol.ATTRIBUTE5 Discount_pri,
       -- ROUND((pol.unit_price*nvl(pha.rate,1)) * (nvl(pol.ATTRIBUTE8,0)/100),3) Discount_pri,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION(POL.PO_LINE_ID,:P_ORG_ID) requisition_num_c,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_DT(POL.PO_LINE_ID,:P_ORG_ID) pr_creation,
        pha.segment1||CHR(10)||DECODE(NVL(PHA.ATTRIBUTE8,'NA'),'NA',PHA.QUOTE_VENDOR_QUOTE_NUMBER,'SQ-'||PHA.QUOTE_VENDOR_QUOTE_NUMBER) quotation_no,
       --pha.segment1||CHR(10)||'SQ-'|| NVL(PHA.ATTRIBUTE8,'NO Ref') quotation_no, 
       pd.item_code, pol.item_description,
       TO_CHAR(TO_DATE(SUBSTR(pol.attribute3,1,11),'YYYY MM DD'),'DD-MON-RRRR') DEL_DATE,
        muom.uom_code uom,
        (pol.unit_price*nvl(pha.rate,1)) unit_price,
       pov.vendor_name,
        DECODE(NVL(XX_QUOTE_APP_REASON (POL.PO_LINE_ID),'X'),'X','Not Approved','Approved') item_approved, 
     --  pol.note_to_vendor note_to_supplier,
       XX_QUOTE_APP_REASON (POL.PO_LINE_ID) note_to_supplier,
       XX_QUOTE_APP_COMMENTS (POL.PO_LINE_ID) approved_comments,
       plt.line_type,
       pov.vendor_name || ' [' || pov.segment1
       || ']' vendor_name_vendor_number,
       pvs.vendor_site_code vendor_site,POL.ITEM_ID,
       pol.note_to_vendor specifications --new
      -- decode(price_ev,'Y',pol.unit_price*nvl(pha.rate,1),0) selected_price
  FROM (SELECT poh.po_header_id, POH.ATTRIBUTE1,POH.QUOTE_TYPE_LOOKUP_CODE||' RFQ' QUOTE_TYPE,POH.COMMENTS,
                             poh.segment1 rfq_num,
                             poh.created_by,
                             POl.po_line_id, 
                             TRUNC (poh.creation_date) rfq_cret_dt
          FROM po_headers_all poh, po_lookup_codes plc,PO_LINES_ALL POL
         WHERE poh.type_lookup_code = 'RFQ'
          AND poh.status_lookup_code IN ('A', 'I', 'P')
           AND poh.status_lookup_code = plc.lookup_code
         AND plc.lookup_type = 'RFQ/QUOTE STATUS'
           AND POH.PO_HEADER_ID=POL.PO_HEADER_ID  
           AND (:p_rfq_no iS NULL or POH.PO_HEADER_ID = :p_rfq_no)
           AND  (:p_org_id IS NULL OR poh.org_id = :p_org_id)
                      ) prfq,
       po_headers_all pha,
       AP_TERMS APT,
       po_lookup_codes plc,
       mtl_units_of_measure_tl muom,
       po_lines_all pol,
       po_line_types plt,
       AP_SUPPLIERS pov,
       AP_SUPPLIER_sites_ALL pvs,
       HR_OPERATING_UNITS HRO,
       (SELECT inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4 item_code
                   FROM mtl_system_items
                   GROUP BY inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4) pd,
       (SELECT NVL(SUM(NVL(QUANTITY,0)),0) PLL_QTY,PO_HEADER_ID,PO_LINE_ID
            FROM PO_LINE_LOCATIONS_ALL
            WHERE ATTRIBUTE1 IS NULL
            GROUP BY PO_HEADER_ID,PO_LINE_ID) PLL                 
 WHERE prfq.po_header_id = pha.from_header_id
   AND prfq.po_line_id=POL.FROM_LINE_ID
   AND pha.type_lookup_code = 'QUOTATION'
   AND PHA.ORG_ID=POL.ORG_ID 
   AND PHA.ORG_ID=HRO.ORGANIZATION_ID
 AND pha.status_lookup_code IN ('A', 'I', 'P')
   AND pha.status_lookup_code = plc.lookup_code
  AND plc.lookup_type = 'RFQ/QUOTE STATUS'
   AND pha.po_header_id = pol.po_header_id
   AND POL.PO_HEADER_ID=PLL.PO_HEADER_ID(+)
   AND POL.PO_LINE_ID=PLL.PO_LINE_ID(+)
   AND pha.org_id = :p_org_id
   AND pol.line_type_id = plt.line_type_id
   AND POV.VENDOR_ID=PVS.VENDOR_ID
   AND pol.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND pov.vendor_id = pha.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id(+)
   AND pol.item_id = pd.inventory_item_id
   AND PHA.TERMS_ID(+)=APT.TERM_ID
   AND PRFQ.QUOTE_TYPE='BID RFQ'
  AND (:p_rfq_no IS NULL OR prfq.po_header_id = :p_rfq_no)
 AND POL.ITEM_ID=NVL(:P_ITEM_ID,POL.ITEM_ID)
   union all
   SELECT PRFQ.PO_HEADER_ID,
   DECODE (pol.unit_price*nvl(pha.rate,1),
               MIN (pol.unit_price*nvl(pha.rate,1)) OVER (PARTITION BY pol.item_id), 'Y',
               'N'
              ) price_ev, APT.NAME  TERM_NAME,
      prfq.po_line_id,
      PHA.CURRENCY_CODE,
      PRFQ.QUOTE_TYPE,
      PRFQ.COMMENTS,
       XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY(POL.PO_LINE_ID,:P_ORG_ID) qty_req,
       prfq.rfq_num rfq_num, 
      TO_CHAR(prfq.rfq_cret_dt,'DD-MON-RRRR') rfq_cret_dt, 
        XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(prfq.rfq_cret_dt,prfq.created_by) Prepared_by,
      -- XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(substr(pha.attribute12,1,11),to_number(substr(pha.attribute12,13,50))) Checked_by,
      null Checked_by,
      -- XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(substr(pol.attribute12,1,11),to_number(substr(pol.attribute12,13,50))) Approved_by,
     null Approved_by,
       POL.ATTRIBUTE7 USE_AREA, 
           POL.ATTRIBUTE1 BRAND,  
           POL.ATTRIBUTE2 ORIGIN,  
           POL.ATTRIBUTE8 MAKE, 
    --     pol.ATTRIBUTE5 Discount,
          PHA.QUOTE_VENDOR_QUOTE_NUMBER SUPP_QUOTE,
            pol.ATTRIBUTE5 Discount_pri,
     --   ROUND((pol.unit_price*nvl(pha.rate,1)) * (nvl(pol.ATTRIBUTE8,0)/100),3) Discount_pri,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION(POL.PO_LINE_ID,:P_ORG_ID) requisition_num_c,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_DT(POL.PO_LINE_ID,:P_ORG_ID) pr_creation,
       pha.segment1||CHR(10)||DECODE(NVL(PHA.QUOTE_VENDOR_QUOTE_NUMBER,'NA'),'NA',PHA.QUOTE_VENDOR_QUOTE_NUMBER,'SQ-'||PHA.QUOTE_VENDOR_QUOTE_NUMBER) quotation_no, pd.item_code, pol.item_description,
       TO_CHAR(TO_DATE(SUBSTR(pol.attribute6,1,11),'YYYY MM DD'),'DD-MON-RRRR') DEL_DATE,
        muom.uom_code uom,
        (pol.unit_price*nvl(pha.rate,1)) unit_price,
       pov.vendor_name, 
       DECODE(NVL(XX_QUOTE_APP_REASON (POL.PO_LINE_ID),'X'),'X','Not Approved','Approved') item_approved,
     --  pol.note_to_vendor note_to_supplier,
     XX_QUOTE_APP_REASON (POL.PO_LINE_ID) note_to_supplier,
          XX_QUOTE_APP_COMMENTS (POL.PO_LINE_ID) approved_comments,
       plt.line_type,
       pov.vendor_name || ' [' || pov.segment1
       || ']' vendor_name_vendor_number,
       pvs.vendor_site_code vendor_site,POL.ITEM_ID,
       pol.note_to_vendor specifications --new
       --decode(price_ev,'Y',pol.unit_price*nvl(pha.rate,1),0) selected_price
  FROM (SELECT poh.po_header_id, POH.ATTRIBUTE1,POH.QUOTE_TYPE_LOOKUP_CODE||' RFQ' QUOTE_TYPE,POH.COMMENTS,
                             poh.segment1 rfq_num,
                             POl.po_line_id, 
                             poh.created_by,
                             TRUNC (poh.creation_date) rfq_cret_dt
          FROM po_headers_all poh, po_lookup_codes plc,PO_LINES_ALL POL
         WHERE poh.type_lookup_code = 'RFQ'
           AND poh.status_lookup_code IN ('A', 'I', 'P')
           AND poh.status_lookup_code = plc.lookup_code
           AND plc.lookup_type = 'RFQ/QUOTE STATUS'
           AND POH.PO_HEADER_ID=POL.PO_HEADER_ID  
      AND (:p_rfq_no iS NULL or POH.PO_HEADER_ID = :p_rfq_no)
        AND (:p_org_id IS NULL OR poh.org_id = :p_org_id)
                    ) prfq,
       po_headers_all pha,
       AP_TERMS APT,
       po_lookup_codes plc,
       mtl_units_of_measure_tl muom,
       po_lines_all pol,
       po_line_types plt,
       AP_SUPPLIERS pov,
       AP_SUPPLIER_sites_ALL pvs,
       HR_OPERATING_UNITS HRO,
       (SELECT inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4 item_code
                   FROM mtl_system_items
                   group by inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4) pd
 WHERE prfq.po_header_id = pha.from_header_id
   AND prfq.po_line_id=POL.FROM_LINE_ID
   AND pha.type_lookup_code = 'QUOTATION'
   AND PHA.ORG_ID=POL.ORG_ID 
   AND PHA.ORG_ID=HRO.ORGANIZATION_ID
   AND pha.status_lookup_code IN ('A', 'I', 'P')
   AND pha.status_lookup_code = plc.lookup_code
   AND plc.lookup_type = 'RFQ/QUOTE STATUS'
   AND pha.po_header_id = pol.po_header_id
 AND  (:p_org_id IS NULL OR pha.org_id = :p_org_id)
   AND pol.line_type_id = plt.line_type_id
   AND POV.VENDOR_ID=PVS.VENDOR_ID
   AND pol.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND pov.vendor_id = pha.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id(+)
   AND pol.item_id = pd.inventory_item_id
   AND PHA.TERMS_ID(+)=APT.TERM_ID
   AND PRFQ.QUOTE_TYPE='STANDARD RFQ'
 AND (:p_rfq_no iS NULL or PHA.PO_HEADER_ID = :p_rfq_no)
  AND POL.ITEM_ID=NVL(:P_ITEM_ID,POL.ITEM_ID)
  order by 19 asc
  
  
  ---=========================================
  -- PURCHASE ORDER KSRM   (Check --> ORG_ID: 81 , PO NO: 31001)
  --=========================================
  
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
'Date :'||TO_CHAR (pha.APPROVED_DATE, 'FMMonth DD, YYYY') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
ood.ORGANIZATION_CODE destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2 Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
XX_GET_HR_OPERATING_UNIT(:p_org_id) Org_header_name, 
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,  
MP.ORGANIZATION_CODE IO,
XX_P2P_PKG.LC_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') release_date, 
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
'' css_no,
'' css_date,
pla.attribute1 brand,
pla.attribute2 origin,               
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
                   mtl_parameters MP
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id 
   AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pha.org_id = :p_org_id
   AND pha.po_header_id = :p_po_no
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1,
pla.ATTRIBUTE5,
PLA.ATTRIBUTE11,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY'), 
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
'Date :'||TO_CHAR (pha.APPROVED_DATE, 'FMMonth DD, YYYY'),
PHA.CURRENCY_CODE,
PHA.RATE,
PHA.ATTRIBUTE10,
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_CODE,
pvs.EMAIL_ADDRESS,
--xx_com_pkg.get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
'',
'',
mst.item_code,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by),
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
--PHA.ATTRIBUTE15,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'), 
PLA.UNIT_PRICE-NVL((NVL(NVL(PLA.ATTRIBUTE11,0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0),
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0)*(pll.quantity),
pha.REVISION_NUM,
PLA.UNIT_PRICE,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE)
UNION ALL
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPE, 
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
'Date :'||TO_CHAR (pha.APPROVED_DATE, 'FMMonth DD, YYYY') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
NULL destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2 Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
XX_GET_HR_OPERATING_UNIT(:p_org_id) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_CODE IO,
--(select organization_code from mtl_parameters where ORGANIZATION_ID=pll.ship_to_organization_id) IO,
TO_CHAR(NULL) LC_NO,
TO_NUMBER(NULL) release_num,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') rel_dt,
null,
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
'' css_no,
'' css_date,
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pla.attribute1 brand,
pla.attribute2 origin,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       PO_LINE_LOCATIONS_ALL PLL,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1, 
       (SELECT inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        )) mst,
                        mtl_parameters MP
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND UPPER(pll.SHIPMENT_TYPE)='PRICE BREAK'
   AND pha.org_id = :p_org_id
  AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
   AND pha.po_header_id = :p_po_no
   --AND 1=nvl2(:p_release,900,1)
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND :p_release IS NULL
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE, 
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1,
TO_CHAR (pha.creation_date, 'FMMonth DD, YYYY'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE3,
'Date :'||TO_CHAR (pha.APPROVED_DATE, 'FMMonth DD, YYYY'),
PHA.CURRENCY_CODE,
PHA.RATE,
PHA.ATTRIBUTE10,
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
pvs.EMAIL_ADDRESS,
XX_GET_HR_OPERATING_UNIT(:p_org_id) ,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE,
MP.ORGANIZATION_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
TO_CHAR(NULL),
pla.ATTRIBUTE5,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0),
TO_CHAR(NULL),
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
'' ,
'' ,
mst.item_code,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0),
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by),
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13, 
--PHA.ATTRIBUTE15,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'),
null, 
pha.REVISION_NUM,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE) 
 order by line_num
 
-- ====================================================
-- EBS Purchase Requisition Report  KSRM
--====================================================

SELECT prh.requisition_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       prl.ATTRIBUTE9 Department,
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (SELECT DESCRIPTION||' ('||FLEX_VALUE||')' FROM FND_FLEX_VALUES_VL WHERE     FLEX_VALUE_SET_ID =1016512 AND PRH.ATTRIBUTE1=FND_FLEX_VALUES_VL.FLEX_VALUE) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id,
       mst.item_code,
       mst.description,
       prl.QUANTITY Unit,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
       paaf.job_id,
       pj.NAME,
       pj.job_definition_id,
      -- pjd.segment1 department,
       prL.ATTRIBUTE3 Use_of_Area,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
       substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID) dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION 
  FROM po_requisition_headers_all prh,
       po_requisition_lines_all prl,
       mtl_units_of_measure_tl muom,
       per_people_f ppf,
       per_all_assignments_f paaf,
       per_jobs pj,
       per_job_definitions pjd,
       ORG_ORGANIZATION_DEFINITIONS HRO,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '.' || segment2 || '.' || segment3
                        ) item_code
                   FROM mtl_system_items_b) mst,
        hr_operating_units HOU           
 WHERE prh.requisition_header_id = prl.requisition_header_id
   AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND prh.preparer_id = ppf.person_id
   AND prh.preparer_id = paaf.person_id
  AND HRL.LOCATION_ID=DELIVER_TO_LOCATION_ID
  AND HRL1.LOCATION_ID=PAAF.LOCATION_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  AND PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
  AND HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID 
   AND prl.item_id = mst.inventory_item_id
   AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
   and prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
 AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
 AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  --AND MST.item_code BETWEEN NVL(:P_ITEM_From,MST.item_code) AND NVL(:P_ITEM_To,MST.item_code)
 AND nvl(PRL.ATTRIBUTE9,'x')=nvl(:P_DEPT,nvl(PRL.ATTRIBUTE9,'x'))
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
   AND TRUNC(prh.creation_date) BETWEEN  nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date)) 
ORDER BY PRL.REQUISITION_LINE_ID


--=================================================
--Purchase Requisition Summary KSRM
--=================================================
SELECT prh.requisition_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       ppg.segment2 Department,
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (SELECT DESCRIPTION||' ('||FLEX_VALUE||')' FROM FND_FLEX_VALUES_VL WHERE     FLEX_VALUE_SET_ID =1016512 AND PRH.ATTRIBUTE1=FND_FLEX_VALUES_VL.FLEX_VALUE) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id,
       mst.item_code,
       mst.description,
       prl.QUANTITY Unit,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
       paaf.job_id,
       pj.NAME,
       pj.job_definition_id,
      -- pjd.segment1 department,
       prL.ATTRIBUTE3 Use_of_Area,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
       substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID) dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION 
  FROM po_requisition_headers_all prh,
       po_requisition_lines_all prl,
       mtl_units_of_measure_tl muom,
       per_people_f ppf,
       per_all_assignments_f paaf,
       pay_people_groups ppg,
       per_jobs pj,
       per_job_definitions pjd,
       ORG_ORGANIZATION_DEFINITIONS HRO,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '.' || segment2 || '.' || segment3
                        ) item_code
                   FROM mtl_system_items_b) mst,
        hr_operating_units HOU           
 WHERE prh.requisition_header_id = prl.requisition_header_id
   AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND prh.preparer_id = ppf.person_id
   AND prh.preparer_id = paaf.person_id
  AND HRL.LOCATION_ID=DELIVER_TO_LOCATION_ID
  AND HRL1.LOCATION_ID=PAAF.LOCATION_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND ppg.people_group_id(+) = paaf.people_group_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  AND PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
  AND HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID 
   AND prl.item_id = mst.inventory_item_id
   AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
   and prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
 AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
 AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  --AND MST.item_code BETWEEN NVL(:P_ITEM_From,MST.item_code) AND NVL(:P_ITEM_To,MST.item_code)
 --AND nvl(PRL.ATTRIBUTE9,'x')=nvl(:P_DEPT,nvl(PRL.ATTRIBUTE9,'x'))
  AND nvl(ppg.segment2,'x')=nvl(:p_dept,nvl(ppg.segment2,'x'))
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
  -- AND TRUNC(prh.creation_date) BETWEEN  nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
--AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date)) 
AND TRUNC(PRH.CREATION_DATE) BETWEEN NVL(:P_F_PR_DT,TRUNC(PRH.CREATION_DATE)) AND NVL(:P_T_PR_DT,TRUNC(PRH.CREATION_DATE))
ORDER BY PRL.REQUISITION_LINE_ID

--===========================================================
--PR pending UAT KSRM
--===========================================================

--select * from po_requisition_headers_all
--where segment1= '10000047'


SELECT prh.requisition_header_id,
        prh.attribute_category,
        pha.po_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
        pha.segment1 po_no,
    --    pla.quantity po_qty,
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),      --old
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,     --old
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
   --    prl.ATTRIBUTE9 Department,     --old
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (SELECT DESCRIPTION||' ('||FLEX_VALUE||')' FROM FND_FLEX_VALUES_VL WHERE     FLEX_VALUE_SET_ID =1016512 AND PRH.ATTRIBUTE1=FND_FLEX_VALUES_VL.FLEX_VALUE) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id, 
       mst.item_code,
       mst.description,
       nvl(prl.QUANTITY,0) PR_QTY,
   --    (select QUANTITY_RECEIVED from po_line_locations_all plla where plla.po_line_id=pla.po_line_id and plla.line_location_id=pda.line_location_id) received_qty,
       rt.RECEIPT_QTY received_qty,
      rt.REJECTED_QTY quantity_rejected ,
      -- nvl(pda.quantity_delivered,0) quantity_delivered,
      RT.DELIVER_QTY quantity_delivered,
       nvl(pda.quantity_billed,0) quantity_billed,
       nvl(pda.quantity_cancelled,0) quantity_cancelled,
    --  (select quantity_rejected from po_line_locations_all plla where plla.po_line_id=pla.po_line_id and plla.line_location_id=pda.line_location_id) quantity_rejected,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,PRL.DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       --sum(rt.quantity) return_qty,
       rt.return_qty return_qty,
      -- prl.quantity-(select QUANTITY_RECEIVED from po_line_locations_all plla where plla.po_line_id=pla.po_line_id and plla.line_location_id=pda.line_location_id)+(select quantity_rejected from po_line_locations_all plla where plla.po_line_id=pla.po_line_id and plla.line_location_id=pda.line_location_id) PENDING_QTY1,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
       paaf.job_id,
       pj.NAME,
       pj.job_definition_id,
      -- pjd.segment1 department,
       prL.ATTRIBUTE3 Use_of_Area,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
     --  substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,  --new
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,   --old
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,     --old
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,      --old
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,        --old
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,     --old
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,     --old
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID)||' - '||HRO.ORGANIZATION_CODE dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION
  from po_requisition_headers_all prh
  left outer join po_requisition_lines_all prl
  on prh.requisition_header_id=prl.requisition_header_id
  AND prl.MODIFIED_BY_AGENT_FLAG is null
 -- AND TYPE_LOOKUP_CODE='PURCHASE'
  left outer join po_req_distributions_all prda
  on prl.requisition_line_id=prda.requisition_line_id
  left outer join po_distributions_all pda
  on prda.distribution_id=pda.req_distribution_id
  left outer join po_headers_all pha
  on pda.po_header_id=pha.po_header_id
 -- and PRH.AUTHORIZATION_STATUS= 'APPROVED'
  left outer join po_lines_all pla
  on pda.po_line_id=pla.po_line_id
  AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  left outer join per_people_f ppf
  on prh.preparer_id = ppf.person_id
  AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
  left outer join per_all_assignments_f paaf
  on prh.preparer_id = paaf.person_id
  AND ppf.person_id = paaf.person_id
  AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
  left outer join mtl_units_of_measure_tl muom
  on PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE
  left outer join per_jobs pj
  on paaf.job_id = pj.job_id
  left outer join per_job_definitions pjd
  on pj.job_definition_id = pjd.job_definition_id
  left outer join ORG_ORGANIZATION_DEFINITIONS HRO
  on prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
  left outer join HR_LOCATIONS_ALL HRL
  on prl.DELIVER_TO_LOCATION_ID=HRL.LOCATION_ID
  left outer join HR_LOCATIONS_ALL HRL1
  on PAAF.LOCATION_ID=HRL1.LOCATION_ID
  left outer join (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '.' || segment2 || '.' || segment3|| '.' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst
  on prl.item_id = mst.inventory_item_id
  AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
  left outer join hr_operating_units HOU
  on HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID
  left outer join ( SELECT DISTINCT  PO_HEADER_ID,PO_LINE_ID,SUM(RECEIPT_QTY) RECEIPT_QTY,  SUM(ACCEPTED_QTY) ACCEPTED_QTY, SUM(REJECTED_QTY) REJECTED_QTY,
                         SUM( RETURN_QTY) RETURN_QTY,SUM(DELIVER_QTY) DELIVER_QTY 
                        FROM WBI_INV_RCV_TRANSACTIONS_F 
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY PO_HEADER_ID,PO_LINE_ID) RT
  on pha.po_header_id=rt.po_header_id
  and pla.po_line_id=rt.po_line_id
 -- and pha.po_header_id IS NOT NULL
 where UPPER(NVL(PRL.ATTRIBUTE_CATEGORY,0)) NOT IN ('BRANDING')
 AND UPPER(NVL(PRH.ATTRIBUTE_CATEGORY,0)) NOT IN ('SHIPPING_INFO')
 AND TRUNC(prh.creation_date) BETWEEN NVL(:P_F_PR_DT,TRUNC(prh.creation_date)) AND NVL(:P_T_PR_DT,TRUNC(prh.creation_date))
-- AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1)
AND prh.requisition_header_id=NVL(:P_REQ_NO,prh.requisition_header_id)
 AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
 AND PRH.TYPE_LOOKUP_CODE='PURCHASE' 
 AND PRH.AUTHORIZATION_STATUS =nvl(:p_status,PRH.AUTHORIZATION_STATUS)
 AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)
 AND pha.po_header_id is null
  --======================================================
  --EBS PR Pending Summary Report (Main Query)
 --Date: 23-DEC-2018
 --======================================================
 
 SELECT prh.requisition_header_id,
        pha.po_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
        (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3 and IUA.use_area_type='XXKSRM_USE_AREA') Use_of_Area,
        pha.segment1 po_no,
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (SELECT DESCRIPTION||' ('||FLEX_VALUE||')' FROM FND_FLEX_VALUES_VL WHERE     FLEX_VALUE_SET_ID =1016512 AND PRH.ATTRIBUTE1=FND_FLEX_VALUES_VL.FLEX_VALUE) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id, 
       mst.item_code,
       mst.description,
       nvl(prl.QUANTITY,0) PR_QTY,
   pll.LINE_LOCATION_ID,
       PLL.QUANTITY_RECEIVED received_qty_pll,
       RT.RECEIPT_QTY RECEIVED_QTY,
        RT.RECEIPT_QTY1 RECEIVED_QTY1,
      PLL.QUANTITY_REJECTED quantity_rejected ,
      RT.DELIVER_QTY quantity_delivered,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,PRL.DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       rt.return_qty return_qty,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
      paaf.job_id,
       pj.NAME,
      pj.job_definition_id,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID)||' - '||HRO.ORGANIZATION_CODE dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION,
                     to_char(:P_F_PR_DT,'DD-MON-RRRR') from_date,
       to_char(:P_T_PR_DT,'DD-MON-RRRR') to_datee
  from po_requisition_headers_all prh
  left outer join po_requisition_lines_all prl
  on prh.requisition_header_id=prl.requisition_header_id
  AND prl.MODIFIED_BY_AGENT_FLAG is null
  left outer join po_req_distributions_all prda
  on prl.requisition_line_id=prda.requisition_line_id
 left outer join (SELECT pda.PO_DISTRIBUTION_ID,pda.line_location_id,pda.po_header_id,pda.po_line_id,pda.REQ_DISTRIBUTION_ID,pda.REQ_HEADER_REFERENCE_NUM,pda.REQ_LINE_REFERENCE_NUM,plla.attribute1,plla.attribute2 
               FROM po_distributions_all pda,PO_LINE_LOCATIONS_ALL plla
               where pda.line_location_id=plla.line_location_id) pda
  on prh.REQUISITION_header_ID=pda.attribute1
  and prl.line_num=pda.attribute2
  or prda.distribution_id=pda.req_distribution_id
  left outer join po_headers_all pha
  on pda.po_header_id=pha.po_header_id
 -- and PRH.AUTHORIZATION_STATUS= 'APPROVED'
  left outer join po_lines_all pla
  on pda.po_line_id=pla.po_line_id
  AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  left outer join per_people_f ppf
  on prl.TO_PERSON_ID = ppf.person_id
  AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
  left outer join per_all_assignments_f paaf
  on prl.TO_PERSON_ID = paaf.person_id
  AND ppf.person_id = paaf.person_id
  AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
  left outer join mtl_units_of_measure_tl muom
  on PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE
  left outer join per_jobs pj
  on paaf.job_id = pj.job_id
  left outer join per_job_definitions pjd
  on pj.job_definition_id = pjd.job_definition_id
  left outer join ORG_ORGANIZATION_DEFINITIONS HRO
  on prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
  left outer join HR_LOCATIONS_ALL HRL
  on prl.DELIVER_TO_LOCATION_ID=HRL.LOCATION_ID
  left outer join HR_LOCATIONS_ALL HRL1
  on PAAF.LOCATION_ID=HRL1.LOCATION_ID
  left outer join (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst
  on prl.item_id = mst.inventory_item_id
  AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
  left outer join hr_operating_units HOU
  on HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID
  left outer join ( SELECT DISTINCT  PO_HEADER_ID,PO_LINE_ID,SUM(RECEIPT_QTY)-(NVL(SUM( RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) RECEIPT_QTY,SUM(RECEIPT_QTY) RECEIPT_QTY1,  SUM(ACCEPTED_QTY) ACCEPTED_QTY, SUM(REJECTED_QTY) REJECTED_QTY,(NVL(SUM( RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) RETURN_QTY,
                         (SUM(DELIVER_QTY)-NVL(SUM(DLV_RETURN_QTY),0)) DELIVER_QTY,LINE_LOCATION_ID
                        FROM INV_RCV_TRANSACTIONS_P2P_VW 
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY PO_HEADER_ID,PO_LINE_ID,LINE_LOCATION_ID) RT
  on pha.po_header_id=rt.po_header_id
  and pla.po_line_id=rt.po_line_id
  and pda.LINE_LOCATION_ID=rt.LINE_LOCATION_ID
 -- and pha.po_header_id IS NOT NULL
 LEFT OUTER JOIN PO_LINE_LOCATIONS PLL
 ON PHA.PO_HEADER_ID=PLL.PO_HEADER_ID
 AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
 AND RT.PO_HEADER_ID=PLL.PO_HEADER_ID
 AND RT.PO_LINE_ID=PLL.PO_LINE_ID
 AND RT.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID
 AND PDA.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID
 LEFT OUTER JOIN pay_people_groups ppg
 ON paaf.people_group_id=ppg.people_group_id
 LEFT OUTER JOIN PER_all_positions pp
 ON paaf.position_id=pp.position_id
 LEFT OUTER JOIN  PER_position_definitions pd
 ON pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
where UPPER(NVL(PRL.ATTRIBUTE_CATEGORY,0)) NOT IN ('BRANDING')
AND UPPER(NVL(PRH.ATTRIBUTE_CATEGORY,0)) NOT IN ('SHIPPING_INFO')
AND nvl(prl.CANCEL_FLAG,'N')= ('N')
AND TRUNC(prh.creation_date) BETWEEN NVL(:P_F_PR_DT,TRUNC(prh.creation_date)) AND NVL(:P_T_PR_DT,TRUNC(prh.creation_date))
-- AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1)
AND prh.requisition_header_id=NVL(:P_REQ_NO,prh.requisition_header_id)
--AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org, PRL.DESTINATION_ORGANIZATION_ID)
AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
AND PRH.TYPE_LOOKUP_CODE='PURCHASE' 
AND PRH.AUTHORIZATION_STATUS =nvl(:p_status,PRH.AUTHORIZATION_STATUS)
AND PRH.AUTHORIZATION_STATUS='APPROVED'
AND  upper(prh.attribute15) =upper( NVL(:P_PRIORITY,  prh.attribute15))
AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)
AND (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3)-- and use_area_type='XXKSRM_USE_AREA') 
=NVL(:P_USE_OF_AREA, (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3))-- and use_area_type='XXKSRM_USE_AREA'))
 
 
 
 --======================================================
   --EBS PR Pending Summary Report
 -- This query is updated to omit the 0 value when pending qty is 0 it will not show in the report
 --Date: 23-DEC-2018
  --=======================================================
  
 SELECT prh.requisition_header_id,
        pha.po_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
        (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3 and IUA.use_area_type='XXKSRM_USE_AREA') Use_of_Area,
        pha.segment1 po_no,
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (SELECT DESCRIPTION||' ('||FLEX_VALUE||')' FROM FND_FLEX_VALUES_VL WHERE     FLEX_VALUE_SET_ID =1016512 AND PRH.ATTRIBUTE1=FND_FLEX_VALUES_VL.FLEX_VALUE) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id, 
       mst.item_code,
       mst.description,
       nvl(prl.QUANTITY,0) PR_QTY,
   pll.LINE_LOCATION_ID,
       PLL.QUANTITY_RECEIVED received_qty_pll,
       RT.RECEIPT_QTY RECEIVED_QTY,
        RT.RECEIPT_QTY1 RECEIVED_QTY1,
      PLL.QUANTITY_REJECTED quantity_rejected ,
      RT.DELIVER_QTY quantity_delivered,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,PRL.DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       --xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
      -- NVL(nvl(prl.QUANTITY,0) - (RT.RECEIPT_QTY1 +  rt.return_qty),prl.QUANTITY)PENDING_QTY,
       rt.return_qty return_qty,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,PRH.CREATION_DATE) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
      paaf.job_id,
       pj.NAME,
      pj.job_definition_id,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID)||' - '||HRO.ORGANIZATION_CODE dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION,
                     to_char(:P_F_PR_DT,'DD-MON-RRRR') from_date,
       to_char(:P_T_PR_DT,'DD-MON-RRRR') to_datee
  from po_requisition_headers_all prh
  left outer join po_requisition_lines_all prl
  on prh.requisition_header_id=prl.requisition_header_id
  AND prl.MODIFIED_BY_AGENT_FLAG is null
  left outer join po_req_distributions_all prda
  on prl.requisition_line_id=prda.requisition_line_id
 left outer join (SELECT pda.PO_DISTRIBUTION_ID,pda.line_location_id,pda.po_header_id,pda.po_line_id,pda.REQ_DISTRIBUTION_ID,pda.REQ_HEADER_REFERENCE_NUM,pda.REQ_LINE_REFERENCE_NUM,plla.attribute1,plla.attribute2 
               FROM po_distributions_all pda,PO_LINE_LOCATIONS_ALL plla
               where pda.line_location_id=plla.line_location_id) pda
  on prh.REQUISITION_header_ID=pda.attribute1
  and prl.line_num=pda.attribute2
  or prda.distribution_id=pda.req_distribution_id
  left outer join po_headers_all pha
  on pda.po_header_id=pha.po_header_id
 -- and PRH.AUTHORIZATION_STATUS= 'APPROVED'
  left outer join po_lines_all pla
  on pda.po_line_id=pla.po_line_id
  AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  left outer join per_people_f ppf
  on prl.TO_PERSON_ID = ppf.person_id
  AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
  left outer join per_all_assignments_f paaf
  on prl.TO_PERSON_ID = paaf.person_id
  AND ppf.person_id = paaf.person_id
  AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
  left outer join mtl_units_of_measure_tl muom
  on PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE
  left outer join per_jobs pj
  on paaf.job_id = pj.job_id
  left outer join per_job_definitions pjd
  on pj.job_definition_id = pjd.job_definition_id
  left outer join ORG_ORGANIZATION_DEFINITIONS HRO
  on prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
  left outer join HR_LOCATIONS_ALL HRL
  on prl.DELIVER_TO_LOCATION_ID=HRL.LOCATION_ID
  left outer join HR_LOCATIONS_ALL HRL1
  on PAAF.LOCATION_ID=HRL1.LOCATION_ID
  left outer join (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst
  on prl.item_id = mst.inventory_item_id
  AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
  left outer join hr_operating_units HOU
  on HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID
  left outer join ( SELECT DISTINCT  PO_HEADER_ID,PO_LINE_ID,SUM(RECEIPT_QTY)-(NVL(SUM( RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) RECEIPT_QTY,SUM(RECEIPT_QTY) RECEIPT_QTY1,  SUM(ACCEPTED_QTY) ACCEPTED_QTY, SUM(REJECTED_QTY) REJECTED_QTY,(NVL(SUM( RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) RETURN_QTY,
                         (SUM(DELIVER_QTY)-NVL(SUM(DLV_RETURN_QTY),0)) DELIVER_QTY,LINE_LOCATION_ID
                        FROM INV_RCV_TRANSACTIONS_P2P_VW 
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY PO_HEADER_ID,PO_LINE_ID,LINE_LOCATION_ID) RT
  on pha.po_header_id=rt.po_header_id
  and pla.po_line_id=rt.po_line_id
  and pda.LINE_LOCATION_ID=rt.LINE_LOCATION_ID
 -- and pha.po_header_id IS NOT NULL
 LEFT OUTER JOIN PO_LINE_LOCATIONS PLL
 ON PHA.PO_HEADER_ID=PLL.PO_HEADER_ID
 AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
 AND RT.PO_HEADER_ID=PLL.PO_HEADER_ID
 AND RT.PO_LINE_ID=PLL.PO_LINE_ID
 AND RT.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID
 AND PDA.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID
 LEFT OUTER JOIN pay_people_groups ppg
 ON paaf.people_group_id=ppg.people_group_id
 LEFT OUTER JOIN PER_all_positions pp
 ON paaf.position_id=pp.position_id
 LEFT OUTER JOIN  PER_position_definitions pd
 ON pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
where UPPER(NVL(PRL.ATTRIBUTE_CATEGORY,0)) NOT IN ('BRANDING')
AND UPPER(NVL(PRH.ATTRIBUTE_CATEGORY,0)) NOT IN ('SHIPPING_INFO')
AND nvl(prl.CANCEL_FLAG,'N')= ('N')
AND TRUNC(prh.creation_date) BETWEEN NVL(:P_F_PR_DT,TRUNC(prh.creation_date)) AND NVL(:P_T_PR_DT,TRUNC(prh.creation_date))
-- AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1)
AND prh.requisition_header_id=NVL(:P_REQ_NO,prh.requisition_header_id)
--AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org, PRL.DESTINATION_ORGANIZATION_ID)
AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
AND PRH.TYPE_LOOKUP_CODE='PURCHASE' 
AND PRH.AUTHORIZATION_STATUS =nvl(:p_status,PRH.AUTHORIZATION_STATUS)
AND PRH.AUTHORIZATION_STATUS='APPROVED'
AND  upper(prh.attribute15) =upper( NVL(:P_PRIORITY,  prh.attribute15))
AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)
AND (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3)-- and use_area_type='XXKSRM_USE_AREA') 
=NVL(:P_USE_OF_AREA, (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3))-- and use_area_type='XXKSRM_USE_AREA'))
--- and  NVL(nvl(prl.QUANTITY,0) - (RT.RECEIPT_QTY1 +  rt.return_qty),prl.QUANTITY) <> 0  


--==========================================================================================

--====================================
--LC register report
-- LC ID : 10343
-- ORG  OU :  104
--DATE: 6-feb-2019
--========================================

SELECT ORG.Organization_code,
substr(XX_GET_HR_OPERATING_UNIT(:p_org),5) ORG_HEADER_NAME,
 LC.LC_NUMBER,
 LC.LC_OPENING_DATE,
LC. LC_AMDT_DATE,
RH.SHIPMENT_NUM,
LC.FOB_CF Del_terms, 
LC.Bank_name,
DECODE(LC.LC_TYPE,'D','Defferd','S','Sight','C','CAD','U','UPAS','T','TT',lc.lc_type) LC_TYPE,
ROUND(IND.GRN_DT-LC.LC_OPENING_DATE)LEAD_TIME,
POL.ITEM_DESCRIPTION,
XX_FND_EMP_NAME(POH.CREATED_BY) USER_NAME,
(LC.Supplier_Name||' ( '||    LC.Supplier_Number||') ')Supplier,
LC.SUPPLIER_BANK_NAME,
PLL.QUANTITY PO_QTY,
POL.UNIT_MEAS_LOOKUP_CODE UOM,
POL.LINE_NUM,
RL.QUANTITY_SHIPPED,
POL.UNIT_PRICE,
(PLL.QUANTITY)*POL.UNIT_PRICE Amount,
POH.CURRENCY_CODE,
 POH.SEGMENT1 PO_NO,
 to_char(POH.CREATION_DATE,'DD-MON-RRRR') CREATION_DATE,
 LC.PROFORMA_INVOICE_NUM PI_NO,
 LC.PROFORMA_INVOICE_DATE PI_Date,
 pol.Attribute2 origin,
 --DECODE(RH.ATTRIBUTE_CATEGORY,'Billet Receiving',RH.ATTRIBUTE14,NULL) ORIGIN,
 POH.Revision_num PO_AMEND_NO,
 LC.HS_CODE,
 --LCD.GRN_NO DEEP_SEA_GRN,
 RH.RECEIPT_NUM DEEP_SEA_GRN,
 LCD.GRN_QTY PORT_QTY,
 LCD.GRN_VALUE GRN_VALUE,
 PLL.QUANTITY-NVL(LCD.GRN_QTY,0) PENDING_QTY,
NVL(PLL.QUANTITY-NVL(LCD.GRN_QTY,0),0)*POL.UNIT_PRICE PENDING_QTY_VALUE,
 --to_char(PLL.NEED_BY_DATE,'DD-MON-RRRR') ETA,
 --to_char(PLL.PROMISED_DATE,'DD-MON-RRRR') ETD,
 LC.ETA,
 LC.ETD,
 DEL_QTY*POL.UNIT_PRICE FAC_GRN_VALUE,
 POH.RATE,
 nvl(NVL(PLL.QUANTITY,0)*NVL(POH.RATE,0)*NVL(POL.UNIT_PRICE,0),0) CONV_AMNT_BDT, 
 DEL_QTY FAC_QTY,
abs(LCD.GRN_QTY-PLL.QUANTITY) DEEP_SEA_ACCESS_QTY,
 DEL_DT Delivery_DT,
 LC.LATEST_SHIPMENT_DATE LSD,
-- SHA.ATTRIBUTE1 LSD,
      --  SHA.ATTRIBUTE2 EXP1,
      LC.LC_EXPIRE_DATE EXP1,
  --      SHA.ATTRIBUTE3 ETD,
    --    SHA.ATTRIBUTE4 ETA,
        SHA.ATTRIBUTE5 NON_ND,
        LCD.ORIGINAL_DOC_DATE ORG_DOC_DT,---?
        LCD.DUTY_PAID_DATE Duty_DT,
        LC.LCA_NO LCA_NO,
       LC.COVER_NO Cover_Note,
       LC.COVER_DATE Cover_DT,
       LCD.POLICY_NO POLICY_NO,
       LC.INSURANCE_NAME,
        LCD.BL_AWB_CONSIGNMENT_NO BL_NO,
        LCD.BL_AWB_CONSIGNMENT_DATE BL_DT,
        SHA.ATTRIBUTE13 Courier_NO,
        LCD.BILL_OF_ENTRY_NO BE_NO,
        LCD.BILL_OF_ENTRY_DATE BE_DT ,   
DECODE(LC.LC_STATUS,'O','Open','C','Closed') LC_STATUS,
LCD.COMMERCIAL_INVOICE_NO Commercial_Invoice_No,
 LCD.COMMERCIAL_INVOICE_DATE Commercial_Invoice_Date,
 LCD.VESSEL_NAME Air_Vessel_Name,
 LCD.PORT_OF_LOADING Port_of_Loading,
  LCD.ORIGINAL_DOC_DATE Original_Doc_Arrival_Date,
  LCD.MATURITY_DATE,
 LCD.ACCEPTANCE_DATE Acceptance_Date,
 RH.attribute9 Forwarding_Schedule_Date,---?
 LCD.ASSESSABLE_VALUE Assessable_Value,
 LCD.TOTAL_NO_PACKAGE Total_No_of_Package,
 RH.attribute3 Total_No_of_Items,
 LCD.GROSS_WEIGHT Gross_Weight,
 LCD.NET_WEIGHT Net_Weight,
 LCD.COUNTRY_OF_ORIGIN Country_of_Origin,
RT.ATTRIBUTE10 Lighter_Mother_Vessel,
RT.ATTRIBUTE11 Container_Number,
RT.ATTRIBUTE13 Container_Size,
RT.ATTRIBUTE14 Carrying_Contractor_Name,
RT.ATTRIBUTE2 Crane_Supplier,
LCD.CNF_NAME C_F_Agent,
RT.ATTRIBUTE15 C_F_Challan_No,
 (select vendor_name from ap_suppliers where vendor_id=:P_VENDOR_ID) P_SUPPLIER,
(SELECT distinct description from mtl_system_items_kfv WHERE inventory_item_id=:P_ITEM_ID) P_ITEM,
(select LC_NUMBER from XX_LC_DETAILS WHERE lc_id=:P_LC_ID) P_LC,
 (select distinct DECODE(LC_TYPE,'D','Defferd','S','Sight','C','CAD','U','UPAS','T','TT',lc_type) from XX_LC_DETAILS WHERE lc_type=:P_LC_TYPE) P_LC_TYPE,
(SELECT BANK_NAME FROM ce_banks_v where bank_party_id=:P_BANK_ID) P_BANK,
to_char(:P_FR_DT,'DD-MON-RRRR') from_date,
to_char(:P_TO_DT,'DD-MON-RRRR') to_datee
FROM PO_HEADERS_ALL POH
LEFT OUTER JOIN PO_LINES_ALL POL
ON POH.PO_HEADER_ID=POL.PO_HEADER_ID
AND POL.CANCEL_FLAG='N'
LEFT OUTER JOIN PO_LINE_LOCATIONS_ALL PLL
ON POL.PO_LINE_ID=PLL.PO_LINE_ID
LEFT OUTER JOIN xx_lc_details LC
ON POH.PO_HEADER_ID=LC.PO_HEADER_ID
LEFT OUTER JOIN xx_lc_details_dt LCD
ON LC.LC_ID=LCD.LC_ID
AND POL.ITEM_ID=LCD.ITEM_ID
LEFT OUTER JOIN INL_SHIP_HEADERS_ALL SHA
ON POH.ORG_ID =SHA.ORG_ID
LEFT OUTER JOIN INL_ADJ_SHIP_LINES_V SLA
ON SHA.SHIP_HEADER_ID=SLA.SHIP_HEADER_ID
AND POL.ITEM_ID=SLA.INVENTORY_ITEM_ID
AND SLA.SHIP_LINE_SOURCE_ID=PLL.LINE_LOCATION_ID
LEFT OUTER JOIN XX_IND_PAY_V IND
ON PLL.LINE_LOCATION_ID=IND.PO_LINE_LOCATION_ID
LEFT OUTER JOIN RCV_SHIPMENT_HEADERS RH
ON IND.SHIPMENT_HEADER_ID=RH.SHIPMENT_HEADER_ID
LEFT OUTER JOIN RCV_SHIPMENT_LINES RL
ON IND.SHIPMENT_LINE_ID=RL.SHIPMENT_LINE_ID
LEFT OUTER JOIN rcv_transactions rt
ON RH.SHIPMENT_HEADER_ID= RT.SHIPMENT_HEADER_ID
LEFT OUTER JOIN ORG_ORGANIZATION_DEFINITIONS ORG
ON PLL.SHIP_TO_ORGANIZATION_ID =ORG.ORGANIZATION_ID
WHERE  POH.type_lookup_code IN ('BLANKET','STANDARD')
AND NVL (UPPER (POH.authorization_status), 'INCOMPLETE') = 'APPROVED'
AND POH.ORG_ID=NVL(:P_ORG,POH.ORG_ID)
AND LC.VENDOR_ID=NVL(:P_VENDOR_ID, LC.VENDOR_ID)
AND POL.ITEM_ID=NVL(:P_ITEM_ID,POL.ITEM_ID)
AND LC.LC_ID=NVL(:P_LC_ID,LC.LC_ID)
AND LC.LC_TYPE=NVL(:P_LC_TYPE,LC.LC_TYPE)
AND LC.BANK_ID=NVL(:P_BANK_ID,LC.BANK_ID)
--AND LC.LC_ID BETWEEN NVL(:P_LC,LC.LC_ID) And NVL(:P_LC,LC.LC_ID)
AND TRUNC(LC.LC_OPENING_DATE) BETWEEN  nvl(:P_FR_DT, TRUNC(LC.LC_OPENING_DATE)) AND NVL(:P_TO_DT, TRUNC(LC.LC_OPENING_DATE))
GROUP BY ORG.Organization_code,
 LC.LC_NUMBER,
 LC.LC_OPENING_DATE,
LC. LC_AMDT_DATE,
RH.SHIPMENT_NUM,
LC.FOB_CF , 
LC.Bank_name,
LC.LC_TYPE,
ROUND(IND.GRN_DT-LC.LC_OPENING_DATE),
POL.ITEM_DESCRIPTION,
POH.CREATED_BY,
(LC.Supplier_Name||' ( '||    LC.Supplier_Number||') '),
LC.SUPPLIER_BANK_NAME,
PLL.QUANTITY ,
POL.UNIT_MEAS_LOOKUP_CODE ,
RL.QUANTITY_SHIPPED,
POL.UNIT_PRICE,
POH.CURRENCY_CODE,
 POH.SEGMENT1 ,
 to_char(POH.CREATION_DATE,'DD-MON-RRRR') ,
 LC.PROFORMA_INVOICE_NUM ,
 LC.PROFORMA_INVOICE_DATE ,
 pol.Attribute2 ,
 --DECODE(RH.ATTRIBUTE_CATEGORY,'Billet Receiving',RH.ATTRIBUTE14,NULL) ORIGIN,
 POH.Revision_num ,
 LC.HS_CODE,
 LCD.GRN_NO ,
 LCD.GRN_QTY ,
 LCD.GRN_VALUE ,
 PLL.QUANTITY-NVL(LCD.GRN_QTY,0) ,
NVL(PLL.QUANTITY-NVL(LCD.GRN_QTY,0),0)*POL.UNIT_PRICE ,
 --to_char(PLL.NEED_BY_DATE,'DD-MON-RRRR') ETA,
 --to_char(PLL.PROMISED_DATE,'DD-MON-RRRR') ETD,
 LC.ETA,
 LC.ETD,
 DEL_QTY*POL.UNIT_PRICE ,
 POH.RATE,
 PLL.QUANTITY*POH.RATE , 
 DEL_QTY ,
abs(LCD.GRN_QTY-PLL.QUANTITY) ,
 DEL_DT ,
LC.LATEST_SHIPMENT_DATE,
 --SHA.ATTRIBUTE1 ,
        SHA.ATTRIBUTE2 ,
  --      SHA.ATTRIBUTE3 ETD,
    --    SHA.ATTRIBUTE4 ETA,
        SHA.ATTRIBUTE5 ,
        LCD.ORIGINAL_DOC_DATE ,---?
        LCD.DUTY_PAID_DATE ,
        LC.LCA_NO ,
       LC.COVER_NO ,
       LC.COVER_DATE ,
       LCD.POLICY_NO ,
       LC.INSURANCE_NAME,
        LCD.BL_AWB_CONSIGNMENT_NO ,
        LCD.BL_AWB_CONSIGNMENT_DATE ,
        SHA.ATTRIBUTE13 ,
        LCD.BILL_OF_ENTRY_NO ,
        LCD.BILL_OF_ENTRY_DATE  ,   
DECODE(LC.LC_STATUS,'O','Open','C','Closed') ,
LCD.COMMERCIAL_INVOICE_NO ,
 LCD.COMMERCIAL_INVOICE_DATE ,
 LCD.VESSEL_NAME ,
 LCD.PORT_OF_LOADING ,
  LCD.ORIGINAL_DOC_DATE ,
  LCD.MATURITY_DATE,
 LCD.ACCEPTANCE_DATE ,
 RH.attribute9 ,---?
 LCD.ASSESSABLE_VALUE ,
 LCD.TOTAL_NO_PACKAGE ,
 RH.attribute3 ,
 LCD.GROSS_WEIGHT ,
 LCD.NET_WEIGHT ,
 LCD.COUNTRY_OF_ORIGIN ,
RT.ATTRIBUTE10 ,
RT.ATTRIBUTE11 ,
RT.ATTRIBUTE13 ,
RT.ATTRIBUTE14 ,
POL.LINE_NUM,
RT.ATTRIBUTE2 ,
LCD.CNF_NAME ,
 LC.LC_EXPIRE_DATE,
RT.ATTRIBUTE15 ,
RH.RECEIPT_NUM
 order by 2 DESC 
 
 --=============================================
 --PO TRANSECTION STATUS SUMMERY REPORT
 --=============================================
 
 SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
ood.ORGANIZATION_CODE destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE IO,
XX_P2P_PKG.LC_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') release_date, 
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
pla.attribute1 brand,
pla.attribute2 origin,               
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
                   mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pla.po_header_id=rt.PO_HEADER_ID(+)
    AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
 AND PDA.LINE_LOCATION_ID=PL.LINE_LOCATION_ID(+)---
   AND pla.po_line_id=rt.po_line_id(+)
  AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :p_org_id
   AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
   AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
   AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)
   AND PHA.AGENT_ID=NVL(:P_AGENT,PHA.AGENT_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE,
PLA.LINE_NUM, 
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
pla.ATTRIBUTE5,
PLA.ATTRIBUTE11,
MP.ORGANIZATION_ID ,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
pha.attribute6,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE,
pvs.EMAIL_ADDRESS,
--xx_com_pkg.get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
pla.attribute1,
pla.attribute2,
PLA.ATTRIBUTE3  ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
--PHA.ATTRIBUTE15,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'), 
PLA.UNIT_PRICE-NVL((NVL(NVL(PLA.ATTRIBUTE11,0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0),
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0)*(pll.quantity),
pha.REVISION_NUM,
PLA.UNIT_PRICE,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE),
RT.DELIVER_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY
UNION ALL
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
pha.authorization_status,
--PHA.ATTRIBUTE10 TERM_DAYS,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
NULL destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE IO,
--(select organization_code from mtl_parameters where ORGANIZATION_ID=pll.ship_to_organization_id) IO,
TO_CHAR(NULL) LC_NO,
TO_NUMBER(NULL) release_num,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') rel_dt,
null,
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
pla.attribute1 brand,
pla.attribute2 origin,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,
MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       PO_LINE_LOCATIONS_ALL PLL,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1, 
       (SELECT inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        )) mst,
                        mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND UPPER(pll.SHIPMENT_TYPE)='PRICE BREAK'
     AND pla.po_header_id=rt.PO_HEADER_ID(+)
   AND pla.po_line_id=rt.po_line_id(+)
      AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
       AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
    AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :p_org_id
      AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
  AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
   AND pha.po_header_id = :p_po_no
   --AND 1=nvl2(:p_release,900,1)
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND :p_release IS NULL
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
      AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)
      AND PHA.AGENT_ID=NVL(:P_AGENT,PHA.AGENT_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE, 
PLA.LINE_NUM,
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_ID ,
pvs.EMAIL_ADDRESS,
XX_GET_HR_OPERATING_UNIT(:p_org_id) ,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
MP.ORGANIZATION_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
pha.authorization_status,
TO_CHAR(NULL),
PLA.PO_LINE_ID,
pla.ATTRIBUTE5,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0),
TO_CHAR(NULL),
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0),
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13, 
--PHA.ATTRIBUTE15,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'),
null, 
pha.REVISION_NUM,
PLA.ATTRIBUTE3,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE) ,
RT.DELIVER_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY
order by RECEIPT_NO
 

--======================PO COMPLETED BUT NOT GRN OR Pertial GRN QUERY =============================

--PO completed but NOT GRN, OR Pertial GEN QUERY

SELECT
     XX_GET_HR_OPERATING_UNIT(POH.ORG_ID) Org_header_name,  
      POH.PO_HEADER_ID,
      poh.segment1 po_number,
      poh.type_lookup_code PO_TYPE,
     poh.AUTHORIZATION_STATUS,
     pol.CLOSED_CODE,
     poh.ATTRIBUTE1,
     pr.release_num,
     to_char(poh.creation_date, 'DD-MON-RRRR') poh_Creation_date,
     to_char(poh.approved_date, 'DD-MON-RRRR') poh_Approved_date,
      mp.organization_code inv_org,
      pol.item_id,
      (msi.segment1||'|'||msi.segment2||'|'||msi.segment3||'|'||msi.segment4) Item_code,
      msi.description item_desc,
      pol.UNIT_MEAS_LOOKUP_CODE,
      pv.vendor_id supplier_id,
      pv.vendor_name supplier,
      pvs.vendor_site_code supplier_site_code,
      hl.location_code ship_to_location_code,
      pb.agent_name buyer_name,
      msi.inventory_item_status_code item_status,
      pll.quantity,
      pol.unit_price,
     (pll.quantity * pol.unit_price) amount,
     poh.CURRENCY_CODE,
      pll.quantity_received,
      pll.quantity_cancelled,
      pll.quantity_billed,
      rcvl.QUANTITY_RECEIVED,
      rcvl.QUANTITY_SHIPPED,
      (SELECT mc.concatenated_segments
        FROM mtl_categories_kfv mc, mtl_item_categories mic, mtl_category_sets mcs
        WHERE mcs.category_set_name = 'PURCHASING'
          AND mcs.category_set_id = mic.category_set_id
          AND mic.inventory_item_id = msi.inventory_item_id
          AND mic.organization_id = msi.organization_id
          AND mic.category_id = mc.category_id)
          po_category
FROM po_headers_all poh
   , po_lines_all pol
   , po_line_locations_all pll
   , po_releases_all pr
   , mtl_system_items msi                
   , org_organization_definitions mp
   , po_vendors pv
   , po_vendor_sites_all pvs
   , po_agents_v pb
   , hr_locations hl
   , hr_operating_units hou
    ,RCV_TRANSACTIONS rcv
    ,RCV_SHIPMENT_HEADERS rcvh
    ,rcv_shipment_lines rcvl
WHERE poh.type_lookup_code IN ('BLANKET', 'STANDARD')
  AND msi.inventory_item_id = pol.item_id
  AND msi.organization_id = pll.ship_to_organization_id
  AND mp.organization_id = msi.organization_id
  AND poh.po_header_id = pol.po_header_id
  AND pol.po_line_id = pll.po_line_id
  AND pr.po_header_id(+) = poh.po_header_id
  AND NVL (pll.po_release_id, 1) = NVL (pr.po_release_id, 1)
  AND poh.vendor_id = pv.vendor_id
  AND poh.vendor_site_id = pvs.vendor_site_id
  AND pvs.vendor_id = pv.vendor_id
  AND pb.agent_id = poh.agent_id
  AND hl.location_id = poh.ship_to_location_id 
  AND poh.org_id = hou.organization_id
 -- and POH.PO_HEADER_ID BETWEEN  NVL(:P_PO_NO_FROM, POH.PO_HEADER_ID) and  NVL(:P_PO_NO_TO, POH.PO_HEADER_ID)
 and POH.PO_HEADER_ID = rcv.PO_HEADER_ID
 and pol.PO_HEADER_ID = rcv.PO_HEADER_ID
 and PLL.PO_HEADER_ID = RCV.PO_HEADER_ID
 and PR.PO_HEADER_ID = RCV.PO_HEADER_ID
 and rcv.TRANSACTION_TYPE in ( 'DELIVER')
 and rcv.SHIPMENT_HEADER_ID = rcvh.SHIPMENT_HEADER_ID
 and rcvh.SHIPMENT_HEADER_ID = rcvl.SHIPMENT_HEADER_ID(+)
 and poh.po_header_id = rcvl.po_header_id(+)
 and POL.PO_LINE_ID = RCVL.PO_LINE_ID(+)
 and PLL.LINE_LOCATION_ID = RCVL.PO_LINE_LOCATION_ID(+)
 AND poh.po_header_id between NVL(:p_po_no, poh.po_header_id) and NVL(:p_po_to, poh.po_header_id)
  and POH.ORG_ID = NVL(:P_OU, POH.ORG_ID)
    AND TRUNC(poh.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(poh.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(poh.creation_date))
    and  pv.vendor_id = NVL(:P_SUPLIER,  pv.vendor_id)
    and  poh.type_lookup_code = NVL(:P_POTYPE,  poh.type_lookup_code)
    and   pb.AGENT_ID = NVL(:P_BUYER, pb.AGENT_ID)
    and  pol.item_id = NVL(:P_ITEM,  pol.item_id)
    and  poh.AUTHORIZATION_STATUS = NVL(:P_AUTSTATUS, poh.AUTHORIZATION_STATUS)
--     AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
--    AND pol.po_header_id=rt.PO_HEADER_ID(+)
-- AND pol.po_line_id=rt.po_line_id(+)
 -- AND hou.short_code = 'VIS-US'
 --and poh.segment1 = 40000914
ORDER BY poh.segment1, pr.release_num
 
 
 --===================== TEST ===============================
 --PO completed but NOT GRN, OR Pertial GEN QUERY
 
SELECT
     XX_GET_HR_OPERATING_UNIT(POH.ORG_ID) Org_header_name,  
      POH.PO_HEADER_ID,
      poh.segment1 po_number,
      poh.type_lookup_code PO_TYPE,
     poh.AUTHORIZATION_STATUS,
     pol.CLOSED_CODE,
     poh.ATTRIBUTE1,
     pr.release_num,
     to_char(poh.creation_date, 'DD-MON-RRRR') poh_Creation_date,
     to_char(poh.approved_date, 'DD-MON-RRRR') poh_Approved_date,
      mp.organization_code inv_org,
      pol.item_id,
      (msi.segment1||'|'||msi.segment2||'|'||msi.segment3||'|'||msi.segment4) Item_code,
      msi.description item_desc,
      pol.UNIT_MEAS_LOOKUP_CODE,
      pv.vendor_id supplier_id,
      pv.vendor_name supplier,
      pvs.vendor_site_code supplier_site_code,
      hl.location_code ship_to_location_code,
      pb.agent_name buyer_name,
      msi.inventory_item_status_code item_status,
      pll.quantity,
      pol.unit_price,
     (pll.quantity * pol.unit_price) amount,
     poh.CURRENCY_CODE,
      pll.quantity_received,
      pll.quantity_cancelled,
      pll.quantity_billed,
      rcvl.QUANTITY_RECEIVED,
      rcvl.QUANTITY_SHIPPED,
      (SELECT mc.concatenated_segments
        FROM mtl_categories_kfv mc, mtl_item_categories mic, mtl_category_sets mcs
        WHERE mcs.category_set_name = 'PURCHASING'
          AND mcs.category_set_id = mic.category_set_id
          AND mic.inventory_item_id = msi.inventory_item_id
          AND mic.organization_id = msi.organization_id
          AND mic.category_id = mc.category_id)
          po_categor,
          pov.GRN_NO,
          pov.GRN_QTY RECEIVE_QTY,pov.GRN_DT RECEIVED_DATE, pov.ACCEPT_QTY, pov.DEL_QTY DELIVERY_QTY, pov.DEL_QTY,pov.DEL_DT
FROM po_headers_all poh
   , po_lines_all pol
   , po_line_locations_all pll
   , po_releases_all pr
   , mtl_system_items msi                
   , org_organization_definitions mp
   , po_vendors pv
   , po_vendor_sites_all pvs
   , po_agents_v pb
   , hr_locations hl
   , hr_operating_units hou
    ,RCV_TRANSACTIONS rcv
    ,RCV_SHIPMENT_HEADERS rcvh
    ,rcv_shipment_lines rcvl
    ,XXKBG_IND_PAY_V pov 
WHERE poh.type_lookup_code IN ('BLANKET', 'STANDARD')
  AND msi.inventory_item_id = pol.item_id
  AND msi.organization_id = pll.ship_to_organization_id
  AND mp.organization_id = msi.organization_id
  AND poh.po_header_id = pol.po_header_id
  AND pol.po_line_id = pll.po_line_id
  AND pr.po_header_id(+) = poh.po_header_id
  AND NVL (pll.po_release_id, 1) = NVL (pr.po_release_id, 1)
  AND poh.vendor_id = pv.vendor_id
  AND poh.vendor_site_id = pvs.vendor_site_id
  AND pvs.vendor_id = pv.vendor_id
  AND pb.agent_id = poh.agent_id
  AND hl.location_id = poh.ship_to_location_id 
  AND poh.org_id = hou.organization_id
 -- and POH.PO_HEADER_ID BETWEEN  NVL(:P_PO_NO_FROM, POH.PO_HEADER_ID) and  NVL(:P_PO_NO_TO, POH.PO_HEADER_ID)
 and POH.PO_HEADER_ID = rcv.PO_HEADER_ID
 and pol.PO_HEADER_ID = rcv.PO_HEADER_ID
 and PLL.PO_HEADER_ID = RCV.PO_HEADER_ID
 and PR.PO_HEADER_ID = RCV.PO_HEADER_ID
 and rcv.TRANSACTION_TYPE in ( 'DELIVER')
 and rcv.SHIPMENT_HEADER_ID = rcvh.SHIPMENT_HEADER_ID
 and rcvh.SHIPMENT_HEADER_ID = rcvl.SHIPMENT_HEADER_ID(+)
 and poh.po_header_id = rcvl.po_header_id(+)
 and POL.PO_LINE_ID = RCVL.PO_LINE_ID(+)
 and PLL.LINE_LOCATION_ID = RCVL.PO_LINE_LOCATION_ID(+)
 and poh.po_header_id = pov.po_header_id
 and pol.po_line_id = pov.po_line_id
 and pll.line_location_id = pov.PO_LINE_LOCATION_ID
  AND poh.po_header_id between NVL(:p_po_no, poh.po_header_id) and NVL(:p_po_to, poh.po_header_id)
  and POH.ORG_ID = NVL(:P_OU, POH.ORG_ID)
    AND TRUNC(poh.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(poh.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(poh.creation_date))
    and  pv.vendor_id = NVL(:P_SUPLIER,  pv.vendor_id)
    and  poh.type_lookup_code = NVL(:P_POTYPE,  poh.type_lookup_code)
    and   pb.AGENT_ID = NVL(:P_BUYER, pb.AGENT_ID)
    and  pol.item_id = NVL(:P_ITEM,  pol.item_id)
    and  poh.AUTHORIZATION_STATUS = NVL(:P_AUTSTATUS, poh.AUTHORIZATION_STATUS)
--     AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
--    AND pol.po_header_id=rt.PO_HEADER_ID(+)
-- AND pol.po_line_id=rt.po_line_id(+)
 -- AND hou.short_code = 'VIS-US'
 --and poh.segment1 = 40000914
ORDER BY poh.segment1, pr.release_num



select * from RCV_SHIPMENT_HEADERS Where SHIPMENT_HEADER_ID = 397176

select * from RCV_TRANSACTIONS 
where PO_header_ID = 397176
--and TRANSACTION_TYPE =  RECEIVE 'DELIVER'  REJECT , 

select  * from rcv_shipment_lines where PO_header_ID = 397176

select * from PO_LINE_LOCATIONS_ALL

select * from XXKBG_IND_PAY_V
where PO_HEADER_ID =  397176

select * from PO_headers_all where segment1 = '40000914'

select * from po_headers_all where po_header_id = 397176


pov.GRN_QTY RECEIVE_QTY,pov.GRN_DT RECEIVED_DATE, pov.ACCEPT_QTY, pov.DEL_QTY DELIVERY_QTY, pov.DEL_QTY,pov.DEL_DT, pov.ORGANIZATION_ID INV_ORG

--============================== TEST Final  11-MAR-2019 Balance qty is problem==============================================


SELECT
     XX_GET_HR_OPERATING_UNIT(POH.ORG_ID) Org_header_name,  
      POH.PO_HEADER_ID,
      poh.segment1 po_number,
      poh.type_lookup_code PO_TYPE,
     poh.AUTHORIZATION_STATUS,
     pol.CLOSED_CODE,
     poh.ATTRIBUTE1,
     pr.release_num,
     to_char(pr.RELEASE_DATE, 'DD-MON-RRRR') release_date,
     to_char(poh.creation_date, 'DD-MON-RRRR') poh_Creation_date,
     to_char(poh.approved_date, 'DD-MON-RRRR') poh_Approved_date,
      mp.organization_code inv_org,
      pol.item_id,
      (msi.segment1||'|'||msi.segment2||'|'||msi.segment3||'|'||msi.segment4) Item_code,
      msi.description item_desc,
      pol.UNIT_MEAS_LOOKUP_CODE,
      pv.vendor_id supplier_id,
      pv.vendor_name supplier,
      pvs.vendor_site_code supplier_site_code,
      hl.location_code ship_to_location_code,
      pb.agent_name buyer_name,
      msi.inventory_item_status_code item_status,
 -- (pov.GRN_QTY+pov.RETURN_QTY)) balence,
      pll.quantity PO_QUANTITY,
      pol.unit_price,
     (pll.quantity * pol.unit_price) amount,
     poh.CURRENCY_CODE,
     pov.GRN_NO GRN_NUMBER,
    pov.GRN_QTY RECEIVE_QTY,
    pov.GRN_DT RECEIVED_DATE,
     pov.ACCEPT_QTY,
      pov.DEL_QTY 
      DELIVERY_QTY, 
      pov.DEL_DT DELIVERY_DATE,
      pov.REJECT_QTY REJECT_QTY,
      pov.RETURN_QTY RETURN_QTY,
      (pol.quantity - (pov.GRN_QTY+pov.RETURN_QTY))  BALANCE,
     XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME,
     XX_GET_VENDOR_ADDRESS (POH.VENDOR_SITE_ID) VENDOR_ADDRESS,
    NVL((pll.quantity - pov.GRN_QTY+pov.RETURN_QTY), pll.quantity) Balance
FROM po_headers_all poh
   , po_lines_all pol
   , po_line_locations_all pll
   , po_releases_all pr
   , mtl_system_items msi                
   , org_organization_definitions mp
   , po_vendors pv
   , po_vendor_sites_all pvs
   , po_agents_v pb
   , hr_locations hl
   , hr_operating_units hou
   , XXKBG_IND_PAY_V pov
WHERE poh.type_lookup_code IN ('BLANKET')
AND   poh.AUTHORIZATION_STATUS = 'APPROVED'
  AND msi.inventory_item_id = pol.item_id
  AND msi.organization_id = pll.ship_to_organization_id
  AND mp.organization_id = msi.organization_id
  AND poh.po_header_id = pol.po_header_id
  AND pol.po_line_id = pll.po_line_id
  AND pr.po_header_id(+) = poh.po_header_id
  AND NVL (pll.po_release_id, 1) = NVL (pr.po_release_id, 1)
  AND poh.vendor_id = pv.vendor_id
  AND poh.vendor_site_id = pvs.vendor_site_id
  AND pvs.vendor_id = pv.vendor_id
  AND pb.agent_id = poh.agent_id
  AND hl.location_id = poh.ship_to_location_id 
  AND poh.org_id = hou.organization_id
  and poh.po_header_id = pov.po_header_id(+)
  and pol.po_header_id = pov.po_header_id(+)
  and pll.po_line_id = pov.po_line_id(+)
  and pll.po_header_id = pov.po_header_id(+)
  and pll.line_location_id= pov.PO_LINE_LOCATION_ID(+)
 -- and pr.line_location_id(+) = pov.PO_LINE_LOCATION_ID
 -- and POH.PO_HEADER_ID BETWEEN  NVL(:P_PO_NO_FROM, POH.PO_HEADER_ID) and  NVL(:P_PO_NO_TO, POH.PO_HEADER_ID)
 AND poh.po_header_id between NVL(:p_po_no, poh.po_header_id) and NVL(:p_po_to, poh.po_header_id)
  and POH.ORG_ID = NVL(:P_OU, POH.ORG_ID)
   -- AND TRUNC(poh.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(poh.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(poh.creation_date))
    AND (:P_F_PO_DT IS NULL OR TRUNC(poh.creation_date) BETWEEN :P_F_PO_DT AND :P_T_PO_DT) 
    and  pv.vendor_id = NVL(:P_SUPLIER,  pv.vendor_id)
    and  poh.type_lookup_code = NVL(:P_POTYPE,  poh.type_lookup_code)
    and   pb.AGENT_ID = NVL(:P_BUYER, pb.AGENT_ID)
    and  pol.item_id = NVL(:P_ITEM,  pol.item_id)
    and pov.GRN_NO = NVL(:P_GRN_NO, pov.GRN_NO)
    and  poh.AUTHORIZATION_STATUS = NVL(:P_AUTSTATUS, poh.AUTHORIZATION_STATUS)
--     AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
--    AND pol.po_header_id=rt.PO_HEADER_ID(+)
-- AND pol.po_line_id=rt.po_line_id(+)
 -- AND hou.short_code = 'VIS-US'
 --and poh.segment1 = 40000914
ORDER BY poh.segment1, pr.release_num

--==========================================================================================


    select * from  po_vendors pv
   select * from  po_vendor_sites_all pvs

select * from RCV_SHIPMENT_HEADERS Where SHIPMENT_HEADER_ID = 397176

select *  from PO_RELEASES_ALL where  PO_header_ID = 397176

 select * from PO_LINES_ALL where  PO_header_ID = 397176
 
 select * from  mtl_units_of_measure_tl 
select * from RCV_TRANSACTIONS 
where PO_header_ID = 397176
--and TRANSACTION_TYPE =  RECEIVE 'DELIVER'  REJECT , 

select  * from rcv_shipment_lines where PO_header_ID = 397176

select * from PO_LINE_LOCATIONS_ALL

select * from XXKBG_IND_PAY_V
where PO_HEADER_ID =  397176

pov.GRN_QTY RECEIVE_QTY,pov.GRN_DT RECEIVED_DATE, pov.ACCEPT_QTY, pov.DEL_QTY DELIVERY_QTY, pov.DEL_QTY,pov.DEL_DT, pov.ORGANIZATION_ID INV_ORG 
 
 
    select * from  po_vendors pv
   select * from  po_vendor_sites_all pvs

select * from RCV_SHIPMENT_HEADERS Where SHIPMENT_HEADER_ID = 397176

select *  from PO_RELEASES_ALL where  PO_header_ID = 397176

 select * from PO_LINES_ALL where  PO_header_ID = 397176
 
 select * from  mtl_units_of_measure_tl 
select * from RCV_TRANSACTIONS 
where PO_header_ID = 397176
--and TRANSACTION_TYPE =  RECEIVE 'DELIVER'  REJECT , 

select  * from rcv_shipment_lines where PO_header_ID = 397176

select * from PO_LINE_LOCATIONS_ALL

select * from XXKBG_IND_PAY_V
where PO_HEADER_ID =  397176

pov.GRN_QTY RECEIVE_QTY,pov.GRN_DT RECEIVED_DATE, pov.ACCEPT_QTY, pov.DEL_QTY DELIVERY_QTY, pov.DEL_QTY,pov.DEL_DT, pov.ORGANIZATION_ID INV_ORG 
 
--==================================================

--select poh.po_header_id, pll.quantity po_quantity, pov.grn_qty,pov.DEL_QTY, pov.REJECT_QTY,pov.RETURN_QTY
select :PO_QTY,SUM(nvl(pll.quantity,0)) - SUM(nvl(GRN_QTY,0))+NVL(SUM( NVL(RETURN_QTY,0)),0)
 FROM XXKBG_IND_PAY_V  pov,po_headers_all poh, po_lines_all pol, po_line_locations_all pll
 where poh.po_header_id= pov.po_header_id
 and pol.po_header_id = pov.po_header_id(+)
 and pol.po_line_id = pov.po_line_id(+)
 and pll.line_location_id = pov.po_line_location_id(+)
 and poh.segment1 = '40000835'
 and poh.org_id = 104
 GROUP BY PO_QTY
   



--=================================== Blanket PO QUERY  13-mar-2109============================

 SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
ood.ORGANIZATION_CODE destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE IO,
XX_P2P_PKG.LC_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') release_date, 
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
pla.attribute1 brand,
pla.attribute2 origin,               
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
                   mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE --,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pla.po_header_id=rt.PO_HEADER_ID(+) 
    AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
 AND PDA.LINE_LOCATION_ID=PL.LINE_LOCATION_ID(+)---
   AND pla.po_line_id=rt.po_line_id(+)
  AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :p_org_id
   AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
 --  AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
   AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE,
PLA.LINE_NUM, 
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
pla.ATTRIBUTE5,
PLA.ATTRIBUTE11,
MP.ORGANIZATION_ID ,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
pha.attribute6,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE,
pvs.EMAIL_ADDRESS,
--xx_com_pkg.get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
pla.attribute1,
pla.attribute2,
PLA.ATTRIBUTE3  ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
--PHA.ATTRIBUTE15,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'), 
PLA.UNIT_PRICE-NVL((NVL(NVL(PLA.ATTRIBUTE11,0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0),
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0)*(pll.quantity),
pha.REVISION_NUM,
PLA.UNIT_PRICE,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE),
RT.DELIVER_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY



UNION ALL
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
pha.authorization_status,
--PHA.ATTRIBUTE10 TERM_DAYS,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
NULL destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE IO,
--(select organization_code from mtl_parameters where ORGANIZATION_ID=pll.ship_to_organization_id) IO,
TO_CHAR(NULL) LC_NO,
TO_NUMBER(NULL) release_num,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') rel_dt,
null,
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
pla.attribute1 brand,
pla.attribute2 origin,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,
MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       PO_LINE_LOCATIONS_ALL PLL,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1, 
       (SELECT inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        )) mst,
                        mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND UPPER(pll.SHIPMENT_TYPE)='PRICE BREAK'
     AND pla.po_header_id=rt.PO_HEADER_ID(+)
   AND pla.po_line_id=rt.po_line_id(+)
      AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
       AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
    AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :p_org_id
      AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
  AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
   AND pha.po_header_id = :p_po_no
   --AND 1=nvl2(:p_release,900,1)
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND :p_release IS NULL
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
      AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE, 
PLA.LINE_NUM,
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_ID ,
pvs.EMAIL_ADDRESS,
XX_GET_HR_OPERATING_UNIT(:p_org_id) ,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
MP.ORGANIZATION_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
pha.authorization_status,
TO_CHAR(NULL),
PLA.PO_LINE_ID,
pla.ATTRIBUTE5,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0),
TO_CHAR(NULL),
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0),
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13, 
--PHA.ATTRIBUTE15,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'),
null, 
pha.REVISION_NUM,
PLA.ATTRIBUTE3,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE) ,
RT.DELIVER_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY
order by RECEIPT_NO

--=======================================



-- Main Function

function CF_NET_VALUEFormula return Number is
V_NO NUMBER;
V_NET_VAL NUMBER;
begin
IF
    :RETURN_QTY = 0 THEN
    SELECT  NVL((:PO_QUANTITY - :RECEIVE_QTY+:RETURN_QTY),:PO_QUANTITY)  --:PO_QUANTITY - SUM(NVL(:RECEIVE_QTY,0))+SUM(NVL(:RETURN_QTY,0))
    INTO V_NO
    FROM XXKBG_IND_PAY_V pov,po_headers_all poh, po_lines_all pol, po_line_locations_all pll
 where poh.po_header_id = pov.po_header_id
 and pol.po_header_id = pov.po_header_id(+)
 and pol.po_line_id = pov.po_line_id(+)
 and pll.line_location_id = pov.po_line_location_id(+)
 and pov.PO_LINE_ID=:PO_LINE_ID
 and pov.GRN_NO <=NVL(:GRN_NUMBER,pov.GRN_NO)

 GROUP BY :PO_QUANTITY;

SELECT NVL(SUM(NVL(:RECEIVE_QTY,0))- nvl(V_NO,0),0)
INTO V_NET_VAL
FROM XXKBG_IND_PAY_V pov
WHERE pov.PO_LINE_ID=:PO_LINE_ID
and pov.GRN_NO =NVL(:GRN_NUMBER,pov.GRN_NO);

ELSIF 
 :RETURN_QTY>0  THEN
  
SELECT V_NET_VAL - SUM(nvl(:RECEIVE_QTY,0))
INTO V_NO
FROM XXKBG_IND_PAY_V pov
WHERE pov.PO_LINE_ID=:PO_LINE_ID
and pov.GRN_NO =NVL(:GRN_NUMBER,pov.GRN_NO)
GROUP BY :PO_QUANTITY;


 SELECT NVL(SUM(NVL(:RECEIVE_QTY,0))+ nvl(V_NO,0),0)
INTO V_NET_VAL
FROM XXKBG_IND_PAY_V pov
WHERE pov.PO_LINE_ID=:PO_LINE_ID
and pov.GRN_NO =NVL(:GRN_NUMBER,pov.GRN_NO);


ELSE V_NET_VAL:=:PO_QUANTITY;
    
END IF; 
  --V_NET_VAL:=round(:PO_QUANTITY*:unit_price,2);
  RETURN(V_NO);
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
end;

--================Operation of PO transaction Status report======================== 

Select Pha.segment1, pla.po_line_id, pov.VENDOR_ID, pov.VENDOR_NAME, pvs.VENDOR_SITE_CODE, mst.item_code, pla.ITEM_DESCRIPTION, UOM_CODE
FROM po_headers_all pha,
      po_headers_all pha1,
      po_lines_all pla,
      mtl_units_of_measure_tl muom,
      po_line_locations_all pll,
      ap_suppliers pov,
       ap_supplier_sites_all pvs,
     hr_locations_all hrl,
      hr_locations_all hrl1,
--       org_organization_definitions ood,
      po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                       ) item_code
                  FROM mtl_system_items_b) mst,
--                   mtl_parameters MP,
                  ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.LINE_LOCATION_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                      FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                       AND  PO_HEADER_ID=:P_PO_NO
                       GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,wrt.LINE_LOCATION_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT
--                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
 and pha.po_header_id = 397176
   AND pha.vendor_id = pov.vendor_id
  AND pha.vendor_site_id = pvs.vendor_site_id
  AND pov.vendor_id = pvs.vendor_id
  AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
  AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
  AND pla.po_header_id = pll.po_header_id
 AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
  AND hrl.location_id = pll.ship_to_location_id
  AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
  AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pla.po_header_id=rt.PO_HEADER_ID(+)
   and pha.po_header_id = rt.po_header_id
   and pla.po_line_id = rt.po_line_id
   and pll.line_location_id = rt.LINE_LOCATION_ID
--    AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
-- AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
-- AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
---- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
-- AND PDA.LINE_LOCATION_ID=PL.LINE_LOCATION_ID(+)---
--   AND pla.po_line_id=rt.po_line_id(+)
--  AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
-- AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
--   AND pha.org_id = :p_org_id
--   AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
--    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
--    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
--       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
--   AND ood.organization_id = pll.ship_to_organization_id  
--   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
--   AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
--   --AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
--   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
--   AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)

--============================= Final  Operation of PO transaction Status report================================================

SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
ood.ORGANIZATION_CODE destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE IO,
XX_P2P_PKG.LC_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') release_date, 
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
pla.attribute1 brand,
pla.attribute2 origin,               
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee,
XX_ONT_GET_ENAME(:P_USER) PRINTED_BY 
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
                   mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,wrt.LINE_LOCATION_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,wrt.LINE_LOCATION_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   and pll.LINE_LOCATION_ID = rt.LINE_LOCATION_ID(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pla.po_header_id=rt.PO_HEADER_ID(+)
    AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
 AND PDA.LINE_LOCATION_ID=PL.LINE_LOCATION_ID(+)---
   AND pla.po_line_id=rt.po_line_id(+)
  AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :p_org_id
   AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
 --  AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
   AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE,
PLA.LINE_NUM, 
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
pla.ATTRIBUTE5,
PLA.ATTRIBUTE11,
MP.ORGANIZATION_ID ,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
pha.attribute6,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE,
pvs.EMAIL_ADDRESS,
--xx_com_pkg.get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
pla.attribute1,
pla.attribute2,
PLA.ATTRIBUTE3  ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
--PHA.ATTRIBUTE15,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'), 
PLA.UNIT_PRICE-NVL((NVL(NVL(PLA.ATTRIBUTE11,0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0),
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0)*(pll.quantity),
pha.REVISION_NUM,
PLA.UNIT_PRICE,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE),
RT.DELIVER_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
XX_ONT_GET_ENAME(:P_USER)  
UNION ALL
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
pha.authorization_status,
--PHA.ATTRIBUTE10 TERM_DAYS,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
NULL destinition,
pov.segment1 supplier_id,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE IO,
--(select organization_code from mtl_parameters where ORGANIZATION_ID=pll.ship_to_organization_id) IO,
TO_CHAR(NULL) LC_NO,
TO_NUMBER(NULL) release_num,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') rel_dt,
null,
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
pla.attribute1 brand,
pla.attribute2 origin,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,
MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee,
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
XX_ONT_GET_ENAME(:P_USER) PRINTED_BY 
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       PO_LINE_LOCATIONS_ALL PLL,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1, 
       (SELECT inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        )) mst,
                        mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND UPPER(pll.SHIPMENT_TYPE)='PRICE BREAK'
     AND pla.po_header_id=rt.PO_HEADER_ID(+)
   AND pla.po_line_id=rt.po_line_id(+)
      AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
       AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
    AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :p_org_id
      AND pha.po_header_id between NVL(:p_po_no, pha.po_header_id) and NVL(:p_po_to, pha.po_header_id)
    AND NVL2(:p_po_no,pha.po_header_id,-1) between NVL(:p_po_no,-1) and NVL(:p_po_to,-1) 
    AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
  AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
   AND pha.po_header_id = :p_po_no
   --AND 1=nvl2(:p_release,900,1)
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND :p_release IS NULL
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
      AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:p_inv_org,PLL.SHIP_TO_ORGANIZATION_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE, 
PLA.LINE_NUM,
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_ID ,
pvs.EMAIL_ADDRESS,
XX_GET_HR_OPERATING_UNIT(:p_org_id) ,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
MP.ORGANIZATION_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
pha.authorization_status,
TO_CHAR(NULL),
PLA.PO_LINE_ID,
pla.ATTRIBUTE5,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0),
TO_CHAR(NULL),
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0),
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13, 
--PHA.ATTRIBUTE15,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'),
null, 
pha.REVISION_NUM,
PLA.ATTRIBUTE3,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE) ,
RT.DELIVER_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
XX_ONT_GET_ENAME(:P_USER)  
order by RECEIPT_NO


--========================================
-- Formula column for 30 days consumption 

select  SUM(NVL((SELECT PRIMARY_QUANTITY FROM MTL_MATERIAL_TRANSACTIONS WHERE TRANSACTION_ID=MMT.TRANSACTION_ID AND PRIMARY_QUANTITY<0),0)) ISSUE_QTY   --MMT.SUBINVENTORY_CODE SUBINVENTORY
FROM 
MTL_MATERIAL_TRANSACTIONS MMT, 
WBI_INV_ORG_DETAIL WIOD,
WBI_XXKBGITEM_MT_D WXMD
WHERE 
MMT.ORGANIZATION_ID=WIOD.INV_ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID = MMT.INVENTORY_ITEM_ID
AND WXMD.ORGANIZATION_ID= MMT.ORGANIZATION_ID
AND WIOD.INV_ORGANIZATION_ID = MMT.ORGANIZATION_ID
--AND WXMD.ITEM_CODE=NVL(:P_ITEM_CODE,WXMD.ITEM_CODE) 
AND MMT.ORGANIZATION_ID= 164   --152 --NVL(:P_ORG_ID, MMT.ORGANIZATION_ID)
AND MMT.INVENTORY_ITEM_ID = 18 
AND   MMT.TRANSACTION_DATE between '01-JAN-2018' and '30-JAN-2019' 
--AND TRUNC( TRANSACTION_DATE) BETWEEN TO_DATE(:P_DATE_FROM) AND TO_DATE(:P_DATE_TO)
ORDER BY MMT.TRANSACTION_ID 

--=====================Blanket PO Transaction Summary  Final  24-MAR-2019============================================

--Blanket PO Transaction Summary 
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PLL.LINE_LOCATION_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
ood.ORGANIZATION_CODE destinition,
pov.segment1 supplier_id,
pov.VENDOR_ID,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:P_ORG_ID),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE IO,
XX_P2P_PKG.LC_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') release_date, 
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
pla.attribute1 brand,
pla.attribute2 origin,               
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee,
XX_ONT_GET_ENAME(:P_USER) PRINTED_BY 
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM xx_po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
                   mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,wrt.LINE_LOCATION_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,wrt.LINE_LOCATION_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   and pll.LINE_LOCATION_ID = rt.LINE_LOCATION_ID(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pla.po_header_id=rt.PO_HEADER_ID(+)
    AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
 AND PDA.LINE_LOCATION_ID=PL.LINE_LOCATION_ID(+)---
   AND pla.po_line_id=rt.po_line_id(+)
  AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.ORG_ID = :P_ORG_ID
   AND pha.po_header_id between NVL(:P_PO_NO, pha.po_header_id) and NVL(:P_PO_TO, pha.po_header_id)
    AND NVL2(:P_PO_NO,pha.po_header_id,-1) between NVL(:P_PO_NO,-1) and NVL(:P_PO_TO,-1) 
  --  AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
  AND (:P_F_PO_DT IS NULL OR TRUNC(pha.creation_date) BETWEEN :P_F_PO_DT AND :P_T_PO_DT) 
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
       AND POV.VENDOR_ID = NVL(:P_SUPP,POV.VENDOR_ID)
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
 --  AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
   AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:P_INV_ORG,PLL.SHIP_TO_ORGANIZATION_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE,
PLA.LINE_NUM, 
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
PLL.LINE_LOCATION_ID,
pla.ATTRIBUTE5,
PLA.ATTRIBUTE11,
MP.ORGANIZATION_ID ,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
pha.attribute6,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PLA.PO_LINE_ID,
PHA.ATTRIBUTE11,
pov.segment1,
POV.VENDOR_ID,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE,
pvs.EMAIL_ADDRESS,
--xx_com_pkg.get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
pla.attribute1,
pla.attribute2,
PLA.ATTRIBUTE3  ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
--PHA.ATTRIBUTE15,
to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'), 
PLA.UNIT_PRICE-NVL((NVL(NVL(PLA.ATTRIBUTE11,0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0),
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0)*(pll.quantity),
pha.REVISION_NUM,
PLA.UNIT_PRICE,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE),
RT.DELIVER_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
XX_ONT_GET_ENAME(:P_USER)  
UNION ALL
SELECT
pha.attribute4 H_DIS,
PHA.ATTRIBUTE13 project,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM,
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
PL.LINE_LOCATION_ID,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
pha.authorization_status,
--PHA.ATTRIBUTE10 TERM_DAYS,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
NULL destinition,
pov.segment1 supplier_id,
POV.VENDOR_ID,
pov.vendor_name supplier_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
substr(XX_GET_HR_OPERATING_UNIT(:P_ORG_ID),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE BCL_F_ADD,
hrl.TELEPHONE_NUMBER_1 PHP_F_PHONE,
HRL.TELEPHONE_NUMBER_2 PHP_F_FAX,
HRL.LOC_INFORMATION13 PHP_F_EMAIL,
MP.ORGANIZATION_ID INVENTORY_ORG,
MP.ORGANIZATION_CODE IO,
--(select organization_code from mtl_parameters where ORGANIZATION_ID=pll.ship_to_organization_id) IO,
TO_CHAR(NULL) LC_NO,
TO_NUMBER(NULL) release_num,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR') rel_dt,
null,
pha.REVISION_NUM,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE BCL_bill_ADD,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id) css_no,
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR') css_date,
mst.item_code,
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
pla.attribute1 brand,
pla.attribute2 origin,
PLA.ATTRIBUTE3 Specifications ,
pla.item_description,
MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0) UNIT_PRICE,
pla.ATTRIBUTE5 line_dis,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
RT.DELIVER_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
to_char(:P_F_PO_DT,'DD-MON-RRRR') from_date,
to_char(:P_T_PO_DT,'DD-MON-RRRR') to_datee,
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
XX_ONT_GET_ENAME(:P_USER) PRINTED_BY 
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
       mtl_units_of_measure_tl muom,
       PO_LINE_LOCATIONS_ALL PLL,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1, 
       (SELECT inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        ) item_code
                   FROM mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '-' || segment2 || '-' || segment3|| '-' || segment4
                        )) mst,
                        mtl_parameters MP,
                   ( SELECT DISTINCT  WRT.ORGANIZATION_ID,WRT.PO_HEADER_ID,WRT.PO_LINE_ID,SUM(WRT.RECEIPT_QTY) RECEIPT_QTY,  SUM(WRT.ACCEPTED_QTY) ACCEPTED_QTY, 
                        (NVL(SUM( WRT.RETURN_QTY),0)+NVL(SUM(WRT.DLV_RETURN_QTY),0)) RETURN_QTY,(SUM(WRT.DELIVER_QTY)-NVL(SUM(WRT.DLV_RETURN_QTY),0)) DELIVER_QTY,WRT.RECEIPT_NO,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY') RECEIPT_DATE--,LISTAGG(RECEIPT_NO,',') within group  (ORDER BY RECEIPT_NO) GRN_NO 
                        FROM INV_RCV_TRANSACTIONS_P2P_VW WRT
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY WRT.PO_HEADER_ID,WRT.PO_LINE_ID,WRT.RECEIPT_NO, WRT.ORGANIZATION_ID,to_char(WRT.RECEIPT_DATE, 'DD-MON-YYYY')) RT,
                        PO_LINE_LOCATIONS PL
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pll.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND UPPER(pll.SHIPMENT_TYPE)='PRICE BREAK'
     AND pla.po_header_id=rt.PO_HEADER_ID(+)
   AND pla.po_line_id=rt.po_line_id(+)
      AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
       AND PHA.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND PLA.PO_LINE_ID=PL.PO_LINE_ID(+)---
 AND RT.PO_HEADER_ID=PL.PO_HEADER_ID(+)---
 AND RT.PO_LINE_ID=PL.PO_LINE_ID(+)---
-- AND RT.LINE_LOCATION_ID=PL.LINE_LOCATION_ID---
    AND UPPER(NVL(PLA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding')
 AND UPPER(NVL(PHA.ATTRIBUTE_CATEGORY,0)) NOT IN ('Branding_Info','Shipping_Info')
   AND pha.org_id = :P_ORG_ID
      AND pha.po_header_id between NVL(:P_PO_NO, pha.po_header_id) and NVL(:P_PO_TO, pha.po_header_id)
    AND NVL2(:P_PO_NO,pha.po_header_id,-1) between NVL(:P_PO_NO,-1) and NVL(:P_PO_TO,-1) 
  --  AND TRUNC(pha.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(pha.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(pha.creation_date))
  AND (:P_F_PO_DT IS NULL OR TRUNC(pha.creation_date) BETWEEN :P_F_PO_DT AND :P_T_PO_DT) 
       AND PLA.ITEM_ID=NVL(:P_ITEM_ID,PLA.ITEM_ID)
        AND POV.VENDOR_ID = NVL(:P_SUPP,POV.VENDOR_ID)
  AND PLA.PO_LINE_ID=PLL.PO_LINE_ID
   AND pha.po_header_id = :P_PO_NO
   --AND 1=nvl2(:p_release,900,1)
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
   AND :p_release IS NULL
   AND PHA.ATTRIBUTE1=NVL(:P_PO_TYPE,PHA.ATTRIBUTE1)
      AND  PLL.SHIP_TO_ORGANIZATION_ID=NVL(:P_INV_ORG,PLL.SHIP_TO_ORGANIZATION_ID)
GROUP BY
pha.attribute4,
PHA.TYPE_LOOKUP_CODE, 
PLA.LINE_NUM,
PL.QUANTITY_REJECTED,
PHA.PO_HEADER_ID,
pha.attribute1,
PHA.ATTRIBUTE1||'/'||pha.segment1,
PL.LINE_LOCATION_ID,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR'),
PHA.ATTRIBUTE2,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14),
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
nvl(PHA.ATTRIBUTE10,0),
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.segment1,
POV.VENDOR_ID,
pov.vendor_name,
ADDRESS_LINE1||' '||ADDRESS_LINE2||' '||pvs.city,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
MP.ORGANIZATION_ID ,
pvs.EMAIL_ADDRESS,
XX_GET_HR_OPERATING_UNIT(:P_ORG_ID) ,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||'  '||hrl.REGION_1||' '||hrl.POSTAL_CODE,
MP.ORGANIZATION_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
pha.authorization_status,
TO_CHAR(NULL),
PLA.PO_LINE_ID,
pla.ATTRIBUTE5,
PLA.UNIT_PRICE,
NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0),
TO_CHAR(NULL),
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
xx_p2p_pkg.xx_fnd_cs_no_info(pha.po_header_id,pha.org_id),
to_char(xx_p2p_pkg.xx_fnd_cs_date_info(pha.po_header_id,pha.org_id), 'DD-MON-RRRR'),
mst.item_code,
PHA.ATTRIBUTE4,
PHA.ATTRIBUTE5,
pha.attribute6,
pla.attribute1,
pla.attribute2,
PLA.NOTE_TO_VENDOR ,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE-(NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE)-NVL(PLA.ATTRIBUTE5,0),
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) ,
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
NVL(PHA.ATTRIBUTE15,0),
PHA.ATTRIBUTE13, 
--PHA.ATTRIBUTE15,
--to_char(pra.RELEASE_DATE, 'DD-MON-RRRR'),
null, 
pha.REVISION_NUM,
PLA.ATTRIBUTE3,
(hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||'  '||hrl1.REGION_1||' '||hrl1.POSTAL_CODE) ,
RT.DELIVER_QTY,
--RT.REJECTED_QTY,
RT.RETURN_QTY,
RT.RECEIPT_NO,
RT.RECEIPT_DATE,
RT.RECEIPT_QTY,
XX_ONT_GET_ENAME(:P_USER)  
order by RECEIPT_NO

--=====================Spend Analysis report=========================

SELECT * FROM PO_HEADERS_ALL WHERE PO_HEADER_ID = 30001 -- SEGMENT1 =40000020  /  --39003 

SELECT * FROM XXKBG_BI_PO_GRN where ITEM_ID = 19298

select SUM(AVG(PRICE)) FROM XXKBG_BI_PO_GRN where ITEM_ID = 19298
GROUP BY ITEM_ID

SELECT * FROM PO_LINES_ALL WHERE PO_HEADER_ID = 39003  -- 19298

SELECT * FROM PO_lines_ALL WHERE ITEM_ID = 19298 --1552 --15 --51502

SELECT * FROM PO_lines_ALL  WHERE ITEM_ID =   19298  --2547 and ITEM_TYPE = 'STORE  SPARES'   --ITEM_DESCRIPTION = 'SHREDDED SCRAP'  --= 51502 

--=====================Spend Analysis report=========================

select * from XXKBG_BI_PO_GRN where  segment1 <> 'FA'   --ITEM_ID = 14 -- 'RM|CHEM|ACID|000093'
and STORE_DELIVERY_DATE between '15-NOV-2018' and '20-NOV-2018'

select * from PO_LINE_LOCATIONS_ALL where po_HEADER_ID = 306034 -- 306033

select * from PO_RELEASES_ALL where po_HEADER_ID = 306034 

select * from XXKBG_BI_PO_GRN where PO_HEADER_ID = 306034
 

--==================================================

--Spend Analysis Report
SELECT  BPG.OU_ID,substr(XX_GET_HR_OPERATING_UNIT(:P_ORG_ID),5,200) Org_header_name,
BPG.ITEM_TYPE ,
BPG.ITEM_GROUP ,
 BPG.ITEM_SUBGROUP ,
   BPG.ITEM_CATEGORY, 
   BPG.ITEM ITEM_CODE, 
   BPG.ITEM_DESCRIPTION ,
    BPG.ITEM_ID ,  BPG.UOM , 
--    MAX(STORE_DELIVERY_DATE),
    SUM(BPG.STORE_QTY) DELV_QTY, 
   --AVG(BPG.PRICE) UNIT_PRICE,
   AVG(NVL(PRICE*RATE,PRICE))   CONV_PRICE, 
   SUM(BPG.STORE_QTY) *  AVG(NVL(PRICE*RATE,PRICE))  CONV_AMOUNT
  -- SUM(BPG.STORE_QTY)*AVG(BPG.PRICE) AMOUNT
FROM XXKBG_BI_PO_GRN BPG  
WHERE  BPG.OU_ID = NVL(:P_ORG_ID,BPG.OU_ID )
AND BPG.ITEM_TYPE = NVL(:P_ITEMTYPE, BPG.ITEM_TYPE)
AND BPG.ITEM_GROUP = NVL(:P_ITMGROUP, BPG.ITEM_GROUP)
AND BPG.ITEM_SUBGROUP = NVL(:P_SUBGROUP, BPG.ITEM_SUBGROUP)
AND BPG.ITEM_ID = NVL(:P_ITEMID, BPG.ITEM_ID) 
AND BPG.segment1 <> 'FA' 
--AND VENDOR_ID = NVL(:P_VENDOR, VENDOR_ID )
AND (:P_F_DELV_DT IS NULL OR TRUNC( BPG.STORE_DELIVERY_DATE) BETWEEN :P_F_DELV_DT AND :P_T_DELV_DT) 
GROUP BY  BPG.OU_ID, ITEM_TYPE , 
BPG.ITEM_GROUP ,
 BPG.ITEM_SUBGROUP , 
 BPG.ITEM_CATEGORY, 
 BPG.ITEM_DESCRIPTION ,
 -- STORE_DELIVERY_DATE,
 BPG.ITEM_ID , 
 BPG.ITEM, 
 BPG.UOM   
 ORDER BY    SUM(BPG.STORE_QTY) *  AVG(NVL(PRICE*RATE,PRICE))  DESC
 
 
 --=====================================================
 
 
 select * from XXKBG_BI_PO_GRN where  ITEM = 'CV|CONS|CEMT|001280'  and ITEM_CATEGORY = 'DEFAULT|DEFAULT|DEFAULT' 
 
  select * from XXKBG_BI_PO_GRN where  ITEM = 'CV|CONS|CEMT|001280'  and ITEM_GROUP= 'DEFAULT' 
 
  select AVG(NVL(PRICE*RATE,PRICE)), SUM() from XXKBG_BI_PO_GRN where ITEM_ID =  20009  --ITEM = 'CV|CONS|CEMT|001280'
  
  select distinct(ITEM_TYPE) from XXKBG_BI_PO_GRN
  
    select distinct(ITEM_GROUP) from XXKBG_BI_PO_GRN
  
    
     
       select AVG(PRICE) from XXKBG_BI_PO_GRN where  ITEM = 'CV|CONS|CEMT|001280' 
       
       
       
        select * from XXKBG_BI_PO_GRN where ITEM = 'RM|SCRP|HMSL|000001' and ITEM_TYPE = 'DEFAULT'
        
        select AVG(PRICE) from XXKBG_BI_PO_GRN where ITEM = 'RM|SCRP|HMSL|000001' 
        
         select AVG(NVL(PRICE*RATE,PRICE))  from XXKBG_BI_PO_GRN where ITEM = 'RM|SCRP|HMSL|000001'  
         
         
         
         SELECT  * from user_objects where object_type = '' -- 'PROGRAM' --'FUNCTION';
         
              SELECT  DISTINCT(OBJECT_TYPE) from user_objects  where object_type = 'FUNCTION'; 
              
              select distinct object_type from all_objects; 
              
              
              SELECT *  from user_objects   where OBJECT_TYPE = 'SEQUENCE ' 
              
      --===================================================================
      
      --CS REPORT    
      
      SELECT PRFQ.PO_HEADER_ID,
pha.APPROVED_DATE,
       DECODE (pol.unit_price*nvl(pha.rate,1),
               MIN (pol.unit_price*nvl(pha.rate,1)) OVER (PARTITION BY pol.item_id), 'Y',
               'N'
              ) price_ev, 
              --APT.NAME  TERM_NAME,
      prfq.po_line_id,
      PHA.CURRENCY_CODE,
      pol.line_num quotation_line_num,
      PRFQ.QUOTE_TYPE,
      PRFQ.COMMENTS,
       XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY_C(POL.PO_LINE_ID,:P_ORG_ID)+NVL(PLL_QTY,0) qty_req,
         (SELECT SUM(PLL.QUANTITY) FROM XX_PO_QUOTATION_APPROVALS_V PAV, PO_LINE_LOCATIONS_ALL PLL, PO_LINES_ALL PLA WHERE PAV.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID AND PLL.PO_LINE_ID=PLA.PO_LINE_ID AND PLA.PO_LINE_ID=POL.PO_LINE_ID) QUOT_QTY,
    --   XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY(POL.PO_LINE_ID,:P_ORG_ID) qty_req,
       prfq.rfq_num rfq_num, 
      TO_CHAR(prfq.rfq_cret_dt,'DD-MON-RRRR') rfq_cret_dt, 
       XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(prfq.rfq_cret_dt,prfq.created_by) Prepared_by,
       --XX_P2P_EMP_INFO.xx_P2P_GET_EMPNP_MAIL(substr(pha.attribute12,1,11),to_number(substr(pha.attribute12,13,50))) Checked_by,
       null Checked_by, 
       --XX_P2P_EMP_INFO.xx_P2P_GET_EMPNP_MAIL(substr(pol.attribute12,1,11),to_number(substr(pol.attribute12,13,50))) Approved_by,
       null Approved_by,
       POL.ATTRIBUTE7 USE_AREA,
           POL.ATTRIBUTE1 BRAND,  
           POL.ATTRIBUTE2 ORIGIN,  
           POL.ATTRIBUTE8 MAKE,  
        -- pol.ATTRIBUTE5 Discount,
         PHA.QUOTE_VENDOR_QUOTE_NUMBER SUPP_QUOTE,
         pol.ATTRIBUTE5 Discount_pri,
       -- ROUND((pol.unit_price*nvl(pha.rate,1)) * (nvl(pol.ATTRIBUTE8,0)/100),3) Discount_pri,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION(POL.PO_LINE_ID,:P_ORG_ID) requisition_num_c,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_DT(POL.PO_LINE_ID,:P_ORG_ID) pr_creation,
      --  pha.segment1||CHR(10)||DECODE(NVL(PHA.ATTRIBUTE8,'NA'),'NA',PHA.QUOTE_VENDOR_QUOTE_NUMBER,'SQ-'||PHA.QUOTE_VENDOR_QUOTE_NUMBER) quotation_no,
       --pha.segment1||CHR(10)||'SQ-'|| NVL(PHA.ATTRIBUTE8,'NO Ref') quotation_no, 
        pha.segment1 quotation_no, 
       pd.item_code, pol.item_description,
       TO_CHAR(TO_DATE(SUBSTR(pol.attribute4,1,11),'YYYY MM DD'),'DD-MON-RRRR') DEL_DATE,
        muom.uom_code uom,
   --     (pol.unit_price*nvl(pha.rate,1)) unit_price,
   pol.unit_price unit_price,
       pov.vendor_name,
        DECODE(NVL(XX_QUOTE_APP_REASON (POL.PO_LINE_ID),'X'),'X','Not Approved','Approved') item_approved, 
     --  pol.note_to_vendor note_to_supplier,
       XX_QUOTE_APP_REASON (POL.PO_LINE_ID) note_to_supplier,
       XX_QUOTE_APP_COMMENTS (POL.PO_LINE_ID) approved_comments,
       plt.line_type,
       pov.vendor_name || ' [' || pov.segment1
       || ']' vendor_name_vendor_number,
       pvs.vendor_site_code vendor_site,POL.ITEM_ID,
       POL.ATTRIBUTE3 specifications,
       PRFQ.BRND BRANDDD,  
       PRFQ.ORGN ORIGINNN,
       PRFQ.SPEC specificationsss --new
      -- decode(price_ev,'Y',pol.unit_price*nvl(pha.rate,1),0) selected_price
  FROM (SELECT poh.po_header_id, POH.ATTRIBUTE1,POH.QUOTE_TYPE_LOOKUP_CODE||' RFQ' QUOTE_TYPE,POH.COMMENTS,
                             poh.segment1 rfq_num,
                             poh.created_by,
                             POl.po_line_id, 
                             TRUNC (poh.creation_date) rfq_cret_dt, POL.ATTRIBUTE1 BRND, POL.ATTRIBUTE2 ORGN, POL.ATTRIBUTE3 SPEC
          FROM po_headers_all poh, po_lookup_codes plc,PO_LINES_ALL POL
         WHERE poh.type_lookup_code = 'RFQ'
          AND poh.status_lookup_code IN ('A', 'I', 'P')
           AND poh.status_lookup_code = plc.lookup_code
         AND plc.lookup_type = 'RFQ/QUOTE STATUS'
           AND POH.PO_HEADER_ID=POL.PO_HEADER_ID  
           AND (:p_rfq_no iS NULL or POH.PO_HEADER_ID = :p_rfq_no)
           AND  (:p_org_id IS NULL OR poh.org_id = :p_org_id)
                      ) prfq,
       po_headers_all pha,
     --  AP_TERMS APT,
       po_lookup_codes plc,
       mtl_units_of_measure_tl muom,
       po_lines_all pol,
       po_line_types plt,
       AP_SUPPLIERS pov,
       AP_SUPPLIER_sites_ALL pvs,
       HR_OPERATING_UNITS HRO,
       (SELECT inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4 item_code
                   FROM mtl_system_items
                   GROUP BY inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4) pd,
       (SELECT NVL(SUM(NVL(PLLA.QUANTITY,0)),0) PLL_QTY,PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID
            FROM PO_LINE_LOCATIONS_ALL PLLA,XX_PO_QUOTATION_APPROVALS_V PAV
                          WHERE PAV.LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID 
            AND PLLA.ATTRIBUTE1 IS NULL
            GROUP BY PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID) PLL                 
 WHERE prfq.po_header_id = pha.from_header_id
   AND prfq.po_line_id=POL.FROM_LINE_ID
   AND pha.type_lookup_code = 'QUOTATION'
   AND PHA.ORG_ID=POL.ORG_ID 
   AND PHA.ORG_ID=HRO.ORGANIZATION_ID
 AND pha.status_lookup_code IN ('A', 'I', 'P')
   AND pha.status_lookup_code = plc.lookup_code
  AND plc.lookup_type = 'RFQ/QUOTE STATUS'
   AND pha.po_header_id = pol.po_header_id
   AND POL.PO_HEADER_ID=PLL.PO_HEADER_ID(+)
   AND POL.PO_LINE_ID=PLL.PO_LINE_ID(+)
   AND pha.org_id = :p_org_id
   AND pol.line_type_id = plt.line_type_id
   AND POV.VENDOR_ID=PVS.VENDOR_ID
   AND pol.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND pov.vendor_id = pha.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id(+)
   AND pol.item_id = pd.inventory_item_id
--   AND PHA.TERMS_ID(+)=APT.TERM_ID
   AND PRFQ.QUOTE_TYPE='BID RFQ'
  AND (:p_rfq_no IS NULL OR prfq.po_header_id = :p_rfq_no)
 AND POL.ITEM_ID=NVL(:P_ITEM_ID,POL.ITEM_ID)
   union all
   SELECT PRFQ.PO_HEADER_ID,
   pha.APPROVED_DATE,
   DECODE (pol.unit_price*nvl(pha.rate,1),
               MIN (pol.unit_price*nvl(pha.rate,1)) OVER (PARTITION BY pol.item_id), 'Y',
               'N'
              ) price_ev, 
              --APT.NAME  TERM_NAME,
      prfq.po_line_id,
      PHA.CURRENCY_CODE,
     pol.line_num qoutation_line_num,
      PRFQ.QUOTE_TYPE,
      PRFQ.COMMENTS,
      -- XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY(POL.PO_LINE_ID,:P_ORG_ID) qty_req,
      XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY_C(POL.PO_LINE_ID,:P_ORG_ID) qty_req,
(SELECT SUM(PLL.QUANTITY) FROM XX_PO_QUOTATION_APPROVALS_V PAV, PO_LINE_LOCATIONS_ALL PLL, PO_LINES_ALL PLA WHERE PAV.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID AND PLL.PO_LINE_ID=PLA.PO_LINE_ID AND PLA.PO_LINE_ID=POL.PO_LINE_ID) QUOT_QTY,
       prfq.rfq_num rfq_num, 
      TO_CHAR(prfq.rfq_cret_dt,'DD-MON-RRRR') rfq_cret_dt, 
        XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(prfq.rfq_cret_dt,prfq.created_by) Prepared_by,
      -- XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(substr(pha.attribute12,1,11),to_number(substr(pha.attribute12,13,50))) Checked_by,
      null Checked_by,
      -- XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(substr(pol.attribute12,1,11),to_number(substr(pol.attribute12,13,50))) Approved_by,
     null Approved_by,
       POL.ATTRIBUTE7 USE_AREA, 
           POL.ATTRIBUTE1 BRAND,  
           POL.ATTRIBUTE2 ORIGIN,  
           POL.ATTRIBUTE8 MAKE, 
    --     pol.ATTRIBUTE5 Discount,
          PHA.QUOTE_VENDOR_QUOTE_NUMBER SUPP_QUOTE,
            pol.ATTRIBUTE5 Discount_pri,
     --   ROUND((pol.unit_price*nvl(pha.rate,1)) * (nvl(pol.ATTRIBUTE8,0)/100),3) Discount_pri,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION(POL.PO_LINE_ID,:P_ORG_ID) requisition_num_c,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_DT(POL.PO_LINE_ID,:P_ORG_ID) pr_creation,
      -- pha.segment1||CHR(10)||DECODE(NVL(PHA.QUOTE_VENDOR_QUOTE_NUMBER,'NA'),'NA',PHA.QUOTE_VENDOR_QUOTE_NUMBER,'SQ-'||PHA.QUOTE_VENDOR_QUOTE_NUMBER) quotation_no, 
       pha.segment1 quotation_no,
pd.item_code, pol.item_description,    
      TO_CHAR(TO_DATE(SUBSTR(pol.attribute4,1,11),'YYYY MM DD'),'DD-MON-RRRR') DEL_DATE,
        muom.uom_code uom,
   --     (pol.unit_price*nvl(pha.rate,1)) unit_price,
    pol.unit_price unit_price,
       pov.vendor_name, 
       DECODE(NVL(XX_QUOTE_APP_REASON (POL.PO_LINE_ID),'X'),'X','Not Approved','Approved') item_approved,
     --  pol.note_to_vendor note_to_supplier,
     XX_QUOTE_APP_REASON (POL.PO_LINE_ID) note_to_supplier,
          XX_QUOTE_APP_COMMENTS (POL.PO_LINE_ID) approved_comments,
       plt.line_type,
       pov.vendor_name || ' [' || pov.segment1
       || ']' vendor_name_vendor_number,
       pvs.vendor_site_code vendor_site,POL.ITEM_ID,
       pol.ATTRIBUTE3 specifications,
       PRFQ.BRND BRANDDD,  
       PRFQ.ORGN ORIGINNN,
       PRFQ.SPEC specificationsss --new
       --decode(price_ev,'Y',pol.unit_price*nvl(pha.rate,1),0) selected_price
  FROM (SELECT poh.po_header_id, POH.ATTRIBUTE1,POH.QUOTE_TYPE_LOOKUP_CODE||' RFQ' QUOTE_TYPE,POH.COMMENTS,
                             poh.segment1 rfq_num,
                             poh.created_by,
                             POl.po_line_id, 
                             TRUNC (poh.creation_date) rfq_cret_dt, POL.ATTRIBUTE1 BRND, POL.ATTRIBUTE2 ORGN, POL.ATTRIBUTE3 SPEC
          FROM po_headers_all poh, po_lookup_codes plc,PO_LINES_ALL POL
         WHERE poh.type_lookup_code = 'RFQ'
          AND poh.status_lookup_code IN ('A', 'I', 'P')
           AND poh.status_lookup_code = plc.lookup_code
         AND plc.lookup_type = 'RFQ/QUOTE STATUS'
           AND POH.PO_HEADER_ID=POL.PO_HEADER_ID  
           AND (:p_rfq_no iS NULL or POH.PO_HEADER_ID = :p_rfq_no)
           AND  (:p_org_id IS NULL OR poh.org_id = :p_org_id)
                      ) prfq,
       po_headers_all pha,
     --  AP_TERMS APT,
       po_lookup_codes plc,
       mtl_units_of_measure_tl muom,
       po_lines_all pol,
       po_line_types plt,
       AP_SUPPLIERS pov,
       AP_SUPPLIER_sites_ALL pvs,
       HR_OPERATING_UNITS HRO,
       (SELECT inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4 item_code
                   FROM mtl_system_items
                   GROUP BY inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4) pd,
                         (SELECT NVL(SUM(NVL(PLLA.QUANTITY,0)),0) PLL_QTY,PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID
            FROM PO_LINE_LOCATIONS_ALL PLLA,XX_PO_QUOTATION_APPROVALS_V PAV
                          WHERE PAV.LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID 
            AND PLLA.ATTRIBUTE1 IS NULL
            GROUP BY PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID) PLL                            
 WHERE prfq.po_header_id = pha.from_header_id
   AND prfq.po_line_id=POL.FROM_LINE_ID
   AND pha.type_lookup_code = 'QUOTATION'
   AND PHA.ORG_ID=POL.ORG_ID 
   AND PHA.ORG_ID=HRO.ORGANIZATION_ID
 AND pha.status_lookup_code IN ('A', 'I', 'P')
   AND pha.status_lookup_code = plc.lookup_code
  AND plc.lookup_type = 'RFQ/QUOTE STATUS'
   AND pha.po_header_id = pol.po_header_id
   AND POL.PO_HEADER_ID=PLL.PO_HEADER_ID(+)
   AND POL.PO_LINE_ID=PLL.PO_LINE_ID(+)
   AND pha.org_id = :p_org_id
   AND pol.line_type_id = plt.line_type_id
   AND POV.VENDOR_ID=PVS.VENDOR_ID
   AND pol.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND pov.vendor_id = pha.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id(+)
   AND pol.item_id = pd.inventory_item_id
   AND PRFQ.QUOTE_TYPE='STANDARD RFQ'
 --AND (:p_rfq_no iS NULL or PHA.PO_HEADER_ID = :p_rfq_no)
AND PRFQ.PO_HEADER_ID=NVL(:p_rfq_no,prfq.po_header_id)  
AND POL.ITEM_ID=NVL(:P_ITEM_ID,POL.ITEM_ID)
UNION ALL
SELECT PRFQ.PO_HEADER_ID,
pha.APPROVED_DATE,
       DECODE (pol.unit_price*nvl(pha.rate,1),
               MIN (pol.unit_price*nvl(pha.rate,1)) OVER (PARTITION BY pol.item_id), 'Y',
               'N'
              ) price_ev, 
              --APT.NAME  TERM_NAME,
      prfq.po_line_id,
      PHA.CURRENCY_CODE,
     pol.line_num quotation_line_num,
      PRFQ.QUOTE_TYPE,
      PRFQ.COMMENTS,
       XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY_C(POL.PO_LINE_ID,:P_ORG_ID)+NVL(PLL_QTY,0) qty_req,
         (SELECT SUM(PLL.QUANTITY) FROM XX_PO_QUOTATION_APPROVALS_V PAV, PO_LINE_LOCATIONS_ALL PLL, PO_LINES_ALL PLA WHERE PAV.LINE_LOCATION_ID=PLL.LINE_LOCATION_ID AND PLL.PO_LINE_ID=PLA.PO_LINE_ID AND PLA.PO_LINE_ID=POL.PO_LINE_ID) QUOT_QTY,
    --   XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_QTY(POL.PO_LINE_ID,:P_ORG_ID) qty_req,
       prfq.rfq_num rfq_num, 
      TO_CHAR(prfq.rfq_cret_dt,'DD-MON-RRRR') rfq_cret_dt, 
       XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(prfq.rfq_cret_dt,prfq.created_by) Prepared_by,
       --XX_P2P_EMP_INFO.xx_P2P_GET_EMPNP_MAIL(substr(pha.attribute12,1,11),to_number(substr(pha.attribute12,13,50))) Checked_by,
       null Checked_by, 
       --XX_P2P_EMP_INFO.xx_P2P_GET_EMPNP_MAIL(substr(pol.attribute12,1,11),to_number(substr(pol.attribute12,13,50))) Approved_by,
       null Approved_by,
       POL.ATTRIBUTE7 USE_AREA,
           POL.ATTRIBUTE1 BRAND,  
           POL.ATTRIBUTE2 ORIGIN,  
           POL.ATTRIBUTE8 MAKE,  
        -- pol.ATTRIBUTE5 Discount,
         PHA.QUOTE_VENDOR_QUOTE_NUMBER SUPP_QUOTE,
         pol.ATTRIBUTE5 Discount_pri,
       -- ROUND((pol.unit_price*nvl(pha.rate,1)) * (nvl(pol.ATTRIBUTE8,0)/100),3) Discount_pri,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION(POL.PO_LINE_ID,:P_ORG_ID) requisition_num_c,
        XX_P2P_PKG.XX_PRICE_BRK_REQUISITION_DT(POL.PO_LINE_ID,:P_ORG_ID) pr_creation,
      --  pha.segment1||CHR(10)||DECODE(NVL(PHA.ATTRIBUTE8,'NA'),'NA',PHA.QUOTE_VENDOR_QUOTE_NUMBER,'SQ-'||PHA.QUOTE_VENDOR_QUOTE_NUMBER) quotation_no,
       --pha.segment1||CHR(10)||'SQ-'|| NVL(PHA.ATTRIBUTE8,'NO Ref') quotation_no, 
        pha.segment1 quotation_no, 
       pd.item_code, pol.item_description,
       TO_CHAR(TO_DATE(SUBSTR(pol.attribute4,1,11),'YYYY MM DD'),'DD-MON-RRRR') DEL_DATE,
        muom.uom_code uom,
   --     (pol.unit_price*nvl(pha.rate,1)) unit_price,
   pol.unit_price unit_price,
       pov.vendor_name,
        DECODE(NVL(XX_QUOTE_APP_REASON (POL.PO_LINE_ID),'X'),'X','Not Approved','Approved') item_approved, 
     --  pol.note_to_vendor note_to_supplier,
       XX_QUOTE_APP_REASON (POL.PO_LINE_ID) note_to_supplier,
       XX_QUOTE_APP_COMMENTS (POL.PO_LINE_ID) approved_comments,
       plt.line_type,
       pov.vendor_name || ' [' || pov.segment1
       || ']' vendor_name_vendor_number,
       pvs.vendor_site_code vendor_site,POL.ITEM_ID,
       POL.ATTRIBUTE3 specifications,
       PRFQ.BRND BRANDDD,  
       PRFQ.ORGN ORIGINNN,
       PRFQ.SPEC specificationsss --new
      -- decode(price_ev,'Y',pol.unit_price*nvl(pha.rate,1),0) selected_price
  FROM (SELECT poh.po_header_id, POH.ATTRIBUTE1,POH.QUOTE_TYPE_LOOKUP_CODE||' RFQ' QUOTE_TYPE,POH.COMMENTS,
                             poh.segment1 rfq_num,
                             poh.created_by,
                             POl.po_line_id, 
                             TRUNC (poh.creation_date) rfq_cret_dt, POL.ATTRIBUTE1 BRND, POL.ATTRIBUTE2 ORGN, POL.ATTRIBUTE3 SPEC
          FROM po_headers_all poh, po_lookup_codes plc,PO_LINES_ALL POL
         WHERE poh.type_lookup_code = 'RFQ'
          AND poh.status_lookup_code IN ('A', 'I', 'P')
           AND poh.status_lookup_code = plc.lookup_code
         AND plc.lookup_type = 'RFQ/QUOTE STATUS'
           AND POH.PO_HEADER_ID=POL.PO_HEADER_ID  
           AND (:p_rfq_no iS NULL or POH.PO_HEADER_ID = :p_rfq_no)
           AND  (:p_org_id IS NULL OR poh.org_id = :p_org_id)
                      ) prfq,
       po_headers_all pha,
     --  AP_TERMS APT,
       po_lookup_codes plc,
       mtl_units_of_measure_tl muom,
       po_lines_all pol,
       po_line_types plt,
       AP_SUPPLIERS pov,
       AP_SUPPLIER_sites_ALL pvs,
       HR_OPERATING_UNITS HRO,
       (SELECT inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4 item_code
                   FROM mtl_system_items
                   GROUP BY inventory_item_id,
                        segment1 || '-' || segment2 || '-'
                        || segment3|| '-' || segment4) pd,
       (SELECT NVL(SUM(NVL(PLLA.QUANTITY,0)),0) PLL_QTY,PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID,PLLA.ATTRIBUTE14
            FROM PO_LINE_LOCATIONS_ALL PLLA,XX_PO_QUOTATION_APPROVALS_V PAV
                          WHERE PAV.LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID 
           -- WHERE ATTRIBUTE1 IS NULL
            GROUP BY PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID,PLLA.ATTRIBUTE14) PLL              
 WHERE prfq.po_line_id=PLL.ATTRIBUTE14
   AND pha.type_lookup_code = 'QUOTATION'
   AND PHA.ORG_ID=POL.ORG_ID 
   AND PHA.ORG_ID=HRO.ORGANIZATION_ID
 AND pha.status_lookup_code IN ('A', 'I', 'P')
   AND pha.status_lookup_code = plc.lookup_code
  AND plc.lookup_type = 'RFQ/QUOTE STATUS'
   AND pha.po_header_id = pol.po_header_id
   AND POL.PO_HEADER_ID=PLL.PO_HEADER_ID(+)
   AND POL.PO_LINE_ID=PLL.PO_LINE_ID(+)
   AND pha.org_id = :p_org_id
   AND pol.line_type_id = plt.line_type_id
   AND POV.VENDOR_ID=PVS.VENDOR_ID
   AND pol.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND pov.vendor_id = pha.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id(+)
   AND pol.item_id = pd.inventory_item_id
--   AND PHA.TERMS_ID(+)=APT.TERM_ID
   AND PRFQ.QUOTE_TYPE='BID RFQ'
  AND (:p_rfq_no IS NULL OR prfq.po_header_id = :p_rfq_no)
 AND POL.ITEM_ID=NVL(:P_ITEM_ID,POL.ITEM_ID)
  order by 19 desc 
  
  
  --============================================ 
  
  select * from  mtl_system_items_b msb   
  
  select * from mtl_item_categories  mic
  
  select * from mtl_categories mc
  
  select  count(distinct(msb.INVENTORY_ITEM_ID)),msb.ORGANIZATION_ID,msb.DESCRIPTION,msb.SEGMENT1||'|'||msb.SEGMENT2||'|'||msb.SEGMENT3||'|'||msb.SEGMENT4 Item_code,
  msb.INVENTORY_ITEM_STATUS_CODE
   from  mtl_system_items_b msb, mtl_item_categories  mic 
   WHERE   msb.INVENTORY_ITEM_ID = mic.INVENTORY_ITEM_ID
  group by msb.ORGANIZATION_ID,DESCRIPTION,msb.SEGMENT1||'|'||msb.SEGMENT2||'|'||msb.SEGMENT3||'|'||msb.SEGMENT4,msb.INVENTORY_ITEM_STATUS_CODE
  
  select * from xxkbg_bi_po_GRN
  
  
  --=========================================================================== 
  
 
--------------------------------------------------------------------------------------------

  
 select distinct(Finance_category), item, DESCRIPTION,  Item_code, INVENTORY_ITEM_STATUS_CODE,ORGANIZATION_ID,  from
(SELECT distinct(msb.INVENTORY_ITEM_ID) item, msb.ORGANIZATION_ID ORGANIZATION_ID, msb.DESCRIPTION, 
msb.SEGMENT1||'|'||msb.SEGMENT2||'|'||msb.SEGMENT3||'|'||msb.SEGMENT4 Item_code,
msb.INVENTORY_ITEM_STATUS_CODE,mc.SEGMENT1 Finance_category
from mtl_system_items_b msb,
mtl_item_categories  mic,
mtl_categories mc
where msb.INVENTORY_ITEM_ID =mic.INVENTORY_ITEM_ID
and mic.CATEGORY_ID = mc.CATEGORY_ID) b  


-----------------------------------------------------------------------------------------------------------------------------
 select * FROM mtl_item_categories mic  
      
  select * FROM  mtl_category_sets_tl mcst    
     
  select * FROM  mtl_category_sets_b mcs    
     
 --mfg_lookups ml,       
  select * FROM  mtl_categories_b_kfv mc  
       
 select * FROM  mtl_system_items_b msi  
 
SELECT distinct msi.segment1||'|'|| msi.segment2||'|'|| msi.segment3||'|'|| msi.segment4  item_code, msi.description item_desc, 
mc.segment1 Finance_category , mc.CONCATENATED_SEGMENTS  INV_CATEGORY
 FROM mtl_item_categories mic,       
 mtl_category_sets_tl mcst,       
 mtl_category_sets_b mcs,       
 --mfg_lookups ml,       
 mtl_categories_b_kfv mc,        
mtl_system_items_b msi  
WHERE mic.category_set_id = mcs.category_set_id   
 AND mcs.category_set_id = mcst.category_set_id   
 AND mcst.LANGUAGE = USERENV ('LANG')    
AND mic.category_id = mc.category_id    
--AND mic.organization_id = 3   
 --and upper(mc.concatenated_segments) like '%CAPITAL%'    
AND msi.organization_id = mic.organization_id    
AND msi.inventory_item_id = mic.inventory_item_id   
 --and mcst.category_set_name='PURCHASING CATEGORY SET'    
--AND ( mc.segment12 IN ('COMPONENT', 'NONE') OR mc.segment12 LIKE '%TOOL%') 

  
  --=========================================================================

  
  
  --  EBS Purchase Requisition(PR) Summary 
  
  SELECT prh.requisition_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       ppg.segment2 Department,
       prh.attribute15 Priority,
       prl.reference_num move_order_no,
      (select mtrl.quantity from mtl_txn_request_lines mtrl,mtl_txn_request_headers mtrh where mtrh.header_id=mtrl.header_id and mtrl.inventory_item_id=prl.item_id and mtrh.request_number=prl.reference_num ) move_order_qty,
      (select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PROJECT' and b.flex_value=prh.attribute1) Project_Name,
       nvl(prh.authorization_status,'INCOMPLETE') req_status,
       prl.SUGGESTED_BUYER_ID,
       prh.preparer_id,
       prl.TO_PERSON_ID,
      APPS.XX_KBG_REQUISITION_DEPT(PRL.TO_PERSON_ID) REQUESTER_DEPT,
       ppf.full_name,
       prh.attribute1 BUDGET_NO,
       prl.item_id,
       mst.item_code,
       mst.description,
       prl.QUANTITY Unit,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPO,
       xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPD,
        xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LPR,
         xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID,prh.creation_date) LP_SUPP,
       MUOM.UOM_CODE UOM,
       HRL1.LOCATION_CODE,
       to_char(trunc(prl.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE,
       paaf.job_id,
       pj.NAME,
       pj.job_definition_id,
      -- pjd.segment1 department,
       (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3 ) Use_of_Area,--and use_area_type='XXKSRM_USE_AREA') Use_of_Area,
       prl.NOTE_TO_RECEIVER,
       prl.DESTINATION_ORGANIZATION_ID,
       HRO.ORGANIZATION_CODE ORG_CODE,
       PRH.TYPE_LOOKUP_CODE REQ_TYPE,
       substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID)||' - '||HRO.ORGANIZATION_CODE dest_org_name   ,    
          (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
    TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N') CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION ,
       to_char(:P_F_PR_DT,'DD-MON-RRRR') from_date,
       to_char(:P_T_PR_DT,'DD-MON-RRRR') to_datee
  FROM po_requisition_headers_all prh,
       po_requisition_lines_all prl,
       mtl_units_of_measure_tl muom,
       per_people_f ppf,
       per_all_assignments_f paaf,
       pay_people_groups ppg,
       per_jobs pj,
       per_job_definitions pjd,
              PER_all_positions pp,
       PER_position_definitions pd,
       ORG_ORGANIZATION_DEFINITIONS HRO,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
        hr_operating_units HOU           
 WHERE prh.requisition_header_id = prl.requisition_header_id
   AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
   AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
   AND prh.preparer_id = ppf.person_id
   AND prh.preparer_id = paaf.person_id
  AND HRL.LOCATION_ID=DELIVER_TO_LOCATION_ID
  AND HRL1.LOCATION_ID=PAAF.LOCATION_ID
   AND ppf.person_id = paaf.person_id
   AND paaf.job_id(+) = pj.job_id
   AND ppg.people_group_id(+) = paaf.people_group_id
   AND pj.job_definition_id(+) = pjd.job_definition_id
   AND pp.position_id=paaf.position_id
   AND pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
   AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
  AND PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
  AND HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID 
   AND prl.item_id = mst.inventory_item_id
   AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
      and prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
 AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
 AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org,PRL.DESTINATION_ORGANIZATION_ID)
 AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  --AND MST.item_code BETWEEN NVL(:P_ITEM_From,MST.item_code) AND NVL(:P_ITEM_To,MST.item_code)
 --AND nvl(PRL.ATTRIBUTE9,'x')=nvl(:P_DEPT,nvl(PRL.ATTRIBUTE9,'x'))
 -- AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
  --AND prl.TO_PERSON_ID = NVL(:p_dept,prl.TO_PERSON_ID)
   and APPS.XX_KBG_REQUISITION_DEPT(PRL.TO_PERSON_ID)= NVL(:p_dept, APPS.XX_KBG_REQUISITION_DEPT(PRL.TO_PERSON_ID) )
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
  -- AND TRUNC(prh.creation_date) BETWEEN  nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
--AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date)) 
AND TRUNC(PRH.CREATION_DATE) BETWEEN NVL(:P_F_PR_DT,TRUNC(PRH.CREATION_DATE)) AND NVL(:P_T_PR_DT,TRUNC(PRH.CREATION_DATE))
 AND PRH.TYPE_LOOKUP_CODE='PURCHASE'
 AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
   AND NVL(UPPER(PRH.ATTRIBUTE_CATEGORY),0) NOT IN ('SHIPPING INFORMATION')
   AND NVL(UPPER(PRL.ATTRIBUTE_CATEGORY),0) NOT IN ('BRANDING')
   AND  upper(prh.attribute15) =upper( NVL(:P_PRIORITY,  prh.attribute15))
ORDER BY PRL.REQUISITION_LINE_ID 





select * from PO_REQUISITION_HEADERS_ALL where segment1 = 10000002 and org_id = 81


 select * from XX_P2P_PKG.XX_REQUISITION_DEPT


fnd_user fu, per_people_x ppx, per_assignments_x pax, per_positions ppos, per_position_definitions ppd_in, (select distinct segment5, segment3 from per_position_definitions) ppd_out

distinct prl.TO_PERSON_ID, paf.LAST_NAME  from po_requisition_lines_all prl, per_all_people_f paf)

SELECT  * from WBI_HR_EMPLOYEE_DETAILS_D;

SELECT  distinct department_name  from WBI_HR_EMPLOYEE_DETAILS_D; 

select * from XX_KBG_DEPT_V

select  distinct paf.DEPARTMENT_NAME  from po_requisition_lines_all prl,  WBI_HR_EMPLOYEE_DETAILS_D paf where prl.TO_PERSON_ID(+)= paf.PERSON_ID and paf.DEPARTMENT_NAME is not null and sysdate between paf.EFFECTIVE_START_DATE and paf.EFFECTIVE_END_DATE


select DISTINCT(DEPARTMENT_NAME), from WBI_HR_EMPLOYEE_DETAILS_D where person_id = 225

select  DEPARTMENT_NAME  from WBI_HR_EMPLOYEE_DETAILS_D wd 
 where (select to_person_id from  
            po_requisition_lines_all prl 
            where prl.person_id = wd.person_id) 

select distinct to_person_id from po_requisition_lines_all 

fnd_user fu, per_people_x ppx, per_assignments_x pax, per_positions ppos, per_position_definitions ppd_in, (select distinct segment5, segment3 from per_position_definitions) ppd_out

SELECT DISTINCT UPPER(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1,INSTR(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1),'.',1)-1))  DEPT FROM PER_ALL_POSITIONS PAP

(SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME FROM WBI_HR_EMPLOYEE_DETAILS_D) WHED_DEPT

(SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME FROM WBI_HR_EMPLOYEE_DETAILS_D) WHED_DEPT









-- and  prl.requisition_header_id=34002



select * from  po_requisition_headers_all where requisition_header_id=34002

select * from PO_requisition_headers_all where segment1 = 10000019 and org_id = 81

  select * from po_requisition_headers_all where segment1 = '10001004'

select * from po_requisition_headers_all where segment1 = '10000846' 

select * from PO_requisition_lines_all where requisition_header_id = 926031 

select * from PO_requisition_lines_all where requisition_header_id = 806037 



SELECT  * from WBI_HR_EMPLOYEE_DETAILS_D; 

select * from per_all_people_f where person_id = 225 

select * from per_people_f  where EMPLOYEE_NUMBER = 3297

select * from per_people_x 

select * from per_all_people_f where FIRST_NAME = 'KG-5243'

select * from per_all_people_f where FIRST_NAME = 'KG-4497' 

select * from  per_people_f

select * from  pay_people_groups ppg

select * from  per_all_assignments_f

SELECT  DISTINCT(SEGMENT3) from per_position_definitions ;

select * from FND_lookup_values where lookup_type = 'KSRM_DEPT'

SELECT  KG-4337


select * from per_position_definitions where SEGMENT3 = 'Workshop'


  
  
  
  
  
  
  
  
  
  
  
  
  
      
                  
         
         
         