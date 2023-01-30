--=============================================
--  API  TO UPDATE a CLOSED PO INTO FINALLY CLOSED 
-- THIS QUERY IS WORKING AND TESTED IN UAT SERVER
-- DATE: 10_FEB_2019
--=============================================

DECLARE
   x_action         CONSTANT VARCHAR2 (20)  := 'FINALLY CLOSE';
   -- Change this parameter as per requirement
   x_calling_mode   CONSTANT VARCHAR2 (2)   := 'PO';
   x_conc_flag      CONSTANT VARCHAR2 (1)   := 'N';
   x_return_code_h           VARCHAR2 (100);
   x_auto_close     CONSTANT VARCHAR2 (1)   := 'N';
   x_origin_doc_id           NUMBER;
   x_returned                BOOLEAN        := NULL;
BEGIN
   apps.mo_global.set_policy_context ('S', 204);
   fnd_global.apps_initialize (1015932, 50578, 201);
   DBMS_OUTPUT.put_line
             ('Calling PO_Actions.close_po for Closing/Finally Closing PO =>');
   x_returned :=
      po_actions.close_po (p_docid              => 25001,   -- THIS IS PO HEADER ID
                           p_doctyp             => 'PO',
                           p_docsubtyp          => 'STANDARD',
                           p_lineid             => NULL,
                           p_shipid             => NULL,
                           p_action             => x_action,
                           p_reason             => NULL,
                           p_calling_mode       => x_calling_mode,
                           p_conc_flag          => x_conc_flag,
                           p_return_code        => x_return_code_h,
                           p_auto_close         => x_auto_close,
                           p_action_date        => SYSDATE,
                           p_origin_doc_id      => NULL
                          );
   COMMIT;

   IF x_returned = TRUE
   THEN
      DBMS_OUTPUT.put_line
                   ('Purchase Order which just got Closed to Finally Closed. ');
      DBMS_OUTPUT.put_line (x_return_code_h);

   ELSE
      DBMS_OUTPUT.put_line
                      ('API Failed to Close/Finally Close the Purchase Order');
   END IF;
END;
           