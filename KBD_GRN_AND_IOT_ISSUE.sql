



--GRN ISSUE

--=========================================
-- RCV TRANS DATE IS NOT SAME AS MMT TRANS DATE QUERY
--=========================================

SELECT B.ORGANIZATION_ID, B.INVENTORY_ITEM_ID,XXGET_ITEM_DESCRIPTION(B.INVENTORY_ITEM_ID,B.ORGANIZATION_ID ) INVENTORY_ITEM_NAME, A.SHIPMENT_HEADER_ID,A.TRANSACTION_TYPE, A.TRANSACTION_ID,B.RCV_TRANSACTION_ID,  TO_CHAR(A.transaction_DATE,'DD-MON-RR') RCV_transaction_DATE,
TO_CHAR(B.transaction_DATE,'DD-MON-RR') MMT_transaction_DATE,
 A.TRANSACTION_DATE, B.TRANSACTION_DATE   FROM RCV_TRANSACTIONS A, mtl_material_transactions B, ORG_ORGANIZATION_DEFINITIONS C 
WHERE A.TRANSACTION_ID = B.RCV_TRANSACTION_ID
AND B.ORGANIZATION_ID = C.ORGANIZATION_ID
AND B.ORGANIZATION_ID= 166
and B.TRANSACTION_DATE <  (TRUNC(A.TRANSACTION_DATE)-25)
--and A.TRANSACTION_DATE <  (TRUNC(B.TRANSACTION_DATE)-1) 
--AND A.TRANSACTION_DATE BETWEEN '01-SEP-2018' and '30-SEP-2018'
AND A.TRANSACTION_DATE BETWEEN '01-SEP-2018' and '30-SEP-2018'
--AND A.TRANSACTION_DATE BETWEEN '01-NOV-2018' and '30-NOV-2018'
--AND A.TRANSACTION_DATE BETWEEN '01-DEC-2018' and '30-DEC-2018'
--and A.TRANSACTION_DATE    LIKE '%AUG-18%'  
--and B.TRANSACTION_DATE   NOT  LIKE '%AUG-18%'  
--AND B.RCV_TRANSACTION_ID IN (
--320481,
--320861,
--329284
--)





UPDATE RCV_TRANSACTIONS -- NOV 20
SET TRANSACTION_DATE =  TO_DATE('11/11/2018 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE TRANSACTION_ID IN (
307944
)


UPDATE MTL_MATERIAL_TRANSACTIONS -- NOV 20
SET TRANSACTION_DATE =  TO_DATE('11/23/2020 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE RCV_TRANSACTION_ID IN (
880635
)



UPDATE MTL_MATERIAL_TRANSACTIONS -- JUN 20
SET TRANSACTION_DATE =  TO_DATE('6/23/2020 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE RCV_TRANSACTION_ID IN (
804868
)



UPDATE MTL_MATERIAL_TRANSACTIONS -- NOV 19
SET TRANSACTION_DATE =  TO_DATE('11/25/2019 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE RCV_TRANSACTION_ID IN (
705335,
709782,
709785,
709789,
709779,
709783,
709787
)


UPDATE MTL_MATERIAL_TRANSACTIONS -- MAR 19
SET TRANSACTION_DATE =  TO_DATE('3/25/2019 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE RCV_TRANSACTION_ID IN (
642867)

UPDATE MTL_MATERIAL_TRANSACTIONS -- SEP 18
SET TRANSACTION_DATE =  TO_DATE('9/25/2018 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE RCV_TRANSACTION_ID IN (
318741)





UPDATE MTL_MATERIAL_TRANSACTIONS 
SET TRANSACTION_DATE =  TO_DATE('10/25/2018 01:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE RCV_TRANSACTION_ID IN (
320484,
320865,
320867,
320863,
323104,
323116,
323114,
331433,
334339,
337850,
337864,
337866,
337868,
337872,
337878,
337852,
337881
)




select * from RCV_SHIPMENT_HEADERS WHERE SHIPMENT_HEADER_ID=186036

select * from MTL_MATERIAL_TRANSACTIONS WHERE RCV_TRANSACTION_ID=324455




