--XXLOPR
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
  AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
   --AND  prh.attribute15 = NVL(:P_PEIORITY,  prh.attribute15)
 AND PRH.TYPE_LOOKUP_CODE='PURCHASE'
 AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
  AND NVL(UPPER(PRH.ATTRIBUTE_CATEGORY),0) NOT IN ('SHIPPING INFORMATION')
   AND NVL(UPPER(PRL.ATTRIBUTE_CATEGORY),0) NOT IN ('BRANDING')
ORDER BY PRL.REQUISITION_LINE_ID

--=======================================================
--XXLOPRSUM
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
  AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
  AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
   AND PRH.AUTHORIZATION_STATUS= NVL(:P_STATUS,PRH.AUTHORIZATION_STATUS)
   AND  prh.attribute15 = NVL(:P_PEIORITY,  prh.attribute15)
  -- AND TRUNC(prh.creation_date) BETWEEN  nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
--AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date)) 
AND TRUNC(PRH.CREATION_DATE) BETWEEN NVL(:P_F_PR_DT,TRUNC(PRH.CREATION_DATE)) AND NVL(:P_T_PR_DT,TRUNC(PRH.CREATION_DATE))
AND  prh.attribute15 = NVL(:P_PEIORITY,  prh.attribute15)
 AND PRH.TYPE_LOOKUP_CODE='PURCHASE'
 AND NVL(PRH.ATTRIBUTE_CATEGORY,0) NOT IN ('Planned Requisition')
  AND NVL(UPPER(PRH.ATTRIBUTE_CATEGORY),0) NOT IN ('SHIPPING INFORMATION')
   AND NVL(UPPER(PRL.ATTRIBUTE_CATEGORY),0) NOT IN ('BRANDING')
ORDER BY PRL.REQUISITION_LINE_ID

--=========================================================================================

--XXPRPENDING

SELECT prh.requisition_header_id,
        pha.po_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        prh.requisition_header_id header_id,
        substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
     --   RT.LINE_LOCATION_ID,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
        pha.segment1 po_no,
    --    pla.quantity po_qty,
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),      --old
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,     --old
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR')  APPROVED_DATE,
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
   pll.LINE_LOCATION_ID,
       PLL.QUANTITY_RECEIVED received_qty_pll,
       RT.RECEIPT_QTY RECEIVED_QTY,
        RT.RECEIPT_QTY1 RECEIVED_QTY1,
      PLL.QUANTITY_REJECTED quantity_rejected ,
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
AND  prh.attribute15 = NVL(:P_PEIORITY,  prh.attribute15)
AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)
AND (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3) 
=NVL(:P_USE_OF_AREA, (SELECT USE_AREA FROM XXKSRM_INV_USE_AREA_V IUA WHERE IUA.USE_AREA_ID=prL.ATTRIBUTE3) )




--=======================================================================================

--XXPOTRANSTATUS


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

--=====================================================================================


