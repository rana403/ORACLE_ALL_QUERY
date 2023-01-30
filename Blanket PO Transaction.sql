

SELECT
--pha.attribute4 H_DIS,
--PHA.ATTRIBUTE13 project,

PHA.ATTRIBUTE1||'/'||pha.segment1 PO_NUM,
 pra.release_num,
 to_char(PHA.creation_date, 'DD-MON-RRRR') RELEASE_DATE,
 ood.ORGANIZATION_CODE INV_ORG,
 mst.item_code,
 pla.item_description,
 MUOM.UOM_CODE,
Sum(pll.quantity) po_qty,
PLA.UNIT_PRICE PRICE,
sum(pll.quantity * PLA.UNIT_PRICE) amount,
nvl(RT.RECEIPT_NO,0) GRN_NO,
--RT.REJECTED_QTY,
nvl(RT.RECEIPT_QTY,0) RECEIPT_QTY,
RT.RECEIPT_DATE,
NVL(RT.RETURN_QTY,0) RETURN_QTY,
PL.QUANTITY_REJECTED REJECTED_QTY,
nvl(RT.DELIVER_QTY,0) deilver_qty,
PHA.TYPE_LOOKUP_CODE PO_TYPEEE,
(select b.description from fnd_flex_value_sets a, fnd_flex_values_vl b where  a.flex_value_set_id = b.flex_value_set_id and a.flex_value_set_name = 'XX_PO_TYPE' and b.flex_value=pha.attribute1) PO_TYPE,
PLA.LINE_NUM, 
PHA.PO_HEADER_ID,
PLA.PO_LINE_ID,
TO_CHAR (pha.creation_date, 'DD-MON-RRRR') po_cr_dt,
PHA.ATTRIBUTE2 CON_PERSON,
XX_GET_ACCT_FLEX_SEG_DESC (7, PHA.ATTRIBUTE14) PROJECT_NAME,
--PHA.ATTRIBUTE10 TERM_DAYS,
pha.authorization_status,
TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RRRR') po_APP_dt,
PHA.CURRENCY_CODE,
PHA.RATE,
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
PHA.ATTRIBUTE4 DIS_AMT,
PHA.ATTRIBUTE5 DIS_PER,
pha.attribute6 contact_person,
PLA.ATTRIBUTE3 Specifications ,
--NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0) DISCOUNT_PRICE,
--Sum(pll.quantity)*PLA.UNIT_PRICE CF_NET_VALUE_SUM,
--nvl(PHA.ATTRIBUTE10,0) CARRYING_COST,
--(NVL((NVL(PLA.ATTRIBUTE11,0)/100*PLA.UNIT_PRICE),0)+NVL(PLA.ATTRIBUTE5,0))*SUM(pll.quantity) DISCOUNT_PRICE_SUM,
--PLA.UNIT_PRICE-NVL((NVL(NVL(to_number(PLA.ATTRIBUTE11),0)/100*NVL(PLA.UNIT_PRICE,0),0)+PLA.ATTRIBUTE5),0) UNIT_PRICE,
--pla.ATTRIBUTE5 line_dis,
--PLA.ATTRIBUTE11 LINE_DIS_PER,
XX_P2P_EMP_INFO.xx_p2p_get_only_empn(pha.creation_date,pha.AGENT_ID) creator_details,
NVL(pha1.segment1,'...............') quote_no,
NVL(pha1.QUOTE_VENDOR_QUOTE_NUMBER,'...............') supplier_quote,
NVL(TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR'),'...............')  REPLY_DATE,
 '(For '||pov.vendor_name||')' SUPP_ALIAS,
NVL(PHA.ATTRIBUTE15,0) VAT,
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
   AND pll.po_release_id = pra.po_release_id
   --AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
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
  -- AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
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

--===========================MY CREATED  QUERY ==============================================


SELECT          
          POH.ORG_ID "OU_Id",
          POH.SEGMENT1 PO_NUMBER,
         POH.ATTRIBUTE1 PO_Type,
         POH.TYPE_LOOKUP_CODE "System_PO_Type",
         POH.AUTHORIZATION_STATUS "Approval_Status",
         TRUNC (POH.APPROVED_DATE) APPROVED_DATE,
         SUP.SEGMENT1 "Supplier_No",
          Sup.Vendor_Name "Supplier_Name",
          sup.VENDOR_TYPE_LOOKUP_CODE "SUPPLIER_TYPE", 
          PRA.RELEASE_NUM,
           to_char(PRA.RELEASE_DATE, 'DD-MON-RRRR') RELEASE_DATE,
          OOD.ORGANIZATION_CODE INV_ORG,
          MTI.CONCATENATED_SEGMENTS Item,
          muom.uom_code uom,
          POL.UNIT_PRICE "Price",
          PLL.QUANTITY "PO_Quantity",
          PLL.QUANTITY*POL.UNIT_PRICE amount,
        --  SUP.VENDOR_ID,
          --SUS.VENDOR_SITE_CODE "Supplier_Site",
         -- TRUNC (POH.CREATION_DATE) "Creation_Date",
           --  XX_LOC_NAME (POH.BILL_TO_LOCATION_ID) "Parent_Bill_Location",
         -- XX_LOC_NAME (POH.SHIP_TO_LOCATION_ID) "Parent_Ship_Location",
         -- POH.Rate "Rate",
        --  POH.RATE_DATE "Rate_Date",
         -- POH.Currency_Code "Currency",
         -- POH.ATTRIBUTE4 "Supplier_Quote_No",
         -- POL.ITEM_ID,
        --  PRA.RELEASE_NUM "PO_Release_Num",
         -- PRA.RELEASE_Date "PO_Release_Date",
          --MC.SEGMENT1 || '|' || MC.SEGMENT2 "Item_Category",
          --pol.ITEM_Description "Item_Description",
         -- POL.ATTRIBUTE1 "Use_of_Area",
          --POL.ATTRIBUTE2 "Brand",
          --POL.ATTRIBUTE3 "Origin",
          --POL.ATTRIBUTE5 "Make",
         -- poh1.segment1 "Quote_No",
          --TRUNC (PLL.NEED_BY_DATE) "Need_By_Date",
         -- TRUNC (PLL.PROMISED_DATE) "Promissed_Date",
         -- OOD.ORGANIZATION_NAME "Shipment_Org_Name",
         -- OOD.ORGANIZATION_ID "Shipment_Org_Id",
         -- XXLC.LC_ID,
         -- XXLC.LC_NUMBER "LC_Number",
         -- XXLC.LC_OPENING_DATE "LC_Opening_Date",
         -- XXLC.BANK_NAME "LC_Bank_Name",
          --xxlc.BANK_BRANCH_NAME "LC_Bank_Branch_Name",
         -- xxlc.company_code "LC_Balancing_Company",
          --xxlc.company_name "LC_Balancing_Segment",
          --DECODE (xxlc.LC_TYPE,  'S', 'Sight',  'D', 'Deferred',  NULL)
          --   "LC_Type",
         -- DECODE (xxlc.FOB_CF,  'CF', 'C and F',  'FOB', 'fob',  NULL)
          --   "FOB_C_And_F",
--          XX_ON_HAND (
--             POL.ITEM_ID,
--             GRN.ORGANIZATION_ID,
--             DECODE (
--                XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
--                   PDA.requisition_header_id,
--                   POH.ORG_ID),
--                NULL, XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
--                         PLL.ATTRIBUTE1,
--                         POH.ORG_ID),
--                XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
--                   PDA.requisition_header_id,
--                   POH.ORG_ID)))
--             "On_Hand_PR_Date",
--          DECODE (pda.req_header_reference_num,
--                  NULL, XX_P2P_PKG.XX_FND_REQUISITION_INFO (
--                           PLL.ATTRIBUTE1,
--                           POH.ORG_ID,
--                           PLL.ATTRIBUTE2,
--                           'RNUM'),
--                  'PR-' || pda.req_header_reference_num)
--             "Requisition_No",
--          DECODE (
--             XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
--                PDA.requisition_header_id,
--                POH.ORG_ID),
--             NULL, XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
--                      PLL.ATTRIBUTE1,
--                      POH.ORG_ID),
--             XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
--                PDA.requisition_header_id,
--                POH.ORG_ID))
--             "Requisition_Date",
          --GRN.SHIPMENT_HEADER_ID,
          GRN.GRN_NO "GRN_Number",
         -- rsh.COMMENTS "GRN_Remarks",
          --GRN.CHALLAN_NO "Challan_No",
          --GRN.CHALLAN_DT "Challan_Date",
          GRN.GRN_QTY "GRN_Quantity",
          GRN.ACCEPT_QTY "Accept_Qty",
         -- GRN.PHY_QTY "Physical_Qty",
          --GRN.DEL_QTY "Store_Qty",
          GRN.REJECT_QTY "Reject_Qty",
            ((PLL.QUANTITY -   GRN.GRN_QTY) +  GRN.RETURN_QTY) Balance,
          POL.QUANTITY - GRN.PHY_QTY "Pending_Qty",
          --GRN.GRN_DT "GRN_Date",
          GRN.DEL_DT "Store_Delivery_Date",
         -- GRN.INSPECT_DT "Quality_Date",
          GRN.RETURN_QTY "Return_Qty"
          --GRN.RETURN_DT "Return_Date",
       --   rt.subinventory "Subinventory",
        --  XX_LOC_NAME (rt.DELIVER_TO_LOCATION_ID) "Actual_Delivery_Loc",
