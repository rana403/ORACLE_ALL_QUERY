select * from xle_entity_profiles 

 SELECT * FROM hr_all_organization_units_tl   hr_outl
 
 select * from  hr_operating_units ORDER BY NAME
 
 select * from  hr_operating_units ORDER BY NAME
 
 select DISTINCT ORGANIZATION_ID , ADDRESS_LINE_1, ADDRESS_LINE_2, ADDRESS_LINE_3 from HR_ORGANIZATION_UNITS_V
 
 select * from PO_HEADERS_ALL WHERE SEGMENT1= 40005009  and org_id= 81
 
SELECT LOCATION_CODE||', '|| ADDRESS_LINE_1||', '|| ADDRESS_LINE_2||', '||REGION_1||', '||ADDRESS_LINE_3 , SHIP_TO_LOCATION
    from HR_LOCATIONS_V , ORG_ORGANIZATION_DEFINITIONS 
 where 1=1
 AND INVENTORY_ORGANIZATION_ID = ORGANIZATION_ID
  and ADDRESS_LINE_3 LIKE '%BIN%'
--  and OPERATING_UNIT = 81
 and   INVENTORY_ORGANIZATION_ID is not null 
 
 select * from HR_LOCATIONS_V 
 where 1=1
 --and INVENTORY_ORGANIZATION_ID is not null 
 and ADDRESS_LINE_3 LIKE '%BIN%'
 --and SHIP_TO_LOCATION LIKE '%Manufacturing%'  
 --and INVENTORY_ORGANIZATION_ID =  121 --   163 
-- and location_id= 142


 select LOCATION_CODE,ADDRESS_LINE_1,ADDRESS_LINE_2,REGION_1,ADDRESS_LINE_3  from HR_LOCATIONS_V 
 where 1=1
 and INVENTORY_ORGANIZATION_ID is not null 
-- and SHIP_TO_LOCATION LIKE '%Manufacturing%'  
 --and INVENTORY_ORGANIZATION_ID =  121 --   163 
-- and location_id= 142


 select LOCATION_CODE||','|| ADDRESS_LINE_1||','|| ADDRESS_LINE_2||','||REGION_1||','||ADDRESS_LINE_3 , SHIP_TO_LOCATION
  from HR_LOCATIONS_V , ORG_ORGANIZATION_DEFINITIONS 
 where 1=1
 AND INVENTORY_ORGANIZATION_ID = ORGANIZATION_ID
 --and INVENTORY_ORGANIZATION_ID is not null 
-- and SHIP_TO_LOCATION LIKE '%Manufacturing%'  
 and SHIP_TO_LOCATION IN ('KSRM Transport Barakumira', 'KSPL Lighter Ship Main Store',
 'KSPL Manufacturing Unit',
'KSRM Manufacturing Unit',
'KSRM Power Manufacturing Unit',
'KBIL Manufacturing Unit',
'KASIL Manufacturing Unit',
'KOL Manufacturing Unit',
'KSL Manufacturing Unit',
'KWSBL Manufacturing Unit',
'KSBL Manufacturing Unit'
 )
 --and INVENTORY_ORGANIZATION_ID =  121 --   163 
 --and OPERATING_UNIT IN (103) --81
-- and location_id= 142


select * from ORG_ORGANIZATION_DEFINITIONS where OPERATING_UNIT IN ( 103)
 
 SELECT * FROM HR_ORGANIZATION_UNITS_V where ORGANIZATION_ID = 81 and  LOCATION_ID= 142
 
 LOCATION_ID IN(
 192,
204,
206,
208,
212,
214,
222,
242
 )