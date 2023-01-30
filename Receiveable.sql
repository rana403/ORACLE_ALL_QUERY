
----CASE: CHECK entry deoar pore Jodi bank ledger a hit na kore taile
--SOLUSION:  receiveable a ekti custom process ase-->  "  API Process for AR Collections " jeta chalale pore bank lkedger a hit korbe


--REPORT: IBRAHIM VAI CREATEED A TEMP TABLE TO RUN THE  "  EBS Customer Balance Accumulated  "  REPORT  FIRSTLY
--EBS Customer Balance Procedure Temp
--EBS Customer Balance Accumulated

--EI NAME EKTA PROCEDUREs  BANAISE, JEKHANE " XX_AR_CUST_ACCUMU_LED_V " EI VIEW THEKE DATA INSERT OR UPDATE HOBE 
--procedureS name:  AR_CUST_ACCUMU_BAl_TEMP_PRO

SELECT * from XX_AR_CUST_ACCUMU_LED_V 



 SELECT DISTINCT SEGMENT1 LEGAL_ENTITY_CODE,SEGMENT1||'-'||XX_GET_ACCT_FLEX_SEG_DESC (1, SEGMENT1) LEGAL_ENTITY_NAME FROM GL_CODE_COMBINATIONS

 SELECT SUBSTR(NAME,1,3) from HR_OPERATING_UNITS
