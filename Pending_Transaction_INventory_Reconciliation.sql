--==========================================
-- 1.  SELECT PENDING DATA FOR FEBRUARY-2022
--==========================================
SELECT * FROM RCV_TRANSACTIONS_INTERFACE WHERE TRUNC(CREATION_DATE) between '01-FEB-2022' and '28-FEB-2022' 

----============================================================================
--2. IF GET ANY DELIVERY STATUS , "INVENTORY "
--GO TO THE TRANSACTION STATUS SUMMARY FORM THEN SELECTORG--> GO TO TRANSACTION DETAILS TAB--> PROVIDE THE DATE RANGE THE FIND THE DATA --> DELETE THE DATA FROM THE FORM --> SAVE THE FORM  
----===========================================================================
SELECT * FROM RCV_TRANSACTIONS_INTERFACE WHERE TRUNC(CREATION_DATE) between '01-FEB-2022' and '28-FEB-2022' 
and DESTINATION_TYPE_CODE = 'INVENTORY'


--==========================================
-- 3. ERROR IF INTERFACE TABLE BACKUP FOR FEBRUARY-2022
--==========================================
select *  from RCV_TRANSACTIONS_FEB_2022 

CREATE TABLE RCV_TRANSACTIONS_FEB_2022 AS 
SELECT * FROM RCV_TRANSACTIONS_INTERFACE WHERE TRUNC(CREATION_DATE) between '01-FEB-2022' and '28-FEB-2022' 


--==========================================
-- 4. DELETE DATE FROM INTERFACE TABLE  FOR FEBRUARY-2022
--==========================================
delete from RCV_TRANSACTIONS_INTERFACE WHERE TRUNC(CREATION_DATE) between '01-FEB-2022' and '28-FEB-2022' 




SELECT *
FROM RCV_TRANSACTIONS_INTERFACE
WHERE TO_ORGANIZATION_ID =121
AND TRANSACTION_DATE <= '&EndPeriodDate'
AND DESTINATION_TYPE_CODE = 'INVENTORY';

select * from ORG_ORGANIZATION_DEFINITIONS