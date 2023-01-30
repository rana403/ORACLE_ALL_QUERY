--Ordermanagement Custom Tables

Select * from XX_ONT_TRIP_MT -- Trip Master table 

where tripsys_no = 1449

select * from XX_ONT_TRIP_DT   -- Trip Details Table


Select * from XX_ONT_TRIP_MT a, XX_ONT_TRIP_DT b
where a.tripsys_no = b.tripsys_no 
and a.tripsys_no = 1449

 