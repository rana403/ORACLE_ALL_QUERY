--TABLE LINK 
--=============

--GMF_XLA_EXTRACT_HEADERS.TRANSACTION_ID = MTL_MATERIAL_TRANSACTIONS.TRANSACTION_ID
--XLA_AE_HEADERS.EVENT_ID=GMF_XLA_EXTRACT_LINES.EVENT_ID
--XLA_AE_LINES.AE_HEADER_ID=XLA_AE_HEADERS.AE_HEADER_ID



select * from GMF_XLA_EXTRACT_HEADERS WHERE TRANSACTION_ID IN (10830084,
11079515,
11079428)


select * from GMF_XLA_EXTRACT_LINES WHERE EVENT_ID IN (
5791681,
5792161,
5791980
)


select * from XLA_AE_HEADERS WHERE AE_HEADER_ID IN (
14273514,
14273810,
14273989
)



select * from XLA_AE_LINES WHERE AE_HEADER_ID IN (
46958231
)


select * from GME_BATCH_HEADER WHERE BATCH_NO=1244
and organization_id=121




4878396
4906916

select * from GMF_XLA_EXTRACT_HEADERS WHERE TRANSACTION_ID = 1631266 

select * from GMF_XLA_EXTRACT_HEADERS WHERE TRANSACTION_ID = 4788162 --IN ( 4906916, 4878396 )

--select * from GMF_XLA_EXTRACT_LINES where header_id= 7544794   

select * from XLA_AE_HEADERS WHERE EVENT_ID=1461622

select * from XLA_AE_LINES WHERE AE_HEADER_ID= 20416321







select * from MTL_MATERIAL_TRANSACTIONS where TRANSACTION_ID =11049268  


SELECT * FROM GMF_XLA_EXTRACT_HEADERS WHERE TRANSACTION_DATE BETWEEN  '1-OCT-2019' and '31-OCT-2019'

select * from GMF_XLA_EXTRACT_LINES

select * from GMF_XLA_EXTRACT_HEADERS a, GMF_XLA_EXTRACT_LINES b 
where a.HEADER_ID = b.HEADER_ID
and a.TRANSACTION_DATE BETWEEN  '1-OCT-2019' and '31-OCT-2019' 



select * from XLA_AE_HEADERS  WHERE GL_TRANSFER_DATE BETWEEN  '1-OCT-2019' and '31-OCT-2019'





-- QUERY FOR DELETING AND BACKUP TABLE  FOR INVENTORY CLOSSING

/*
 * Generic script to delete RTI records which are not appearing in Transaction Status Summary form for deletion.
 * Please refer to bug 9919054.
 *
 * Input for the script :-
 * please replace &interface_transaction_ids with all interface transaction ids separated by comma. 
 *
 * Important Note :
 * Please ensure the scripts are ran on TEST instance first and tested for data 
 * correctness thoroughly. After the scripts are ran, please check the data and 
 * only the correct records are updated before committing.
 * If all goes well, the script can be promoted to the PRODUCTION instance.
 *
 */


--back up date in rti, rli, mtli,mtlt, rsi, msni and msnt
create table rti_bak_0819 as 

select * from rcv_transactions_interface
where 1=1
--and interface_transaction_id in (:interface_transaction_ids)
--and processing_status_code in ('RUNNING')
--and (processing_status_code in ('ERROR','PENDING','RUNNING') or (processing_status_code = 'COMPLETED' and transaction_status_code = 'ERROR'))
and lcm_shipment_line_id is null  -- / LCM shipment receipt /
and unit_landed_cost is null      --    / LCM shipment receipt /
and (header_interface_id is NULL OR mobile_txn = 'Y')
and transaction_date   between  '01-SEP-2019' and '30-SEP-2019'  
--and ORGANIZATION_ID= 121

 
select * from mtl_transaction_lots_interface








select * from  rli_bak



create table rli_bak as
select * from rcv_lots_interface 
where  interface_transaction_id in (select interface_transaction_id
                                    from rti_bak);
create table mtli_bak as 
select * from mtl_transaction_lots_interface
where  product_code = 'RCV' 
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

create table mtlt_bak as 
select * from mtl_transaction_lots_temp
where  product_code = 'RCV' 
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);
                                    
  SELECT * FROM mtl_transaction_lots_temp                                   

create table rsi_bak as
select * from rcv_serials_interface
where  interface_transaction_id  in  (select interface_transaction_id
                                     from rti_bak);
create table msni_bak as
select * from mtl_serial_numbers_interface
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

create table msnt_bak as
select * from mtl_serial_numbers_temp
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

--delete data in rti, rli, mtli,mtlt, rsi, msni and msnt
delete rcv_transactions_interface 
where interface_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

delete rcv_lots_interface 
where  interface_transaction_id in (select interface_transaction_id
                                    from rti_bak);

delete mtl_transaction_lots_interface
where  product_code = 'RCV'
and    product_transaction_id in (select interface_transaction_id 
                               from rti_bak);

delete mtl_transaction_lots_temp
where  product_code = 'RCV' 
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

delete rcv_serials_interface
where  interface_transaction_id  in  (select interface_transaction_id
                                     from rti_bak);

delete mtl_serial_numbers_interface
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);

delete mtl_serial_numbers_temp
where  product_code = 'RCV'
and    product_transaction_id in  (select interface_transaction_id
                                    from rti_bak);
                                    
---=============================================================



select * from gmf_xla_extract_headers where inventory_item_id= and organization_id= and to_char(transaction_date,'mon-yy')=''
 
select * from cm_acst_led where inventory_item_id=92 and organization_id=121 and period_id=187 and cost_analysis_code='IND'


select * from xla_ae_headers a,xla_ae_lines b
where a.ae_header_id=b.ae_header_id
and b.code_combination_id in (320544,363544)
order by ae_header_id

select * from gl_je_headers a,gl_je_lines b where a.je_header_id=b.je_header_id
and b.code_combination_id in (320544,363544) and a.period_name  ='Jun-19'
order by a.je_header_id

--======================= 5-DEC-2020

select *  from MTL_SYSTEM_ITEMS_B where inventory_item_id=165

select INVENTORY_ITEM_ID,SEGMENT1||'|'||SEGMENT2||'|'|| SEGMENT3||'|'|| SEGMENT4 from MTL_SYSTEM_ITEMS_B where SEGMENT1||'|'||SEGMENT2||'|'|| SEGMENT3||'|'|| SEGMENT4 ='CP|500W|10MM|000002' --'FL|F&LB|HOIL|000083' -- 'RM|SCRP|ROLL|000005' -- 'CP|400E|10MM|000052'

select  *  from cm_cmpt_dtl where TOTAL_QTY is not null and INVENTORY_ITEM_ID = 9

   select * from gmf_period_statuses mst2
   
   select * from cm_cmpt_dtl ccd 
   
             select * from cm_cmpt_mst_vl ccmv2

