--GET CUSTOMER ID,NAME , NUMBER 
----=========================

SELECT   --a.CUSTOMER_NAME , 
 a.* FROM  XX_AR_CUSTOMER_SITE_V a 
WHERE 1=1
--and ORDER_TYPE  IN ('KSBL-IC-SALE-KPPL', 'KSL-IC-SALE-KSBIL')
AND PARTY_TYPE='ORGANIZATION' 
AND CUSTOMER_CLASS_CODE = 'INTERNAL'
--AND CUST_CATEGORY <>'INTERNAL'

SELECT *   FROM  XX_AR_CUSTOMER_SITE_V WHERE  CUSTOMER_CLASS_CODE = 'INTERNAL'
--==================================================================
--QUERY TO  GET  INTERNAL  CUSTOMER MASTER INFORMATION. CUSTOMER NAME, ACCOUNT NUMBER, ADDRESS ETC.
--=================================================================

select Distinct  p.PARTY_NAME,ca.ACCOUNT_NUMBER,loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code,CUSTOMER_CLASS_CODE,P.CREATION_DATE,
loc.country,ca.CUST_ACCOUNT_ID
from apps.ra_customer_trx_all I,
apps.hz_cust_accounts CA,
apps.hz_parties P,
apps.hz_locations Loc,
apps.hz_cust_site_uses_all CSU,
apps.hz_cust_acct_sites_all CAS,
apps.hz_party_sites PS
where I.COMPLETE_FLAG ='Y'
and I.bill_TO_CUSTOMER_ID= CA.CUST_ACCOUNT_ID
and ca.PARTY_ID=p.PARTY_ID
and I.bill_to_site_use_id=csu.site_use_id
and csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
and cas.PARTY_SITE_ID=ps.party_site_id
and ps.location_id=loc.LOCATION_ID
--AND ca.CUST_ACCOUNT_ID = 1526
AND CUSTOMER_CLASS_CODE =  'INTERNAL'
--AND    p.PARTY_NAME LIKE '%KSRM Transport%'


--==================================================================
--QUERY TO  GET  EXTERNAL  CUSTOMER MASTER INFORMATION. CUSTOMER NAME, ACCOUNT NUMBER, ADDRESS ETC.
--=================================================================

select Distinct  p.PARTY_NAME,ca.ACCOUNT_NUMBER,loc.address1,loc.address2,loc.address3,loc.city,loc.postal_code,CUSTOMER_CLASS_CODE,P.CREATION_DATE,
loc.country,ca.CUST_ACCOUNT_ID
from apps.ra_customer_trx_all I,
apps.hz_cust_accounts CA,
apps.hz_parties P,
apps.hz_locations Loc,
apps.hz_cust_site_uses_all CSU,
apps.hz_cust_acct_sites_all CAS,
apps.hz_party_sites PS
where I.COMPLETE_FLAG ='Y'
and I.bill_TO_CUSTOMER_ID= CA.CUST_ACCOUNT_ID
and ca.PARTY_ID=p.PARTY_ID
and I.bill_to_site_use_id=csu.site_use_id
and csu.CUST_ACCT_SITE_ID=cas.CUST_ACCT_SITE_ID
and cas.PARTY_SITE_ID=ps.party_site_id
and ps.location_id=loc.LOCATION_ID
--AND ca.CUST_ACCOUNT_ID = 1526
AND CUSTOMER_CLASS_CODE <>  'INTERNAL'
--AND    p.PARTY_NAME LIKE '%KSRM Transport%'