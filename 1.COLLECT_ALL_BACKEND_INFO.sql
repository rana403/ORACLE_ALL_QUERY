
-- TO GET ALL VIEW
--=====================
SELECT * FROM TAB where TABTYPE = 'VIEW' AND TNAME LIKE '%XX%'


SELECT*
FROM    user_source
WHERE TEXT LIKE '%XX%'

-- TO GET ALL CUSTOM PACKAGE
--==========================
SELECT DISTINCT NAME
FROM    user_source
WHERE NAME LIKE 'XX%PKG%'

XX_GET_INV_QTY