select * from MTL_MATERIAL_TRANSACTIONS

--VALUE COST ADJUSTMENT  ---->  Kisu item er against a dite hobe 


--=======================================
--LOGIC: WIP COMPLETION-WIP RETURN

-- XXKSRM Production Cost Summary Report
SELECT period_code, ITEM_CODE,NVL(SUM(CMPNT_COST),0) CPMT,NVL(TOTAL_QTY,0) TOTAL_QTY,NVL(SUM(MATERIAL_VALUE),0) MATERIAL_VALUE, NVL(SUM(MATERIAL_VALUE_V1),0) MATERIAL_VALUE_V1, NVL(SUM(OH_VALUE),0) OH_VALUE,
ORGANIZATION_ID,PERIOD_CODE,ORGANIZATION_CODE,ORGANIZATION_NAME,START_DATE,END_DATE,ITEM_DESC
 FROM 
(SELECT UPPER(CCMV.COST_CMPNTCLS_DESC) COST_CMPNTCLS_DESC,CCD.COST_ANALYSIS_CODE,CCD.CMPNT_COST,CCD.TOTAL_QTY,CCD.cost_cmpntcls_id,
                      (SELECT  NVL(SUM(CCD2.CMPNT_COST*CCD2.TOTAL_QTY),0) GTOTAL_VALUE 
      FROM cm_cmpt_dtl   ccd2
               ,gmf_period_statuses mst2
               ,cm_cmpt_mst_vl ccmv2
      WHERE ccd2.period_id          = mst2.period_id
        AND CCMV2.COST_CMPNTCLS_ID=ccd2.COST_CMPNTCLS_ID
        and wxm.organization_id=ccd2.organization_id
        AND ccd2.delete_mark        = 0
        AND ccd.period_id          = mst.period_id
        AND CCD.COST_CMPNTCLS_ID=ccd2.COST_CMPNTCLS_ID
        GROUP BY  CCD2.ORGANIZATION_ID,MST2.PERIOD_CODE,CCMV2.COST_CMPNTCLS_DESC,CCD2.COST_ANALYSIS_CODE) GTOTAL, 
     CASE WHEN CCMV.COST_CMPNTCLS_DESC='Material' THEN CCD.CMPNT_COST*CCD.TOTAL_QTY ELSE 0 END MATERIAL_VALUE,
     CASE WHEN CCMV.COST_CMPNTCLS_DESC='Material' THEN CCD.TOTAL_QTY  ELSE 0 END MATERIAL_VALUE_V1,
     CASE WHEN CCMV.COST_CMPNTCLS_DESC<>'Material' THEN CCD.CMPNT_COST*CCD.TOTAL_QTY ELSE 0 END OH_VALUE,
     CCD.CMPNT_COST*CCD.TOTAL_QTY TOTAL_COGS,
     ratio_to_report (CCD.CMPNT_COST*CCD.TOTAL_QTY) OVER () *100 PER_ON_TOTAL_COST,
     CCD.ORGANIZATION_ID,MST.PERIOD_CODE,WXM.ITEM_CODE,WXM.ORGANIZATION_CODE,WXM.ORGANIZATION_NAME,mst.start_date start_date,trunc(mst.end_date) end_date,wxm.uom1,wxm.uom2,wxm.item_desc
      FROM cm_cmpt_dtl   ccd
               ,gmf_period_statuses mst
               ,cm_cmpt_mst_vl ccmv
               ,wbi_xxkbgitem_mt_d wxm
      WHERE ccd.period_id          = mst.period_id
        AND CCMV.COST_CMPNTCLS_ID=ccd.COST_CMPNTCLS_ID
        AND wxm.inventory_item_id=ccd.inventory_item_id
        ---AND wxm.item_code=:p_item_code
        and wxm.organization_id=ccd.organization_id
        and mst.period_code =:p_period_code
         and CCD.PERIOD_TRANS_QTY <>0
      --  and  to_char( mst.creation_date,'MON-YY') = :P_PERIOD_CODE
        AND wxm.organization_code   =NVL(:p_organization_code,wxm.organization_code)
        AND wxm.finance_category LIKE 'FINISHED GOODS|FINISHED GOODS'
        --and ITEM_CODE= 'RM|SCRP|ROLL|000005'
     --   AND wxm.item_code =:p_item_code
       -- and ccd.PERIOD_TRANS_QTY is not null
      --- AND upper(cost_cmpntcls_desc)='MATERIAL'
        AND ccd.delete_mark        = 0)
        GROUP BY ITEM_CODE,TOTAL_QTY,ORGANIZATION_ID,PERIOD_CODE,ORGANIZATION_CODE,ORGANIZATION_NAME,START_DATE,END_DATE,ITEM_DESC
        ORDER BY ITEM_CODE 
        
        
        

--==================3-DEC-2020============================================

select * from APPS.EAM_OP_GDET_VW where CONCAT_ITEM_CODE= 'SP|ELEC|CABL|020496'   --;  ---> EKTA ITEM ER JOTO ROKOM TRANSACTIONS ASE SOB GULO 

Invoice validation

craeteaccounting 

transfer to gl        

uninvoice transaction report ---> validate or not status


--=================================

 -- within a period Opening , Receive, Issue, Clossing ---> Inventory valuation report er purpose
 
--WITHIN A PERIOD EKTI ITEM ER INPUT, OUTPUT, VALUE,  --> COST SHEET ER PURPOSE 

select * from ORG_ORGANIZATION_DEFINITIOS

-- > SELECT * FROM CM_ADJS_DTL 


ITEM_ID: 86
ITEM CODE: FG|500W|08MM|000001
ITEM_DESCRIPTION: 'KSRM 500 W 08 MM'  

select * from gmf_period_balances

select * FROM ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE LIKE 'KSD%'   






 select SUM(TRANSACTION_QUANTITY)
  from mtl_material_transactions
  where inventory_item_id= 86 
  and transaction_date between '01-JUN-2019' and '30-JUN-2019' 
and  TRANSACTION_ID= 3604110 --3604312 --3604067
 and ORGANIZATION_ID IN(
 121,
150,
149,
148,
147,
146,
145,
144,
143,
142,
141)
 

 select * --SUM(TRANSACTION_QUANTITY) 
 from GMF_XLA_EXTRACT_HEADERS 
 WHERE transaction_date between '01-JUN-2019' and '30-JUN-2019'
  and legal_entity_id ='23273' and INVENTORY_ITEM_ID=86
 --and  TRANSACTION_ID= 3604110 --3604312 --3604067
 
 3,9,14,19,24
 
 ALC= ALLLOCATION, GL COST ALOCATION
 

