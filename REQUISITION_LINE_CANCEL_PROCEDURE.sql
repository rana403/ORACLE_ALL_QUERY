DECLARE
l_return_status VARCHAR2 (1000);
l_msg_count NUMBER;
l_msg_data VARCHAR2 (1000);
lv_header_id po_tbl_number;
lv_line_id po_tbl_number;
m NUMBER := NULL;
l_msg_dummy VARCHAR2 (2000);
l_output VARCHAR2 (2000);
BEGIN
m := 1;
lv_header_id := po_tbl_number (:REQ_HEADER_ID);
lv_line_id := po_tbl_number (:REQ_LINE_ID);
po_req_document_cancel_grp.cancel_requisition
(p_api_version => 1.0,
p_req_header_id => lv_header_id,
p_req_line_id => lv_line_id,
p_cancel_date => SYSDATE,
p_cancel_reason => 'Cancelled Requisition Through Mailed By Abu Choudhury',
p_source => 'REQUISITION',
x_return_status => l_return_status,
x_msg_count => l_msg_count,
x_msg_data => l_msg_data
);
COMMIT;
DBMS_OUTPUT.put_line (l_return_status);
IF l_return_status <> 'S'
THEN
fnd_msg_pub.get (m, fnd_api.g_false, l_msg_data, l_msg_dummy);
l_output := (TO_CHAR (m) || ': ' || l_msg_data);
DBMS_OUTPUT.put_line (l_output);
END IF;
END;