SELECT  A.SHIP_TO_ORG_ID, GET_ORG_CODE_FROM_ID(A.SHIP_TO_ORG_ID) INV_ORG_CODE,  A.RECEIPT_NUM, A.SHIPMENT_HEADER_ID,  XX_GET_EMP_NAME_FROM_USER_ID (C.CREATED_BY) CREATED_BY,A.SHIPMENT_NUM, TO_CHAR(C.CREATION_DATE,'DD-MON-RRRR HH12:MI:SS PM') CREATION_DATE,
 C.TRANSACTION_TYPE, 
TO_CHAR(C.TRANSACTION_DATE,'DD-MON-RRRR HH12:MI:SS PM') TRANSACTION_DATE,  C.QUANTITY
from RCV_TRANSACTIONS C, RCV_SHIPMENT_HEADERS A
 --WHERE TRUNC(TRANSACTION_DATE) BETWEEN (TRUNC(CREATION_DATE)-30) AND TRUNC(P_PR_APP_DT)
WHERE C.SHIPMENT_HEADER_ID= A.SHIPMENT_HEADER_ID
and TRANSACTION_DATE <  (TRUNC(C.CREATION_DATE)-30) 
--and organization_ID= 121
and a.CREATION_DATE between '01-JAN-2021' and '30-JUN-2021'
--and C.TRANSACTION_TYPE IN ('DELIVER','TRANSFER','RETURN TO VENDOR')
and A.SHIP_TO_ORG_ID <> 362
--and a.receipt_num = 80000489
 and a.CREATED_BY <>  1462
ORDER BY C.CREATION_DATE DESC



--==============KBD GRN 8000002===== 

SELECT * FROM RCV_SHIPMENT_HEADERS WHERE  RECEIPT_NUM= 80000002 and SHIP_TO_ORG_ID=166

SELECT * FROM mtl_material_transactions WHERE RCV_TRANSACTION_ID IN (
316922,
316906,
316932,
316913,
209151,
209152,
209153,
209146,
209147,
209148,
209149,
209150,
324469,
324472,
324480,
324481
)


SELECT * FROM  MTL_MATERIAL_TRANSACTIONS
 WHERE RCV_TRANSACTION_ID IN (
316922,
316906,
316932,
316913,
209151,
209152,
209153,
209146,
209147,
209148,
209149,
209150,
324469,
324472,
324480,
324481
)


SELECT * FROM  MTL_MATERIAL_TRANSACTIONS
 WHERE TRANSACTION_ID IN (
1447355,
1447404,
1546542,
1546642
)

UPDATE  MTL_MATERIAL_TRANSACTIONS
SET TRANSACTION_DATE = TO_DATE('9/13/2018 6:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
 WHERE TRANSACTION_ID IN (
1447355,
1447404,
1546542,
1546642
)
--==============================================================

select * FROM RCV_SHIPMENT_HEADERS WHERE RECEIPT_NUM IN(
80000816,
80000817,
80000818,
80000819,
80000820,
80000042,
80000063,
80000064,
80000065,
80000330,
80000332,
80000333,
80000387,
80000944,
80000945,
80000946,
80000947,
80000948,
80000949,
80000950,
80000034,
80000748,
80000750,
80000751,
80000752,
80000760,
80000762,
80000763,
80000765,
80000031,
80000032,
80000033,
80000061,
80000062,
80000651,
80000652,
80000417,
80000577,
80000484,
80000486,
80000487,
80000500,
80000501,
80000502,
80000503,
80000504,
80000505,
80000506,
80000507,
80000508,
80000509,
80000630,
80000631,
80000632,
80000633,
80000634,
80000635,
80000636,
80000579,
80000580,
80000581,
80000001,
80000002,
80000497,
80000498,
80000499,
80000661,
80000662,
80000663,
80000664,
80000665,
80000666,
80000401,
80000402,
80000403,
80000404,
80000405,
80000481,
80000482,
80000483,
80000657,
80000658,
80000408,
80000409,
80000410,
80000411,
80000412,
80000413,
80000351,
80000352,
80000354,
80000479,
80000257,
80000717,
80000718,
80000653,
80000655,
80000656,
80000414,
80000415,
80000740,
80000741,
80000742,
80000225,
80000779,
80000828,
80000835,
80000838,
80000839,
80000840,
80000578,
80000805
)
--and RECEIPT_NUM= 80000816
 and ship_to_org_id= 166
 --and TRUNC(CREATION_DATE)  not between '01-MAR-2019' and '31-MAR-2019'
-- and TRUNC(CREATION_DATE)  between '01-APR-2019' and '30-APR-2019'



