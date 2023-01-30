--CURSOR FUNCTION
--===================
--CREATE OR REPLACE FUNCTION  GET_MTL_TRANSACTION_QTY ( P_ID IN NUMBER )
   RETURN NUMBER
IS
   CNUMBER NUMBER;
   CURSOR C1
   IS
             SELECT SUM (TRANSACTION_QUANTITY)
             FROM MTL_MATERIAL_TRANSACTIONS
            WHERE  1=1
            AND    TRANSACTION_TYPE_ID IN (42, 163, 129) 
            AND TRANSACTION_ID = P_ID ;-- IN( 8026865, 8026864) 
--     SELECT course_number
--     FROM courses_tbl
--     WHERE course_name = name_in;
BEGIN
   OPEN C1;
   FETCH C1 INTO CNUMBER;
   IF C1%NOTFOUND THEN
      CNUMBER := 9999;
   END IF;

   CLOSE C1;

RETURN CNUMBER;

END;




--===========================================
-- KSRM FUNCTION FOR INVENTORY (THIS IS A VIEW)
--===========================================
DROP VIEW APPS.WBI_INV_RCV_TRANSACTIONS_F;

/* Formatted on 2017/12/13 09:30 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW apps.wbi_inv_rcv_transactions_f (organization_name,
                                                              organization_id,
                                                              location_code,
                                                              shipment_num,
                                                              receipt_no,
                                                              receipt_date,
                                                              inventory_item_id,
                                                              item_code,
                                                              item_desc,
                                                              uom,
                                                              brand,
                                                              origin,
                                                              TYPE,
                                                              department,
                                                              rcv_transaction_id,
                                                              rate,
                                                              from_subinventory,
                                                              from_locator_name,
                                                              to_locator_name,
                                                              release_number,
                                                              release_date,
                                                              oe_order_header_id,
                                                              oe_order_line_id,
                                                              subinventory,
                                                              invoice_id,
                                                              transaction_type,
                                                              source_document_code,
                                                              invoice_status_code,
                                                              locator_name,
                                                              ref_grn_no,
                                                              ref_grn_qty,
                                                              rt_parent_transaction_id,
                                                              vendor_id,
                                                              supplier,
                                                              supplier_address,
                                                              prepayment_amount,
                                                              po_header_id,
                                                              po_no,
                                                              po_line_id,
                                                              requisition_line_id,
                                                              po_approved_date,
                                                              pr_no,
                                                              pr_qty,
                                                              lc_no,
                                                              lc_opening_date,
                                                              lc_type,
                                                              lc_currency,
                                                              po_qty,
                                                              po_price,
                                                              po_amount,
                                                              receipt_qty,
                                                              accepted_qty,
                                                              rejected_qty,
                                                              deliver_qty,
                                                              return_qty,
                                                              dlv_return_qty,
                                                              trans_qty,
                                                              dlv_return_date,
                                                              accepted_amount,
                                                              rejected_amount,
                                                              cancel_qty,
                                                              cancel_amount,
                                                              reason_id,
                                                              reason_for_rejection,
                                                              remarks,
                                                              shipment_line_id,
                                                              line_num,
                                                              shipment_header_id,
                                                              gate_entry_no,
                                                              gate_entry_date,
                                                              lc_invoice_no,
                                                              lc_invoice_date,
                                                              lc_air_vsl_name,
                                                              lc_port_of_loading,
                                                              lc_doc_arv_date,
                                                              lc_acceptance_date,
                                                              lc_fwd_schdl_date,
                                                              lc_assessable_value,
                                                              total_no_pkg,
                                                              total_no_item,
                                                              gross_weight,
                                                              net_weight,
                                                              lc_ldt_wt,
                                                              lc_dwt_wt,
                                                              lc_cutting_wt,
                                                              lc_certif_of_origin,
                                                              lc_bl_no,
                                                              lc_bl_date,
                                                              challan_number_rt,
                                                              challan_date,
                                                              challan_quantity_rt,
                                                              vehicle_number_rt,
                                                              first_weight,
                                                              second_weight,
                                                              country_of_origin,
                                                              lighter_vessel_name,
                                                              container_number,
                                                              container_size,
                                                              carrying_contractor_rt,
                                                              crane_supplier_rt,
                                                              c_and_f_name_rt,
                                                              c_and_f_cno_rt,
                                                              purpose,
                                                              through_by,
                                                              gate_pass_required,
                                                              num_of_containers,
                                                              challan_no,
                                                              challan_quantity,
                                                              crane_supplier,
                                                              gate_pass_rt,
                                                              full_container_weight,
                                                              empty_container_weight,
                                                              vehicle_number,
                                                              carrying_contractor,
                                                              lot_no,
                                                              serial_no,
                                                              created_by,
                                                              employee_id,
                                                              prepared_by,
                                                              inspection_by,
                                                              inspection_date,
                                                              trans_date,
                                                              LOCATION,
                                                              gate_pass_no,
                                                              rt_purpose,
                                                              rt_through_by,
                                                              grn_source,
                                                              lc_no_iot,
                                                              lc_opening_date_iot,
                                                              iot_ir_from_org,
                                                              iot_qty,
                                                              customer_order_no,
                                                              grn_cus_id
                                                             )
AS
   SELECT DISTINCT wxmd.organization_name, wxmd.organization_id,
                   (SELECT hl.location_code
                      FROM hr_locations hl
                     WHERE hl.location_id =
                                        pha.ship_to_location_id)
                                                                location_code,
                   rsh.shipment_num, rsh.receipt_num receipt_no,
                   rsh.last_update_date receipt_date, wxmd.inventory_item_id,
                   wxmd.item_code, wxmd.item_desc, wxmd.uom1 uom,
                   plla.attribute1 brand,
--- (SELECT ATTRIBUTE1 FROM PO_LINES_ALL WHERE     PO_HEADER_ID = PLLA.PO_HEADER_ID AND PO_LINE_ID = PLLA.PO_LINE_ID) BRAND, ----
                                         plla.attribute2 origin,
----(SELECT ATTRIBUTE2 FROM PO_LINES_ALL WHERE     PO_HEADER_ID = PLLA.PO_HEADER_ID AND PO_LINE_ID = PLLA.PO_LINE_ID) ORIGIN,
                   plla.attribute8 TYPE,
---(SELECT ATTRIBUTE8 FROM PO_LINES_ALL WHERE     PO_HEADER_ID = PLLA.PO_HEADER_ID AND PO_LINE_ID = PLLA.PO_LINE_ID) TYPE,
                   
                   ---XX_INV_PKG.XXGET_DEPARTMENT ( TO_CHAR (XX_INV_PKG.XXGET_PR_PERSON_ID (PLLA.PO_HEADER_ID,PLLA.PO_LINE_ID,WXMD.INVENTORY_ITEM_ID)))  DEPARTMENT,
                   xx_inv_pkg.xxget_department (plla.po_header_id) department,
                   
                   ----- XXGET_PR_PERSON_ID (PLLA.PO_HEADER_ID, PLLA.PO_LINE_ID,WXMD.INVENTORY_ITEM_ID) PR_PERSON_ID,
                   ----XXGET_DEPARTMENT (TO_CHAR (rsh.created_by)) department,
                   rt.transaction_id rcv_transaction_id,
                                                       -- rcv_shipment_headers
                                                        plla.unit_price rate,
                   rt.from_subinventory,
                   xx_inv_pkg.xxget_locator
                                       (rt.from_locator_id,
                                        rt.organization_id
                                       ) from_locator_name,
                   
                   -- XXGET_LOCATOR (rt.to_locator_id, rt.organization_id) to_locator_name,
                   NULL to_locator_name,
                                        ----PLLA.PO_RELEASE_ID
                   NULL release_number, NULL release_date,
                   rt.oe_order_header_id, rt.oe_order_line_id,
                   rt.subinventory, rt.invoice_id, rt.transaction_type,
                   rt.source_document_code, rt.invoice_status_code,
                   xx_inv_pkg.xxget_locator (rt.locator_id,
                                             rt.organization_id
                                            ) locator_name,
                   (SELECT msh.receipt_num
                      FROM rcv_shipment_headers msh
                     WHERE msh.shipment_header_id IN (
                              SELECT shipment_header_id
                                FROM rcv_transactions
                               WHERE transaction_id =
                                          rt.parent_transaction_id))
                                                                   ref_grn_no,
                   rt.source_doc_quantity ref_grn_qty,
                   rt.parent_transaction_id rt_parent_transaction_id,
                   pha.vendor_id,
                   xx_inv_pkg.xxget_vendorname
                                             (TO_CHAR (pha.vendor_id)
                                             ) supplier,
                   xx_inv_pkg.xxget_vendoraddress
                                    (TO_CHAR (pha.vendor_id),
                                     pha.vendor_site_id
                                    ) supplier_address,
                   NULL prepayment_amount, plla.po_header_id,
                   pha.segment1 po_no, plla.po_line_id,
                   rsl.requisition_line_id,
                   TRUNC (pha.approved_date) po_approved_date,
                   
                   ----XX_INV_PKG.XXGET_PRNO (PLLA.PO_HEADER_ID) PR_NO, ----, PLLA.PO_LINE_ID) PR_NO,
                   NVL
                      (xx_inv_pkg.xxget_prno (plla.po_header_id),
                       (SELECT segment1
                          FROM po_requisition_headers_all
                         WHERE requisition_header_id IN (
                                  SELECT DISTINCT requisition_header_id
                                             FROM po_requisition_lines_all
                                            WHERE requisition_line_id =
                                                       rsl.requisition_line_id))
                      ) pr_no,
                   xx_inv_pkg.xxget_prqty (plla.po_header_id,
                                           plla.po_line_id
                                          ) pr_qty,
                   
                   ----NVL ( (SELECT DISTINCT LC_NUMBER FROM XX_LC_DETAILS WHERE PO_HEADER_ID = PHA.PO_HEADER_ID), RSH.SHIPMENT_NUM) LC_NO,
                   ----RSH.SHIPMENT_NUM LC_NO,
                   (SELECT DISTINCT lc_number
                               FROM xx_lc_details
                              WHERE po_header_id = pha.po_header_id) lc_no,
                   (SELECT DISTINCT lc_opening_date
                               FROM xx_lc_details
                              WHERE po_header_id =
                                             pha.po_header_id)
                                                              lc_opening_date,
                   (SELECT DISTINCT DECODE (lc_type,
                                            'D', 'DEFFERED',
                                            'U', 'USANCE',
                                            'S', 'SIGHT',
                                            NULL
                                           ) lc_type
                               FROM xx_lc_details
                              WHERE po_header_id = pha.po_header_id) lc_type,
                   (SELECT DISTINCT currency_code
                               FROM xx_lc_details
                              WHERE po_header_id =
                                                 pha.po_header_id)
                                                                  lc_currency,
                   plla.quantity po_qty, plla.unit_price po_price,
                   NULL po_amount,                           ------PLLA.AMOUNT
                   
-----============================START CALCULATION========================================================================================
----RSL.QUANTITY_RECEIVED RECEIPT_QTY,
                   (SELECT SUM (quantity)
                      FROM rcv_transactions
                     WHERE shipment_header_id IN (
                              SELECT shipment_header_id
                                FROM rcv_shipment_headers
                               WHERE receipt_num =
                                                  rsh.receipt_num)
                       AND transaction_type IN
                                          ('RECEIVE', 'UNORDERED', 'CORRECT')
                       AND destination_type_code = 'RECEIVING'        ---- NEW
                       AND shipment_header_id = rt.shipment_header_id
                       AND shipment_line_id = rt.shipment_line_id
                       AND NVL (attribute5, 'XX') = NVL (rt.attribute5, 'XX'))
                                                                  receipt_qty,
                   
-------------------------------------------------------------------------------------------
                   (SELECT SUM (quantity)
                      FROM rcv_transactions
                     WHERE shipment_header_id IN (
                              SELECT shipment_header_id
                                FROM rcv_shipment_headers
                               WHERE receipt_num =
                                                 rsh.receipt_num)
                       AND transaction_type = 'ACCEPT'
                       AND shipment_header_id = rt.shipment_header_id
                       AND shipment_line_id = rt.shipment_line_id
                       AND NVL (attribute5, 'XX') = NVL (rt.attribute5, 'XX'))
                                                                 accepted_qty,
                   
------------------------------------------------------------------------------------------
                   (SELECT SUM (quantity)
                      FROM rcv_transactions
                     WHERE shipment_header_id IN (
                              SELECT shipment_header_id
                                FROM rcv_shipment_headers
                               WHERE receipt_num =
                                                 rsh.receipt_num)
                       AND transaction_type = 'REJECT'
                       AND shipment_header_id = rt.shipment_header_id
                       AND shipment_line_id = rt.shipment_line_id
                       AND NVL (attribute5, 'XX') = NVL (rt.attribute5, 'XX'))
                                                                 rejected_qty,
                   
---------------------------------------------------------------------------------------
                   (NVL
                       ((SELECT SUM (quantity)
                           FROM rcv_transactions
                          WHERE shipment_header_id IN (
                                           SELECT shipment_header_id
                                             FROM rcv_shipment_headers
                                            WHERE receipt_num =
                                                               rsh.receipt_num)
                            ----AND TRANSACTION_TYPE = 'DELIVER'
                            AND transaction_type IN
                                                 ('DELIVER', 'CORRECT') ---NEW
                            AND destination_type_code = 'INVENTORY'    ----NEW
                            AND shipment_header_id = rt.shipment_header_id
                            AND shipment_line_id = rt.shipment_line_id
                            AND NVL (attribute5, 'XX') =
                                                     NVL (rt.attribute5, 'XX')),
                        0
                       )
                    ---   - NVL ( (SELECT SUM (QUANTITY) FROM RCV_TRANSACTIONS
                   --       WHERE     SHIPMENT_HEADER_ID IN (SELECT SHIPMENT_HEADER_ID FROM RCV_SHIPMENT_HEADERS WHERE RECEIPT_NUM = RSH.RECEIPT_NUM)
                   ---          AND TRANSACTION_TYPE IN ('RETURN TO VENDOR','RETURN TO CUSTOMER')
                   ---        AND SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
                   --       AND SHIPMENT_LINE_ID = RT.SHIPMENT_LINE_ID
                   --       AND NVL (ATTRIBUTE5, 'XX') =NVL (RT.ATTRIBUTE5, 'XX')),0)
                   ) deliver_qty,
                   
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                   (  ((SELECT SUM (quantity)
                          FROM rcv_transactions
                         WHERE shipment_header_id IN (
                                           SELECT shipment_header_id
                                             FROM rcv_shipment_headers
                                            WHERE receipt_num =
                                                               rsh.receipt_num)
                           AND transaction_type IN
                                   ('RETURN TO VENDOR', 'RETURN TO CUSTOMER')
                           ---AND INSPECTION_STATUS_CODE = 'REJECTED'
                           ----AND PARENT_TRANSACTION_ID NOT IN (SELECT PARENT_TRANSACTION_ID FROM RCV_TRANSACTIONS WHERE     TRANSACTION_TYPE =  'DELIVER' AND SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID)
                           AND shipment_header_id = rt.shipment_header_id
                           AND shipment_line_id = rt.shipment_line_id
                           AND NVL (attribute5, 'XX') =
                                                     NVL (rt.attribute5, 'XX')))
                    - NVL
                         (((SELECT SUM (quantity)
                              FROM rcv_transactions
                             WHERE shipment_header_id IN (
                                           SELECT shipment_header_id
                                             FROM rcv_shipment_headers
                                            WHERE receipt_num =
                                                               rsh.receipt_num)
                               AND transaction_type IN
                                                      ('RETURN TO RECEIVING')
                               AND transaction_id IN (
                                      SELECT rcv_transaction_id
                                        FROM mtl_material_transactions
                                       WHERE rcv_transaction_id IN (
                                                SELECT transaction_id
                                                  FROM rcv_transactions
                                                 WHERE shipment_header_id =
                                                          rsh.shipment_header_id
                                                   AND transaction_type =
                                                          'RETURN TO RECEIVING'))
                               AND shipment_header_id = rt.shipment_header_id
                               AND shipment_line_id = rt.shipment_line_id
                               AND NVL (attribute5, 'XX') =
                                                     NVL (rt.attribute5, 'XX'))),
                          0
                         )
                   ) return_qty,
                   
                      /*
                   (SELECT SUM (QUANTITY)
                      FROM RCV_TRANSACTIONS
                     WHERE     SHIPMENT_HEADER_ID IN (SELECT SHIPMENT_HEADER_ID
                                                        FROM RCV_SHIPMENT_HEADERS
                                                       WHERE RECEIPT_NUM =
                                                                RSH.RECEIPT_NUM)
                           AND TRANSACTION_TYPE IN ('RETURN TO VENDOR',
                                                    'RETURN TO CUSTOMER')
                           ---AND INSPECTION_STATUS_CODE = 'ACCEPTED'
                           AND PARENT_TRANSACTION_ID IN (SELECT PARENT_TRANSACTION_ID
                                                           FROM RCV_TRANSACTIONS
                                                          WHERE     TRANSACTION_TYPE =
                                                                       'DELIVER'
                                                                AND SHIPMENT_HEADER_ID =
                                                                       RT.SHIPMENT_HEADER_ID)
                           AND SHIPMENT_HEADER_ID = RT.SHIPMENT_HEADER_ID
                           AND SHIPMENT_LINE_ID = RT.SHIPMENT_LINE_ID
                           AND NVL (ATTRIBUTE5, 'XX') = NVL (RT.ATTRIBUTE5, 'XX'))
                      DLV_RETURN_QTY,
                      */
                   (SELECT SUM (quantity)
                      FROM rcv_transactions
                     WHERE shipment_header_id IN (
                              SELECT shipment_header_id
                                FROM rcv_shipment_headers
                               WHERE receipt_num =
                                               rsh.receipt_num)
                       AND transaction_type IN ('RETURN TO RECEIVING')
                       AND transaction_id IN (
                              SELECT rcv_transaction_id
                                FROM mtl_material_transactions
                               WHERE rcv_transaction_id IN (
                                        SELECT transaction_id
                                          FROM rcv_transactions
                                         WHERE shipment_header_id =
                                                        rsh.shipment_header_id
                                           AND transaction_type =
                                                         'RETURN TO RECEIVING'))
                       AND shipment_header_id = rt.shipment_header_id
                       AND shipment_line_id = rt.shipment_line_id
                       AND NVL (attribute5, 'XX') = NVL (rt.attribute5, 'XX'))
                                                               dlv_return_qty,
                   rt.quantity trans_qty,
                   
