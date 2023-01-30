--PENDING PR FOR UAT

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
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
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
       rt.RECEIPT_QTY received_qty,
      rt.REJECTED_QTY quantity_rejected ,
     RT.DELIVER_QTY quantity_delivered,
       nvl(pda.quantity_billed,0) quantity_billed,
       nvl(pda.quantity_cancelled,0) quantity_cancelled,
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
       prL.ATTRIBUTE3 Use_of_Area,
       prl.NOTE_TO_RECEIVER,
      prl.DESTINATION_ORGANIZATION_ID,
     HRO.ORGANIZATION_CODE ORG_CODE,
     PRH.TYPE_LOOKUP_CODE REQ_TYPE,
     PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
   (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID)||' - '||HRO.ORGANIZATION_CODE dest_org_name   ,    
         (select location_code from hr_locations_all where location_id=prl.DELIVER_TO_LOCATION_ID) dest_location,
   TO_CHAR (TRUNC (prh.APPROVED_DATE),'DD-MON-RRRR') APPROVED_DATE,
       NVL(PRL.CANCEL_FLAG,'N')  CANCEL_FLAG, 
       DECODE(PRL.CLOSED_CODE,NULL,'N','Y') CLOSED_FLAG,
       HRL.DESCRIPTION LOC,
       PRL.JUSTIFICATION
  from po_requisition_headers_all prh
  left outer join po_requisition_lines_all prl
  on prh.requisition_header_id=prl.requisition_header_id
  AND prl.MODIFIED_BY_AGENT_FLAG is null
  left outer join po_req_distributions_all prda
  on prl.requisition_line_id=prda.requisition_line_id
  left outer join po_distributions_all pda
  on prda.distribution_id=pda.req_distribution_id
  left outer join po_headers_all pha
  on pda.po_header_id=pha.po_header_id
  left outer join po_lines_all pla
  on pda.po_line_id=pla.po_line_id
 --AND prl.MODIFIED_BY_AGENT_FLAG is null
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
 where UPPER(NVL(PRL.ATTRIBUTE_CATEGORY,0)) NOT IN ('BRANDING')
 AND UPPER(NVL(PRH.ATTRIBUTE_CATEGORY,0)) NOT IN ('SHIPPING_INFO')
 AND TRUNC(prh.creation_date) BETWEEN NVL(:P_F_PR_DT,TRUNC(prh.creation_date)) AND NVL(:P_T_PR_DT,TRUNC(prh.creation_date))
AND prh.requisition_header_id=NVL(:P_REQ_NO,prh.requisition_header_id)
 AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
 AND PRH.TYPE_LOOKUP_CODE='PURCHASE' 
 AND PRH.AUTHORIZATION_STATUS =nvl(:p_status,PRH.AUTHORIZATION_STATUS)
 AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)
 
 
 
 
 /*  ==========================================================
 Pending PR Date: 12-DEC-2017  
 ==============================================================
 */
  
 
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
      -- prL.ATTRIBUTE3 Use_of_Area,
       (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3) Use_of_Area,
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
       PRL.JUSTIFICATION,
                     to_char(:P_F_PR_DT,'DD-MON-RRRR') from_date,
       to_char(:P_T_PR_DT,'DD-MON-RRRR') to_datee
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
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst
  on prl.item_id = mst.inventory_item_id
  AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
  left outer join hr_operating_units HOU
  on HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID
  left outer join (SELECT DISTINCT  PO_HEADER_ID,PO_LINE_ID,(NVL(SUM(RECEIPT_QTY),0)-(NVL(SUM(DLV_RETURN_QTY),0)+ NVL(SUM(RETURN_QTY),0))) RECEIPT_QTY,
    SUM(ACCEPTED_QTY) ACCEPTED_QTY, NVL(SUM(REJECTED_QTY),0)- (SUM(RETURN_QTY)+(SUM((DLV_RETURN_QTY)))) REJECTED_QTY, (NVL(SUM(RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) - (NVL(SUM(RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0))RETURN_QTY,
                         (SUM((DELIVER_QTY))-NVL(SUM(DLV_RETURN_QTY),0)) DELIVER_QTY
                        FROM WBI_INV_RCV_TRANSACTIONS_F 
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY PO_HEADER_ID,PO_LINE_ID) RT
  on pha.po_header_id=rt.po_header_id
  and pla.po_line_id=rt.po_line_id
 -- and pha.po_header_id IS NOT NULL
 LEFT OUTER JOIN pay_people_groups ppg
 ON paaf.people_group_id=ppg.people_group_id
 LEFT OUTER JOIN PER_all_positions pp
 ON paaf.position_id=pp.position_id
 LEFT OUTER JOIN  PER_position_definitions pd
 ON pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
where UPPER(NVL(PRL.ATTRIBUTE_CATEGORY,0)) NOT IN ('BRANDING')
AND UPPER(NVL(PRH.ATTRIBUTE_CATEGORY,0)) NOT IN ('SHIPPING_INFO')
AND TRUNC(prh.creation_date) BETWEEN NVL(:P_F_PR_DT,TRUNC(prh.creation_date)) AND NVL(:P_T_PR_DT,TRUNC(prh.creation_date))
-- AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1)
--AND prh.requisition_header_id=NVL(:P_REQ_NO,prh.requisition_header_id)
AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
AND nvl(pd.segment2,'x')=nvl(:p_dept,nvl(pd.segment2,'x'))
AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org, PRL.DESTINATION_ORGANIZATION_ID)
AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
AND PRH.TYPE_LOOKUP_CODE='PURCHASE' 
AND PRH.AUTHORIZATION_STATUS =nvl(:p_status,PRH.AUTHORIZATION_STATUS)
AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)  


