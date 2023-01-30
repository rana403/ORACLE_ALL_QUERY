SELECT * FROM XX_ONT_BG_DT WHERE BG_NO = 'Shakha/Khila/Guarantee/01/2019'  

update XX_ONT_BG_DT 
set BANK_ISSUE_DATE = TO_DATE('4/26/2019 06:18:34 PM', 'MM/DD/YYYY HH12:MI:SS PM')
where BG_NO = 'Shakha/Khila/Guarantee/01/2019'

