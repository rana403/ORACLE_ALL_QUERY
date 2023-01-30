--DELIVERY DATA FOR TAYEF VAI  Date: 01-NOV-2022 V2
--==================

SELECT TO_CHAR(challan_date,'MON-YY') PERIOD,cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME, --dlv.ORDERED_ITEM ,--challan_date, 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
ACCOUNT_NAME,
SUM(dlv.SHIPPED_QUANTITY) CHALLAN_QUANTITY,
(SELECT SUM(CR_AMOUNT) FROM AR_CUST_ACCUMU_BAl_TEMP where CUSTOMER_NUMBER =cust.CUSTOMER_NUMBER and GL_DATE BETWEEN  :P_FROM_DATE AND :P_TO_DATE  ) Collection_Amount
from wbi_ont_delivery_details_f dlv, wbi_ont_customer_d cust --, AR_CUST_ACCUMU_BAl_TEMP ACT
where dlv.org_id = 81
and dlv.customer_id = cust.customer_id
--AND cust.CUSTOMER_NUMBER = ACT.CUSTOMER_NUMBER
and dlv.org_id = cust.org_id
--AND ORDERED_ITEM = 'FG|500W|10MM|000002'
and CUSTOMER_CATEGORY <> 'INTERNAL'
and trunc(challan_date) between  :P_FROM_DATE AND :P_TO_DATE ---'01-MAY-22' and  '16-OCT-22' 
--and cust.CUSTOMER_NUMBER  = '1526'
--AND cust.CUSTOMER_NAME='HOQUE TRADERS'
GROUP BY
TO_CHAR(challan_date,'MON-YY') , 
cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME,-- dlv.ORDERED_ITEM , 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
ACCOUNT_NAME
--challan_date
--order by CHALLAN_DATE

select * from AR_CUST_ACCUMU_BAl_TEMP where TRUNC(GL_DATE) BETWEEN '01-OCT-22' and  '31-OCT-22'  and CUSTOMER_NUMBER = '1526'


SELECT * from wbi_ont_delivery_details_f

GET CUSTOMER ID< NAME < NUMBER 
--=========================


select * from  XX_AR_CUSTOMER_SITE_V where CUSTOMER_NUMBER =1526

SELECT 
A.OD_NUMBER,
A.OD_DATE,
A.CUSTOMER_ID,
(SELECT DISTINCT CUSTOMER_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE CUSTOMER_ID=A.SOLD_TO_ORG_ID) CUSTOMER_NAME,
A.CUSTOMER_ID CUSTOMER_NO
FROM  XX_ONT_TRANSACTIONS_V A
WHERE (SELECT DISTINCT CUSTOMER_NAME FROM XX_AR_CUSTOMER_SITE_V WHERE CUSTOMER_ID=A.SOLD_TO_ORG_ID) LIKE '%PRIME TRADERS %'

SELECT *  FROM  XX_ONT_TRANSACTIONS_V WHERE 



--DELIVERY DATA FOR TAYEF VAI  Date: 01-NOV-2022 V1
--==================

SELECT TO_CHAR(challan_date,'MON-YY') PERIOD,cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME, --dlv.ORDERED_ITEM ,--challan_date, 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
ACCOUNT_NAME,
SUM(dlv.CHALLAN_QUANTITY) CHALLAN_QUANTITY,
(SELECT SUM(CR_AMOUNT) FROM AR_CUST_ACCUMU_BAl_TEMP where CUSTOMER_NUMBER =cust.CUSTOMER_NUMBER and GL_DATE BETWEEN  :P_FROM_DATE AND :P_TO_DATE  ) Collection_Amount
from wbi_ont_delivery_details_f dlv, wbi_ont_customer_d cust , AR_CUST_ACCUMU_BAl_TEMP ACT
where dlv.org_id = 81
and dlv.customer_id = cust.customer_id
AND cust.CUSTOMER_NUMBER = ACT.CUSTOMER_NUMBER
and dlv.org_id = cust.org_id
--AND ORDERED_ITEM = 'FG|500W|10MM|000002'
and CUSTOMER_CATEGORY <> 'INTERNAL'
and trunc(challan_date) between  :P_FROM_DATE AND :P_TO_DATE ---'01-MAY-22' and  '16-OCT-22' 
and cust.CUSTOMER_NUMBER  = '1526'
--AND cust.CUSTOMER_NAME='HOQUE TRADERS'
GROUP BY 
TO_CHAR(challan_date,'MON-YY'),cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME,-- dlv.ORDERED_ITEM , 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
ACCOUNT_NAME
--challan_date
--order by CHALLAN_DATE




--DELIVERY DATA FOR TAYEF VAI  Date: 01-NOV-2022 V1
--==================