-- MTL DETAILS
SELECT organization_id,INVENTORY_ITEM_ID,TRANSACTION_ID,GET_ORG_CODE_FROM_ID(organization_id)
INVENTORY_ITEM_ID,XXGET_ITEM_CODE(INVENTORY_ITEM_ID) ITEM_CODE,
MY_PACKAGE.XXGET_ITEM_DESCRIPTION(INVENTORY_ITEM_ID), 
PRIMARY_QUANTITY,TRANSACTION_QUANTITY 
FROM MTL_MATERIAL_TRANSACTIONS
where 1=1
and transaction_DATE BETWEEN '01-JUL-2019' and '31-JUL-2019'
and organization_id in (select ORGANIZATION_ID from ORG_ORGANIZATION_DEFINITIONS where LEGAL_ENTITY=23273 )
and XXGET_ITEM_CODE(INVENTORY_ITEM_ID)  = 'FG|500W|08MM|000001'
and organization_id= 121
--and TRANSACTION_ID = 3950869
order by TRANSACTION_ID
--group by INVENTORY_ITEM_ID,organization_id


-- MTL SUM
SELECT organization_id,GET_ORG_CODE_FROM_ID(organization_id)
INVENTORY_ITEM_ID,XXGET_ITEM_CODE(INVENTORY_ITEM_ID) ITEM_CODE,
MY_PACKAGE.XXGET_ITEM_DESCRIPTION(INVENTORY_ITEM_ID), 
SUM(PRIMARY_QUANTITY),SUM(TRANSACTION_QUANTITY) 
FROM MTL_MATERIAL_TRANSACTIONS
where transaction_DATE BETWEEN '01-JUL-2019' and '31-JUL-2019'
and organization_id in (select ORGANIZATION_ID from ORG_ORGANIZATION_DEFINITIONS where LEGAL_ENTITY=23273 )
group by INVENTORY_ITEM_ID,organization_id


-- GMF DETAILS

select distinct eh.TRANSACTION_TYPE_ID, el.journal_line_type,GET_ORG_CODE_FROM_ID(eh.organization_id) ,
eh.INVENTORY_ITEM_ID,XXGET_ITEM_CODE(INVENTORY_ITEM_ID) ITEM_CODE,MY_PACKAGE.XXGET_ITEM_DESCRIPTION(INVENTORY_ITEM_ID),TRANSACTION_QUANTITY,el.base_amount from gmf_xla_extract_lines el,gmf_xla_extract_headers eh
where el.header_id = eh.header_id
 and eh.transaction_date >= to_date('01-JUL-2019 00:00:00','dd-mon-yyyy hh24:mi:ss') -- Change to first date of the current period
 and eh.transaction_date <= to_date('31-JUL-2019 23:59:59','dd-mon-yyyy hh24:mi:ss') -- Change to last date of the current period
 --and eh.ledger_id = LEDGER_ID
 and eh.legal_entity_id ='23273'
 and  eh.INVENTORY_ITEM_ID= 71
 and el.JOURNAL_LINE_TYPE='INV' 
 and eh.organization_id=121
 and eh.TRANSACTION_TYPE_ID <> 0
 and eh.transaction_id=3950869
 --and eh.organization_id = <enter the organization_id>
--group by el.journal_line_type,eh.INVENTORY_ITEM_ID,eh.organization_id;



-- GMF SUM
select el.journal_line_type,GET_ORG_CODE_FROM_ID(eh.organization_id) ,
eh.INVENTORY_ITEM_ID,XXGET_ITEM_CODE(INVENTORY_ITEM_ID) ITEM_CODE,MY_PACKAGE.XXGET_ITEM_DESCRIPTION(INVENTORY_ITEM_ID),SUM(TRANSACTION_QUANTITY),sum(el.base_amount)from gmf_xla_extract_lines el,gmf_xla_extract_headers eh
where el.header_id = eh.header_id
 and eh.transaction_date >= to_date('01-JUL-2019 00:00:00','dd-mon-yyyy hh24:mi:ss') -- Change to first date of the current period
 and eh.transaction_date <= to_date('31-JUL-2019 23:59:59','dd-mon-yyyy hh24:mi:ss') -- Change to last date of the current period
 --and eh.ledger_id = LEDGER_ID
 and eh.legal_entity_id ='23273'
 and  eh.INVENTORY_ITEM_ID= 71
 and eh.organization_id=121
 --and eh.organization_id = <enter the organization_id>
group by el.journal_line_type,eh.INVENTORY_ITEM_ID,eh.organization_id;

select * from gmf_xla_extract_headers eh where  eh.transaction_id=3950869

select * 

select * from gmf_xla_extract_lines el  where  el.header_id=5284626 







--===================================================

select * from ORG_ORGANIZATION_DEFINITIONS where ORGANIZATION_CODE= 'KSA'
--inventory asset account  kongulo? 

-- 1. puro data excel a anar jonno script ta fahim vai dise draft accounting

SELECT INV_TRANS.ORGANIZATION_CODE,FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.ORGANIZATION_ID,INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,
INV_TRANS.EVENT_TYPE_CODE,INV_TRANS.TRANSACTION_TYPE_ID,
CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.EVENT_TYPE_CODE ELSE INV_TRANS.TRANSACTION_TYPE_NAME END TRANSACTION_TYPE_NAME,
INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,
0 OP_QTY, 0 OP_VAL,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (17,12,44,18,61,1002,1003) THEN INV_TRANS.TRANSACTION_QUANTITY ELSE 0 END) RCV_QTY,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (17,18,1002,1003) THEN INV_TRANS.TRANSACTION_VALUE 
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (44) THEN INV_TRANS.TRANSACTION_VALUE -----INV_TRANS.ACCOUNTED_DR 
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (61)  THEN INV_TRANS.ACCOUNTED_DR
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (12)  THEN INV_TRANS.ACCOUNTED_DR 
                  WHEN NVL(INV_TRANS.TRANSACTION_TYPE_ID,11111)=11111  AND EVENT_TYPE_CODE = 'GLCOSTALOC' THEN INV_TRANS.TRANSACTION_VALUE    
                  WHEN NVL(INV_TRANS.TRANSACTION_TYPE_ID,2222)=2222  AND EVENT_TYPE_CODE = 'LC_ADJUST_VALUATION' THEN INV_TRANS.TRANSACTION_VALUE  
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID=-99 THEN INV_TRANS.TRANSACTION_VALUE ELSE 0 END) RCV_VAL,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (32,35,36,42,43,15,21,63,101,103,104,107,111,120,10008,140,71,200,260,261,52) THEN INV_TRANS.TRANSACTION_QUANTITY 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,1) > 0 THEN 0 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,1) =  0 THEN 0 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_DR,0) >  0 THEN INV_TRANS.TRANSACTION_QUANTITY
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_CR,0) > 0 THEN INV_TRANS.TRANSACTION_QUANTITY
                  ELSE 0 END) ISSUE_QTY,