--XXWOBRAND
--EBS Work Order (Brand) Report
SELECT
pha.attribute4 H_DIS,
PHA.TYPE_LOOKUP_CODE PO_TYPE,
pha.ATTRIBUTE2 supp_con_person,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE6 SUPPLIER_CONTACT_PERSON,
PHA.ATTRIBUTE8 CONTACT_PERSON_CONTACT_NO,
PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE3 CON_PERSON_NO,
PHA.ATTRIBUTE10 TERM_DAYS,
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no ,
(select description from FND_LOOKUP_VALUES_VL where lookup_type = 'XX_OM_SD_AREA' and meaning=pla.attribute7) Area,
(select description from FND_LOOKUP_VALUES_VL where lookup_type = 'XX_OM_SD_ZONE' and meaning=pla.attribute12) Zone,
(SELECT CUSTOMER_NUMBER FROM XX_AR_CUSTOMER_SITE_V WHERE SITE_USE_CODE='BILL_TO' AND ORG_ID=:P_ORG_ID AND CUSTOMER_ID=PLA.ATTRIBUTE13) Customer_No,
(SELECT PARTY_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE SITE_USE_CODE='BILL_TO' AND ORG_ID=:P_ORG_ID AND CUSTOMER_ID=PLA.ATTRIBUTE13) Customer_name,
pla.attribute14 shop_name,
--PHA.ATTRIBUTE14 PROJECT,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
TO_CHAR(TO_DATE(SUBSTR(pha.attribute9,1,11),'YYYY MM DD'),'DD-MON-RRRR') period_from,
TO_CHAR(TO_DATE(SUBSTR(pha.attribute10,1,10),'YYYY MM DD'),'DD-MON-RRRR') period_to,
PHA.CURRENCY_CODE,
PHA.RATE,
ood.ORGANIZATION_CODE destinition,
pov.vendor_name supplier_name,
POV.SEGMENT1 SUPP_NO,       
ADDRESS_LINE1||' '||
ADDRESS_LINE2 Supplier_add,
pvs.city||'-'||pvs.zip City_ZIP,
pvs.phone supp_phone,
pvs.telex,
pvs.EMAIL_ADDRESS supp_email,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE IO,
substr(get_hr_operating_unit(:p_org_id),5,200) Org_header_name,
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE BCL_F_ADD,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE BCL_bill_ADD,
hrl.TELEPHONE_NUMBER_1 F_PHONE,
HRL.TELEPHONE_NUMBER_2 F_FAX,
HRL.LOC_INFORMATION13 F_EMAIL,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID) LC_NO,
pra.release_num,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
mst.CONCATENATED_SEGMENTS item_code,
pla.item_description,MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE,
--PHA.RATE,
PLA.NOTE_TO_VENDOR ,
--pla.ATTRIBUTE5 line_dis,
PLA.ATTRIBUTE3 Specifications ,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
pha1.segment1 quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,pha.ATTRIBUTE8) supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
'(For '||pov.vendor_name||')' SUPP_ALIAS,
--TO_CHAR (TO_DATE (SUBSTR (PHA.ATTRIBUTE10, 1, 10), 'RRRR/MM/DD'),'DD-MON-RRRR') PERIOD_FROM,--||'To'||
         --  TO_CHAR (TO_DATE (SUBSTR (PHA.ATTRIBUTE11, 1, 10), 'RRRR/MM/DD'),'DD-MON-RRRR') PERIOD_TO,
             --    TO_DATE (SUBSTR (PHA.ATTRIBUTE11, 1, 10),'RRRR/MM/DD')-TO_DATE (SUBSTR (PHA.ATTRIBUTE10, 1, 10),'RRRR/MM/DD') DURATION_JOB,
                pha.ATTRIBUTE12 cwip_ord,
                HRL.location_code work_site,
                TO_CHAR(PHA.CLOSED_DATE,'DD-MON-RRRR') CERTIFIED_DATE,
                XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL (pha.creation_date,
                                              pha.AGENT_ID) SUPP_BY,
                 XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL (pha.APPROVED_date,
                                              pha.AGENT_ID) APP_BY,
             --    XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
   substr(ou.name,5,200) org
--  case  when PHA.ATTRIBUTE15 is null then  'VAT Included' else PHA.ATTRIBUTE15  end vat
  FROM po_headers_all pha,
       po_headers_all pha1,
       po_lines_all pla,
        hr_operating_units ou,
       mtl_units_of_measure_tl muom,
       po_line_locations_all pll,
       ap_suppliers pov,
       ap_supplier_sites_all pvs,
       hr_locations_all hrl,
       hr_locations_all hrl1,
       org_organization_definitions ood,
       po_releases_all pra,
       (SELECT  req_header_reference_num, line_location_id
                   FROM po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                   GROUP BY req_header_reference_num, line_location_id) pda,
      /* (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '.' || segment2 || '.' || segment3
                        ) item_code
                   FROM mtl_system_items_b)*/ 
                   MTL_SYSTEM_ITEMS_KFV mst,
                   mtl_parameters MP
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
    and pha.org_id=ou.organization_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
   AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') = 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id
   AND hrl.location_id = pha.ship_to_location_id
   AND hrl1.location_id = pha.bill_to_location_id 
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N' 
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
  -- AND PLL.approved_flag = 'Y'
   AND NVL(PRA.APPROVED_FLAG,'Y')='Y'
   AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')='APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID
   AND pha.org_id = nvl(:p_org_id,pha.org_id)
   AND pha.po_header_id = NVL(:p_po_no,pha.po_header_id)
   AND PHA.ATTRIBUTE1 IN ('IWO','NWO','LWO','LSRV','ISRV','CWIP','OSP')
   AND ood.organization_id = pll.ship_to_organization_id  
   AND MP.ORGANIZATION_ID=pll.ship_to_organization_id
       AND POV.VENDOR_ID=nvl(:P_VENDOR,POV.VENDOR_ID)
   AND UPPER(PHA.ATTRIBUTE_CATEGORY)  in upper('branding_info')
   AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
   AND TRUNC(PHA.APPROVED_DATE) BETWEEN NVL(:P_F_PO_DT,TRUNC(PHA.APPROVED_DATE)) AND NVL(:P_T_PO_DT,TRUNC(PHA.APPROVED_DATE))
GROUP BY
pha.attribute4,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL (pha.creation_date,
                                              pha.AGENT_ID),
                 XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL (pha.APPROVED_date,
                                              pha.AGENT_ID),
