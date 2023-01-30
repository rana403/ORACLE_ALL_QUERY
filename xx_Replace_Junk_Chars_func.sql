CREATE OR REPLACE FUNCTION APPS.xx_Replace_Junk_Chars_func (p_string IN VARCHAR2)
   RETURN VARCHAR2
IS
   lv_string   VARCHAR2 (1000);
   i           NUMBER;
BEGIN
   DBMS_OUTPUT.PUT_LINE (p_string);

   FOR i IN 1 .. LENGTH (p_string)
   LOOP
      DBMS_OUTPUT.PUT_LINE (   SUBSTR (p_string, i, 1)
                            || '....'
                            || ASCII (SUBSTR (p_string, i, 1))
                           );

      IF    (ASCII (SUBSTR (p_string, i, 1)) BETWEEN 65 AND 90) OR (ASCII (SUBSTR (p_string, i, 1)) BETWEEN 97 AND 122)
   OR (ASCII (SUBSTR (p_string, i, 1)) BETWEEN 48 AND 57) OR (SUBSTR (p_string, i, 1) IN (' ','.','/','-'))
      THEN
         lv_string := lv_string || SUBSTR (p_string, i, 1);
      ELSE
         lv_string := lv_string || ' ';
      END IF;

      DBMS_OUTPUT.PUT_LINE (lv_string);
   END LOOP;

   DBMS_OUTPUT.PUT_LINE ('Final String :' || lv_string);
   RETURN lv_string;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN NULL;
END;
/