SUM(CASE WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (32,35,36,42,43,21,63,101,103,104,107,111,120,10008,140,71,200,260,261,52) THEN INV_TRANS.TRANSACTION_VALUE 
                 WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (15) THEN INV_TRANS.ACCOUNTED_DR   
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,0) > 0 THEN INV_TRANS.ACCOUNTED_DR
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (33) AND NVL(INV_TRANS.ACCOUNTED_DR,0) =  0 THEN INV_TRANS.TRANSACTION_VALUE 
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_DR,0) >  0 THEN INV_TRANS.TRANSACTION_VALUE
                  WHEN INV_TRANS.TRANSACTION_TYPE_ID IN (62) AND NVL(INV_TRANS.ACCOUNTED_CR,0) > 0 THEN INV_TRANS.TRANSACTION_VALUE
                  ELSE 0 END) ISSUE_VAL,
SUM(nvl(INV_TRANS.TRANSACTION_QUANTITY,0)) TRANS_QTY, 
SUM(nvl(INV_TRANS.TRANSACTION_VALUE,0)) TRANS_VAL,
INV_TRANS.je_category_name,INV_TRANS.accounting_class_code,
SUM(INV_TRANS.ACCOUNTED_DR) DR,SUM(INV_TRANS.ACCOUNTED_CR) CR ,INV_TRANS.ACCOUNTING_CODE
FROM
(SELECT to_char(transaction_date,'MON-YY') PERIOD_CODE,C.ORGANIZATION_CODE,A.ORGANIZATION_ID,A.INVENTORY_ITEM_ID,B.SEGMENT1||'|'||B.SEGMENT2||'|'||B.SEGMENT3||'|'||B.SEGMENT4 ITEM_CODE,a.transaction_id,a.event_class_code,a.event_type_code,
g.transaction_type_id,g.transaction_type_name,
d.je_category_name,e.accounting_class_code,d.ae_header_id,XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (e.CODE_COMBINATION_ID) ACCOUNT_NAME,XX_AP_PKG.GET_SUB_ACCOUNT_DESC_FROM_CCID(TO_NUMBER(e.CODE_COMBINATION_ID)) SUB_ACCOUNT,
TRANSACTION_QUANTITY,TRANSACTION_VALUE,e.accounted_dr,e.accounted_cr,f.concatenated_segments accounting_code
FROM GMF_XLA_EXTRACT_HEADERS a,mtl_system_items_b b,org_organization_definitions c,xla_ae_headers d,xla_ae_lines e,gl_code_combinations_kfv f,mtl_transaction_types g
WHERE a.inventory_item_id=b.inventory_item_id(+) and a.organization_id=b.organization_id(+) and A.organization_id=c.organization_id  and a.transaction_type_id=g.transaction_type_id(+)
and a.event_id=d.event_id and d.ae_header_id=e.ae_header_id and e.code_combination_id=f.code_combination_id
and to_char(transaction_date,'MON-YY')=:P_PERIOD_CODE and a.ledger_id=:P_LEDGER_ID) INV_TRANS 
LEFT OUTER JOIN  (SELECT  MIC.INVENTORY_ITEM_ID,MIC.ORGANIZATION_ID,MC.SEGMENT1 MEJOR_FIN_CAT,MC.SEGMENT1||'|'||MC.SEGMENT2 FIN_CAT 
                                        FROM MTL_ITEM_CATEGORIES MIC,MTL_CATEGORIES MC WHERE  MIC.CATEGORY_ID=MC.CATEGORY_ID  AND STRUCTURE_ID=50408) FIN_CAT 
                                      ON FIN_CAT.INVENTORY_ITEM_ID=INV_TRANS.INVENTORY_ITEM_ID AND  FIN_CAT.ORGANIZATION_ID=INV_TRANS.ORGANIZATION_ID
GROUP BY FIN_CAT.MEJOR_FIN_CAT,FIN_CAT.FIN_CAT,INV_TRANS.ORGANIZATION_CODE,INV_TRANS.ORGANIZATION_ID,INV_TRANS.INVENTORY_ITEM_ID,INV_TRANS.ITEM_CODE,INV_TRANS.EVENT_TYPE_CODE,
INV_TRANS.TRANSACTION_TYPE_NAME,INV_TRANS.ACCOUNT_NAME,INV_TRANS.SUB_ACCOUNT,INV_TRANS.ACCOUNTING_CODE,INV_TRANS.TRANSACTION_TYPE_ID,INV_TRANS.je_category_name,INV_TRANS.accounting_class_code

--- 2. sekhan theke arefin vai accounting class code filter kore wrong data gulo ber kore ekti sheet dise 


select * from gmf_xla_extract_headers

   select TRANSACTION_ID, EVENT_ID from  gmf_xla_extract_headers gxh where TRANSACTION_DATE between  

-- 3. sekhan theke transaction id reaz vai ber kore data dise ei query ta use kore: 
SELECT transaction_id, 
MTRL.TO_ACCOUNT_ID,
(SELECT XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=MTRL.TO_ACCOUNT_ID)||'-'||
(SELECT SEGMENT4 FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=MTRL.TO_ACCOUNT_ID) ACCOUNT,
XX_GET_EMP_NAME_FROM_USER_ID (Mtrl.CREATED_BY) CREATED_BY,
--GET_DEPT_NAME_FROM_EMP_ID(Mtrl.CREATED_BY) DEPT,
XX_INV_PKG.XXGET_EMP_DEPT(MTRL.CREATED_BY) DEPARTMENT,
--GET_DEPARTMENT_FRM_USERKG('KG-4079') DEPARTMENT,
--XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) ACCOUNT_DESC,
(SELECT DISTINCT OPERATING_UNIT_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID) OU_NAME
,(SELECT DISTINCT OPERATING_UNIT_ADDRESS FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID) OU_ADD
,(SELECT DISTINCT INVENTORY_ORGANIZATION_NAME FROM WBI_INV_ORG_DETAIL WHERE INV_ORGANIZATION_ID=MTRL.ORGANIZATION_ID) ORG_NAME
,MTRL.DATE_REQUIRED MO_DATE
,MTRL.REQUEST_NUMBER MO_NO
---,MTRL.TRANSACTION_TYPE_NAME
,WXMD.ITEM_CODE ITEM_CODE
,WXMD.ITEM_DESC ITEM_DESC
,MTRL.QUANTITY MO_QTY
----,MTRL.QUANTITY_DELIVERED ISSUE_QTY
,ABS(MMT.TRANSACTION_QUANTITY) ISSUE_QTY
----,MMT.PRIMARY_QUANTITY
,MMT.SUBINVENTORY_CODE SUBINVENTORY
, MTRL.TO_ACCOUNT_ID
,(SELECT SEGMENT1|| '.' || SEGMENT2|| '.' || SEGMENT3|| '.' || SEGMENT4|| '.' || SEGMENT5|| '.' || SEGMENT6|| '.' || SEGMENT7|| '.' || SEGMENT8 FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=MTRL.TO_ACCOUNT_ID) ACCOUNT_COMBINATION
--,XX_INV_PKG.XXGET_ENAME (TO_CHAR (:P_USER)) USER_NAME
--,:P_FROM_DATE PFROM_DATE
--,:P_TO_DATE PTO_DATE
FROM
MTL_MATERIAL_TRANSACTIONS MMT,
MTL_TXN_REQUEST_LINES_V MTRL,
WBI_XXKBGITEM_MT_D WXMD
WHERE
MMT.TRANSACTION_SET_ID=MTRL.TRANSACTION_HEADER_ID
---AND MTRL.REQUEST_NUMBER LIKE 'MO%'---='MO-KSM-0002872'
---AND TRANSACTION_TYPE_NAME IN ('Returnable Item Issue','Sales Order Pick','Loan Given To External Company')
AND MTRL.TO_ACCOUNT_ID IS NOT NULL
------------------------------------------------------------------------------------------------
AND WXMD.ORGANIZATION_ID=MMT.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MMT.INVENTORY_ITEM_ID
AND WXMD.ORGANIZATION_ID=MTRL.ORGANIZATION_ID
AND WXMD.INVENTORY_ITEM_ID=MTRL.INVENTORY_ITEM_ID
------------------------------------------------------------------------------------------------
AND MTRL.ORGANIZATION_ID = NVL (:P_ORG, MTRL.ORGANIZATION_ID)
AND MTRL.REQUEST_NUMBER = NVL (:P_MO_NUMBER, MTRL.REQUEST_NUMBER)
AND transaction_id in (4238512,
4011035,
4194738,
4315438,
4047950,
3973716,
4197855,
4287659,
3990589,
4045751,
4193231,
4323904,
3958405,
4082794,
4083024,
4274205,
4084455,
4236470,
3972382,
3980706,
4201102,
4211802)