PHA.TYPE_LOOKUP_CODE,
PHA.CLOSED_DATE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PHA.ATTRIBUTE6,
PHA.ATTRIBUTE8,
   ou.name,
PHA.ATTRIBUTE14,
HRL.location_code,
pha.ATTRIBUTE11,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,pha.ATTRIBUTE8),
PHA.ATTRIBUTE1||'/'||pha.segment1,
pla.ATTRIBUTE5,
pha.creation_date,
POV.SEGMENT1 ,
PHA.ATTRIBUTE2,
PHA.ATTRIBUTE5,
PHA.ATTRIBUTE6,
PHA.ATTRIBUTE4,
ood.ORGANIZATION_CODE,
PHA.ATTRIBUTE3,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR'),
PHA.CURRENCY_CODE,
PHA.RATE,
PHA.ATTRIBUTE10,
PHA.ATTRIBUTE12,
PHA.ATTRIBUTE11,
pov.vendor_name,
ADDRESS_LINE1||' '||
ADDRESS_LINE2,
pvs.city||'-'||pvs.zip,
pvs.phone,
pvs.telex,
PLA.ATTRIBUTE3,
MP.ORGANIZATION_CODE||' - '||hrl.LOCATION_CODE,
pvs.EMAIL_ADDRESS,
get_hr_operating_unit(:p_org_id),
hrl.ADDRESS_LINE_1||' '||hrl.ADDRESS_LINE_2||' '||hrl.ADDRESS_LINE_3||', '||hrl.REGION_1||'-'||hrl.POSTAL_CODE,
hrl1.ADDRESS_LINE_1||' '||hrl1.ADDRESS_LINE_2||' '||hrl1.ADDRESS_LINE_3||', '||hrl1.REGION_1||'-'||hrl1.POSTAL_CODE,
hrl.TELEPHONE_NUMBER_1,
HRL.TELEPHONE_NUMBER_2,
HRL.LOC_INFORMATION13,
XX_P2P_PKG.LC_DT_FROM_PO(PHA.PO_HEADER_ID),
pra.release_num,
pha1.segment1,
TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR'),
DECODE (pda.req_header_reference_num,
               NULL,XX_P2P_PKG.XX_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) ,
mst.CONCATENATED_SEGMENTS,
pla.item_description,MUOM.UOM_CODE,
PLA.UNIT_PRICE,
PLA.NOTE_TO_VENDOR ,
XX_P2P_EMP_INFO.XX_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by),
NVL(pha1.segment1,'...............'),
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............'),
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............'),
 '(For '||pov.vendor_name||')',
 pla.attribute7,
pla.attribute12,
pla.attribute13,
pla.attribute14 ,
TO_CHAR(TO_DATE(SUBSTR(pha.attribute9,1,11),'YYYY MM DD'),'DD-MON-RRRR') ,
TO_CHAR(TO_DATE(SUBSTR(pha.attribute10,1,10),'YYYY MM DD'),'DD-MON-RRRR') ,
NVL(PHA.ATTRIBUTE15,0)
ORDER BY PLA.LINE_NUM


--=========================TESTING ========================================
select * --poh.po_header_id, poh.segment1
 from po_headers_all poh, po_lines_all pol, po_line_locations_all pll, po_distributions_all pod
where 1=1
and poh.po_header_id = pol.po_header_id
and pol.po_line_id = pll.po_line_id
and poh.po_header_id = pod.po_header_id
and pol.po_line_id = pll.po_line_id
and pll.line_location_id = pod.line_location_id
 and poh.segment1 ='40000043'-- '40000044'
and poh.org_id = 108

select * from PO_DISTRIBUTIONS_ALL pod, 
where po_header_id between '402101' and '403104'
and org_id = '108'





select prh.requisition_header_id  from po_line_locations_all pll, PO_DISTRIBUTIONS_ALL pod, po_req_distributions_all prd, po_requisition_lines_all prl, po_requisition_headers_all prh
where 1=1 
and pod.REQ_DISTRIBUTION_ID = prd.DISTRIBUTION_ID(+)
and prd.requisition_line_id = prl.requisition_line_id(+)
and prl.requisition_header_id= prh.requisition_header_id(+)
and pll.line_location_id = pod.line_location_id(+)
and pod.po_header_id between '402101' and '403104'
and pod.org_id = '108'

select * from PO_LINE_LOCATIONS_ALL
where po_header_id between  '402101' and '403104'
--and ATTRIBUTE_CATEGORY = 'Requisition'
and org_id = '108'


select * from PO_LINES_ALL
where po_header_id between '402101' and '403104'
and org_id = '108'

select * from po_headers_all 
where segment1 between '40000043' and  '40000044'
and org_id = 108