--===========================================
-- Pending PR Date: 13-DEC-2017  
--===========================================

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
      -- prL.ATTRIBUTE3 Use_of_Area,
       (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3) Use_of_Area,
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
       PRL.JUSTIFICATION,
                     to_char(:P_F_PR_DT,'DD-MON-RRRR') from_date,
       to_char(:P_T_PR_DT,'DD-MON-RRRR') to_datee
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
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst
  on prl.item_id = mst.inventory_item_id
  AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
  left outer join hr_operating_units HOU
  on HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID
  left outer join ( SELECT DISTINCT  PO_HEADER_ID,PO_LINE_ID,SUM(RECEIPT_QTY) RECEIPT_QTY,  SUM(ACCEPTED_QTY) ACCEPTED_QTY, SUM(REJECTED_QTY) REJECTED_QTY,(NVL(SUM( RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) RETURN_QTY,
                         (SUM(DELIVER_QTY)-NVL(SUM(DLV_RETURN_QTY),0)) DELIVER_QTY
                        FROM WBI_INV_RCV_TRANSACTIONS_F 
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY PO_HEADER_ID,PO_LINE_ID) RT
  on pha.po_header_id=rt.po_header_id
  and pla.po_line_id=rt.po_line_id
 -- and pha.po_header_id IS NOT NULL
 LEFT OUTER JOIN pay_people_groups ppg
 ON paaf.people_group_id=ppg.people_group_id
 LEFT OUTER JOIN PER_all_positions pp
 ON paaf.position_id=pp.position_id
 LEFT OUTER JOIN  PER_position_definitions pd
 ON pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
where UPPER(NVL(PRL.ATTRIBUTE_CATEGORY,0)) NOT IN ('BRANDING')
AND UPPER(NVL(PRH.ATTRIBUTE_CATEGORY,0)) NOT IN ('SHIPPING_INFO')
AND TRUNC(prh.creation_date) BETWEEN NVL(:P_F_PR_DT,TRUNC(prh.creation_date)) AND NVL(:P_T_PR_DT,TRUNC(prh.creation_date))
-- AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1)
--AND prh.requisition_header_id=NVL(:P_REQ_NO,prh.requisition_header_id)
AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)
AND nvl(pd.segment2,'x')=nvl(:p_dept,nvl(pd.segment2,'x'))
AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org, PRL.DESTINATION_ORGANIZATION_ID)
AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
AND PRH.TYPE_LOOKUP_CODE='PURCHASE' 
AND PRH.AUTHORIZATION_STATUS =nvl(:p_status,PRH.AUTHORIZATION_STATUS)
AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)


--===============================================================================

-- XXLOPR 
-- Purchase Requisition

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
       (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3) Use_of_Area,
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
       per_jobs pj,
       per_job_definitions pjd,
       ORG_ORGANIZATION_DEFINITIONS HRO,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '|' || segment2 || '|' || segment3 || '|' || segment4
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
 AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org,PRL.DESTINATION_ORGANIZATION_ID)
 AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  --AND MST.item_code BETWEEN NVL(:P_ITEM_From,MST.item_code) AND NVL(:P_ITEM_To,MST.item_code)
 -- AND prh.requisition_header_id =nvl(:P_REQ_NO,prh.requisition_header_id) 
 AND nvl(PRL.ATTRIBUTE9,'x')=nvl(:P_DEPT,nvl(PRL.ATTRIBUTE9,'x'))
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
 --  AND TRUNC(prh.creation_date) BETWEEN  nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
--AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date)) 
AND NVL(PRH.ATTRIBUTE_CATEGORY,'X') NOT IN 'Planned Requisition'
ORDER BY PRL.REQUISITION_LINE_ID





