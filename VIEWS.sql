CREATE OR REPLACE FORCE VIEW APPS.XXKBG_BI_PO_GRN
(PO_HEADER_ID, OU_ID, PO_NUMBER, VENDOR_ID, SUPPLIER_NO, 
 SUPPLIER_NAME, SUPPLIER_TYPE, SUPPLIER_SITE, CREATION_DATE, APPROVED_DATE, 
 APPROVAL_STATUS, PO_TYPE, SYSTEM_PO_TYPE,   
 RATE, RATE_DATE, CURRENCY, SUPPLIER_QUOTE_NO, ITEM_ID, 
 ITEM, UOM, PO_RELEASE_NUM, PO_RELEASE_DATE, ITEM_CATEGORY, 
 ITEM_DESCRIPTION, USE_OF_AREA, BRAND, ORIGIN, MAKE, 
 QUOTE_NO, PRICE, PO_QUANTITY, NEED_BY_DATE, PROMISSED_DATE, 
 SHIPMENT_ORG_CODE, SHIPMENT_ORG_NAME, SHIPMENT_ORG_ID, LC_ID, LC_NUMBER, 
 LC_OPENING_DATE, LC_BANK_NAME, LC_BANK_BRANCH_NAME, LC_BALANCING_COMPANY, LC_BALANCING_SEGMENT, 
 LC_TYPE, FOB_C_AND_F, REQUISITION_NO, REQUISITION_DATE, 
 SHIPMENT_HEADER_ID, GRN_NUMBER, GRN_REMARKS, CHALLAN_NO, CHALLAN_DATE, 
 GRN_QUANTITY, ACCEPT_QTY, PHYSICAL_QTY, STORE_QTY, REJECT_QTY,Pending_Qty, 
 GRN_DATE, STORE_DELIVERY_DATE, QUALITY_DATE, RETURN_QTY, RETURN_DATE, 
 SUBINVENTORY,  TOTAL_DELIVERY_AMOUNT, TOTAL_RETURN_AMOUNT, ACCRUAL_LIABILITY_AMOUNT, 
  SUPPLIER_BILL_NO, SUPPLIER_BILL_DATE, CHECK_DATE, 
 PAYMENT_VOUCHER_NO, PAYMENT_VOUCHER_DATE, INVOICE_VOUCHER_NO, INVOICE_VOUCHER_DATE, INVOICE_RATE, 
 PAYMENT_RATE, CLOSED_CODE)
