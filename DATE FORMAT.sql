 period just change the sysdate - 7 criteria to a larger duration for example for the past 30 days it would be: "and transaction_date >= sysdate - 30")
 
 
 select interface_transaction_id, processing_status_code, processing_mode_code, transaction_status_code, transaction_type,
      transaction_date
      from rcv_transactions_interface
      where (processing_status_code = 'ERROR' or transaction_status_code = 'ERROR') and transaction_date >= sysdate - 1



--7 DAYS BEFORE SUSDATE OR 30 DAYS BEFORE SYSDATE
 select interface_transaction_id, processing_status_code, processing_mode_code, transaction_status_code, transaction_type,
      transaction_date
      from rcv_transactions_interface
      where (processing_status_code = 'ERROR' or transaction_status_code = 'ERROR') and transaction_date >= sysdate - 7
      
      OR
      
       select interface_transaction_id, processing_status_code, processing_mode_code, transaction_status_code, transaction_type,
      transaction_date
      from rcv_transactions_interface
      where (processing_status_code = 'ERROR' or transaction_status_code = 'ERROR') and transaction_date >= sysdate - 30





--=============DATE FORMATS ALL ==============

AND TO_CHAR(TRANSACTION_DATE,'MM-YYYY')='02-2021'

AND TO_CHAR(TRANSACTION_DATE,'MON-YY')='FEB-21' 

AND  TRUNC(TRANSACTION_DATE)  BETWEEN '01-JAN-2021' AND '28-JAN-2021'   -- 2,353

TO_CHAR(TRUNC(I.CHECK_DATE)) "PAYMENT DATE"  

TO_CHAR(WIRTF.CHALLAN_DATE,'DD-MON-RRRR HH12:MI:SS PM') 

TO_CHAR(TRUNC(PRL.NEED_BY_DATE),'DD-MON-RRRR') NEED_BY_DATE

TO_CHAR(TO_DATE(WIRTF.CHALLAN_DATE,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') CHALLAN_DATE

TRUNC(TO_DATE(TO_DATE(WDD.ATTRIBUTE14,'YYYY-MM-DD HH24:MI:SS'))) OD_DATE,

DATE FORMATE -- TO GET ACTUAL DATA 
=================

FROM DATE: '01-DEC-2018 00:00:01'
TO DATE: '01-DEC-2018 23:59:59'


select * from gme_batch_header
where trunc (ACTUAL_START_DATE) = '14-OCT2019'

select * from HR_OPERATING_UNITS

--======================GET DATE AS PARAMETER ==============================
Date- <?FROM_DATE?> to - <?TO_DATE?>

--================= Another Date Function to show in report Header======================

SELECT (' From '||TO_CHAR(TO_DATE(:P_FROM_OD_DT,'DD-MON-RRRR'),'DD-MON-RRRR')||' To '||TO_CHAR(TO_DATE(:P_TO_OD_DT,'DD-MON-RRRR'),'DD-MON-RRRR')) OD_DT
FROM DUAL;

--======================================
-- DATE AS PERIOD
--======================================
 to_char(transaction_date,'MON-YY') PERIOD_CODE
  
 TO_CHAR(CREATION_DATE,'MON-YY') = 'JUL-19'
 
 --=====================================
 -- GET PERIOD INFO
 --=====================================
 
 Select * from org_acct_periods
WHERE organization_id = 246 --:organization_id
AND acct_period_id = 7001 --:period_id
and PERIOD_NUM= 2

select * from gmf_period_balances where organization_id= 121

--==============================
--GET FIRST DATE OF THE MONTH
--=============================

SELECT TRUNC(SYSDATE, 'MM') FROM DUAL

SELECT trunc(sysdate) - (to_number(to_char(sysdate,'DD')) - 1) FROM dual

--==============================
--GET LAST DATE OF THE MONTH
--=============================

SELECT add_months(trunc(sysdate) - (to_number(to_char(sysdate,'DD')) - 1), 1) -1 FROM dual


SELECT TRUNC(:TRANSACTION_DATE, 'MONTH') FROM MTL_MATERIAL_TRANSACTIONS

SELECT * FROM MTL_MATERIAL_TRANSACTIONS

SELECT ABS(NVL(SUM(NVL(PRIMARY_QUANTITY,0)),0)) -- INTO V_QTY 
FROM MTL_MATERIAL_TRANSACTIONS
WHERE 1=1
and TRUNC(TRANSACTION_DATE)  BETWEEN (TRUNC(:P_PR_APP_DT )) AND TRUNC(:P_PR_APP_DT)
AND INVENTORY_ITEM_ID=:P_ITEM
--AND ORGANIZATION_ID=P_ORG
--AND TRANSACTION_SOURCE_ID IS NOT NULL
--AND PRIMARY_QUANTITY<0