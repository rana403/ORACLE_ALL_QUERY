
UPDATE PO_REQUISITION_LINES_ALL
SET UNIT_PRICE=1
WHERE UNIT_PRICE = 14500
AND requisition_header_id=1321574
AND ORG_ID = 104




select *from po_requisition_headers_all where segment1=  10002051 and org_id=104


UPDATE PO_REQUISITION_HEADERS_ALL
SET  CREATION_DATE = TO_DATE('4/30/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM'), 
 LAST_UPDATE_DATE = TO_DATE('4/30/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM'), 
 APPROVED_DATE = TO_DATE('4/30/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
 WHERE  ORG_ID = 104 AND SEGMENT1 = 10002051    
 
 
 select * from po_requisition_lines_all where requisition_header_id= 1351205 and org_id= 104
 
 UPDATE po_requisition_lines_all
 SET  LAST_UPDATE_DATE = TO_DATE('4/30/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM'), 
 CREATION_DATE = TO_DATE('4/30/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM'), 
 NEED_BY_DATE = TO_DATE('4/30/2020 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
WHERE  org_id = 104 and REQUISITION_HEADER_ID = 1351205


/*TO GET THAT PR NUMBERS WHICH HAVE MORE THAN 150 LINES*/
SELECT ORG_ID, REQUISITION_HEADER_ID ,COUNT(LINE_NUM) FROM PO_REQUISITION_LINES_ALL 
WHERE ORG_ID= 81
HAVING COUNT(LINE_NUM) > 150
GROUP BY ORG_ID,REQUISITION_HEADER_ID