--          (GRN.DEL_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
--             "Total_Delivery_Amount",
--          (GRN.RETURN_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
--             "Total_Return_Amount",
--          (GRN.PHY_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
--          - (GRN.RETURN_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
--             "Accrual_Liability_Amount",
--      --    XX_PO_PREPAY (POH.PO_HEADER_ID, 'VOU') "Prepayment_Voucher_No",
--      --    XX_PO_PREPAY (POH.PO_HEADER_ID, 'DT') "Prepayment_Invoice_Date",
--           PAY.BILL_NO "Supplier_Bill_No",
--          BILL_DATE "Supplier_Bill_Date",
--          CHECK_DATE "Check_Date",
--          PAY_VOU "Payment_Voucher_No",
--          PAY_VOU_DT "Payment_Voucher_Date",
--          INV_VOU "Invoice_Voucher_No",
--          INV_VOU_DT "Invoice_Voucher_Date",
--          INVOICE_RATE "Invoice_Rate",
--          PAYMENT_RATE "Payment_Rate",
--          poh.closed_code
       FROM XXKBG_IND_PAY_V GRN,
          XXKBG_INDTO_PAY_V  PAY,
          mtl_units_of_measure_tl muom,
          PO_HEADERS_ALL POH,
          PO_LINES_ALL POL,
          PO_LINE_LOCATIONS_ALL PLL,
          PO_RELEASES_ALL PRA,
          XX_LC_DETAILS XXLC,
          MTL_SYSTEM_ITEMS_KFV MTI,
          AP_SUPPLIERS SUP,
          AP_SUPPLIER_SITES_ALL SUS,
          mtl_categories mc,
          po_headers_all poh1,
          ORG_ORGANIZATION_DEFINITIONS OOD,
          RCV_TRANSACTIONS RT,
          RCV_SHIPMENT_HEADERS RSH,
          (  SELECT req_header_reference_num,
                    line_location_id,QUANTITY_ORDERED,
                    NVL (
                       requisition_header_id,
                       XX_P2P_PKG.XX_FND_REQ_SEG_HDR (
                          req_header_reference_num,
                          ORG_ID))
                       requisition_header_id
               FROM XX_po_distributions_v
              WHERE NVL (
                       requisition_header_id,
                       XX_P2P_PKG.XX_FND_REQ_SEG_HDR (
                          req_header_reference_num,
                          ORG_ID))
                       IS NOT NULL
           GROUP BY req_header_reference_num,
                    line_location_id,QUANTITY_ORDERED,
                    NVL (
                       requisition_header_id,
                       XX_P2P_PKG.XX_FND_REQ_SEG_HDR (
                          req_header_reference_num,
                          ORG_ID))) pda
    WHERE     POH.PO_HEADER_ID = POL.PO_HEADER_ID
          AND POL.PO_LINE_ID = PLL.PO_LINE_ID
          AND pol.UNIT_MEAS_LOOKUP_CODE = muom.unit_of_measure
          AND GRN.PO_LINE_LOCATION_ID = PLL.LINE_LOCATION_ID
          --AND GRN.SHIPMENT_HEADER_ID = 58122                              --19258
          AND POL.CATEGORY_ID = MC.CATEGORY_ID
          AND poh.from_header_id = poh1.po_header_id(+)
          AND PLL.PO_RELEASE_ID = PRA.PO_RELEASE_ID(+)
          AND POH.PO_HEADER_ID = XXLC.PO_HEADER_ID(+)
          AND MTI.INVENTORY_ITEM_ID = POL.ITEM_ID
          AND MTI.ORGANIZATION_ID = GRN.ORGANIZATION_ID
          AND SUP.VENDOR_ID = SUS.VENDOR_ID
          AND SUP.VENDOR_ID = GRN.VENDOR_ID
          AND SUS.VENDOR_SITE_ID = GRN.VENDOR_SITE_ID
          AND GRN.ORGANIZATION_ID = OOD.ORGANIZATION_ID
          AND pda.line_location_id(+) = pll.line_location_id
          AND RT.SHIPMENT_HEADER_ID(+) = GRN.SHIPMENT_HEADER_ID
          AND RT.SHIPMENT_LINE_ID(+) = GRN.SHIPMENT_LINE_ID
          AND RT.TRANSACTION_TYPE =
          DECODE (GRN.DEL_QTY, 0, 'RECEIVE', 'DELIVER')
          AND GRN.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID
          AND GRN.PHY_QTY >0
           AND GRN.SHIPMENT_LINE_ID = PAY.SHIPMENT_LINE_ID(+)
           AND POH.PO_HEADER_ID =  395177
          UNION 
          Select 
           POH.ORG_ID "OU_Id",
          POH.SEGMENT1 PO_NUMBER,
         POH.ATTRIBUTE1 PO_Type,
         POH.TYPE_LOOKUP_CODE "System_PO_Type",
         POH.AUTHORIZATION_STATUS "Approval_Status",
         TRUNC (POH.APPROVED_DATE) APPROVED_DATE,
         SUP.SEGMENT1 "Supplier_No",
          Sup.Vendor_Name "Supplier_Name",
          sup.VENDOR_TYPE_LOOKUP_CODE "SUPPLIER_TYPE", 
          PRA.RELEASE_NUM,
           to_char(PRA.RELEASE_DATE, 'DD-MON-RRRR') RELEASE_DATE,
          OOD.ORGANIZATION_CODE INV_ORG,
          --MTI.CONCATENATED_SEGMENTS Item,
            (msi.segment1||'|'||msi.segment2||'|'||msi.segment3||'|'||msi.segment4) Item,
          --muom.uom_code uom,
          null,
          POL.UNIT_PRICE "Price",
          PLL.QUANTITY "PO_Quantity",
          PLL.QUANTITY*POL.UNIT_PRICE amount,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
          from 
          po_headers_all poh,
          po_lines_all pol,
           po_line_locations_all pll,
           po_releases_all pra,
           org_organization_definitions ood,        
      mtl_system_items msi,                
    po_vendors sup,
    po_vendor_sites_all pvs,
    po_agents_v pb,
    hr_locations hl,
    hr_operating_units hou
          where 1=1
   AND poh.type_lookup_code IN ('BLANKET', 'STANDARD')
  AND msi.inventory_item_id = pol.item_id
  AND msi.organization_id = pll.ship_to_organization_id
  AND ood.organization_id = msi.organization_id
  AND poh.po_header_id = pol.po_header_id
  AND pol.po_line_id = pll.po_line_id
  AND pra.po_header_id(+) = poh.po_header_id
  AND NVL (pll.po_release_id, 1) = NVL (pra.po_release_id, 1)
  AND poh.vendor_id = sup.vendor_id
  AND poh.vendor_site_id = pvs.vendor_site_id
  AND pvs.vendor_id = sup.vendor_id
  AND pb.agent_id = poh.agent_id
  AND hl.location_id = poh.ship_to_location_id 
  AND poh.org_id = ood.organization_id
   and poh.PO_HEADER_ID =  395177

--================================ another QUERY===============================

select * from po_headers_all where segment1 =  '40000914'   --  '40000914'

select * from po_lines_all where po_header_id = 395177    --  '40000914'

select * from po_line_locations_all pll

select * FROM APPS.XXKBG_BI_PO_GRN where po_header_id = 395177 

select * from  po_releases_all



SELECT
     XX_GET_HR_OPERATING_UNIT(POH.ORG_ID) Org_header_name,  
      POH.PO_HEADER_ID,
      poh.segment1 po_number,
      poh.type_lookup_code PO_TYPE,
     poh.AUTHORIZATION_STATUS,
     pol.CLOSED_CODE,
     poh.ATTRIBUTE1  ,
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
 AND poh.po_header_id between NVL(:p_po_no, poh.po_header_id) and NVL(:p_po_to, poh.po_header_id)
  and POH.ORG_ID = NVL(:P_OU, POH.ORG_ID)
    AND TRUNC(poh.creation_date) BETWEEN NVL(:P_F_PO_DT,TRUNC(poh.creation_date)) AND NVL(:P_T_PO_DT,TRUNC(poh.creation_date))
    and  pv.vendor_id = NVL(:P_SUPLIER,  pv.vendor_id)
    and  poh.type_lookup_code = NVL(:P_POTYPE,  poh.type_lookup_code)
    and   pb.agent_name = NVL(:P_BUYER, pb.agent_name)
    and  pol.item_id = NVL(:P_ITEM,  pol.item_id)
--     AND RT.ORGANIZATION_ID(+)=PLL.SHIP_TO_ORGANIZATION_ID
--    AND pol.po_header_id=rt.PO_HEADER_ID(+)
-- AND pol.po_line_id=rt.po_line_id(+)
 -- AND hou.short_code = 'VIS-US'
-- and poh.segment1 = 40000914
ORDER BY poh.segment1, pr.release_num
 

