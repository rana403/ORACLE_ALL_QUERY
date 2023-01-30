
SELECT * FROM ORG_ORGANIZATION_DEFINITIONS

--=====================================================
-- TO GET INVENTORY PERIOD STATUS
--=====================================================

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
FROM org_acct_periods oap ,
  org_organization_definitions ood
WHERE oap.organization_id = ood.organization_id
--AND (TRUNC(SYSDATE) -- Comment line if a a date other than SYSDATE is being tested.
--  --AND ('01-DEC-2014' -- Uncomment line if a date other than SYSDATE is being tested.
--  BETWEEN TRUNC(oap.period_start_date) AND TRUNC (oap.schedule_close_date))
  and oap.period_name  = 'Sep-18'
 -- and OOD.OPERATING_UNIT= 81
  AND ood.legal_entity = 26280   
--  and    OOD.OPERATING_UNIT IN( 101,102,103)
ORDER BY ood.organization_id, 
  oap.period_start_date
-- If Period Status is 'Y' and Closed Date is not NULL then the closing of the INV period failed.



--===================================================================
-- TO GET ALL PERIOD STATUS
--===================================================================
SELECT ROWID,
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
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ( 'AP', 'AR', 'PO', 'GL')
and period_name like '%Sep%18%'
and  PERIOD_NAME NOT LIKE '%Adj%' 
and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) = '102-KSRM Steel Plant Ltd'
ORDER BY period_year DESC,
  period_num DESC
