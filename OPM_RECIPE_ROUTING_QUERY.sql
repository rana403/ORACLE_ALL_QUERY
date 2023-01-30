--OPM CUSTOM PROCESS:
--===================

1 XX OPM Batch Cost Allocation Process 
2 XX GL Cost Allocation Process

--***********************************
-1 XX OPM Batch Cost Allocation Process DETAILS
--***********************************
XXOPM_BATCH_COST_ALLOC_PROC
CREATE OR REPLACE PROCEDURE APPS.XXOPM_BATCH_COST_ALLOC_PROC
(errbuf OUT VARCHAR2,
 retcode OUT NUMBER,
 P_PERIOD IN VARCHAR2)
AS 
--declare
 
 cursor c1 is   
 
SELECT a.inventory_item_id,a.actual_qty,a.batch_id,b.sum_qty,b.organization_id,c.batch_no, nvl(round(nullif(a.actual_qty,0)/nvl(b.sum_qty,0),3),0) cost_allocation,a.line_no
 FROM 
 (SELECT sum(CASE
                                                            WHEN mmt.transaction_uom =
                                                                    'KG'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'MT'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'kWh'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'MWH'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'EAC'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'M3'
                                                            THEN
                                                               mmt.primary_quantity
                                                            ELSE
                                                               0
                                                         END) actual_qty,gmd.inventory_item_id,gmd.organization_id,gmd.batch_id,gmd.line_no
 from mtl_material_transactions mmt,gme_material_details gmd
 where mmt.trx_source_line_id = gmd.material_detail_id
and mmt.transaction_source_id = gmd.batch_id
 and line_type=1
 group by gmd.inventory_item_id,gmd.organization_id,gmd.batch_id,gmd.line_no) a,
 ( SELECT sum(CASE
                                                            WHEN mmt.transaction_uom =
                                                                    'KG'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'MT'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'kWh'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'MWH'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'EAC'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'M3'
                                                            THEN
                                                               mmt.primary_quantity
                                                            ELSE
                                                               0
                                                         END) sum_qty,gmd.organization_id,gmd.batch_id
 from mtl_material_transactions mmt,gme_material_details gmd
 where mmt.trx_source_line_id = gmd.material_detail_id
and mmt.transaction_source_id = gmd.batch_id
 and line_type=1
 group by gmd.organization_id,gmd.batch_id
 ) b,
 GME_BATCH_HEADER C
 WHERE A.BATCH_ID=B.BATCH_ID
 AND A.ORGANIZATION_ID=B.ORGANIZATION_ID
 AND A.BATCH_ID=C.BATCH_ID
 AND A.ORGANIZATION_ID=C.ORGANIZATION_ID
AND C.BATCH_STATUS IN (2,3,4)
AND TO_CHAR(C.BATCH_CLOSE_DATE,'MON-YY')=UPPER(P_PERIOD)
ORDER BY C.BATCH_NO;
BEGIN
  FOR I IN C1 LOOP
    UPDATE gme_material_details
    SET cost_alloc=i.cost_allocation,release_type=2
    WHERE inventory_item_id=i.inventory_item_id
    AND organization_id=i.organization_id
    AND batch_id=i.batch_id AND line_no=i.line_no;
    
    UPDATE gme_material_details
    SET cost_alloc=0  
    WHERE line_type=2 and cost_alloc>0 and batch_id=i.batch_id;
    
    update gme_material_details
    set plan_qty=1
    where nvl(plan_qty,0)=0
    and batch_id=i.batch_id;
    
END LOOP;
 COMMIT;
 
       BEGIN
         FOR I IN (           SELECT MAX(LINE_NO) LINE_NO,BATCH_ID,TOTAL_ALLOC,ALLOC_TOBE FROM 
                (SELECT A.BATCH_ID,A.LINE_NO,COST_ALLOC,SUM(COST_ALLOC) OVER (PARTITION BY A.BATCH_ID) AS TOTAL_ALLOC,round(1 - SUM(COST_ALLOC) OVER (PARTITION BY A.BATCH_ID),3) AS ALLOC_TOBE
                   FROM GME_MATERIAL_DETAILS  A,GME_BATCH_HEADER B  
         WHERE A.BATCH_ID=B.BATCH_ID
         AND A.ORGANIZATION_ID=B.ORGANIZATION_ID AND LINE_TYPE=1
        AND B.BATCH_STATUS IN (2,3,4)
        AND TO_CHAR(B.BATCH_CLOSE_DATE,'MON-YY')=UPPER(P_PERIOD)
        ORDER BY A.BATCH_ID,A.LINE_NO)      
        WHERE ABS(ALLOC_TOBE)<>0 AND COST_ALLOC<>0
        GROUP BY BATCH_ID,TOTAL_ALLOC,ALLOC_TOBE) 
        LOOP  
        UPDATE GME_MATERIAL_DETAILS
        SET COST_ALLOC=COST_ALLOC + I.ALLOC_TOBE WHERE BATCH_ID =I.BATCH_ID AND LINE_NO=I.LINE_NO AND LINE_TYPE=1;
        END LOOP;
        COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
            NULL;
        END;
