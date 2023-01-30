   
-- PROCEDURES  

/*  
When GRN is created and it goes to transaction status summary option . and ststus shows pending.  Then we have to run two report 
1. from purchasing super User --> Rrn the report name -->  Landed cost Integration Manager

2. Resp: Landed cost administrator Kabir Group --> Repport name --> Shipments Interface Import

Then pending GRN will go to active ststus and user will get it in receiving transaction status screen
 */
 RCV_CALL_LCM_WS.insertLCM 
 