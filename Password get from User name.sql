/*<TOAD_FILE_CHUNK>*/

/*
First create the function specification and body 
Then run the query

*/


--Package Specification
CREATE OR REPLACE PACKAGE get_pwd
AS
   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
      RETURN VARCHAR2;
END get_pwd;
/













/*<TOAD_FILE_CHUNK>*/

--Package Body
CREATE OR REPLACE PACKAGE BODY get_pwd
AS
   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
      RETURN VARCHAR2
   AS
      LANGUAGE JAVA
      NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
END get_pwd;
/













/*<TOAD_FILE_CHUNK>*/


--Query to execute the password
SELECT usr.user_name,
       get_pwd.decrypt
          ((SELECT (SELECT get_pwd.decrypt
                              (fnd_web_sec.get_guest_username_pwd,
                               usertable.encrypted_foundation_password
                              )
                      FROM DUAL) AS apps_password
              FROM fnd_user usertable
             WHERE usertable.user_name =
                      (SELECT SUBSTR
                                  (fnd_web_sec.get_guest_username_pwd,
                                   1,
                                     INSTR
                                          (fnd_web_sec.get_guest_username_pwd,
                                           '/'
                                          )
                                   - 1
                                  )
                         FROM DUAL)),
           usr.encrypted_user_password
          ) PASSWORD
  FROM fnd_user usr
 where usr.user_name  = 'KG-2825' 
 
--WHERE usr.user_name = :p_user_name;

select * from per_all_people_f where LAST_NAME like '%Abu%Chow%'  --   KG-4509

--  Syed Nazrul Alam, KG-3287    ksrmsna

-- ABU CHOWDHURY  PURCHASE : 'KG-2825'