-----===============================END CALCULATION================================================================================
                   rsl.last_update_date dlv_return_date, NULL accepted_amount,
                                                      ----PLLA.AMOUNT_ACCEPTED
                   
                   ---PLLA.QUANTITY_REJECTED REJECTED_QTY,
                   NULL rejected_amount,              ----PLLA.AMOUNT_REJECTED
                                        NULL cancel_qty,
                                                   ----PLLA.QUANTITY_CANCELLED
                                                        NULL cancel_amount,
                                                      ---PLLA.AMOUNT_CANCELLED
                   rt.reason_id,
                   (SELECT reason_name
                      FROM mtl_transaction_reasons
                     WHERE reason_id = rt.reason_id) reason_for_rejection,
                   rsl.comments remarks, rsl.shipment_line_id, rsl.line_num,
                   rsl.shipment_header_id,
---------------------------------------DFF START---------------------------------------------------------------------------------------------------
------------------------------HEADER---------------------------------------------------------
                                          rsh.attribute11 gate_entry_no,
                   rsh.attribute13 gate_entry_date,
                   rsh.attribute5 lc_invoice_no,
                   rsh.attribute10 lc_invoice_date,
                   rsh.attribute6 lc_air_vsl_name,
                   rsh.attribute7 lc_port_of_loading,
                   (SELECT DISTINCT attribute2
                               FROM rcv_shipment_headers
                              WHERE attribute_category =
                                                    'LCM GRN'
                                AND shipment_header_id =
                                                        rsh.shipment_header_id)
                                                              lc_doc_arv_date,
                   
                   ---RSH.ATTRIBUTE2 LC_DOC_ARV_DATE,
                   rsh.attribute8 lc_acceptance_date,
                   rsh.attribute9 lc_fwd_schdl_date,
                   rsh.attribute12 lc_assessable_value,
                   (SELECT DISTINCT attribute1
                               FROM rcv_shipment_headers
                              WHERE attribute_category =
                                                       'LCM GRN'
                                AND shipment_header_id =
                                                        rsh.shipment_header_id)
                                                                 total_no_pkg,
                   
                   ---RSH.ATTRIBUTE1 TOTAL_NO_PKG,
                   (SELECT DISTINCT attribute3
                               FROM rcv_shipment_headers
                              WHERE attribute_category =
                                                      'LCM GRN'
                                AND shipment_header_id =
                                                        rsh.shipment_header_id)
                                                                total_no_item,
                   
                   ---RSH.ATTRIBUTE3 TOTAL_NO_ITEM,
                   rsh.attribute14 gross_weight, rsh.attribute15 net_weight,
                   (SELECT DISTINCT attribute1
                               FROM rcv_shipment_headers
                              WHERE attribute_category =
                                                   'Scrap Ship GRN'
                                AND shipment_header_id =
                                                        rsh.shipment_header_id)
                                                                    lc_ldt_wt,
                   
                   ---RSH.ATTRIBUTE1 LC_LDT_WT,
                   (SELECT DISTINCT attribute2
                               FROM rcv_shipment_headers
                              WHERE attribute_category =
                                                   'Scrap Ship GRN'
                                AND shipment_header_id =
                                                        rsh.shipment_header_id)
                                                                    lc_dwt_wt,
                   
                   ----RSH.ATTRIBUTE2 LC_DWT_WT,
                   (SELECT DISTINCT attribute3
                               FROM rcv_shipment_headers
                              WHERE attribute_category =
                                               'Scrap Ship GRN'
                                AND shipment_header_id =
                                                        rsh.shipment_header_id)
                                                                lc_cutting_wt,
                   
                   ----RSH.ATTRIBUTE3 LC_CUTTING_WT,
                   NULL lc_certif_of_origin, NULL lc_bl_no, NULL lc_bl_date,
                   
