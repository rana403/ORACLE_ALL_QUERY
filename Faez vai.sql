
-- JOB CERTIFICATION REPORT

/* Formatted on 2/28/2019 12:50:19 PM (QP5 v5.256.13226.35538) */ --FAIZ_KSRM_ERP
  SELECT MM.ORG_ID,
         SUBSTR (XX_GET_HR_OPERATING_UNIT (MM.ORG_ID), 5) OPERATING_UNIT,
         XX.DESTINATION_ORGANIZATION_ID IO_ID,
         XX_INV_PKG.XXGET_ORG_LOCATION (XX.DESTINATION_ORGANIZATION_ID)
            ORG_ADDRESS,
         MM.PO_HEADER_ID, --
         MM.SEGMENT1 PO_NO,
        -- MM.TYPE_LOOKUP_CODE,
         TO_CHAR (MM.CREATION_DATE, 'DD-MON-RRRR') PO_DATE,
         --XX_GET_EMP_NAME_FROM_USER_ID (MM.CREATED_BY) Created_By,
         XX_GET_VENDOR_NAME (MM.VENDOR_ID) Vendor,
         XX_GET_VENDOR_ADDRESS (MM.VENDOR_SITE_ID) VENDOR_ADDRESS,
         --XX_GET_SHIP_BILL_LOC (MM.SHIP_TO_LOCATION_ID) SHIP_TO,
         --XX_GET_SHIP_BILL_LOC (MM.BILL_TO_LOCATION_ID) BILL_TO,
         --MM.CURRENCY_CODE,
         --MM.RATE_TYPE,
         --TO_CHAR (MM.RATE_DATE,'DD-MON-RRRR') RATE_DATE,
         --MM.RATE,
         --MM.REVISION_NUM,
         --TO_CHAR (MM.REVISED_DATE,'DD-MON-RRRR') REVISED_DATE,
         --MM.COMMENTS,
         --TO_CHAR (MM.CLOSED_DATE, 'DD-MON-RRRR') CLOSED_DATE,
         --MM.ATTRIBUTE1,
         -- MM.ATTRIBUTE5,
         -- MM.ATTRIBUTE6,
         -- MM.ATTRIBUTE8,
         --MM.CLOSED_CODE,
         --MM.REQUEST_ID,
         --MM.WF_ITEM_TYPE,
         --MM.WF_ITEM_KEY,
         --MM.DOCUMENT_CREATION_METHOD,
         --TO_CHAR (MM.SUBMIT_DATE, 'DD-MON-RRRR') SUBMIT_DATE,
         --MM.CLM_DOCUMENT_NUMBER,
         --TO_CHAR (MM.CLM_EFFECTIVE_DATE, 'DD-MON-RRRR') CLM_EFFECTIVE_DATE,
         --NN.PO_LINE_ID,
         NN.ITEM_ID,
         XX_INV_PKG.XXGET_ITEM_CODE (NN.ITEM_ID) ITEM_CODE_d,
         --NN.ITEM_REVISION,
         --NN.CATEGORY_ID,
         NN.ITEM_DESCRIPTION,
         NN.UNIT_MEAS_LOOKUP_CODE,
        -- NN.LIST_PRICE_PER_UNIT,
         --NN.UNIT_PRICE,
         NN.QUANTITY,
         --NN.HAZARD_CLASS_ID,
         --NN.QTY_RCV_TOLERANCE,
         --NN.CLOSED_FLAG,
         --NN.CANCEL_FLAG,
         --XX_GET_SHIP_BILL_LOC (NN.CANCELLED_BY) CANCLEED_BY,
        -- TO_CHAR (NN.CANCEL_DATE, 'DD-MON-RRRR') CANCEL_DATE,
         --NN.CANCEL_REASON,
        -- NN.ATTRIBUTE1,
         --NN.ATTRIBUTE2,
         --NN.ATTRIBUTE3,
         --NN.CLOSED_CODE,
         --TO_CHAR (NN.CLOSED_DATE, 'DD-MON-RRRR') CLOSED_DATE,
         --NN.CLOSED_REASON,
         --XX_ONT_GET_ENAME (NN.CLOSED_BY) CLOSED_BY,
         --NN.SECONDARY_QUANTITY,
         --NN.SECONDARY_UNIT_OF_MEASURE,
         NN.PURCHASE_BASIS,
         NN.BASE_UNIT_PRICE,
         OO.QUANTITY,
         OO.QUANTITY_RECEIVED,
         OO.QUANTITY_ACCEPTED,
         OO.QUANTITY_REJECTED,
         OO.QUANTITY_BILLED,
         OO.QUANTITY_CANCELLED,
         --TO_CHAR (OO.NEED_BY_DATE, 'DD-MON-RRRR') NEED_BY_DATE,
         --TO_CHAR (OO.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
         --TO_CHAR (OO.CANCEL_DATE, 'DD-MON-RRRR') CANCEL_DATE,
         --OO.CANCEL_REASON,
         --OO.SHIPMENT_TYPE,
        -- OO.CLOSED_CODE,
         --OO.CLOSED_REASON,
         PP.TRANSACTION_TYPE,
         XX_ONT_GET_ENAME (PP.CREATED_BY) INS_BY,
         TO_CHAR (PP.CREATION_DATE, 'DD-MON-RRRR') INS_DATE,
         PP.DESTINATION_TYPE_CODE,
         PP.INSPECTION_STATUS_CODE,
         --PP.DESTINATION_CONTEXT,
         PP.QUANTITY_BILLED,
        -- PP.AMOUNT_BILLED,
         --PP.REQUEST_ID,                                                     
         --QQ.RECEIPT_SOURCE_CODE,
         --QQ.SHIPMENT_NUM,
         QQ.RECEIPT_NUM GRN,
         TO_CHAR (QQ.CREATION_DATE, 'DD-MON-RRRR') GRN_DATE
    FROM PO_HEADERS_ALL MM,
         PO_LINES_ALL NN,
         PO_LINE_LOCATIONS_ALL OO,
         PO_DISTRIBUTIONS_ALL XX,
         RCV_TRANSACTIONS PP,
         RCV_SHIPMENT_HEADERS QQ
   WHERE     MM.PO_HEADER_ID = NN.PO_HEADER_ID
         AND OO.PO_HEADER_ID = NN.PO_HEADER_ID
         AND OO.PO_LINE_ID = NN.PO_LINE_ID
         AND XX.PO_HEADER_ID = OO.PO_HEADER_ID
         AND XX.PO_LINE_ID = OO.PO_LINE_ID
         AND XX.LINE_LOCATION_ID = OO.LINE_LOCATION_ID
         AND PP.PO_HEADER_ID = OO.PO_HEADER_ID
         AND PP.PO_LINE_ID = OO.PO_LINE_ID
         AND PP.PO_LINE_LOCATION_ID = OO.LINE_LOCATION_ID
         AND QQ.SHIPMENT_HEADER_ID = PP.SHIPMENT_HEADER_ID
         AND PP.TRANSACTION_TYPE = 'DELIVER'
         AND (MM.ORG_ID = :P_ORG_ID OR :P_ORG_ID IS NULL)
         AND (XX.DESTINATION_ORGANIZATION_ID = :P_IO_ID OR :P_IO_ID IS NULL)
         AND (MM.PO_HEADER_ID= :P_HED_ID OR :P_HED_ID IS NULL)
         --AND (MM.SEGMENT1 = :P_PO_NO OR :P_PO_NO IS NULL)
         AND (QQ.RECEIPT_NUM = :P_GRN OR :P_GRN IS NULL)
         AND (NN.ITEM_ID = :P_ITM_ID OR :P_ITM_ID IS NULL)
ORDER BY MM.PO_HEADER_ID