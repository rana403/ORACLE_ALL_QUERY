DECLARE
v_user_name VARCHAR2 (100) :='KG-4079';
BEGIN
fnd_user_pkg.addresp(username => v_user_name
,resp_app => 'SYSADMIN'
,resp_key => 'SYSTEM_ADMINISTRATOR'
,security_group => 'STANDARD'
,description => NULL
,start_date => SYSDATE
,end_date => null);
commit;
END;




-- CREATE OR REPLACE PACKAGE get_user_pwd
--AS
--   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
--      RETURN VARCHAR2;
--END get_user_pwd;
--
--===========================
--
-- CREATE OR REPLACE PACKAGE BODY get_user_pwd
--AS
--   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
--      RETURN VARCHAR2
--   AS
--      LANGUAGE JAVA
--      NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt
--(java.lang.String,java.lang.String) return java.lang.String';
--END get_user_pwd;

--================================

 --ALTER SESSION SET current_schema = system;

--================================

SELECT (SELECT get_user_pwd.decrypt
                    (fnd_web_sec.get_guest_username_pwd,
                     usertable.encrypted_foundation_password
                    )
          FROM DUAL) AS apps_password
  FROM fnd_user usertable
 WHERE usertable.user_name LIKE
          (SELECT SUBSTR (fnd_web_sec.get_guest_username_pwd,
                          1,
                          INSTR (fnd_web_sec.get_guest_username_pwd, '/') - 1
                         )
             FROM DUAL);