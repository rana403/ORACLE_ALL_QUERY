--BEFORE OPENING PERIOD MONTHLY:
--======================
1. Collect Currency COnversion rate from Accounts dept (Showkot)
2. Update Inter Company Price List by Iftekhar Vai consulting with relevent person
3. Open All Perion (PO, AP, AR, GL,INV)
4. Open Cost Calender from OPM Financial--> setup-->cost Calender-->select the period-->  assign-0-> OPen


VPN ID PASSWORD KSRM
===================
ID: SOHEL
Password: sohel#007



Anydesk Connection
========================
Office Anydesk ID: 772 073 574
Office Anydesk Pass: sohel@321

1. Open Inventory ORG: Query
2. Open Purchasing Org
3. OPen Payable 
4. Open Receiveable 
5. Open GL Period
6. Conversion Rate Add 


1. Open Inventory ORG: Query
=============================

--================================================
-- TO OPEN INVENTORY PERIOD STATUS (Previous open period all org will be open for present month)
-- --RUN THE QUERY TWO TIME ONE FOR  Previous month AUG-22 AND NEXT FOR  Present Month SEP-22 IF HAVE ANY MISSING THEN TAKE OUTPUT IN EXCEL AND FOIND OUT THROUGH VLOOKUP
--================================================

SELECT * FROM ORG_ORGANIZATION_DEFINITIONS where OPERATING_UNIT = 462

SELECT * FROM HR_OPERATING_UNITS


SELECT  OOD.OPERATING_UNIT "OPERATING_UNIT",
ood.organization_id "Organization ID" ,
  ood.organization_code "Organization Code" ,
  ood.organization_name "Organization Name" ,
  oap.period_name "Period Name" ,
  oap.period_start_date "Start Date" ,
  oap.period_close_date "Closed Date" ,
  oap.schedule_close_date "Scheduled Close" ,
  DECODE(oap.open_flag, 'P','P - Period Close is processing' ,
                        'N','Close' ,
                        'Y','open ' ,'Unknown') "Period Status"
FROM org_acct_periods oap,
  org_organization_definitions ood
WHERE oap.organization_id = ood.organization_id
--AND (TRUNC(SYSDATE) -- Comment line if a a date other than SYSDATE is being tested.
--  --AND ('01-DEC-2014' -- Uncomment line if a date other than SYSDATE is being tested.
--  BETWEEN TRUNC(oap.period_start_date) AND TRUNC (oap.schedule_close_date))
  and oap.period_name  = 'Jan-23'
 -- AND ood.organization_code='BLO'
  --and OOD.OPERATING_UNIT IN(81,361,382) -- KSPL
  --  and OOD.OPERATING_UNIT IN(104) -- KBIL
    --and OOD.OPERATING_UNIT IN(102) --
-- and    OOD.OPERATING_UNIT IN( 101,102,103) -- KSRM
ORDER BY ood.organization_id, 
  oap.period_start_date
-- If Period Status is 'Y' and Closed Date is not NULL then the closing of the INV period failed.

2. Open Purchasing Org
=======================
--======================================
-- Open Purchasing Period
--CHECK OPEN PURCHASING PERIOD STATUS
--========================================

SELECT * FROM HR_OPERATING_UNITS ORDER BY NAME 

SELECT ROWID,
 (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) LE,
  (SELECT PRODUCT_CODE
  FROM fnd_application fa
  WHERE fa.application_id = gps.application_id
  ) application,
  (SELECT name
  FROM gl_sets_of_books gsp
  where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID
  ) SETOFBOOK,
  period_name,
  closing_status,
  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) status,
  period_num,
  period_year,
  start_date,
  end_date
from GL_PERIOD_STATUSES GPS
WHERE 1=1
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ('PO')
and period_name like '%Jan%23%'  
and  PERIOD_NAME NOT LIKE '%Adj%' 
 AND  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) = 'Open'
--and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID) = '202-Khawaja Ship Breaking Limi'
ORDER BY  (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID )

3. OPen Payable 
======================================

--======================================
--OPEN AP  PERIOD 
-- Check with Previous and Present month 
--========================================

SELECT * FROM HR_OPERATING_UNITS ORDER BY NAME 

SELECT ROWID,
 (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) LE,
  (SELECT PRODUCT_CODE
  FROM fnd_application fa
  WHERE fa.application_id = gps.application_id
  ) application,
  (SELECT name
  FROM gl_sets_of_books gsp
  where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID
  ) SETOFBOOK,
  period_name,
  closing_status,
  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) status,
  period_num,
  period_year,
  start_date,
  end_date
from GL_PERIOD_STATUSES GPS
WHERE 1=1
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ('AP')
and period_name like '%Dec%22%'  
and  PERIOD_NAME NOT LIKE '%Adj%' 
 AND  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) = 'Open'
--and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID) = '202-Khawaja Ship Breaking Limi'
ORDER BY  (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID )



4. Open Receiveable 
--======================================
--OPEN AR PERIOD 
--Check with Previous and Present month 
--========================================

SELECT * FROM HR_OPERATING_UNITS ORDER BY NAME 

SELECT ROWID,
 (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) LE,
  (SELECT PRODUCT_CODE
  FROM fnd_application fa
  WHERE fa.application_id = gps.application_id
  ) application,
  (SELECT name
  FROM gl_sets_of_books gsp
  where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID
  ) SETOFBOOK,
  period_name,
  closing_status,
  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) status,
  period_num,
  period_year,
  start_date,
  end_date
from GL_PERIOD_STATUSES GPS
WHERE 1=1
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ('AR')
and period_name like '%Dec%22%'  
and  PERIOD_NAME NOT LIKE '%Adj%' 
 AND  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) = 'Open'
--and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID) = '202-Khawaja Ship Breaking Limi'
ORDER BY  (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID )


5. Open GL Period
=============================

--======================================
--OPEN GL  PERIOD 
-- Check GL with Previous and present period, if missing then take 2 month in excel and run VLOOKUP for getting missing
--========================================

SELECT * FROM HR_OPERATING_UNITS ORDER BY NAME 

SELECT ROWID,
 (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) LE,
  (SELECT PRODUCT_CODE
  FROM fnd_application fa
  WHERE fa.application_id = gps.application_id
  ) application,
  (SELECT name
  FROM gl_sets_of_books gsp
  where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID
  ) SETOFBOOK,
  period_name,
  closing_status,
  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) status,
  period_num,
  period_year,
  start_date,
  end_date
from GL_PERIOD_STATUSES GPS
WHERE 1=1
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ('GL')
and period_name like '%Dec%22%'  
and  PERIOD_NAME NOT LIKE '%Adj%' 
 AND  DECODE (gps.closing_status, 'O', 'Open', 'C', 'Closed', 'F', 'Future', 'N', 'Never' ) = 'Open'
--and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID) = '202-Khawaja Ship Breaking Limi'
ORDER BY  (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID )

6. Conversion Rate Add 
===========================


