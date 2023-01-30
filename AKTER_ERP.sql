

-- SELECT  STATEMENT FOR FINDING DATA
-- DATE : 13-JUN-2021
SELECT *  FROM GME_BATCH_HEADER 
WHERE 1=1
and  BATCH_NO in (120,185,202,221,345) 
and attribute28 is not null 

SELECT BATCH_NO, ATTRIBUTE28  FROM GME_BATCH_HEADER 
WHERE 1=1
and  BATCH_NO in (345) 


-- UPDATE SCRIPT
--UPDATE GME_BATCH_HEADER  
SET attribute28 = 'MV. VERA'
WHERE  BATCH_NO =345 
and attribute28 ='MT. WEST ENERGY'





SELECT BATCH_NO, ATTRIBUTE28  FROM GME_BATCH_HEADER 
WHERE 1=1
--and  BATCH_NO in (120,185,202,221,345) 
and attribute28= 'MV. VERA'

1.    Batch No: 120, DFF will be M.T. PALMS

2.    Batch No: 185, DFF will be MV. BRILLIANCE

3.    Batch No: 202, DFF will be MV. BRILLIANCE

4.    Batch No: 221, DFF will be MV. BRILLIANCE

5.    Batch No: 345, DFF will be MV. VERA