-- 4 . event id dhore query kore ami data disi  ebong ami sei ID dhore nicher query ta nisi ebong arefin vai ke disi:
select      XAH.AE_HEADER_ID,XAH.LEDGER_ID,GCC.SEGMENT1||'.'||
          GCC.SEGMENT2||'.'||
          GCC.SEGMENT3||'.'||
          GCC.SEGMENT4||'.'||
          GCC.SEGMENT5 ||'.'||
          GCC.SEGMENT6 ||'.'||
          GCC.SEGMENT7 CODE_COMBINATION, 
          (SELECT XX_GET_ACCT_FLEX_SEG_DESC(4,SEGMENT4) FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID)||'-'||
(SELECT SEGMENT4 FROM GL_CODE_COMBINATIONS WHERE CODE_COMBINATION_ID=XAL.CODE_COMBINATION_ID) ACCOUNT,
gxh.inventory_item_id,msib.segment1||'|'||msib.segment2||'|'||msib.segment3||'|'||msib.segment4 item_code, MSIB.DESCRIPTION,
       XAH.EVENT_ID,XAH.EVENT_TYPE_CODE,XAH.ACCOUNTING_DATE,XAH.JE_CATEGORY_NAME,XAH.GL_TRANSFER_DATE,
          XAL.AE_LINE_NUM,XAL.CODE_COMBINATION_ID,XAL.ACCOUNTING_CLASS_CODE,XAL.ENTERED_DR,XAL.ENTERED_CR,XAL.ACCOUNTED_DR,XAL.ACCOUNTED_CR
from  xla_ae_headers XAH, xla_ae_lines XAL,
    (SELECT gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       4,----- Position of segment  
                                       segment4 ---- Segment value  
                                      ) account_desc,gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       5,----- Position of segment  
                                       segment5 ---- Segment value  
                                      ) sub_account_desc,code_combination_id,segment1,segment2,segment3,segment4,segment5,segment6,segment7   
 FROM gl_code_combinations)  gcc,
 mtl_system_items_b msib,
 gmf_xla_extract_headers gxh
  where 1=1
  --and  EVENT_TYPE_CODE = 'GLCOSTALOC'  
  --and period_name = 'Jul-19' 
  --and XAH.ledger_id = 2021--and GL_TRANSFER_DATE between '01-JUL-2019' and '31-JUL-2019'
  and     xah.ae_header_id = xal.ae_header_id
    and xah.application_id = xal.application_id 
         and xal.code_combination_id = gcc.code_combination_id 
          and msib.inventory_item_id =gxh.inventory_item_id
          and msib.organization_id=gxh.organization_id(+)
                  and gxh.event_id=xah.event_id 
        and gxh.ledger_id=xah.ledger_id 
 and XAH.EVENT_ID IN(3471546,
3471660,
3472200,
3471967,
3471853,
3471659,
3471628,
3472180,
3471820,
3472101,
3472059,
3474651,
3474934,
3474673,
3474654,
3474523,
3471819,
3472277,
3472260,
3472117,
3471777,
3474868)
ORDER BY XAH.AE_HEADER_ID
--5 ebar reaz vai er sathe amar data match kore ki ki account vul hoise segulo update kor te hobe, tobe obossoi accounts dept ke inform korte hobe ebong tader kas theke dicision nite hove
-- 6 fahim vai ekta script dibe jeta die code gulo update korte hobe after accounts dept confirmation
  -- 7 Prothome a query kore dekhte hobe je ki update kobo tarpor update korbo: query ta holo:
  
  select A.HEADER_ID,A.REQUEST_NUMBER,A.TRANSACTION_TYPE_ID,A.ORGANIZATION_ID,A.DESCRIPTION,B.LINE_ID,B.LINE_NUMBER,B.INVENTORY_ITEM_ID,QUANTITY,QUANTITY_DELIVERED,TRANSACTION_HEADER_ID,
TXN_SOURCE_ID,TXN_SOURCE_LINE_ID,
B.TO_ACCOUNT_ID LINE_CCID,
XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (B.TO_ACCOUNT_ID) ACCOUNT_NAME
 from MTL_TXN_REQUEST_HEADERS A,MTL_TXN_REQUEST_LINES B
WHERE A.HEADER_ID=B.HEADER_ID AND B.TO_ACCOUNT_ID NOT IN (60525,56525,84526)
and   B.INVENTORY_ITEM_ID = 165
AND REQUEST_NUMBER IN ('MO-KSB-0023775',
'MO-KSB-0022570',
'MO-KSB-0023419',
'MO-KSB-0023924',
'MO-KSB-0022919',
'MO-KSB-0022272',
'MO-KSM-0068301',
'MO-KSM-0068927',
'MO-KSM-0064894',
'MO-KSM-0066446',
'MO-KSM-0068194',
'MO-KSM-0069242',
'MO-KSM-0064585',
'MO-KSM-0067695',
'MO-KSM-0067705',
'MO-KSM-0068828',
'MO-KSM-0067794',
'MO-KSM-0068565',
'MO-KSM-0064681',
'MO-KSM-0064782',
'MO-KSA-0033979',
'MO-KSA-0031019'
)
ORDER BY REQUEST_NUMBER

HYDRAULIC OIL, VG-46 (FUCHS)

