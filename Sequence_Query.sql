--======================================
-- SEQUENCE FOR IOT
--======================================

DROP SEQUENCE XXERP.XXKSRM_IOT_SEQ_BLM;

CREATE SEQUENCE XXERP.XXKSRM_IOT_SEQ_BLM
  START WITH 12777
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 50
  NOORDER;

--======================================
-- SEQUENCE FOR MOVE ORDER 
--======================================

DROP SEQUENCE XXERP.XXKSRM_MO_SEQ_BLM;

CREATE SEQUENCE XXERP.XXKSRM_MO_SEQ_BLM
  START WITH 1000
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 50
  NOORDER;



--========================================
-- TO GET PR LINE SEQUENCE WITHOUT GAP
--Line suquence iuse this code in SL Column
--========================================
Line suquence :  <?position()?> 




select * FROM fnd_document_sequences order by  START_DATE desc

select * from dba_sequences ds 


SELECT fds.doc_sequence_id, fds.NAME, ds.sequence_name, fds.application_id,
   fds.audit_table_name, fds.TYPE, fds.table_name, fds.initial_value,
    ds.last_number   
    FROM fnd_document_sequences fds, dba_sequences ds  
    WHERE ds.sequence_name = fds.db_sequence_name   
    -- AND ds.sequence_name = 'FND_DOC_SEQ_2116_S'