EXCEPTION
    WHEN OTHERS THEN
     NULL;
END;
/


--***********************************
--1 XX OPM Batch Cost Allocation Process DETAILS
--***********************************
XXGL_COST_ALLOC_PROC

CREATE OR REPLACE PROCEDURE APPS.XXGL_COST_ALLOC_PROC (
   errbuf        OUT VARCHAR2,
   retcode       OUT NUMBER,
   P_PERIOD   IN     VARCHAR2)
AS
--delete from GL_ALOC_BAS_BKUP
--declare
BEGIN
   BEGIN
      INSERT INTO GL_ALOC_BAS_BKUP
         SELECT * FROM GL_ALOC_BAS;

      fnd_file.put_line (
         fnd_file.LOG,
         'Backup is taken for previous month on GL_ALOC_BAS_BKUP..');
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (fnd_file.LOG,
                            SQLERRM || ' ' || '...GL_ALOC_BAS_BKUP..');
   END;

   COMMIT;

   BEGIN
      UPDATE GL_ALOC_BAS_BKUP
         SET BAS_YTD_PTD =
                TO_NUMBER (
                   TO_CHAR (TO_DATE (P_PERIOD, 'MON-YY') - 1, 'YYYYMM'))
       WHERE BAS_YTD_PTD IS NULL;

      COMMIT;

      fnd_file.put_line (
         fnd_file.LOG,
         'Period Name is updated on GL_ALOC_BAS_BKUP..(TEXT_CODE).');
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (
            fnd_file.LOG,
            SQLERRM || ' ' || '...Update on GL_ALOC_BAS_BKUP..');
   END;

   BEGIN
      DELETE FROM xxopm_gl_alloc_tmp;

      fnd_file.put_line (fnd_file.LOG,
                         'Temp table is cleared..XXPHP_GL_ALLOC_TMP..');
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (fnd_file.LOG,
                            SQLERRM || ' ' || '...XXPHP_GL_ALLOC_TMP..');
   END;

   COMMIT;

   BEGIN
      INSERT INTO xxopm_gl_alloc_tmp
           SELECT alloc_id,
                  0 line_no,
                  'IND',
                  ALLOC_CODE,
                  ALLOC_CODE ALLOC_DESC,
                  INVENTORY_ITEM_ID ITEM_CODE,
                  ORGANIZATION_ID ORG_CODE,
                  INVENTORY_ITEM_ID,
                  ORGANIZATION_ID ORGANIZATION_ID,
                  FIXED_PERCENT,
                  COST_CMPNTCLS_ID COST_CMPNTCLS_ID,
                  NULL NEW_OLD,
                  DENSE_RANK ()
                  OVER (PARTITION BY LEGAL_ENTITY, ORGANIZATION_ID, ALLOC_ID
                        ORDER BY alloc_id, inventory_item_id, organization_id)
                     sl
             FROM (SELECT ALLOC.INVENTORY_ITEM_ID,
                          ALLOC.ALLOC_PER FIXED_PERCENT,
                          ALLOC.PERIOD_ID,
                          GAM.alloc_id,
                          0 line_no,
                          'IND',
                          GAM.ALLOC_CODE,
                          GAM.ALLOC_CODE ALLOC_DESC,
                          COST_CMPNTCLS_ID COST_CMPNTCLS_ID,
                          NULL NEW_OLD,
                          LEGAL_ENTITY,
                          ORGANIZATION_ID
                     FROM GL_ALOC_MST GAM,
                          CM_CMPT_MST CCM,
                          (  SELECT A.INVENTORY_ITEM_ID,
                                    SUM (A.ACTUAL_QTY) QTY,
                                    A.ORGANIZATION_ID,
                                    B.LEGAL_ENTITY,
                                    ROUND (
                                       ratio_to_report (SUM (A.ACTUAL_QTY))
                                          OVER (PARTITION BY LEGAL_ENTITY)
                                       * 100,
                                       3)
                                       ALLOC_PER,
                                    PERIOD_ID
                               FROM (SELECT a.inventory_item_id,
                                            a.actual_qty,
                                            a.batch_id,
                                            b.sum_qty,
                                            b.organization_id,
                                            c.batch_no,
                                            NVL (
                                               ROUND (
                                                  NULLIF (a.actual_qty, 0)
                                                  / NVL (b.sum_qty, 0),
                                                  3),
                                               0)
                                               cost_allocation,
                                            a.line_no,
                                            TO_CHAR (C.BATCH_CLOSE_DATE,
                                                     'MON-YY')
                                               PERIOD_ID
                                       FROM (  SELECT SUM (
                                                         CASE
                                                            WHEN mmt.transaction_uom =
                                                                    'KG'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'MT'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'kWh'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'MWH'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'EAC'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'M3'
                                                            THEN
                                                               mmt.primary_quantity
                                                            ELSE
                                                               0
                                                         END)
                                                         actual_qty,
                                                      gmd.inventory_item_id,
                                                      gmd.organization_id,
                                                      gmd.batch_id,
                                                      gmd.line_no
                                                 FROM mtl_material_transactions mmt,
                                                      gme_material_details gmd
                                                WHERE mmt.trx_source_line_id =
                                                         gmd.material_detail_id
                                                      AND mmt.transaction_source_id =
                                                             gmd.batch_id
                                                      AND line_type = 1
                                             GROUP BY gmd.inventory_item_id,
                                                      gmd.organization_id,
                                                      gmd.batch_id,
                                                      gmd.line_no) a,
                                            (  SELECT SUM (
                                                         CASE
                                                            WHEN mmt.transaction_uom =
                                                                    'KG'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'MT'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'kWh'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'MWH'
                                                            THEN
                                                               mmt.primary_quantity
                                                               / 1000
                                                            WHEN mmt.transaction_uom =
                                                                    'EAC'
                                                            THEN
                                                               mmt.primary_quantity
                                                            WHEN mmt.transaction_uom =
                                                                    'M3'
                                                            THEN
                                                               mmt.primary_quantity
                                                            ELSE
                                                               0
                                                         END)
                                                         sum_qty,
                                                      gmd.organization_id,
                                                      gmd.batch_id,
                                                      gmd.inventory_item_id
                                                 FROM mtl_material_transactions mmt,
                                                      gme_material_details gmd
                                                WHERE mmt.trx_source_line_id =
                                                         gmd.material_detail_id
                                                      AND mmt.transaction_source_id =
                                                             gmd.batch_id
                                                      AND line_type = 1
                                             GROUP BY gmd.organization_id,
                                                      gmd.batch_id,
                                                      gmd.inventory_item_id) b,
                                            GME_BATCH_HEADER C
                                      WHERE A.BATCH_ID = B.BATCH_ID
                                            AND A.ORGANIZATION_ID =
                                                   B.ORGANIZATION_ID
                                            AND A.BATCH_ID = C.BATCH_ID
                                            AND A.ORGANIZATION_ID =
                                                   C.ORGANIZATION_ID
                                            AND C.BATCH_STATUS IN (2, 3, 4)
                                            AND TO_CHAR (C.BATCH_CLOSE_DATE,
                                                         'MON-YY') =
                                                   UPPER (P_PERIOD)) A,
                                    ORG_ORGANIZATION_DEFINITIONS B
                              WHERE A.ORGANIZATION_ID = B.ORGANIZATION_ID
                           GROUP BY INVENTORY_ITEM_ID,
                                    LEGAL_ENTITY,
                                    PERIOD_ID,
                                    A.ORGANIZATION_ID) ALLOC
                    WHERE ALLOC.LEGAL_ENTITY = GAM.LEGAL_ENTITY_ID
                          AND CASE
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'SALARY%ALLOWANCES%FACTORY%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'SALARY AND ALLOWANCES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'DEPRECIATION%FACTORY%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'DEPRECIATION-FACTORY'
                                 WHEN GAM.ALLOC_CODE LIKE 'DIRECT%WAGES%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'DIRECT WAGES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'FACTORY%OVERHEADS%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'FACTORY OVERHEADS'
                                 WHEN GAM.ALLOC_CODE LIKE 'GAS%CONSUMED%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'GAS CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'WASA%AND%SEWERAGE%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'WASA AND SEWERAGE'
                                 WHEN GAM.ALLOC_CODE LIKE 'POWER%CONSUMED%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'POWER CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'STORES%AND%SPARES%CONSUMED%KWN'
                                      AND ORGANIZATION_ID = 223
                                 THEN
                                    'STORES AND SPARES CONSUMED'
----------------------------------New Add-------                         
                            /*                
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'SALARY%ALLOWANCES%FACTORY%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'SALARY AND ALLOWANCES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'DEPRECIATION%FACTORY%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'DEPRECIATION-FACTORY'
                                 WHEN GAM.ALLOC_CODE LIKE 'DIRECT%WAGES%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'DIRECT WAGES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'FACTORY%OVERHEADS%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'FACTORY OVERHEADS'
                                 WHEN GAM.ALLOC_CODE LIKE 'GAS%CONSUMED%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'GAS CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'WASA%AND%SEWERAGE%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'WASA AND SEWERAGE'
                                 WHEN GAM.ALLOC_CODE LIKE 'POWER%CONSUMED%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'POWER CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'STORES%AND%SPARES%CONSUMED%KLO'
                                      AND ORGANIZATION_ID = 222
                                 THEN
                                    'STORES AND SPARES CONSUMED'
                                    
----------------------------------------------
                                WHEN GAM.ALLOC_CODE LIKE
                                         'SALARY%ALLOWANCES%FACTORY%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'SALARY AND ALLOWANCES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'DEPRECIATION%FACTORY%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'DEPRECIATION-FACTORY'
                                 WHEN GAM.ALLOC_CODE LIKE 'DIRECT%WAGES%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'DIRECT WAGES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'FACTORY%OVERHEADS%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'FACTORY OVERHEADS'
                                 WHEN GAM.ALLOC_CODE LIKE 'GAS%CONSUMED%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'GAS CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'WASA%AND%SEWERAGE%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'WASA AND SEWERAGE'
                                 WHEN GAM.ALLOC_CODE LIKE 'POWER%CONSUMED%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'POWER CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'STORES%AND%SPARES%CONSUMED%KLM'
                                      AND ORGANIZATION_ID = 177
                                 THEN
                                    'STORES AND SPARES CONSUMED'
                                   */ 
----------------------------------------------------------                                    
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'SALARY%ALLOWANCES%FACTORY'                                                 
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'SALARY AND ALLOWANCES'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'DEPRECIATION%FACTORY'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'DEPRECIATION-FACTORY'
                                 WHEN GAM.ALLOC_CODE LIKE 'DIRECT%WAGES'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'DIRECT WAGES'
                                 WHEN GAM.ALLOC_CODE LIKE 'FACTORY%OVERHEADS'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'FACTORY OVERHEADS'
                                 WHEN GAM.ALLOC_CODE LIKE 'GAS%CONSUMED'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'GAS CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE 'WASA%AND%SEWERAGE'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'WASA AND SEWERAGE'
                                 WHEN GAM.ALLOC_CODE LIKE 'POWER%CONSUMED'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'POWER CONSUMED'
                                 WHEN GAM.ALLOC_CODE LIKE
                                         'STORES%AND%SPARES%CONSUMED'
                                      AND ORGANIZATION_ID <> 223
                                 THEN
                                    'STORES AND SPARES CONSUMED'
                                 ELSE
                                    NULL                     ---GAM.ALLOC_CODE
                              END = CCM.COST_CMPNTCLS_CODE)
         ---       where organization_id=223  ---and alloc_id=51
         ORDER BY LEGAL_ENTITY, ORGANIZATION_ID, ALLOC_ID;

      fnd_file.put_line (fnd_file.LOG,
                         'Data inserted on temp table..XXOPM_GL_ALLOC_TMP..');
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (
            fnd_file.LOG,
            SQLERRM || '..' || 'Error on insertion..XXOPM_GL_ALLOC_TMP..');
   END;

   COMMIT;

   DECLARE
      CURSOR c1
      IS
           SELECT inventory_item_id,
                  organization_id,
                  line_no,
                  alloc_id
             FROM GL_ALOC_BAS
         ORDER BY alloc_id, line_no, organization_id;
   BEGIN
      FOR i IN c1
      LOOP
         UPDATE xxopm_gl_alloc_tmp
            SET line_no = i.line_no
          WHERE     inventory_item_id = i.inventory_item_id
                AND organization_id = i.organization_id
                AND alloc_id = i.alloc_id;
      END LOOP;

      fnd_file.put_line (fnd_file.LOG,
                         'Line number updated on ..XXPHP_GL_ALLOC_TMP..');

      COMMIT;

      BEGIN
         UPDATE xxopm_gl_alloc_tmp
            SET new_old = 'N'
          WHERE LINE_NO = 0;

         fnd_file.put_line (
            fnd_file.LOG,
            'new_old flag is updated to N ...XXPHP_GL_ALLOC_TMP..');
      EXCEPTION
         WHEN OTHERS
         THEN
            fnd_file.put_line (
               fnd_file.LOG,
               SQLERRM || '..'
               || 'Error on updating line_no and new_old ..XXPHP_GL_ALLOC_TMP..');
      END;

      COMMIT;
   END;

   DECLARE
      CURSOR c1
      IS
           SELECT MAX (line_no) line_no, alloc_id, organization_id
             FROM gl_aloc_bas
            WHERE line_no <> 0
         GROUP BY alloc_id, organization_id
         ORDER BY alloc_id;
   BEGIN
      FOR i IN c1
      LOOP
         DECLARE
            v_line_no   NUMBER := i.line_no;

            CURSOR c2
            IS
               SELECT organization_id,
                      line_no,
                      alloc_id,
                      inventory_item_id
                 FROM xxopm_gl_alloc_tmp
                WHERE     alloc_id = i.alloc_id
                      AND organization_id = i.organization_id
                      AND new_old = 'N';
         BEGIN
            FOR j IN c2
            LOOP
               v_line_no := TO_NUMBER (v_line_no) + 1;

               UPDATE xxopm_gl_alloc_tmp
                  SET line_no = v_line_no, NEW_OLD = 'N'
                WHERE     organization_id = j.organization_id
                      AND alloc_id = j.alloc_id
                      AND inventory_item_id = j.inventory_item_id;
            END LOOP;
         END;
      END LOOP;

      UPDATE xxopm_gl_alloc_tmp
         SET line_no = sl, NEW_OLD = 'N'
       WHERE     line_no = 0
             AND organization_id = organization_id
             AND alloc_id = alloc_id
             AND inventory_item_id = inventory_item_id;

      COMMIT;

      fnd_file.put_line (
         fnd_file.LOG,
         'Update line number for new item...XXPHP_GL_ALLOC_TMP..');
      COMMIT;
   END;

   DECLARE
      l_count   NUMBER := 0;
   BEGIN
      FOR I IN (SELECT alloc_id,
                       line_no,
                       fixed_percent,
                       cost_cmpntcls_id cmpntcls_id,
                       inventory_item_id,
                       organization_id,
                       item_code
                  FROM xxopm_gl_alloc_tmp
                 WHERE new_old = 'N')
      LOOP
         BEGIN
            l_count := l_count + 1;


            INSERT INTO GL_ALOC_BAS (ALLOC_ID,
                                     LINE_NO,
                                     ALLOC_METHOD,
                                     FIXED_PERCENT,
                                     CMPNTCLS_ID,
                                     ANALYSIS_CODE,
                                     CREATION_DATE,
                                     CREATED_BY,
                                     LAST_UPDATE_DATE,
                                     LAST_UPDATED_BY,
                                     LAST_UPDATE_LOGIN,
                                     TRANS_CNT,
                                     DELETE_MARK,
                                     BASIS_TYPE,
                                     INVENTORY_ITEM_ID,
                                     ORGANIZATION_ID)
                 VALUES (I.ALLOC_ID,
                         I.LINE_NO,
                         1,
                         I.FIXED_PERCENT,
                         I.CMPNTCLS_ID,
                         'IND',
                         SYSDATE,
                         -1,
                         SYSDATE,
                         -1,
                         -1,
                         0,
                         0,
                         1,
                         I.INVENTORY_ITEM_ID,
                         I.ORGANIZATION_ID);

            fnd_file.put_line (fnd_file.LOG,
                               'Inserted line for new item...GL_ALOC_BAS..');
         EXCEPTION
            WHEN OTHERS
            THEN
               fnd_file.put_line (
                  fnd_file.LOG,
                     SQLERRM
                  || i.alloc_id
                  || ' . '
                  || i.line_no
                  || i.inventory_item_id);
         END;
      END LOOP;

      COMMIT;
      fnd_file.put_line (fnd_file.LOG,
                         'Inserted .... No of records:- ' || l_count);

      UPDATE GL_ALOC_BAS
         SET FIXED_PERCENT = 0;

      fnd_file.put_line (fnd_file.LOG,
                         '0 Percentage updated on : ' || 'GL_ALOC_BAS');
   END;

   COMMIT;

   DECLARE
      l_count   NUMBER := 0;
   BEGIN
      FOR I IN (SELECT alloc_id,
                       line_no,
                       fixed_percent,
                       cost_cmpntcls_id cmpntcls_id,
                       inventory_item_id,
                       organization_id
                  FROM xxopm_gl_alloc_tmp)
      LOOP
         BEGIN
            l_count := l_count + 1;

            UPDATE GL_ALOC_BAS
               SET FIXED_PERCENT = I.fixed_percent
             WHERE     ALLOC_ID = I.ALLOC_ID
                   AND LINE_NO = I.LINE_NO
                   AND INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID
                   AND ORGANIZATION_ID = I.ORGANIZATION_ID;
         EXCEPTION
            WHEN OTHERS
            THEN
               fnd_file.put_line (
                  fnd_file.LOG,
                     SQLERRM
                  || i.alloc_id
                  || ' . '
                  || i.line_no
                  || i.inventory_item_id);
         END;
      END LOOP;

      COMMIT;
      fnd_file.put_line (
         fnd_file.LOG,
         'Updated actual percentage..No of records:- ' || l_count);
   END;

   DECLARE
      V_MAX_LINE_NO   NUMBER;

      CURSOR C1
      IS
           SELECT m.alloc_id,
                  m.alloc_code,
                  m.legal_entity_id,
                  SUM (b.fixed_percent),
                  100 - SUM (b.fixed_percent) TO_BE
             FROM gl_aloc_mst m, gl_aloc_bas b
            WHERE     m.alloc_id = b.alloc_id
                  AND m.delete_mark = 0
                  AND b.delete_mark = 0
                  AND (b.alloc_method = 0
                       OR (b.alloc_method = 1
                           AND 100 <>
                                  (SELECT SUM (bb.fixed_percent)
                                     FROM gl_aloc_bas bb
                                    WHERE bb.alloc_id = b.alloc_id
                                          AND bb.delete_mark = 0)))
         GROUP BY m.alloc_code, m.alloc_id, m.legal_entity_id ---ORGANIZATION_ID
         ORDER BY 3, 1, 2;
   BEGIN
      FOR I IN C1
      LOOP
         SELECT MAX (LINE_NO) LINE_NO
           INTO V_MAX_LINE_NO
           FROM GL_ALOC_BAS
          WHERE FIXED_PERCENT > 0 AND ALLOC_ID = I.ALLOC_ID;

         UPDATE GL_ALOC_BAS
            SET FIXED_PERCENT = FIXED_PERCENT + I.TO_BE
          WHERE LINE_NO = V_MAX_LINE_NO AND ALLOC_ID = I.ALLOC_ID;
      END LOOP;

      COMMIT;
      
      UPDATE GL_ALOC_BAS SET DELETE_MARK=0 WHERE FIXED_PERCENT>0 AND DELETE_MARK=1;
      COMMIT;
      UPDATE GL_ALOC_BAS SET DELETE_MARK=1 WHERE FIXED_PERCENT=0 AND DELETE_MARK=0;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         fnd_file.put_line (fnd_file.LOG,
                            SQLERRM || '..' || 'Percentage allocation..');
   END;

   fnd_file.put_line (fnd_file.LOG,
                      '********** Process Completed  **********  ');