select * from FL|F&LB|HOIL|000083



 --EKHANE UPDATE QUERY TA DISE FAHIM BHAI
--=======================================================================
--- PROTHOM A QUERY TA RUN KORBO THEN CONFIRM  HOE NICER UPDATE TA CHALABO
--=======================================================================

select * from gl_code_combinations where CODE_COMBINATION_ID  IN(60525,56525,84526)  ---84532   --- Fuel & Lubricants Expenses-Factory

101.01.1008.6010217.006.0000.000

60525,56525,84526

select XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (1011556)  from DUAL   

 --MEANING OF 
--ACC.DEP-PLANT & MACHINERY  = ACCUMULATE DEPRECIATION PLANT AND STATIONARY

select * from GL_CODE_COMBINATIONS_KFV where CODE_COMBINATION_ID = 1011556


 select A.HEADER_ID,A.REQUEST_NUMBER,A.TRANSACTION_TYPE_ID,A.ORGANIZATION_ID,A.DESCRIPTION,B.LINE_ID,B.LINE_NUMBER,B.INVENTORY_ITEM_ID,QUANTITY,QUANTITY_DELIVERED,TRANSACTION_HEADER_ID,
TXN_SOURCE_ID,TXN_SOURCE_LINE_ID,
B.TO_ACCOUNT_ID LINE_CCID,84532 new_ccid,
XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (B.TO_ACCOUNT_ID) ACCOUNT_NAME
 from MTL_TXN_REQUEST_HEADERS A,MTL_TXN_REQUEST_LINES B
WHERE A.HEADER_ID=B.HEADER_ID AND B.TO_ACCOUNT_ID NOT IN (60525,56525,84526)
AND REQUEST_NUMBER IN ('MO-KSM-0066499')


 ('MO-KSB-0023775',
'MO-KSB-0022570',
'MO-KSB-0023419',
'MO-KSB-0023924',
'MO-KSB-0022919',
'MO-KSB-0022272',
'MO-KSM-0068301',
'MO-KSM-0068927',
'MO-KSM-0064894',
'MO-KSM-0066446',
'MO-KSM-0068194',
'MO-KSM-0069242',
'MO-KSM-0064585',
'MO-KSM-0067695',
'MO-KSM-0067705',
'MO-KSM-0068828',
'MO-KSM-0067794',
'MO-KSM-0068565',
'MO-KSM-0064681',
'MO-KSM-0064782',
'MO-KSA-0033979',
'MO-KSA-0031019'
)
--AND B.TO_ACCOUNT_ID <> 84532
--and b.to_account_id=1027556
ORDER BY REQUEST_NUMBER
--==================================================================
--     UPDATE QUERY DISABLE KORE RAKHLAM
--==================================================================
--
--begin
for i in (
select A.HEADER_ID,A.REQUEST_NUMBER,A.TRANSACTION_TYPE_ID,A.ORGANIZATION_ID,A.DESCRIPTION,B.LINE_ID,B.LINE_NUMBER,B.INVENTORY_ITEM_ID,QUANTITY,QUANTITY_DELIVERED,TRANSACTION_HEADER_ID,
TXN_SOURCE_ID,TXN_SOURCE_LINE_ID,
B.TO_ACCOUNT_ID LINE_CCID,88525 new_ccid,
XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (B.TO_ACCOUNT_ID) ACCOUNT_NAME
 from MTL_TXN_REQUEST_HEADERS A,MTL_TXN_REQUEST_LINES B
WHERE A.HEADER_ID=B.HEADER_ID AND B.TO_ACCOUNT_ID NOT IN (60525,56525,84526)
AND REQUEST_NUMBER IN ('MO-KSB-0023775',
'MO-KSB-0022570',
'MO-KSB-0023419',
'MO-KSB-0023924',
'MO-KSB-0022919',
'MO-KSB-0022272',
'MO-KSM-0068301',
'MO-KSM-0068927',
'MO-KSM-0064894',
'MO-KSM-0066446',
'MO-KSM-0068194',
'MO-KSM-0069242',
'MO-KSM-0064585',
'MO-KSM-0067695',
'MO-KSM-0067705',
'MO-KSM-0068828',
'MO-KSM-0067794',
'MO-KSM-0068565',
'MO-KSM-0064681',
'MO-KSM-0064782',
'MO-KSA-0033979',
'MO-KSA-0031019'
)
AND B.TO_ACCOUNT_ID = 1027556
ORDER BY REQUEST_NUMBER)  loop
 update MTL_TXN_REQUEST_LINES set TO_ACCOUNT_ID = i.new_ccid where header_id=i.header_id and line_id=i.line_id and line_number=i.line_number;
 end loop;
 end;
 
--==============================================================
-- UPDATE CHALLANOR PORE AMRA ABAR PROCESS GULO CHALALAM BUT , DRAFT ACCOUNT 
--A KONO IMPACT PELAM NA, KARON PROTHOME SE SUDHU MTL_TXN_REQUEST_LINES TABLE A UPDATE KORSE, TAI ASE NI, 
-- PORE MTL_MATERIAL_TRANSACTIONS A O UPDATE KORTE HOISE. SEI QUERY TA :
--=================================================================

--begin
--for i in (select A.HEADER_ID,A.REQUEST_NUMBER,A.TRANSACTION_TYPE_ID,A.ORGANIZATION_ID,A.DESCRIPTION,B.LINE_ID,B.LINE_NUMBER,B.INVENTORY_ITEM_ID,QUANTITY,QUANTITY_DELIVERED,TRANSACTION_HEADER_ID,
--TXN_SOURCE_ID,TXN_SOURCE_LINE_ID,
--B.TO_ACCOUNT_ID LINE_CCID,
--XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (B.TO_ACCOUNT_ID) ACCOUNT_NAME
-- from MTL_TXN_REQUEST_HEADERS A,MTL_TXN_REQUEST_LINES B
--WHERE A.HEADER_ID=B.HEADER_ID AND B.TO_ACCOUNT_ID NOT IN (56525,84526)
--AND REQUEST_NUMBER IN ('MO-KSB-0023775',
--'MO-KSB-0022570',
--'MO-KSB-0023419',
--'MO-KSB-0023924',
--'MO-KSB-0022919',
--'MO-KSB-0022272',
--'MO-KSM-0068301',
--'MO-KSM-0068927',
--'MO-KSM-0064894',
--'MO-KSM-0066446',
--'MO-KSM-0068194',
--'MO-KSM-0069242',
--'MO-KSM-0064585',
--'MO-KSM-0067695',
--'MO-KSM-0067705',
--'MO-KSM-0068828',
--'MO-KSM-0067794',
--'MO-KSM-0068565',
--'MO-KSM-0064681',
--'MO-KSM-0064782',
--'MO-KSA-0033979',
--'MO-KSA-0031019'
--)
--ORDER BY REQUEST_NUMBER) loop
--
--update mtl_material_transactions
--set distribution_account_id=i.line_ccid
--where transaction_type_id=63
--and transaction_source_id=i.header_id
--and trx_source_line_id=i.line_id;
--
--end loop;
--end;






 
--================================================================





