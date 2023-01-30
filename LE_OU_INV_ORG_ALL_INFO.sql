--=====================
--QUERY TO FIND THE BUSINESS GROUP NAME 
--=====================
select
   business_group_id,name
from per_business_groups
--where lower(name) like '%Kabir%Group%'
order by name


--=================================
--QUERY TO FIND SET OF BOOK (SOBS) SET UP IN THE INSTANCE :
--=================================
select
   set_of_books_id,
   name sob_name,
   chart_of_accounts_id,
   chart_of_accounts_name,
   period_set_name calendar_period,
   accounted_period_type,
   user_period_type,
   currency_code
from gl_sets_of_books_v
--where set_of_books_id=1


--=======================================
GET ALL OPERATING UNITS
--=======================================

SELECT * FROM HR_OPERATING_UNITS

--================================================
--A VERY IMPORTANT QUERY TO FIND OUT  INVENTORY ORGANIZATIONS FOR AN OPERATING UNIT :
--===============================================
select
   organization_id,
   organization_code,
   organization_name,
   (SELECT DISTINCT  NAME  FROM HR_OPERATING_UNITS a WHERE a.ORGANIZATION_ID=od.OPERATING_UNIT ) OU,
   (select location_id from hr_all_organization_units ou
     where od.organization_id=ou.organization_id) location_id,
   user_definition_enable_date,
   disable_date,
   chart_of_accounts_id,
   inventory_enabled_flag,
   operating_unit,
   legal_entity,
   set_of_books_id,
   business_group_id
from org_organization_definitions od
WHERE ORGANIZATION_CODE='LSH'
--where operating_unit=204 and ORGANIZATION_ID = 9073
order by organization_code