END;
/




select * from gme_material_details where LINE_TYPE = 2






--========================
-- GET  FORMULA AND RECEIPE  IN  OPM
--========================


SELECT --OOD.ORGANIZATION_ID,  
OOD.ORGANIZATION_CODE,
OOD.ORGANIZATION_NAME, 
--FFM.OWNER_ORGANIZATION_ID, 
FFM.FORMULA_ID, 
FFM.FORMULA_NO, 
FFM.FORMULA_DESC1,  
--FMD.ORGANIZATION_ID, 
FMD.FORMULALINE_ID, 
FMD.FORMULA_ID,
--FMD.LINE_TYPE,
CASE WHEN FMD.LINE_TYPE = -1 THEN 'INGREDENT'
WHEN FMD.LINE_TYPE = 1 THEN 'PRODUCT'
WHEN FMD.LINE_TYPE = 2 THEN 'BYPRODUCT'
END AS PRODUCT_TYPE,
FMD.INVENTORY_ITEM_ID, 
B.SEGMENT1|| '|'|| B.SEGMENT2|| '|'|| B.SEGMENT3|| '|'|| B.SEGMENT4 ITEM_CODE,
B.DESCRIPTION, 
FMD.DETAIL_UOM, 
GR.RECIPE_NO, 
GR.RECIPE_DESCRIPTION,
FMD.COST_ALLOC
--GR.FORMULA_ID
FROM FM_FORM_MST FFM,
         MTL_SYSTEM_ITEMS_B B,
         FM_MATL_DTL FMD,
         gmd_recipes GR,
         ORG_ORGANIZATION_DEFINITIONS OOD
