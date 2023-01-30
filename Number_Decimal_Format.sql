
/*****************************
GET 3 digit After Desimal
***************************/
SELECT TO_CHAR(7, 'fm99D000') FROM DUAL

/*****************************
GET  round after decimal above .5 (ekhane .56 hoar karone output 123 erpore 4 er poriborte 5 hoese)
***************************/
SELECT TO_CHAR(1234.56, 'fm99G999') FROM DUAL


/*****************************
To GET RECEIVE QUANTITY  Shows 3 digit after decimal
***************************/
TO_CHAR(WIRTF.RECEIPT_QTY, 'fm99D000') RECEIPT_QTY