SELECT papf.person_id , pad.primary_flag,
       papf.employee_number "Employee Number",
       papf.title "Title",
       papf.first_name "First Name",
       papf.last_name "Last Name",
       TO_CHAR(papf.date_of_birth, 'DD-MON-RRRR') "Birth Date",
       TRUNC(MONTHS_BETWEEN(SYSDATE, papf.date_of_birth) / 12) "Age",
       hrlsex.meaning "Gender",
       ppt.user_person_type "Person Type",
       papf.national_identifier "National Identifier",
       hrlnat.meaning "Nationality",
       hrlms.meaning "Marital Status",
       papf.email_address "E-mail",
       TO_CHAR(papf.effective_start_date, 'DD-MON-RRRR') "Start Date",
       TO_CHAR(papf.effective_end_date, 'DD-MON-RRRR') "End Date",
       TO_CHAR(papf.original_date_of_hire, 'DD-MON-RRRR') "Hire Date",
       pjobs.name "Job",
       ppos.name "Position",
       pgrade.name "Grade",
       haou.name "Organization",
       pbus.name "Business Group",
       hrlat.meaning "Address Type",
       pad.address_line1 || CHR(10) || pad.address_line2 || CHR(10) ||
       pad.address_line3 "Address",
       pad.postal_code "Postal Code",
       ftt.territory_short_name "Country",
       ftt.description "Full Country Name",
       hrleg.meaning "Ethnic Origin"
FROM per_all_people_f papf,
     per_all_assignments_f paaf,
     per_person_types_tl ppt,
     hr_lookups hrlsex,
     hr_lookups hrlnat,
     hr_lookups hrlms,
     hr_lookups hrleg,
     hr_lookups hrlat,
     per_jobs pjobs,
     per_all_positions ppos,
     per_addresses pad,
     per_grades_tl pgrade,
     per_business_groups pbus,
     hr_all_organization_units haou,
     fnd_territories_tl ftt
WHERE 1 = 1
  AND hrlat.lookup_code(+) = pad.address_type
  AND hrlat.lookup_type(+) = 'ADDRESS_TYPE'
  AND hrlsex.lookup_code(+) = papf.sex
  AND hrlsex.lookup_type(+) = 'SEX'
  AND hrlnat.lookup_code(+) = papf.nationality
  AND hrlnat.lookup_type(+) = 'NATIONALITY'
  AND hrlms.lookup_code(+) = papf.marital_status
  AND hrlms.lookup_type(+) = 'MAR_STATUS'
  AND hrleg.lookup_code(+) = papf.per_information1
  AND hrleg.lookup_type(+) = 'US_ETHNIC_GROUP'
  AND ftt.territory_code(+) = pad.country
  AND pad.business_group_id(+) = papf.business_group_id
  AND pad.date_to IS NULL
  AND pad.person_id(+) = papf.person_id
  AND pgrade.grade_id(+) = paaf.grade_id
  AND haou.organization_id(+) = paaf.organization_id
  AND haou.business_group_id(+) = paaf.business_group_id
  AND pbus.business_group_id(+) = paaf.business_group_id
  AND ppos.position_id(+) = paaf.position_id
  AND pjobs.job_id(+) = paaf.job_id
  AND ppt.person_type_id(+) = papf.person_type_id
  AND TRUNC(SYSDATE) BETWEEN paaf.effective_start_date AND
      paaf.effective_end_date
  AND paaf.person_id = papf.person_id
  AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date
   AND papf.effective_end_date
    and papf.person_id = 225
 --  and FIRST_NAME = 'KG-4079';