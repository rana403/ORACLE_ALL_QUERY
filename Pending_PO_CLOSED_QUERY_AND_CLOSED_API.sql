
 --=====================================================
 -- PO APPROVED BUT NOT GRN
 -- IF  ADD THIS CONDITION THEN PARTIAL GRN WILL NOT SHOW ( and  pll.quantity_received  =  0 )
 
 --=====================================================
 
 select * from PO_HEADERS_ALL where segment1 = 40000010 -- and org_id= 81
 
 SELECT * FROM PO_HEADERS_ALL WHERE PO_HEADER_ID= 220012 -- 482281
 
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
        --AND PHA.CLOSED_CODE   IN ( 'CLOSED')
        --AND PHA.CLOSED_CODE  NOT IN ( 'CLOSED', 'FINALLY CLOSED')
       and pha.ATTRIBUTE1  IN ( 'SIS','IL','INL','LFA','L','IFA')
       -- and  pll.quantity_received  =  0
        AND pha.org_id = :P_OU_NAME
       AND (:P_POAPPROVE_FROM_DT IS NULL OR TRUNC(pha.approved_date) BETWEEN :P_POAPPROVE_FROM_DT AND :P_POAPPROVE_TO_DT) 
      --and pha.po_header_id= 112004
     --AND pha.segment1 ='40000043'  
   ORDER BY pha.segment1  --aps.vendor_name, pla.item_description;
   
   --=========================================================================================================================
   
   ------ FOR PO FINALLY CLOSED  API :  TESTED AND OK DATE: 2-OCT-2021======== 

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
AND PHA.ORG_ID= '81'
AND pha.segment1 = '40000010'; -- Enter the PO Number if one PO needs to be finally closed/Closed

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


--=====================================================================================

   ------ FOR PO ONLY CLOSED  API :  TESTED AND OK DATE: 2-OCT-2021======== 
     
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

--==================================================================================================================

