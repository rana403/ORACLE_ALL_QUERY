-- GET ALL LOCAL and Service Provider SUPPLIERS 
SELECT  --SUBSTR(XX_GET_HR_OPERATING_UNIT(B.ORG_ID),5),
DISTINCT A.VENDOR_NAME SUPPLIER_NAME ,A.SEGMENT1 SUPPLIER_CODE,A.VENDOR_TYPE_LOOKUP_CODE SUPPLIER_TYPE,  B.ADDRESS_LINE1 ADDRESS,
A.CREATED_BY CREATED_BY_ID, XX_GET_EMP_NAME_FROM_USER_ID (A.CREATED_BY) CREATED_BY_NAME,   TO_CHAR(A.CREATION_DATE) CREATION_DATE
--A.ATTRIBUTE5 "Contact Person Name" ,A.ATTRIBUTE7 "Contact Person Phone", A.ATTRIBUTE8 "Contact Person eMail",  A.ATTRIBUTE2 EMAIL, A.ATTRIBUTE7 Mobile,
--A.ATTRIBUTE10 TIN_NUMBER, NULL BIN_NUMBER
--SELECT * 
FROM AP_SUPPLIERS A , AP_SUPPLIER_SITES_ALL B
  WHERE 1=1
  AND A.VENDOR_ID= B.VENDOR_ID
 and A.VENDOR_TYPE_LOOKUP_CODE IN ( 'DRIVER')
 AND  A.VENDOR_NAME not like '%TP%'
 -- and A.SEGMENT1=1029
  and  A.END_DATE_ACTIVE is null  --- INACTIVE SUPPLIER WILL NOT SHOW
  --and a.VENDOR_NAME LIKE  '%WISDRI%ENGINEERING%'
  order by A.VENDOR_NAME
 -- and   A.CREATED_BY NOT IN ( 1191,1211)
 -- and A.SEGMENT1 = 4719
--  and B.ORG_ID not in (111,
--112,
--113,
--114,
--115,
--116,
--117,
--118)
 --AND A.SEGMENT1 IN(5330)
 