AS 
SELECT POH.PO_HEADER_ID,
          POH.ORG_ID "OU_Id",
          POH.SEGMENT1 "PO_NUMBER",
          SUP.VENDOR_ID,
          SUP.SEGMENT1 "Supplier_No",
          Sup.Vendor_Name "Supplier_Name",
          sup.VENDOR_TYPE_LOOKUP_CODE "SUPPLIER_TYPE", 
          SUS.VENDOR_SITE_CODE "Supplier_Site",
          TRUNC (POH.CREATION_DATE) "Creation_Date",
          TRUNC (POH.APPROVED_DATE) "APPROVED_DATE",
          POH.AUTHORIZATION_STATUS "Approval_Status",
          POH.ATTRIBUTE1 "PO_Type",
          POH.TYPE_LOOKUP_CODE "System_PO_Type",
        --  XX_LOC_NAME (POH.BILL_TO_LOCATION_ID) "Parent_Bill_Location",
         -- XX_LOC_NAME (POH.SHIP_TO_LOCATION_ID) "Parent_Ship_Location",
          POH.Rate "Rate",
          POH.RATE_DATE "Rate_Date",
          POH.Currency_Code "Currency",
          POH.ATTRIBUTE4 "Supplier_Quote_No",
          POL.ITEM_ID,
          MTI.CONCATENATED_SEGMENTS Item,
          muom.uom_code uom,
          PRA.RELEASE_NUM "PO_Release_Num",
          PRA.RELEASE_Date "PO_Release_Date",
          MC.SEGMENT1 || '|' || MC.SEGMENT2 "Item_Category",
          pol.ITEM_Description "Item_Description",
          POL.ATTRIBUTE1 "Use_of_Area",
          POL.ATTRIBUTE2 "Brand",
          POL.ATTRIBUTE3 "Origin",
          POL.ATTRIBUTE5 "Make",
          poh1.segment1 "Quote_No",
          POL.UNIT_PRICE "Price",
          POL.QUANTITY "PO_Quantity",
          TRUNC (PLL.NEED_BY_DATE) "Need_By_Date",
          TRUNC (PLL.PROMISED_DATE) "Promissed_Date",
          OOD.ORGANIZATION_CODE "Shipment_Org_Code",
          OOD.ORGANIZATION_NAME "Shipment_Org_Name",
          OOD.ORGANIZATION_ID "Shipment_Org_Id",
          XXLC.LC_ID,
          XXLC.LC_NUMBER "LC_Number",
          XXLC.LC_OPENING_DATE "LC_Opening_Date",
          XXLC.BANK_NAME "LC_Bank_Name",
          xxlc.BANK_BRANCH_NAME "LC_Bank_Branch_Name",
          xxlc.company_code "LC_Balancing_Company",
          xxlc.company_name "LC_Balancing_Segment",
          DECODE (xxlc.LC_TYPE,  'S', 'Sight',  'D', 'Deferred',  NULL)
             "LC_Type",
          DECODE (xxlc.FOB_CF,  'CF', 'C and F',  'FOB', 'fob',  NULL)
             "FOB_C_And_F",
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
          DECODE (pda.req_header_reference_num,
                  NULL, XX_P2P_PKG.XX_FND_REQUISITION_INFO (
                           PLL.ATTRIBUTE1,
                           POH.ORG_ID,
                           PLL.ATTRIBUTE2,
                           'RNUM'),
                  'PR-' || pda.req_header_reference_num)
             "Requisition_No",
          DECODE (
             XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
                PDA.requisition_header_id,
                POH.ORG_ID),
             NULL, XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
                      PLL.ATTRIBUTE1,
                      POH.ORG_ID),
             XX_P2P_PKG.XX_FND_REQUISITION_DT_INFO (
                PDA.requisition_header_id,
                POH.ORG_ID))
             "Requisition_Date",
          GRN.SHIPMENT_HEADER_ID,
          GRN.GRN_NO "GRN_Number",
          rsh.COMMENTS "GRN_Remarks",
          GRN.CHALLAN_NO "Challan_No",
          GRN.CHALLAN_DT "Challan_Date",
          GRN.GRN_QTY "GRN_Quantity",
          GRN.ACCEPT_QTY "Accept_Qty",
          GRN.PHY_QTY "Physical_Qty",
          GRN.DEL_QTY "Store_Qty",
          GRN.REJECT_QTY "Reject_Qty",
          POL.QUANTITY - GRN.PHY_QTY "Pending_Qty",
          GRN.GRN_DT "GRN_Date",
          GRN.DEL_DT "Store_Delivery_Date",
          GRN.INSPECT_DT "Quality_Date",
          GRN.RETURN_QTY "Return_Qty",
          GRN.RETURN_DT "Return_Date",
          rt.subinventory "Subinventory",
        --  XX_LOC_NAME (rt.DELIVER_TO_LOCATION_ID) "Actual_Delivery_Loc",
          (GRN.DEL_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
             "Total_Delivery_Amount",
          (GRN.RETURN_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
             "Total_Return_Amount",
          (GRN.PHY_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
          - (GRN.RETURN_QTY * (POL.UNIT_PRICE * NVL (POH.RATE, 1)))
             "Accrual_Liability_Amount",
      --    XX_PO_PREPAY (POH.PO_HEADER_ID, 'VOU') "Prepayment_Voucher_No",
      --    XX_PO_PREPAY (POH.PO_HEADER_ID, 'DT') "Prepayment_Invoice_Date",
           PAY.BILL_NO "Supplier_Bill_No",
          BILL_DATE "Supplier_Bill_Date",
          CHECK_DATE "Check_Date",
          PAY_VOU "Payment_Voucher_No",
          PAY_VOU_DT "Payment_Voucher_Date",
          INV_VOU "Invoice_Voucher_No",
          INV_VOU_DT "Invoice_Voucher_Date",
          INVOICE_RATE "Invoice_Rate",
          PAYMENT_RATE "Payment_Rate",
          poh.closed_code
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
          /*AND GRN.shipment_line_id NOT IN
                 (SELECT shipment_line_id
                    FROM XXAKG_INDTO_PAY_V
                   WHERE     INV_VOU IS NOT NULL
                         AND shipment_line_id = GRN.shipment_line_id
                         AND shipment_HEADER_id = GRN.shipment_HEADER_id
                         AND ORG_ID = POH.ORG_ID);*/
;



--==========================================================================================================================================



CREATE OR REPLACE FORCE VIEW APPS.XXKBG_IND_PAY_V
(
   GRN_NO,
   CHALLAN_NO,
   CHALLAN_DT,
   GRN_QTY,
   ACCEPT_QTY,
   PHY_QTY,
   DEL_QTY,
   REJECT_QTY,
   RETURN_QTY,
   GRN_DT,
   DEL_DT,
   INSPECT_DT,
   RETURN_DT,
   PO_LINE_LOCATION_ID,
   ORGANIZATION_ID,
   SHIPMENT_HEADER_ID,
   SHIPMENT_LINE_ID,
   PO_HEADER_ID,
   PO_LINE_ID,
   VENDOR_ID,
   VENDOR_SITE_ID
)
AS
     SELECT GRN_NO,
            CHALLAN_NO,
            CHALLAN_DT,
            SUM (GRN_QTY) GRN_QTY,
            SUM (ACCEPT_QTY / DECODE (ACCEPT_DOUBLE, 0, COUNT_TRAN, 1))
               ACCEPT_QTY,
            SUM (PHY_QTY) PHY_QTY,
            SUM (DEL_QTY) DEL_QTY,
            SUM (REJECT_QTY / DECODE (REJECT_DOUBLE, 0, COUNT_TRAN, 1))
               REJECT_QTY,
            SUM (RETURN_QTY) RETURN_QTY,
            MAX (TO_DATE (GRN_DT)) GRN_DT,
            MAX (TO_DATE (DEL_DT)) DEL_DT,
            MAX (NVL (TO_DATE (ACCEPT_DT), TO_DATE (REJECT_DT))) INSPECT_DT,
            MAX (TO_DATE (RETURN_DT)) RETURN_DT,
            PO_LINE_LOCATION_ID,
            ORGANIZATION_ID,
            SHIPMENT_HEADER_ID,
            SHIPMENT_LINE_ID,
            PO_HEADER_ID,
            PO_LINE_ID,
            VENDOR_ID,
            VENDOR_SITE_ID
       FROM XX_RCV_INSP_DEL_ORGINFO_V RC
   --where SHIPMENT_LINE_ID=126004
   GROUP BY GRN_NO,
            CHALLAN_NO,
            CHALLAN_DT,
            PO_LINE_LOCATION_ID,
            ORGANIZATION_ID,
            SHIPMENT_HEADER_ID,
            SHIPMENT_LINE_ID,
            VENDOR_ID,
            VENDOR_SITE_ID,
            PO_HEADER_ID,
            PO_LINE_ID;
--=============================================================================================================================

CREATE OR REPLACE FORCE VIEW APPS.XXKBG_RCV_INSP_DEL_ORGINFO_V
(
   COUNT_TRAN,
   ACCEPT_DOUBLE,
   REJECT_DOUBLE,
   GRN_NO,
   TRANSACTION_TYPE,
   PO_LINE_LOCATION_ID,
   SHIPMENT_HEADER_ID,
   SHIPMENT_LINE_ID,
   PO_HEADER_ID,
   PO_LINE_ID,
   ORGANIZATION_ID,
   ITEM_ID,
   GRN_DT,
   CHALLAN_NO,
   CHALLAN_DT,
   GRN_QTY,
   PHY_QTY,
   DEL_QTY,
   DEL_DT,
   ACCEPT_QTY,
   ACCEPT_DT,
   REJECT_QTY,
   REJECT_DT,
   RETURN_QTY,
   RETURN_DT,
   VENDOR_ID,
   VENDOR_SITE_ID
)
AS
     SELECT COUNT (RT.TRANSACTION_ID) COUNT_TRAN,
            XX_P2P_PKG.XX_P2P_RCV_CORRECTION (rt.shipment_header_id,
                                                    rt.shipment_line_id,
                                                    'ACCEPT',
                                                    'ACCEPT')
               ACCEPT_DOUBLE,
            XX_P2P_PKG.XX_P2P_RCV_CORRECTION (rt.shipment_header_id,
                                                    rt.shipment_line_id,
                                                    'REJECT',
                                                    'REJECT')
               REJECT_DOUBLE,
            RSH.RECEIPT_NUM GRN_NO,
            RT.TRANSACTION_TYPE,
            RT.PO_LINE_LOCATION_ID,
            RT.SHIPMENT_HEADER_ID,
            RT.SHIPMENT_LINE_ID,
            RT.PO_HEADER_ID,
            RT.PO_LINE_ID,
            RT.ORGANIZATION_ID,
            RSL.ITEM_ID,
            MAX (RT.TRANSACTION_DATE) GRN_DT,
            NVL (rsh.shipment_num, RSH.BILL_OF_LADING) challan_no,
            TO_CHAR (TRUNC (rsh.shipped_date), 'DD-MON-RRRR') challan_dt,
            SUM (
               DECODE (RT.TRANSACTION_TYPE,
                       'RECEIVE', rt.quantity,
                       'MATCH', rt.quantity,
                       0))
               GRN_QTY,
            SUM (
               DECODE (RT.TRANSACTION_TYPE,
                       'RECEIVE', rt.quantity,
                       'MATCH', rt.quantity,
                       0))
            + DECODE (RT.TRANSACTION_TYPE,
                      'RECEIVE', XX_P2P_PKG.XX_P2P_RCV_CORRECTION (
                                    rt.shipment_header_id,
                                    rt.shipment_line_id,
                                    'RECEIVE',
                                    'RECEIVE'),
                      'MATCH', XX_P2P_PKG.XX_P2P_RCV_CORRECTION (
                                  rt.shipment_header_id,
                                  rt.shipment_line_id,
                                  'MATCH',
                                  'MATCH'),
                      0)
               PHY_QTY,
            SUM (DECODE (RT.TRANSACTION_TYPE, 'DELIVER', rt.quantity, 0))
            + DECODE (RT.TRANSACTION_TYPE,
                      'DELIVER', XX_P2P_PKG.XX_P2P_RCV_CORRECTION (
                                    rt.shipment_header_id,
                                    rt.shipment_line_id,
                                    'DELIVER',
                                    'DELIVER'),
                      0)
               DEL_QTY,
            TO_CHAR (
               MAX (
                  DECODE (RT.TRANSACTION_TYPE,
                          'DELIVER', RT.TRANSACTION_DATE,
                          NULL)),
               'DD-MON-RRRR')
               DEL_DT,
            SUM (DECODE (RT.TRANSACTION_TYPE, 'ACCEPT', (rt.quantity), 0))
            + DECODE (RT.TRANSACTION_TYPE,
                      'ACCEPT', XX_P2P_PKG.XX_P2P_RCV_CORRECTION (
                                   rt.shipment_header_id,
                                   rt.shipment_line_id,
                                   'ACCEPT',
                                   'ACCEPT'),
                      0)
               ACCEPT_QTY,
            TO_CHAR (
               MAX (
                  DECODE (RT.TRANSACTION_TYPE,
                          'ACCEPT', RT.TRANSACTION_DATE,
                          NULL)),
               'DD-MON-RRRR')
               ACCEPT_DT,
            SUM (DECODE (RT.TRANSACTION_TYPE, 'REJECT', rt.quantity, 0))
            + DECODE (RT.TRANSACTION_TYPE,
                      'REJECT', XX_P2P_PKG.XX_P2P_RCV_CORRECTION (
                                   rt.shipment_header_id,
                                   rt.shipment_line_id,
                                   'REJECT',
                                   'REJECT'),
                      0)
               REJECT_QTY,
            TO_CHAR (
               MAX (
                  DECODE (RT.TRANSACTION_TYPE,
                          'REJECT', RT.TRANSACTION_DATE,
                          NULL)),
               'DD-MON-RRRR')
               REJECT_DT,
            SUM (
               DECODE (RT.TRANSACTION_TYPE, 'RETURN TO VENDOR', rt.quantity, 0))
            + DECODE (RT.TRANSACTION_TYPE,
                      'RETURN TO VENDOR', XX_P2P_PKG.XX_P2P_RCV_CORRECTION (
                                             rt.shipment_header_id,
                                             rt.shipment_line_id,
                                             'RETURN TO VENDOR',
                                             'RETURN TO VENDOR'),
                      0)
               RETURN_QTY,
            TO_CHAR (
               MAX (
                  DECODE (RT.TRANSACTION_TYPE,
                          'RETURN TO VENDOR', RT.TRANSACTION_DATE,
                          NULL)),
               'DD-MON-RRRR')
               RETURN_DT,
            RT.VENDOR_ID,
            RT.VENDOR_SITE_ID
       FROM RCV_TRANSACTIONS RT,
            RCV_SHIPMENT_HEADERS RSH,
            RCV_SHIPMENT_LINES RSL
      WHERE     RSH.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID
            AND RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID
            AND RSL.SHIPMENT_LINE_ID = RT.SHIPMENT_LINE_ID
            --AND RSL.SHIPMENT_LINE_ID=126004
            AND RT.TRANSACTION_TYPE IN
                   ('RECEIVE',
                    'MATCH',
                    'DELIVER',
                    'ACCEPT',
                    'REJECT',
                    'CORRECT',
                    'RETURN TO VENDOR')
            AND RT.PO_LINE_LOCATION_ID IS NOT NULL
   --AND RSL.shipment_line_id=2017
   GROUP BY RSH.RECEIPT_NUM,
            NVL (rsh.shipment_num, RSH.BILL_OF_LADING),
            TO_CHAR (TRUNC (rsh.shipped_date), 'DD-MON-RRRR'),
            TO_CHAR (
               DECODE (RT.TRANSACTION_TYPE,
                       'DELIVER', RT.TRANSACTION_DATE,
                       NULL),
               'DD-MON-RRRR'),
            RT.TRANSACTION_TYPE,
            RT.PO_LINE_LOCATION_ID,
            RT.SHIPMENT_HEADER_ID,
            RT.SHIPMENT_LINE_ID,
            RT.PO_HEADER_ID,
            RT.ORGANIZATION_ID,
            RT.PO_LINE_ID,
            RSL.ITEM_ID,
            RT.VENDOR_ID,
            RT.VENDOR_SITE_ID;
            
            
 --=========================================================================================================================================


CREATE OR REPLACE FORCE VIEW XXKBG_INDTO_PAY_V
(
   BILL_NO,
   BILL_DATE,
   INV_VOU,
   INVOICE_RATE,
   INV_VOU_DT,
   PAY_VOU,
   PAYMENT_RATE,
   PAY_VOU_DT,
   SHIPMENT_HEADER_ID,
   SHIPMENT_LINE_ID,
   ORG_ID,
   CHECK_DATE,
   PREPAY_INV_DT
)
AS
     SELECT INVOICE_NUM BILL_NO,
            TO_CHAR (INVOICE_DATE, 'DD-MON-RRRR') BILL_DATE,
            AI.DOC_SEQUENCE_VALUE INV_VOU,
            NVL (ai.EXCHANGE_RATE, 1) INVOICE_RATE,
            TO_CHAR (AI.CREATION_DATE, 'DD-MON-RRRR') INV_VOU_DT,
            T1.PAY_VOU,
            T1.PAYMENT_RATE,
            MIN (TO_CHAR (T1.CREATION_DATE, 'DD-MON-RRRR')) PAY_VOU_DT,
            RT.SHIPMENT_HEADER_ID,
            RT.SHIPMENT_LINE_ID,
            AI.ORG_ID,
            TO_CHAR (T1.check_date, 'DD-MON-RRRR') check_date,
            MIN (TO_CHAR (T2.CREATION_DATE, 'DD-MON-RRRR')) PREPAY_INV_DT
       FROM ap_invoices_all ai,
            ap_invoice_lines_all apl,
            (SELECT ck.check_date,
                    pm.invoice_id,
                    CK.DOC_SEQUENCE_VALUE PAY_VOU,
                    pm.CREATION_DATE,
                    NVL (PM.EXCHANGE_RATE, 1) PAYMENT_RATE
               FROM ap_invoice_payments_all pm, ap_checks_all ck
              WHERE ck.check_id = pm.check_id
                    AND ck.status_lookup_code <> 'VOIDED') t1,
            (SELECT CREATION_DATE, invoice_id
               FROM ap_invoice_lines_all
              WHERE     line_type_lookup_code = 'PREPAY'
                    AND line_source = 'PREPAY APPL'
                    AND NVL (CANCELLED_FLAG, 'N') <> 'Y') t2,
            rcv_transactions rt
      WHERE     ai.invoice_id = t1.invoice_id(+)
            AND ai.invoice_id = apl.invoice_id
            AND apl.line_type_lookup_code LIKE 'ITEM%'
            AND apps.xx_ap_pkg.GET_INVOICE_STATUS (ai.INVOICE_ID) <>
                   'Cancelled'
            AND (AI.INVOICE_AMOUNT) > 0
            AND apl.invoice_id = t2.invoice_id(+)
            AND rt.transaction_id = apl.rcv_transaction_id
            AND apl.rcv_shipment_line_id = RT.SHIPMENT_LINE_ID
            AND rt.TRANSACTION_TYPE = 'RECEIVE'
   GROUP BY INVOICE_NUM,
            TO_CHAR (INVOICE_DATE, 'DD-MON-RRRR'),
            AI.DOC_SEQUENCE_VALUE,
            T1.PAY_VOU,
            TO_CHAR (AI.CREATION_DATE, 'DD-MON-RRRR'),
            RT.SHIPMENT_HEADER_ID,
            RT.SHIPMENT_LINE_ID,
            TO_CHAR (T1.check_date, 'DD-MON-RRRR'),
            AI.ORG_ID,
            NVL (ai.EXCHANGE_RATE, 1),
            T1.PAYMENT_RATE;

--===============================================================================================================
            
            
  
            
