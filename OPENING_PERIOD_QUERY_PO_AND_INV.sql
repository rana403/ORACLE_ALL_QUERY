--===================================================================
-- TO SEE  PO PERIOD STATUS 
--===================================================================

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
and   (SELECT PRODUCT_CODE  FROM fnd_application fa WHERE fa.application_id = gps.application_id) IN ( 'AP', 'AR', 'PO', 'GL')
and period_name like '%Jun%22%' 
and  PERIOD_NAME NOT LIKE '%Adj%' 
AND   (SELECT PRODUCT_CODE FROM fnd_application fa WHERE fa.application_id = gps.application_id )='PO'
--and   (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID) = '101-KSRM Steel Plant Ltd.'
AND  (SELECT name FROM gl_sets_of_books gsp where GSP.SET_OF_BOOKS_ID = GPS.SET_OF_BOOKS_ID ) IN (
'102-KSRM Steel Plant Ltd',
'101-KSRM Steel Plant Ltd.',
'103-KSRM Steel Plant Ltd',
'104-Khawja Ajmeer Steel Indust',
'105-Kabir Oxygen Ltd.',
'106-KSRM Power Plant Limited',
'201-Kabir Steel Limited',
'202-Khawaja Ship Breaking Limi',
'203-Kabir Ship Breaking Limite'
)
ORDER BY period_year DESC, 
period_num DESC  


--===========================================
-- TO SEE INVENTORY PERIOD 
--==========================================

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
  and oap.period_name  = 'Jun-22'
  AND OOD.ORGANIZATION_ID IN (  --- NEED TO OPEN THESE PERIOD IN EVERY MONTH
  121,
141,
142,
143,
144,
145,
146,
147,
148,
149,
150,
151,
152,
153,
154,
155,
156,
157,
158,
159,
160,
161,
162,
163,
164,
165,
166,
167,
168,
169,
170,
171,
173,
174,
175,
176,
177,
178,
179,
180,
181,
201,
202,
221,
222,
223,
224,
241,
242,
243,
244,
245,
246,
261,
281,
301,
321,
341,
342,
381,
383,
402
  )
  --and OOD.OPERATING_UNIT IN(81,361,382) -- KSPL
  --  and OOD.OPERATING_UNIT IN(104) -- KBIL
  --and    OOD.OPERATING_UNIT IN( 101,102,103) -- KSRM
ORDER BY ood.organization_id, 
  oap.period_start_date
-- If Period Status is 'Y' and Closed Date is not NULL then the closing of the INV period failed.