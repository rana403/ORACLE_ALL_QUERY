
--===================================
--TO SHOW only two digit after dosomik
--===================================
TO_CHAR(ABS(SUM(X.TRANS_QTY)),'99999990D99') t_qty,

TO_CHAR(DECODE ( X.UOM,'KG',ABS(SUM(X.TRANS_QTY))/1000,ABS(SUM(X.TRANS_QTY)) ),'99999990D99') T_QTY,