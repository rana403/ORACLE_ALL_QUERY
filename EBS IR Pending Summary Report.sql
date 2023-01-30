--EBS IR Pending Summary Report
SELECT DISTINCT prh.requisition_header_id,
       -- pha.po_header_id,
        prh.segment1 requisition_num, 
        note_to_agent,
        substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,
        prh.requisition_header_id header_id,
        prh.creation_date CR_DT, 
        prl.line_num,
        prh.DESCRIPTION PR_DESC, 
        --pha.segment1 po_no,
        --pla.quantity po_qty,
     -- NVL(XX_PO_FROM_REQ.GET_PO_FRM_REQ_DIST( :P_ORG_ID,prh.requisition_header_id,prl.line_num),      --old
     -- XX_PO_FROM_REQ.GET_PO_FRM_REQ_SHIP( :P_ORG_ID,prh.requisition_header_id,prl.line_num)) PO_NAME,     --old
       to_char(prh.creation_date,'DD-MON-RRRR HH12:MI:SS PM') creation_dt,
       to_char(prh.APPROVED_DATE,'DD-MON-RRRR HH12:MI:SS PM')  APPROVED_DATE,
       prl.ATTRIBUTE1 Brand, 
       prl.ATTRIBUTE2 Origin,
       ppg.segment2 Department,
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
      -- (select quantity_rejected from po_line_locations_all plla where plla.po_line_id=pla.po_line_id and plla.line_location_id=pda.line_location_id) quantity_rejected,
         ool.order_number iso_no,
  ool.ordered_quantity iso_qty,
  rt.RECEIPT_QTY shipped_quantity,
  rt.REF_GRN_QTY REF_GRN_QTY,
       XX_30_DAYS_CONSUM_FN(NVL(PRH.APPROVED_DATE,prh.creation_date),PRL.ITEM_ID,PRL.DESTINATION_ORGANIZATION_ID) CONSUM_QTY,
       xx_pend_req_qty_fn(PRL.PO_LINE_ID) PENDING_QTY,
       --xx_last_po_info_fn(4,PRL.ITEM_ID,PRH.ORG_ID) LPO,
       --xx_last_po_info_fn(1,PRL.ITEM_ID,PRH.ORG_ID) LPD,
        --xx_last_po_info_fn(2,PRL.ITEM_ID,PRH.ORG_ID) LPR,
         --xx_last_po_info_fn(3,PRL.ITEM_ID,PRH.ORG_ID) LP_SUPP,
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
     --  substr(XX_GET_HR_OPERATING_UNIT(:p_org_id),5) ORG_HEADER_NAME,  --new
      -- XX_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,   --old
      -- XX_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,     --old
       PRL.DESTINATION_SUBINVENTORY WAREHOUSE,
       --xx_inv_org_name_fn(prl.destination_organization_id) dest_loc,      --old
        --xx_inv_org_name_fn(prl.source_organization_id) source_loc,        --old
--        substr(GET_ORGANIZATION_NAME(prl.org_id),5) REQ_ORG_NAME,     --old
--    GET_UNIT_ADDRESS(prl.org_id) REQ_ORG_ADDRESS,     --old
           (select ORGANIZATION_CODE from ORG_ORGANIZATION_DEFINITIONS where organization_id=prl.SOURCE_ORGANIZATION_ID) sourch_org_code,
           (select name from hr_all_organization_units where organization_id=prl.SOURCE_ORGANIZATION_ID) sourch_org_name,    
    (select name from hr_all_organization_units where organization_id=prl.DESTINATION_ORGANIZATION_ID) dest_org_name,    
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
          (SELECT DISTINCT  REQUISITION_LINE_ID,SUM(RECEIPT_QTY) RECEIPT_QTY,SUM(REF_GRN_QTY) REF_GRN_QTY, SUM(ACCEPTED_QTY) ACCEPTED_QTY, SUM(REJECTED_QTY) REJECTED_QTY,(NVL(SUM( RETURN_QTY),0)+NVL(SUM(DLV_RETURN_QTY),0)) RETURN_QTY,
                         (SUM(DELIVER_QTY)-NVL(SUM(DLV_RETURN_QTY),0)) DELIVER_QTY
                        FROM WBI_INV_RCV_TRANSACTIONS_F 
                        WHERE TRANSACTION_TYPE='RECEIVE'
                        GROUP BY REQUISITION_LINE_ID) RT,
       HR_LOCATIONS_ALL HRL,
      HR_LOCATIONS_ALL HRL1,
       (SELECT organization_id,inventory_item_id, description,
                        (segment1 || '|' || segment2 || '|' || segment3|| '|' || segment4
                        ) item_code
                   FROM mtl_system_items_b) mst,
        hr_operating_units HOU,
        --oe_order_headers_all ooh, 
        (select OH.ORDER_NUMBER, OL.SOURCE_DOCUMENT_ID REQ_HEADER_ID, OL.SOURCE_DOCUMENT_LINE_ID REQ_LINE_ID,
   SUM(NVL(OL.ORDERED_QUANTITY,0)) ORDERED_QUANTITY, SUM(NVL(OL.SHIPPED_QUANTITY,0)) SHIPPED_QUANTITY
   FROM OE_ORDER_HEADERS_ALL OH, OE_ORDER_LINES_ALL OL
   WHERE OH.HEADER_ID = OL.HEADER_ID
   AND OL.SOURCE_DOCUMENT_ID IS NOT NULL
   GROUP BY OH.ORDER_NUMBER,OL.SOURCE_DOCUMENT_ID , OL.SOURCE_DOCUMENT_LINE_ID) ool   
