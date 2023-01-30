
-- TO UODATE PO LINE AND DISTRIBUTION QUANTOTY
--set serveroutput ON;
DECLARE
l_result NUMBER;
l_api_errors PO_API_ERRORS_REC_TYPE;
BEGIN
-- This needs to be changed according to your environment setup.
FND_GLOBAL.apps_initialize ( user_id => 1318,
resp_id => 50578,
resp_appl_id => 201 );
mo_global.init('PO'); -- need for R12
l_result := PO_CHANGE_API1_S.update_po (
X_PO_NUMBER => &po_num,
X_AUTHORIZATION_STATUS =>&status
X_RELEASE_NUMBER => Null,
X_REVISION_NUMBER => &rev_num,
X_LINE_NUMBER => &line_num,
X_SHIPMENT_NUMBER => &shipment_num,
NEW_QUANTITY => 100,
NEW_PRICE => Null,
NEW_PROMISED_DATE => Null,
NEW_NEED_BY_DATE => Null,
LAUNCH_APPROVALS_FLAG => 'N',
UPDATE_SOURCE => 'API',
VERSION => '1',
X_OVERRIDE_DATE => Null,
X_API_ERRORS => l_api_errors,
p_BUYER_NAME => Null,
p_secondary_quantity => Null,
p_preferred_grade => Null,
p_org_id => &org_id
);
dbms_output.put_line ('l_result' || l_result);
IF (l_result <> 1) THEN
-- Display the errors
FOR i IN 1..l_api_errors.message_text.COUNT LOOP
dbms_output.put_line ( l_api_errors.message_text(i) );
END LOOP;
END IF;
END;
commit;

--========================== Another Query for updating PO=============================

DECLARE
v_result        NUMBER;
v_api_errors    po_api_errors_rec_type;
v_revision_num  po_headers_all.revision_num%TYPE;
v_price         po_lines_all.unit_price%TYPE;
v_quantity      po_line_locations_all.quantity%TYPE;
v_po_number     po_headers_all.segment1%TYPE;
v_line_num      po_lines_all.line_num%TYPE;
v_shipment_num  po_line_locations_all.shipment_num%TYPE;
v_promised_date DATE;
v_need_by_date  DATE;
v_org_id        NUMBER;
v_context       VARCHAR2(10);
BEGIN
IF v_context = 'F'
   THEN
   DBMS_OUTPUT.PUT_LINE ('Error in the context');
END IF;
MO_GLOBAL.INIT ('PO');
v_po_number     :=40000721;
v_line_num      := 1;
v_shipment_num  := 1;
v_revision_num  := 0;
v_promised_date := '01-APR-2019';
v_need_by_date  := '04-APR-2019';
v_quantity      := 456;
v_price         := 12;
v_org_id        := 81;
DBMS_OUTPUT.put_line ('Calling API To Update PO');
v_result :=
    PO_CHANGE_API1_S.UPDATE_PO
         (x_po_number          => v_po_number,
          x_release_number     => NULL,
          x_revision_number    => v_revision_num,
          x_line_number        => v_line_num,
          x_shipment_number    => v_shipment_num,
          new_quantity         => v_quantity,
          new_price            => v_price,
          new_promised_date    => v_promised_date,
          new_need_by_date     => v_need_by_date,
          launch_approvals_flag=> 'Y',
          update_source        => NULL,
          VERSION              => '1',
          x_override_date      => NULL,
          x_api_errors         => v_api_errors,
          p_buyer_name         => NULL,
          p_secondary_quantity => NULL,
          p_preferred_grade    => NULL,
          p_org_id             => v_org_id
         ); 
DBMS_OUTPUT.put_line ('RESULT :' ||v_result);
IF (v_result = 1)
THEN
 DBMS_OUTPUT.put_line('Updating PO is Successful ');
ELSE
 DBMS_OUTPUT.put_line ('Updating PO failed');
 FOR j IN 1 .. v_api_errors.MESSAGE_TEXT.COUNT
 LOOP
 DBMS_OUTPUT.put_line (v_api_errors.MESSAGE_TEXT (j));
 END LOOP;
END IF; 
END;
commit;