----------------------LINE-------------------------------------------------------------------------
                   rt.attribute5 challan_number_rt,
                   rt.attribute9 challan_date,
                   rt.attribute6 challan_quantity_rt,
                   rt.attribute7 vehicle_number_rt,
                   rt.attribute8 first_weight, NULL second_weight,
                   (SELECT DISTINCT attribute10
                               FROM rcv_transactions
                              WHERE attribute_category =
                                                  'LCM GRN'
                                AND transaction_id = rt.transaction_id)
                                                            country_of_origin,
                   
                   ----RT.ATTRIBUTE10 COUNTRY_OF_ORIGIN,
                   (SELECT DISTINCT attribute10
                               FROM rcv_transactions
                              WHERE attribute_category =
                                       'LC Item Receiving'
                                AND transaction_id = rt.transaction_id)
                                                          lighter_vessel_name,
                   
                   --- RT.ATTRIBUTE10 LIGHTER_VESSEL_NAME,
                   rt.attribute11 container_number,
                   rt.attribute13 container_size,
                   rt.attribute14 carrying_contractor_rt,
                   (SELECT DISTINCT attribute2
                               FROM rcv_transactions
                              WHERE attribute_category =
                                        'LC Item Receiving'
                                AND transaction_id = rt.transaction_id)
                                                            crane_supplier_rt,
                   
                   ---RT.ATTRIBUTE2 CRANE_SUPPLIER_RT,
                   rt.attribute12 c_and_f_name_rt,
                   rt.attribute15 c_and_f_cno_rt, rt.attribute3 purpose,
                   rt.attribute4 through_by,
                   (SELECT DISTINCT attribute2
                               FROM rcv_transactions
                              WHERE attribute_category =
                                        'Return to Vendor'
                                AND transaction_id = rt.transaction_id)
                                                           gate_pass_required,
                   
