
--============================= GAS and POWER GRN DATE CHANGE OK OR NOT QUERY=============

SELECT   a.receipt_num,
TO_CHAR(TO_DATE(a.ATTRIBUTE13,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') CHALLAN_DATE,
TO_CHAR(TRUNC(c.CREATION_DATE),'DD-MON-RRRR') CREATION_DATE,
TO_CHAR(TRUNC(c.TRANSACTION_DATE),'DD-MON-RRRR') TRANSACTION_DATE,
TO_CHAR(TRUNC(a.CREATION_DATE),'DD-MON-RRRR') CREATION_DATE_headerr,
TO_CHAR(TRUNC(b.CREATION_DATE),'DD-MON-RRRR') CREATION_DATE_Line
 FROM  RCV_TRANSACTIONS c, RCV_SHIPMENT_HEADERs a , RCV_SHIPMENT_LINES b where a.SHIPMENT_HEADER_ID= b.SHIPMENT_HEADER_ID
and a.shipment_header_id = c.shipment_header_id
 and a.receipt_num IN (80000657,80000723) 
 AND a.SHIP_TO_ORG_ID =160
 and b.ITEM_ID in (243,244)
and a.CREATION_DATE between '01-JUN-2021' and '24-FEB-2022'
and c.TRANSACTION_TYPE = 'DELIVER'
order by c.TRANSACTION_DATE

--=====================================================================


--- GET APPROVAL PATH FROM BACKEND ------------------------

select OBJECT_TYPE_CODE, OBJECT_SUB_TYPE_CODE,pah.LAST_UPDATE_DATE, pah.CREATION_DATE, pah.CREATED_BY, ACTION_CODE, ACTION_DATE,
(select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID) HIERARCHY_NAME, FULL_NAME, EMPLOYEE_NUMBER, AUTHORIZATION_STATUS, COMMENTS, WF_ITEM_TYPE, WF_ITEM_KEY
FROM po_action_history pah,per_all_people_f papf,po_headers_all pha
where pah.employee_id = papf.person_id AND pah.object_id = pha.po_header_id
--and SEGMENT1 = :PO_Number
and (select NAME from per_position_structures where position_structure_id = pah.APPROVAL_PATH_ID)  like '%FPD%IMPORT%' 









select * from hr_all_positions_f_tl where name LIKE  '%201.Information Communication%Technology.ERP.Deputy Manager.No%'

select * from per_pos_structure_elements_v where trunc(CREATION_DATE)  between '19-JAN-2022' and '19-JAN-2022'


SELECT * FROM per_pos_structure_elements

select * from  per_positions per_pos where name LIKE  '%201.Information Communication%Technology.ERP.Deputy Manager.No%'

select * from PER_POSITION_STRUCTURES  where trunc(CREATION_DATE)  between '19-JAN-2022' and '19-JAN-2022'