--=========DRAFT ACCOUNTING CHECK  SUMMARY  V2======

--FAHIM VAI UPDATE  GL COST ALOCATION  and XAH.EVENT_TYPE_CODE = 'GLCOSTALOC'   ei GLCOSTALOC ta age asto na ekhon ashe just ekta outer join diesen
--  and gxh.transaction_type_id=mtt.transaction_type_id(+)
--===============


SELECT UPPER(period_name) period_name, inventory_item_id,item_code,organization_code,sum(qty), GMF_CMCOMMON.GET_CMPT_COST(INVENTORY_ITEM_ID,ORGANIZATION_ID, TRUNC(TO_DATE(PERIOD_NAME,'MON-YY')),1000,0) COST,
   EVENT_CLASS_CODE,EVENT_TYPE_CODE,transaction_type_name,LEDGER_ID,ACCOUNTING_CLASS_CODE,COMPANY,OU,COST_CENTER,ACCOUNT,SUB_ACCOUNT,
    OU||'.'||COST_CENTER||'.'||ACCOUNT||'.'||SUB_ACCOUNT CODE_COMBINATION,account_desc,sub_account_desc,
   SUM(DR),SUM(CR),SUM(BALANCE) 
   FROM 
 ( SELECT xah.ledger_id,mp.organization_code,mp.organization_id,upper(xah.period_name) period_name,gxh.inventory_item_id,msib.segment1||'|'||msib.segment2||'|'||msib.segment3||'|'||msib.segment4 item_code,xah.ae_header_id,GXH.EVENT_CLASS_CODE,xah.event_type_code,mtt.transaction_type_name,
    xal.accounting_class_code,
    GCC.SEGMENT1 COMPANY,
          GCC.SEGMENT2 OU,
          GCC.SEGMENT3 COST_CENTER,
          GCC.SEGMENT4 ACCOUNT,
          GCC.SEGMENT5 SUB_ACCOUNT,
          GCC.SEGMENT6 PROJECT,
          GCC.SEGMENT7 INTER_COMPANY,
    xal.code_combination_id,
    gcc.account_desc,  
    gcc.sub_account_desc,
    SUM(gxh.transaction_quantity) qty,
    SUM(nvl(accounted_dr,0)) DR, SUM(nvl(accounted_cr,0)) CR,
    SUM(nvl(accounted_dr,0))- SUM(nvl(accounted_cr,0))balance
FROM
    xla_ae_headers             xah,
    xla_ae_lines               xal,
    (SELECT gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       4,----- Position of segment  
                                       segment4 ---- Segment value  
                                      ) account_desc,gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       5,----- Position of segment  
                                       segment5 ---- Segment value  
                                      ) sub_account_desc,code_combination_id,segment1,segment2,segment3,segment4,segment5,segment6,segment7   
 FROM gl_code_combinations)  gcc,
    gmf_xla_extract_headers gxh,
    mtl_transaction_types mtt,
    mtl_system_items_b msib,
    mtl_parameters  mp
WHERE
    xah.ae_header_id = xal.ae_header_id(+)  
    and xah.application_id = xal.application_id   (+)  
     and xal.code_combination_id = gcc.code_combination_id 
        and gxh.event_id=xah.event_id 
        and gxh.ledger_id=xah.ledger_id 
        and gxh.transaction_type_id=mtt.transaction_type_id(+)
        and msib.inventory_item_id =gxh.inventory_item_id(+) and msib.organization_id=gxh.organization_id(+)
        and mp.organization_id=gxh.organization_id
        and mp.organization_id=NVL(:P_ORGANIZATION_ID,MP.ORGANIZATION_ID)
        and msib.inventory_item_id= 86
        and xah.ledger_id = 2021
      --and xah.ledger_id = 2021
     and UPPER(xah.period_name) =UPPER(:P_PERIOD)-- 'Sep-18'
   -- and XAH.EVENT_TYPE_CODE = 'GLCOSTALOC'  
    group by   gxh.inventory_item_id,GXH.EVENT_CLASS_CODE,xah.ae_header_id,xah.event_type_code,mp.organization_id,
    xal.accounting_class_code,mtt.transaction_type_name,xah.LEDGER_ID,mp.organization_code,xah.period_name,
 GCC.SEGMENT1,
          GCC.SEGMENT2,
          GCC.SEGMENT3,
          GCC.SEGMENT4,
          GCC.SEGMENT5,
          GCC.SEGMENT6,
          GCC.SEGMENT7,
          GCC.ACCOUNT_DESC,  
          GCC.SUB_ACCOUNT_DESC,
    xal.code_combination_id,msib.segment1,msib.segment2,msib.segment3,msib.segment4
order by xah.ae_header_id)
-----WHERE EVENT_TYPE_CODE='FOB_SHIP_RECIPIENT_SHIP_TP' ---AND ORGANIZATION_CODE='KWN'
GROUP BY LEDGER_ID,period_name,EVENT_CLASS_CODE,event_type_code,inventory_item_id,item_code,organization_id,organization_code,account_desc,sub_account_desc,EVENT_TYPE_CODE,ACCOUNTING_CLASS_CODE,ACCOUNT_DESC,COMPANY,OU,COST_CENTER,ACCOUNT,
SUB_ACCOUNT,transaction_type_name, UPPER(period_name)
order by company,inventory_item_id


--=========================

-- FIND OUT PROBLEMATIC DATA AFTER FINDING eventing event_ID

GMF_XLA table theke all data dulo ber kore 

XLA_XTRACT_HEADERS  





 
 

select * from  xla_ae_lines


    xah.ae_header_id = xal.ae_header_id
    and xah.application_id = xal.application_id 

SELECT gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       4,----- Position of segment  
                                       segment4 ---- Segment value  
                                      ) account_desc,gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       5,----- Position of segment  
                                       segment5 ---- Segment value  
                                      ) sub_account_desc,code_combination_id,segment1,segment2,segment3,segment4,segment5,segment6,segment7   
 FROM gl_code_combinations