where FFM.FORMULA_ID = FMD.FORMULA_ID
AND FFM.FORMULA_ID = GR.FORMULA_ID
AND FMD.INVENTORY_ITEM_ID= B.INVENTORY_ITEM_ID
AND FMD.ORGANIZATION_ID= B.ORGANIZATION_ID
AND OOD.ORGANIZATION_ID= B.ORGANIZATION_ID
--AND FMD.ORGANIZATION_ID = 121
AND FMD.ORGANIZATION_ID = 163
--AND FFM.FORMULA_ID = 180
AND FFM.FORMULA_ID =  702 



FORMULA_ID



--=========================================== GET RECIPE NUMBER ================================================

select DISTINCT gmd.RECIPE_NO Receipe_code,
CASE WHEN FD.LINE_TYPE = -1 THEN 'INGREDENT'
WHEN FD.LINE_TYPE = 1 THEN 'PRODUCT'
WHEN FD.LINE_TYPE = 2 THEN 'BYPRODUCT'
END AS PRODUCT_TYPE,
RECIPE_DESCRIPTION Receipe_Name ,gmd.RECIPE_VERSION,FD.FORMULA_ID,
--(select distinct description from mtl_system_items mtl1,FM_MATL_DTL fd1
--where fd1.line_type=1
--and fd1.formula_id=fd.formula_id
--and fd1.inventory_item_id = mtl1.inventory_item_id
--and fd1.organization_id= mtl1.organization_id) product,
fm.formula_no,fm.FORMULA_DESC1,fm.FORMULA_VERS,
decode (gmd.RECIPE_STATUS,'900', 'Frozen','700','Approved for General Use') Rec_Status,gmd.RECIPE_STATUS,
b.segment1||'-'||b.segment2 Item_code,
b.description item_desc,
fd.line_no,
fd.qty,
FD.COST_ALLOC
from FM_FORM_MST fm,
FM_MATL_DTL fd,
mtl_system_items b,
GMD_RECIPE_VALIDITY_RULES GV,
gmd_recipes gmd
where  fd.formula_id=fm.formula_id
and fd.organization_id=fm.OWNER_ORGANIZATION_ID
and fm.formula_id =gmd.formula_id
and fm.owner_organization_id=gmd.owner_organization_id
AND GV.RECIPE_ID=GMd.RECIPE_ID
and b.inventory_item_id=fd.inventory_item_id
and b.organization_id=fm.OWNER_ORGANIZATION_ID
--and fm.OWNER_ORGANIZATION_ID in (121)
--and fd.line_type in (-1,2)
--and fm.FORMULA_STATUS=700
--and gmd.RECIPE_STATUS in (700)
--AND gmd.RECIPE_NO = 'FG|500W|19MM|000005'
--AND FD.FORMULA_ID IN( 180, 780) -- 484 --34 --30 --368
--AND gmd.RECIPE_STATUS NOT IN(900, 700)
AND FM.FORMULA_ID =  702
order by 1


COST_ALLOC

SELECT  *   FROM FM_MATL_DTL  WHERE ORGANIZATION_ID = 121 --FORMULA_ID=368

--============GET OPM TRANSACTION STATUS===================

select distinct TRANSACTION_TYPE_NAME , TRANSACTION_TYPE_ID from MTL_TRANSACTION_TYPES WHERE TRANSACTION_TYPE_NAME LIKE '%WIP%'
and transaction_type_id in (35,
17,
43,
44,
1002,
1003
)

