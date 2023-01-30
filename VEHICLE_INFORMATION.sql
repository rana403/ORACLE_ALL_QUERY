



--*********************************************************
--GET VRHICLE INFORMATION 
/**********************************************************/
SELECT * FROM xx_ont_vehicle_v where VEHICLE_ID  IN(413,
369)


SELECT DISTINCT VEHICLE_TYPE  FROM xx_ont_vehicle_v WHERE REG_NO LIKE '%CM-TA-11-9246%'

SELECT DISTINCT  VEHICLE_TYPE, REG_NO, VEHICLE_TYPE, VEHICLE_ID, ORG_ID FROM xx_ont_vehicle_v --where REG_NO  LIKE '%CM-TA-11-9246%'

SELECT DISTINCT  TRANSPORT_TYPE FROM XX_ONT_TRIP_MT 

SELECT  TRIPSYS_NO   FROM XX_ONT_TRIP_MT -- where REG_NO  LIKE '%CM-TA-11-9246%'  352,431


XX_VEHICLE_NO
(SELECT DISTINCT REG_NO, VEHICLE_TYPE, VEHICLE_ID, ORG_ID FROM xx_ont_vehicle_v) XXTDA


WHERE TRANSPORT_TYPE = 'Company Vehicle'
AND VEHICLE_ID IS NOT NULL
AND ORG_ID = 103


(SELECT DISTINCT REG_NO, TRANSPORT_TYPE, VEHICLE_ID, ORG_ID FROM XX_ONT_TRIP_MT) XXTDA


SELECT *  FROM xx_ont_vehicle_v WHERE REG_NO LIKE '%CM-TA-11-9246%'


EBS Fixed Asset Vehicle Repository Details