----------  DRAFT ACCOUNTING CHECK  SUMMARY  V1-----------------------------------------------

 SELECT UPPER(period_name) period_name, inventory_item_id,item_code,organization_code,sum(qty), GMF_CMCOMMON.GET_CMPT_COST(INVENTORY_ITEM_ID,ORGANIZATION_ID, TRUNC(TO_DATE(PERIOD_NAME,'MON-YY')),1000,0) COST,
   EVENT_CLASS_CODE,EVENT_TYPE_CODE,transaction_type_name,LEDGER_ID,ACCOUNTING_CLASS_CODE,COMPANY,OU,COST_CENTER,ACCOUNT,SUB_ACCOUNT,
    OU||'.'||COST_CENTER||'.'||ACCOUNT||'.'||SUB_ACCOUNT CODE_COMBINATION,account_desc,sub_account_desc,
   SUM(DR),SUM(CR),SUM(BALANCE) 
   FROM 
 ( SELECT xah.ledger_id,mp.organization_code,mp.organization_id,upper(xah.period_name) period_name,gxh.inventory_item_id,msib.segment1||'|'||msib.segment2||'|'||msib.segment3||'|'||msib.segment4 item_code,xah.ae_header_id,GXH.EVENT_CLASS_CODE,xah.event_type_code,mtt.transaction_type_name,
    xal.accounting_class_code,
    GCC.SEGMENT1 COMPANY,
          GCC.SEGMENT2 OU,
          GCC.SEGMENT3 COST_CENTER,
          GCC.SEGMENT4 ACCOUNT,
          GCC.SEGMENT5 SUB_ACCOUNT,
          GCC.SEGMENT6 PROJECT,
          GCC.SEGMENT7 INTER_COMPANY,
    xal.code_combination_id,
    gcc.account_desc,  
    gcc.sub_account_desc,
    SUM(gxh.transaction_quantity) qty,
    SUM(nvl(accounted_dr,0)) DR, SUM(nvl(accounted_cr,0)) CR,
    SUM(nvl(accounted_dr,0))- SUM(nvl(accounted_cr,0))balance
FROM
    xla_ae_headers             xah,
    xla_ae_lines               xal,
    (SELECT gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       4,----- Position of segment  
                                       segment4 ---- Segment value  
                                      ) account_desc,gl_flexfields_pkg.get_description_sql  
                                      (101,--- chart of account id  
                                       5,----- Position of segment  
                                       segment5 ---- Segment value  
                                      ) sub_account_desc,code_combination_id,segment1,segment2,segment3,segment4,segment5,segment6,segment7   
 FROM gl_code_combinations)  gcc,
    gmf_xla_extract_headers gxh,
    mtl_transaction_types mtt,
    mtl_system_items_b msib,
    mtl_parameters  mp
WHERE
    xah.ae_header_id = xal.ae_header_id(+)  
    and xah.application_id = xal.application_id   (+)  
     and xal.code_combination_id = gcc.code_combination_id 
        and gxh.event_id=xah.event_id 
        and gxh.ledger_id=xah.ledger_id 
        and gxh.transaction_type_id(+)=mtt.transaction_type_id 
        and msib.inventory_item_id =gxh.inventory_item_id(+) and msib.organization_id=gxh.organization_id(+)
        and mp.organization_id=gxh.organization_id
        and mp.organization_id=NVL(:P_ORGANIZATION_ID,MP.ORGANIZATION_ID)
      --  and xah.ledger_id = 2021
      --and xah.ledger_id = 2021
     and UPPER(xah.period_name) =UPPER(:P_PERIOD)-- 'Sep-18'
    -- and XAH.EVENT_TYPE_CODE = 'GLCOSTALOC'  
    --=====================================================================================  
    WHERE
    xah.ae_header_id = xal.ae_header_id(+)  
    and xah.application_id = xal.application_id   (+)  
     and xal.code_combination_id = gcc.code_combination_id 
        and gxh.event_id=xah.event_id 
        and gxh.ledger_id=xah.ledger_id 
        and gxh.transaction_type_id=mtt.transaction_type_id(+)
        and msib.inventory_item_id =gxh.inventory_item_id(+) and msib.organization_id=gxh.organization_id(+)
        and mp.organization_id=gxh.organization_id
        and mp.organization_id=NVL(:P_ORGANIZATION_ID,MP.ORGANIZATION_ID)
        and xah.ledger_id = 2021
      --and xah.ledger_id = 2021
     and UPPER(xah.period_name) =UPPER(:P_PERIOD)-- 'Sep-18'
   -- and XAH.EVENT_TYPE_CODE = 'GLCOSTALOC'  
    group by   gxh.inventory_item_id,GXH.EVENT_CLASS_CODE,xah.ae_header_id,xah.event_type_code,mp.organization_id,
    xal.accounting_class_code,mtt.transaction_type_name,xah.LEDGER_ID,mp.organization_code,xah.period_name,
 GCC.SEGMENT1,
          GCC.SEGMENT2,
          GCC.SEGMENT3,
          GCC.SEGMENT4,
          GCC.SEGMENT5,
          GCC.SEGMENT6,
          GCC.SEGMENT7,
          GCC.ACCOUNT_DESC,  
          GCC.SUB_ACCOUNT_DESC,
    xal.code_combination_id,msib.segment1,msib.segment2,msib.segment3,msib.segment4
order by xah.ae_header_id)
-----WHERE EVENT_TYPE_CODE='FOB_SHIP_RECIPIENT_SHIP_TP' ---AND ORGANIZATION_CODE='KWN'
GROUP BY LEDGER_ID,period_name,EVENT_CLASS_CODE,event_type_code,inventory_item_id,item_code,organization_id,organization_code,account_desc,sub_account_desc,EVENT_TYPE_CODE,ACCOUNTING_CLASS_CODE,ACCOUNT_DESC,COMPANY,OU,COST_CENTER,ACCOUNT,
SUB_ACCOUNT,transaction_type_name, UPPER(period_name)
order by company,inventory_item_id

--====================================

select A.HEADER_ID,A.REQUEST_NUMBER,A.TRANSACTION_TYPE_ID,A.ORGANIZATION_ID,A.DESCRIPTION,B.LINE_ID,B.LINE_NUMBER,B.INVENTORY_ITEM_ID,QUANTITY,QUANTITY_DELIVERED,TRANSACTION_HEADER_ID,
TXN_SOURCE_ID,TXN_SOURCE_LINE_ID,
B.TO_ACCOUNT_ID LINE_CCID,
XX_AP_PKG.GET_ACCOUNT_DESC_FROM_CCID (B.TO_ACCOUNT_ID) ACCOUNT_NAME
from MTL_TXN_REQUEST_HEADERS A,MTL_TXN_REQUEST_LINES B
WHERE A.HEADER_ID=B.HEADER_ID AND B.TO_ACCOUNT_ID NOT IN (60525,56525,84526)
AND REQUEST_NUMBER IN ('MO-KSB-0023775',
'MO-KSB-0022570',
'MO-KSB-0023419',
'MO-KSB-0023924',
'MO-KSB-0022919',
'MO-KSB-0022272',
'MO-KSM-0068301',
'MO-KSM-0068927',
'MO-KSM-0064894',
'MO-KSM-0066446',
'MO-KSM-0068194',
'MO-KSM-0069242',
'MO-KSM-0064585',
'MO-KSM-0067695',
'MO-KSM-0067705',
'MO-KSM-0068828',
'MO-KSM-0067794',
'MO-KSM-0068565',
'MO-KSM-0064681',
'MO-KSM-0064782',
'MO-KSA-0033979',
'MO-KSA-0031019'
)
ORDER BY REQUEST_NUMBER



