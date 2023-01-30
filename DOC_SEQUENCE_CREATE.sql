select  XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) created_by, CREATED_BY from FND_DOCUMENT_SEQUENCES  WHERE NAME LIKE '%23%' and CREATED_BY =6123

select * from FND_DOCUMENT_SEQUENCES  WHERE NAME LIKE '%Oraask Test Sequence%' --and DOC_SEQUENCE_ID=1506

select * from FND_DOCUMENT_SEQUENCES where  END_DATE = '31-DEC-2023' and  name like '%KSBIL%'  --DOC_SEQUENCE_ID IN(1506,1846) --and CREATED_BY =6123

select * from FND_DOC_SEQUENCE_ASSIGNMENTS 
where  END_DATE = '31-DEC-2022'  --
and DOC_SEQUENCE_ID IN(1936,
1937,
1938,
1939,
1940,
2037,
2038,
2039,
2096)

SELECT   a.name, b.*  FROM FND_DOCUMENT_SEQUENCES a,FND_DOC_SEQUENCE_ASSIGNMENTS b
where a. DOC_SEQUENCE_ID=b. DOC_SEQUENCE_ID
and a.and DOC_SEQUENCE_ID IN(1506,1846)  --1506



--============================= API FOR DOC SEQUENCE================================

------------------------------------------ 
-- Description: API to define document sequence in oracle EBS R12
-- Created By: Hassan @ Oraask.com
-- Creation Date: 21-SEP-2022
------------------------------------------

DECLARE
  L_APPLICATION_NAME    VARCHAR2 (500) := 'Payables';
  L_DOC_SEQUENCE_NAME   VARCHAR2 (500) := 'Oraask Test Sequence';
  L_DOC_SEQUENCE_TYPE   VARCHAR2 (500) := 'A'; --Sequence Type       ('A'=automatic,'G'=gapless,'M'=manual)
  L_MSG_FLAG            VARCHAR2 (500) := 'Y';
  L_INIT_VALUE          VARCHAR2 (500) := 1; -- Initial sequence value
  L_START_DATE          DATE := '01-JAN-2023'; -- Effective Start date
  L_END_DATE            DATE :=  '31-DEC-2023'; -- NULL; -- Effective End date
  L_APPLICATION_ID      NUMBER;
  L_DOC_SEQUENCE_ID     NUMBER;
  L_RETURN              NUMBER;
  L_ERR_MSG             VARCHAR2 (4000);
BEGIN
  DBMS_OUTPUT.PUT_LINE ('**********************************************');

  DBMS_OUTPUT.PUT_LINE ('Get Application ID');

  -- Define a new document sequence
  BEGIN
    SELECT APPLICATION_ID
    INTO   L_APPLICATION_ID
    FROM   FND_APPLICATION_TL
    WHERE  APPLICATION_NAME = L_APPLICATION_NAME;
  EXCEPTION
    WHEN OTHERS THEN
      L_ERR_MSG := 'Application Name is not correct - ' || SQLERRM;
  END;

  DBMS_OUTPUT.PUT_LINE ('L_APPLICATION_ID = ' || L_APPLICATION_ID);

  L_RETURN :=
    FND_SEQNUM.DEFINE_DOC_SEQ (APP_ID        => L_APPLICATION_ID
                              ,DOCSEQ_NAME   => L_DOC_SEQUENCE_NAME
                              ,DOCSEQ_TYPE   => L_DOC_SEQUENCE_TYPE
                              ,MSG_FLAG      => L_MSG_FLAG
                              ,INIT_VALUE    => L_INIT_VALUE
                              ,P_STARTDATE   => L_START_DATE
                              ,P_ENDDATE     => L_END_DATE);

  IF (L_RETURN <> FND_SEQNUM.SEQSUCC) THEN
    DBMS_OUTPUT.PUT_LINE ('Fail: ' || TO_CHAR (L_RETURN));
    DBMS_OUTPUT.PUT_LINE ('Application Name: ' || L_APPLICATION_ID);
    DBMS_OUTPUT.PUT_LINE ('Document Sequence Name: ' || L_DOC_SEQUENCE_NAME);
    DBMS_OUTPUT.PUT_LINE ('Document Sequence Type: ' || L_DOC_SEQUENCE_TYPE);
    DBMS_OUTPUT.PUT_LINE ('Initial Sequence Value: ' || L_INIT_VALUE);
    DBMS_OUTPUT.PUT_LINE ('Effective Start Date: ' || L_START_DATE);
    DBMS_OUTPUT.PUT_LINE ('Effective End Date: ' || L_END_DATE);

    L_ERR_MSG :=
      (CASE
         WHEN L_RETURN = -1 THEN
           'An oracle error occurred and we have raise the error with fnd.message and app_exception.raise_exception function'
         WHEN L_RETURN = -2 THEN
           'No assignment exists for the set of parameters'
         WHEN L_RETURN = -3 THEN
           'The assigned sequence is inactive - so far this is not used here, if the trx_date is out of range for any assignment we return noassign - the ''C'' code does'
         WHEN L_RETURN = -4 THEN
           'No assignment exists for the set of parameters'
         WHEN L_RETURN = -5 THEN
           'A sequence value was not passed for a manual seq'
         WHEN L_RETURN = -6 THEN
           'The manual sequence value passed is not unique'
         WHEN L_RETURN = -7 THEN
           'Sequential Numbering is not used, continue'
         WHEN L_RETURN = -8 THEN
           'Sequential Numbering is always used and there is no assignment for this set of parameters'
         WHEN L_RETURN = -9 THEN
           'Received an invalid DocSeq type'
         WHEN L_RETURN = -10 THEN
           'The sequence Name value passed is not unique'
         WHEN L_RETURN = -11 THEN
           'Received an invalid Message Flag'
         WHEN L_RETURN = -12 THEN
           'Received an invalid start and end date combo for these parameters'
         WHEN L_RETURN = -13 THEN
           'Received an invalid Doc_Seq Name'
         WHEN L_RETURN = -14 THEN
           'Received an invalid Category Code'
         WHEN L_RETURN = -15 THEN
           'Received an invalid Set of Books ID'
         WHEN L_RETURN = -16 THEN
           'Received an invalid Method Code'
         WHEN L_RETURN = -17 THEN
           'Received an invalid Method Code'
       END);
  ELSE
    SELECT DOC_SEQUENCE_ID
    INTO   L_DOC_SEQUENCE_ID
    FROM   FND_DOCUMENT_SEQUENCES
    WHERE  NAME = L_DOC_SEQUENCE_NAME;

    DBMS_OUTPUT.PUT_LINE ('L_RETURN = ' || L_RETURN);
    DBMS_OUTPUT.PUT_LINE ( (CASE WHEN L_RETURN = 0 THEN 'Document Sequence Created Successfully with ID: ' || L_DOC_SEQUENCE_ID END));
  END IF;

  DBMS_OUTPUT.PUT_LINE ('**********************************************');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE ('Error : ' || SQLERRM);
END;
/
