
-- MISCELINIES ISSUE RECEIVE A DEPARTMENT INFO DHORAR JONNO EI CODE TA USSE HOISE BUT EKHANE "SHIPPING PROCUREMENT TA DEKHASSE NA"
SELECT DISTINCT UPPER(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1,INSTR(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1),'.',1)-1))  DEPT FROM PER_ALL_POSITIONS PAP


order by UPPER(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1,INSTR(SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1),'.',1)-1))


select distinct PAP.NAME from  PER_ALL_POSITIONS PAP


select   (SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1)) from PER_ALL_POSITIONS PAP
where (SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1)) like '%Proc%'

select NAME from PER_ALL_POSITIONS PAP
where (SUBSTR(PAP.NAME,INSTR(PAP.NAME,'.',3,2)+1)) like '%Ship%'


select substr(sohel, 3,2) from dual

-- SUBSTR
SELECT
  SUBSTR( '303.Ship_Procurement.Procurement.Deputy_Manager.No', 1, 20 ) SUBSTRING
FROM
  dual
  
  SELECT
  SUBSTR( 'Oracle Substring', 1, 6 ) SUBSTRING
FROM
  dual;

--INSTR
--=====

SELECT INSTR('CORPORATE FLOOR','OR', 3, 2)
  "Instring" FROM DUAL
  
  SELECT INSTR('CORPORATE FLOOR','OR', -3, 2)
"Reversed Instring"
     FROM DUAL;
     
SELECT
  INSTR( '303.Ship_Procurement.Procurement.Deputy_Manager.No', 'Ship_Procurement',-1 ) substring_location
FROM
  dual;
  
  Ship_Procurement
  
