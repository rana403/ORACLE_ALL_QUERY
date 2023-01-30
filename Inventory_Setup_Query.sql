--===========================================
--AFTER SETUP A INVENTORY ORG SEE DATA FROM BACKGROUND

--PRIMARY_COST_METHOD = 1(STANDERD), 2(AVERAGE) COST
--===========================================

SELECT * FROM  MTL_PARAMETERS WHERE ORGANIZATION_CODE =-- YOUR ORG_CODE


SELECT    organization_code,
    organization_id, PRIMARY_COST_METHOD
    --primary_costing_method -- 1 = STD, 2 = AVG costing
FROM    MTL_PARAMETERS

--====================================
--GET LEDGER NAME, OPERATING UNIT NAME, INVENTORY ORG NAME 
--===================================
SELECT Distinct gl.name "Ledger",
          haou2.name "Operating Unit",
          haou.name "Inventory Org",
          mp.organization_code "Org Code"
FROM      inv.mtl_parameters mp,
          hr.hr_organization_information hoi,
          hr.hr_all_organization_units haou,
          hr.hr_all_organization_units haou2,
          gl.gl_ledgers gl
WHERE  1=1
AND hoi.org_information_context = 'Accounting Information'
AND          hoi.organization_id = mp.organization_id
AND          hoi.organization_id = haou.organization_id -- inventory organization name
AND          haou2.organization_id = to_number(hoi.org_information3) -- operating unit id
AND          gl.ledger_id = to_number(hoi.org_information1) -- ledger_id (R11i set of books)
AND         gl.name = '103-KSRM Steel Plant Ltd'





SELECT * FROM MTL_MATERIAL_TRANSACTIONS_TEMP WHERE TRANSACTION_DATE BETWEEN '01-MAR-2022' and '30-APR-2022' and ORGANIZATION_ID 
IN(141,148
--121,
--148,
--150,
--149,
--147,
--146,
--145,
--144,
--143,
--142,
--141
)



SELECT *
FROM RCV_TRANSACTIONS_INTERFACE A, ORG_ORGANIZATION_DEFINITIONS B
WHERE a.TO_ORGANIZATION_ID=B.ORGANIZATION_ID
--AND TO_ORGANIZATION_ID = 121
AND TRANSACTION_DATE <= '30-APR-2022'
AND TRANSACTION_DATE between '01-APR-2022' and '30_APR-2022'
AND DESTINATION_TYPE_CODE = 'INVENTORY'



SELECT COUNT(*)
  FROM RCV_TRANSACTIONS_INTERFACE
  WHERE TO_ORGANIZATION_ID   =121
  AND TRANSACTION_DATE      <= '30-APR-2022'
  AND DESTINATION_TYPE_CODE IN ('INVENTORY','SHOP FLOOR')


CREATE TABLE RCV_TRANS_INTFACE_APR_22_KSPL AS 
Select * from RCV_TRANSACTIONS_INTERFACE WHERE TRANSACTION_DATE between '01-APR-2021' and '30-APR-2021' and TO_ORGANIZATION_ID 
IN(
121,
148,
150,
149,
147,
146,
145,
144,
143,
142,
141
)
and TRANSACTION_STATUS_CODE = 'ERROR'

SELECT * FROM RCV_TRANS_INTFACE_APR_22_KSPL

SELECT *  FROM RCV_TRANSACTIONS_INTERFACE WHERE 1=1 --TRANSACTION_DATE between '01-APR-2021' and '30-APR-2021' 
and TO_ORGANIZATION_ID IN(
--121,
--148,
--150,
--149,
--147,
--146,
--145,
--144,
--143,
--142,
141
)
and TRANSACTION_STATUS_CODE = 'ERROR' 


select * from WIP_COST_TXN_INTERFACE

select 'Inventory' application_name, 'This section checks for Cost (CST) / Inventory (INV) issues.' "Description"
from dual


Org Code = KSA, Inventory Org Name = KSPL Warehouse Barabkunda: Found 1 pending receiving transactions.
Org Code = KS2, Inventory Org Name = KSPL KSL-2: Found 1 pending receiving transactions.



WIP_COST_TXN_INTERFACE

select * from WSM_SPLIT_MERGE_TXN_INTERFACE

SELECT * FROM WIP_COST_TXN_INTERFACE

select * from CST_LC_ADJ_INTERFACE

select * from WIP_MOVE_TXN_INTERFACE

SELECT * FROM ORG_ORGANIZATION_DEFINITIONS WHERE  OPERATING_UNIT = 81

select * from RCV_SHIPMENT_HEADERS WHERE  SHIPMENT_HEADER_ID IN (1043117,
1043118)

select * from RCV_SHIPMENT_LINES WHERE  SHIPMENT_HEADER_ID IN (1043117,
1043118)   

141,148

Select * from PER_ALL_PEOPLE_F WHERE LAST_NAME LIKE '%Abdullah%Mamun'


POS_VENDOR_PUB_PKG


SELECT * FROM fnd_user WHERE USER_NAME LIKE 'APPSMGR'