SELECT TO_CHAR(challan_date,'MON-YY') PERIOD,cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME, dlv.ORDERED_ITEM ,--challan_date, 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
ACCOUNT_NAME,
SUM(dlv.CHALLAN_QUANTITY) CHALLAN_QUANTITY,
(SELECT SUM(CR_AMOUNT) FROM AR_CUST_ACCUMU_BAl_TEMP where CUSTOMER_NUMBER =cust.CUSTOMER_NUMBER and GL_DATE BETWEEN  :P_FROM_DATE AND :P_TO_DATE  ) BALANCE
from wbi_ont_delivery_details_f dlv, wbi_ont_customer_d cust --, AR_CUST_ACCUMU_BAl_TEMP ACT
where dlv.org_id = 81
and dlv.customer_id = cust.customer_id
--AND cust.CUSTOMER_NUMBER = ACT.CUSTOMER_NUMBER
and dlv.org_id = cust.org_id
--AND ORDERED_ITEM = 'FG|500W|08MM|000001'
and CUSTOMER_CATEGORY <> 'INTERNAL'
and trunc(challan_date) between  :P_FROM_DATE AND :P_TO_DATE ---'01-MAY-22' and  '16-OCT-22' 
and cust.CUSTOMER_NUMBER  = '1302'
GROUP BY 
TO_CHAR(challan_date,'MON-YY'),cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME, dlv.ORDERED_ITEM , 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
ACCOUNT_NAME
--challan_date
--order by CHALLAN_DATE


--DELIVERY DATA FOR TAYEF VAI  Date: 01-NOV-2022
--================================

SELECT TO_CHAR(challan_date,'MON-YY') PERIOD,cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME, dlv.ORDERED_ITEM , 
(SELECT   SUM(CR_AMOUNT) FROM AR_CUST_ACCUMU_BAl_TEMP where CUSTOMER_NUMBER =cust.CUSTOMER_NUMBER ) BALANCE,
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
dlv.CHALLAN_QUANTITY,
ACCOUNT_NAME
from wbi_ont_delivery_details_f dlv, wbi_ont_customer_d cust --, AR_CUST_ACCUMU_BAl_TEMP ACT
where dlv.org_id = 81
and dlv.customer_id = cust.customer_id
--AND cust.CUSTOMER_NUMBER = ACT.CUSTOMER_NUMBER
and dlv.org_id = cust.org_id
AND ORDERED_ITEM = 'FG|500W|08MM|000001'
and CUSTOMER_CATEGORY <> 'INTERNAL'
and trunc(challan_date) between  '01-JAN-21' and  '31-JAN-21' 
and cust.CUSTOMER_NUMBER  = '72342'

select * FROM AR_CUST_ACCUMU_BAl_TEMP 

SELECT  CUSTOMER_NUMBER,  TO_CHAR(GL_DATE,'MON-YY') PERIOD ,SUM(CR_AMOUNT) FROM AR_CUST_ACCUMU_BAl_TEMP where CUSTOMER_NUMBER = '3040'  group by CUSTOMER_NUMBER,TO_CHAR(GL_DATE,'MON-YY')

--DELIVERY DATA FOR TAYEF VAI 
--==================

SELECT TO_CHAR(challan_date,'MON-YY') PERIOD,cust.CUSTOMER_NUMBER,cust.CUSTOMER_NAME, dlv.ORDERED_ITEM,trunc(challan_date) Challan_Date , 
cust.ACCOUNT_NUMBER,
cust.CUSTOMER_CATEGORY,
cust.SALESREP_NAME,
cust.ADDRESS1,
cust.ZONE,
cust.REGION,
cust.AREA,
cust.TERRITORY,
cust.ZONE_DESC,
cust.REGION_DESC,
cust.TERRITORY_DESC,
cust.SALES_CHANNEL,
dlv.CHALLAN_QUANTITY_UOM,
dlv.CHALLAN_QUANTITY,
ACCOUNT_NAME
from wbi_ont_delivery_details_f dlv, wbi_ont_customer_d cust , AR_CUST_ACCUMU_BAl_TEMP ACT
where dlv.org_id = 81
and dlv.customer_id = cust.customer_id
and dlv.org_id = cust.org_id
AND ORDERED_ITEM = 'FG|500W|08MM|000001'
and CUSTOMER_CATEGORY <> 'INTERNAL'
and trunc(challan_date) between  '01-JAN-19' and  '31-JAN-19' 


--============== Arafat Vai provided query==============

select SUM(SHIPPED_QUANTITY) --dlv.* 
from wbi_ont_delivery_details_f dlv, wbi_ont_customer_d cust 
where dlv.org_id = 81
and dlv.customer_id = cust.customer_id
and dlv.org_id = cust.org_id
AND dlv.CUSTOMER_ID= '1566'
and challan_date BETWEEN '01-OCT-2022' and '31-OCT-2022'