---RT.ATTRIBUTE2 GATE_PASS_REQUIRED,
--------------------------------------DFF   END ------------------------------------------------------------------------------
---------------------------------DFF START ------------------------------------------------------------------------------------------
                   rsh.num_of_containers, rsl.attribute1 challan_no,
                   rsl.attribute3 challan_quantity,
                   rsl.attribute6 crane_supplier,
                                                 ----RT.ATTRIBUTE1 GATE_PASS_RT,
                   NULL gate_pass_rt,
                                     ----  RT.ATTRIBUTE15 FULL_CONTAINER_WEIGHT,
                   NULL full_container_weight,
                                              --- RT.ATTRIBUTE12 EMPTY_CONTAINER_WEIGHT,
                   NULL empty_container_weight, rsl.attribute4 vehicle_number,
                   rsl.attribute5 carrying_contractor,
                   
---------------------------------DFF END ------------------------------------------------------------------------------------------
                   (xx_inv_pkg.xxget_lot_no (rt.shipment_header_id,
                                             rt.shipment_line_id
                                            )
                   ) lot_no,
                   (xx_inv_pkg.xxget_serial_number
                       (xx_inv_pkg.xxget_mmt_transaction_id (rt.transaction_id)
                       )
                   ) serial_no,
                   
--------------------------------------------------------------------------------------------
                   rsh.created_by, rt.employee_id,
                   xx_inv_pkg.xxget_ename
                                         (TO_CHAR (rsh.created_by)
                                         ) prepared_by,
                   xx_inv_pkg.xxget_ename
                                       (TO_CHAR (rt.employee_id)
                                       ) inspection_by,
                   TRUNC (rt.transaction_date) inspection_date,
                   rt.transaction_date trans_date, NULL LOCATION,
                   rt.attribute1 gate_pass_no,
                   (SELECT attribute3
                      FROM rcv_transactions
                     WHERE attribute1 IS NOT NULL
                       AND attribute_category = 'Return to Vendor'
                       AND transaction_type = 'RETURN TO VENDOR'
                       AND transaction_id = rt.transaction_id) rt_purpose,
                   (SELECT attribute4
                      FROM rcv_transactions
                     WHERE attribute1 IS NOT NULL
                       AND attribute_category = 'Return to Vendor'
                       AND transaction_type = 'RETURN TO VENDOR'
                       AND transaction_id = rt.transaction_id) rt_through_by,
                   rsh.receipt_source_code grn_source,
                   (SELECT DISTINCT lc_number
                               FROM xx_lc_details
                              WHERE lc_id =
                                       (SELECT DISTINCT attribute3
                                                   FROM mtl_material_transactions
                                                  WHERE attribute_category =
                                                                   'LC Number'
                                                    AND transaction_id =
                                                           rsl.mmt_transaction_id))
                                                                    lc_no_iot,
                   (SELECT DISTINCT lc_opening_date
                               FROM xx_lc_details
                              WHERE lc_id =
                                       (SELECT DISTINCT attribute3
                                                   FROM mtl_material_transactions
                                                  WHERE attribute_category =
                                                                   'LC Number'
                                                    AND transaction_id =
                                                           rsl.mmt_transaction_id))
                                                          lc_opening_date_iot,
                   rsl.from_organization_id iot_ir_from_org,
                   
                   ----RSL.QUANTITY_SHIPPED IOT_QTY,
                   DECODE (rsh.receipt_source_code,
                           'INVENTORY', rsl.quantity_shipped,
                           NULL
                          ) iot_qty,
                   (SELECT order_number
                      FROM oe_order_headers_all
                     WHERE header_id =
                                     rsl.oe_order_header_id)
                                                            customer_order_no,
                   rsh.customer_id grn_cus_id
              FROM wbi_xxkbgitem_mt_d wxmd LEFT OUTER JOIN rcv_shipment_lines rsl
                   ON rsl.item_id = wxmd.inventory_item_id
                 AND rsl.to_organization_id = wxmd.organization_id
                   LEFT OUTER JOIN po_lines_all plla
                   ON plla.po_line_id = rsl.po_line_id
                 AND plla.po_header_id = rsl.po_header_id
                   ---AND RSL.LINE_NUM=PLLA.SHIPMENT_NUM --- AND PLLA.CLOSED_CODE='OPEN'
                   LEFT OUTER JOIN po_headers_all pha
                   ON plla.po_header_id = pha.po_header_id
                   LEFT OUTER JOIN rcv_transactions rt
                   ON rsl.shipment_header_id = rt.shipment_header_id
                 AND rsl.shipment_line_id = rt.shipment_line_id
                 ----AND RT.PO_HEADER_ID = PLLA.PO_HEADER_ID ---AND RT.PO_LINE_ID = PLLA.PO_LINE_ID
                 AND rt.organization_id = wxmd.organization_id
                   ,              --  AND inspection_status_code = 'ACCEPTED',
                   rcv_shipment_headers rsh
             WHERE rsl.shipment_header_id = rsh.shipment_header_id;

