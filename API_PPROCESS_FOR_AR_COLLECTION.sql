--API Process for AR Collections

--XX_KSRM_COLLECTIONS_API_PROC


--CREATE OR REPLACE PROCEDURE APPS.XX_KSRM_COLLECTIONS_API_PROC (
   errbuf     OUT VARCHAR2,
   retcode    OUT NUMBER,
   p_org_id       NUMBER)
AS
   l_return_status     VARCHAR2 (1);
   l_msg_count         NUMBER;
   l_msg_data          VARCHAR2 (240);
   l_count             NUMBER;
   l_cash_receipt_id   NUMBER; 
BEGIN
DECLARE
V_PROCESS_ID NUMBER;
begin
SELECT NVL(MAX(PROCESS_ID),0)+1 INTO V_PROCESS_ID FROM XX_RECEIPT_LOG_ALL;
delete from XX_RECEIPT_LOG;
commit;
insert into XX_RECEIPT_LOG value (SELECT DISTINCT     CMM.COLLECTIONS_NUMBER,
                 CMM.CURRENCY_CODE,
                 CMM.AMOUNT FUNCTIONAL_AMOUNT,
                 TO_CHAR (CMM.INSTRUMENT_NUMBER) MODE_NUMBER,
                 TRUNC(CMM.VALUE_DATE) GL_DATE,
                 CMM.CUSTOMER_ID,
                 CMM.COMMENTS,
                 CMM.COLLECTIONS_TRX_ID,
                 CMM.HEADER_ID COLLECTIONS_TRX_LINE_ID,
                 CMM.RECEIPT_METHOD_ID,
                 CMM.BANK_ACCT_USE_ID REMIT_BANK_ACCT_USE_ID,
                 CMM.ORG_ID,
                 ACR.RECEIPT_NUMBER,
                 CMM.TRANSECTION_STATUS,
                 CMM.TRANSECTION_FLAG
            FROM (SELECT ARC.TRANSFER_FLAG,ARC.COLLECTIONS_TRX_ID,ARC.CURRENCY_CODE,ARC.COMMENTS,ARC.CUSTOMER_ID,CML.COLLECTIONS_NUMBER,CMH.VALUE_DATE,CML.INSTRUMENT_NUMBER,
            CML.ORG_ID,
                      CML.AMOUNT, CMH.HEADER_ID,CMH.RECEIPT_METHOD_ID,CMH.BANK_ACCT_USE_ID, CMH.TRANSECTION_STATUS,CML.TRANSECTION_FLAG,ARC.MODE_NUMBER 
                 FROM XX_AR_COLLECTIONS_ALL ARC,XX_CHEQUE_MANAGEMENT_LINES CML, XX_CHEQUE_MANAGEMENT_HEADERS CMH 
                 WHERE ARC.COLLECTIONS_NUMBER=CML.COLLECTIONS_NUMBER AND ARC.ORG_ID=CMH.ORG_ID AND CMH.HEADER_ID =CML.HEADER_ID AND CMH.TRANSECTION_STATUS = 'CLR') CMM
                 LEFT OUTER JOIN AR_CASH_RECEIPTS_ALL ACR  ON TO_CHAR (CMM.MODE_NUMBER) = TO_CHAR (ACR.RECEIPT_NUMBER)
           WHERE CMM.ORG_ID = p_org_id
           AND   NVL(CMM.TRANSFER_FLAG,'X') NOT IN ('Y')
           AND  NOT EXISTS (SELECT 1 FROM AR_CASH_RECEIPTS_ALL CR
                           WHERE CMM.ORG_ID = CR.ORG_ID
                           AND   TO_CHAR (CMM.MODE_NUMBER) = TO_CHAR (CR.RECEIPT_NUMBER)
                          )                     );
                               
                          commit;
                          
  INSERT INTO XX_RECEIPT_LOG_ALL VALUE (SELECT A.*, V_PROCESS_ID, SYSDATE  FROM XX_RECEIPT_LOG A, DUAL B);
  COMMIT;
  
  
 exception 
 when others then
 delete from XX_RECEIPT_LOG;
 COMMIT;
 end;
   mo_global.set_policy_context ('S', p_org_id);

   fnd_global.apps_initialize (user_id        => 1120,
                               resp_id        => 50559,
                               resp_appl_id   => 222);
                               
                 

   FOR REC
      IN (     select * from XX_RECEIPT_LOG    )
              
   LOOP
      ar_receipt_api_pub.create_cash (
         p_api_version                  => 1.0,
         p_init_msg_list                => fnd_api.g_TRUE,
         p_commit                       => fnd_api.g_true,
         p_validation_level             => fnd_api.g_valid_level_full,
         x_return_status                => l_return_status,
         x_msg_count                    => l_msg_count,
         x_msg_data                     => l_msg_data,
         p_currency_code                => rec.currency_code,
         p_amount                       => rec.functional_amount,
         p_receipt_number               => TO_CHAR (rec.mode_number),
         p_receipt_date                 => rec.gl_date,
         p_gl_date                      => rec.gl_date,
         p_customer_id                  => rec.customer_id,
         p_receipt_method_id            => TO_NUMBER (rec.receipt_method_id),
         p_remittance_bank_account_id   => TO_NUMBER (
                                             rec.remit_bank_acct_use_id),
         p_org_id                       => rec.org_id,
         p_comments                     => rec.comments,
         p_cr_id                        => l_cash_receipt_id);

      IF l_return_status = 'S'
      THEN
         UPDATE xx_ar_collections_all
            SET transfer_flag = 'Y',
                cash_receipt_id = l_cash_receipt_id,
                process_date = SYSDATE
          WHERE collections_trx_id = rec.collections_trx_id;
      ELSE
         INSERT INTO xxcash_receipt_error (line_count,
                                           mess,
                                           collection_trx_id,
                                           collection_trx_line_id)
              VALUES (rec.mode_number,
                      l_msg_data,
                      rec.collections_trx_id,
                      rec.collections_trx_line_id);
      END IF;
   END LOOP;

   COMMIT;
END;
/


--==============================================================