WHERE prh.requisition_header_id = prl.requisition_header_id
    --AND pla.po_line_id=pda.po_line_id
    AND SYSDATE BETWEEN paaf.effective_start_date AND paaf.effective_end_date
    AND SYSDATE BETWEEN ppf.effective_start_date AND ppf.effective_end_date
    AND prl.to_person_id = ppf.person_id
    AND prl.to_person_id = paaf.person_id
    AND HRL.LOCATION_ID=prl.DELIVER_TO_LOCATION_ID
    AND HRL1.LOCATION_ID=PAAF.LOCATION_ID
    AND ppg.people_group_id(+) = paaf.people_group_id
    AND ppf.person_id = paaf.person_id
    AND paaf.job_id(+) = pj.job_id
    AND pj.job_definition_id(+) = pjd.job_definition_id
    and pp.position_id=paaf.position_id
    and prl.REQUISITION_LINE_ID=rt.REQUISITION_LINE_ID(+)
   and pp.POSITION_DEFINITION_ID=pd.POSITION_DEFINITION_ID
    AND NVL(PRL.MODIFIED_BY_AGENT_FLAG,'N')<>'Y'
    AND PRL.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
    AND HRO.OPERATING_UNIT=HOU.ORGANIZATION_ID 
    AND prl.item_id = mst.inventory_item_id
    AND PRL.DESTINATION_ORGANIZATION_ID=MST.ORGANIZATION_ID  
    AND prl.DESTINATION_ORGANIZATION_ID=hro.ORGANIZATION_ID
    --AND ooh.header_id = ool.header_id
    AND prl.requisition_line_id=ool.req_line_id(+)
    AND prh.requisition_header_id=ool.req_header_id(+)
    --AND prh.segment1=ooh.orig_sys_document_ref
   -- AND prl.item_id=ool.ORDERED_ITEM_ID
    AND prh.ORG_ID = nvl(:p_ORG_ID,prh.org_id)    
     AND PRL.DESTINATION_ORGANIZATION_ID=nvl(:p_inv_org,PRL.DESTINATION_ORGANIZATION_ID)
    AND NVL2(:P_REQ_NO,prh.requisition_header_id,-1) between NVL(:P_REQ_NO,-1) and NVL(:P_REQ_NO_T,-1) 
  --AND MST.item_code BETWEEN NVL(:P_ITEM_From,MST.item_code) AND NVL(:P_ITEM_To,MST.item_code)
  --  AND nvl(PRL.ATTRIBUTE9,'x')=nvl(:P_DEPT,nvl(PRL.ATTRIBUTE9,'x'))
    AND nvl(pd.segment3,'x')=nvl(:p_dept,nvl(pd.segment3,'x'))
 --   AND PRH.TYPE_LOOKUP_CODE=NVL(:P_TYPE,PRH.TYPE_LOOKUP_CODE) 
    AND PRH.AUTHORIZATION_STATUS= 'APPROVED'
   -- AND TRUNC(prh.creation_date) BETWEEN  nvl(FND_DATE.CANONICAL_TO_DATE(:P_F_PR_DT),TRUNC(prh.creation_date))
  --  AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_T_PR_DT),TRUNC(prh.creation_date))
    AND TRUNC(prh.creation_date) BETWEEN  nvl((:P_F_PR_DT),TRUNC(prh.creation_date))
    AND NVL((:P_T_PR_DT),TRUNC(prh.creation_date))
   --AND (prl.NEED_BY_DATE)=nvl(:p_need_by_date,prl.NEED_BY_DATE)--trunc(NEED_BY_DATE)
--   AND NVL(FND_DATE.CANONICAL_TO_DATE(:P_NEED_BY_DATE),TRUNC(PRL.NEED_BY_DATE))
   AND PRL.ITEM_ID=NVL(:P_ITEM_ID,PRL.ITEM_ID)
   AND PRH.TYPE_LOOKUP_CODE='INTERNAL'   