drop table emp;

create table emp as select * from employees;

alter table emp add constraint emp_id_pk primary key(employee_id);

Select * from emp

SET SERVER OUTPUT ON;


Declare 
my_name varchar2(30)  := 'Sohel Rana';
My_AGE number := 30;
BEGIN 
DBMS_OUTPUT.PUT_LINE('My Name is '|| my_name);
DBMS_OUTPUT.PUT_LINE('My age is '|| My_AGE);
END;

Declare 
my_name varchar2(20);
begin
my_name := 'Rana';
DBMS_OUTPUT.PUT_LINE('My name is '|| my_name);
end;


DECLARE 
name varchar2(50);
sal number;
BEGIN
select first_name|| '-' || last_name , salary into name , sal
FROM employees 
WHERE employee_id = 100;
DBMS_OUTPUT.PUT_LINE('NAME IS '||name ||' salary is '|| sal);
END;


DECLARE
event varchar2(100);
BEGIN
event := 'father''s day';
DBMS_OUTPUT.PUT_LINE('1st june is '||event);
event := 'mother''s day';
DBMS_OUTPUT.PUT_LINE('1st july is '||event);
event := 'Grant Fasther''s day';
DBMS_OUTPUT.PUT_LINE('1st june is '||event);
END;

--================ BOOLIAN VERIABLE============




--==============Inner BLOCK & OUTER BLOCK==========

/* Formatted on 7/2/2018 1:57:31 PM (QP5 v5.163.1008.3004) */
<<outer>>
DECLARE
   Fathers_Name   VARCHAR2 (50) := 'Mamun';
   birth_day      DATE := '01-MAR-1910';
BEGIN
   DECLARE
      child_Name   VARCHAR2 (50) := 'Belal';
      birth_day    DATE := to_date('01-MAR-2015', 'DD-MON-YYYY');
   BEGIN
      DBMS_OUTPUT.PUT_LINE ('Child''s Name is  ' || child_Name);
      DBMS_OUTPUT.PUT_LINE ('childr''s Birth day is  ' || birth_day);
   END;

   DBMS_OUTPUT.PUT_LINE ('FAther''s Name is  ' || Fathers_Name);
   DBMS_OUTPUT.PUT_LINE ('Fater''s Birth day is  ' || birth_day);
END;



declare 
tot_sal  number(10,2);
dept_no number := '&dept';
BEGIN
SELECT SUM(SALARY) INTO TOT_SAL 
FROM employees 
where department_id= dept_no ;
DBMS_OUTPUT.PUT_LINE('total salary = '||tot_sal);
DBMS_OUTPUT.PUT_LINE('Department_id is = '||dept_no);
END;

--=============UPDATE ROW================

DECLARE
sal_inc number(10,2) := 800;
BEGIN
UPDATE emp
set salary = salary+sal_inc
where job_id ='IT_PROG';
DBMS_OUTPUT.PUT_LINE(sal_inc);
END;

select * from emp where job_id= 'IT_PROG'

--============= RECORD=================
select * from retired_employee;

delete from retired_employee;

drop table retired_employee;

select * from emp;

--1. Create a record 
-- FIRST CREATE A TABLE --> DECLARE A RECORD--> INSERT DATE  IN THE NEW TABLE THROUGH RECORD
CREATE TABLE retired_employee
(
   EMPNO       NUMBER (6),
   ENAME       VARCHAR2 (25),
   JOB         VARCHAR2 (10),
   MGR         NUMBER (6),
   HIREDATE    DATE,
   EMAIL         VARCHAR2(25),
   SAL         NUMBER (8, 2),
   COMM        NUMBER (2, 2),
   DEPTNO      NUMBER (4)
);


DECLARE 
EMP_RECORD1 employees%ROWTYPE;
BEGIN
SELECT * INTO EMP_RECORD1 FROM EMP
WHERE EMPLOYEE_ID = &EMPNO;
INSERT INTO retired_employee(EMPNO,ENAME,JOB,MGR,HIREDATE,EMAIL,SAL,COMM,DEPTNO)
VALUES (EMP_RECORD1.EMPLOYEE_ID,
EMP_RECORD1.LAST_NAME,
EMP_RECORD1.JOB_ID,
EMP_RECORD1.MANAGER_ID,
EMP_RECORD1.HIRE_DATE,
EMP_RECORD1.EMAIL,
EMP_RECORD1.SALARY,
EMP_RECORD1.COMMISSION_PCT,
EMP_RECORD1.DEPARTMENT_ID );
END;


DECLARE 
empno retired_employee.empno%type;
BEGIN
delete from retired_employee
where EMPNO = &empno;
:rows_deleted :=(SQL%ROWCOUNT||'row deleted');
DBMS_OUTPUT.PUT_LINE('row deleted '||empno);
END;

SELECT * FROM retired_employee  ;

--======================= CURSOR=======================

DECLARE 
cursor emp_cursor is
select employee_id, last_name, salary from employees
where department_id= '&DEPT';
emp_id            employees.employee_id%type;
emp_name      employees.last_name%type;
salary             employees.salary%type;
job_id             employees.job_id%type;
BEGIN
open emp_cursor;
loop
fetch emp_cursor 
into emp_id ,emp_name, salary;
EXIT when emp_cursor%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('emp ID'|| emp_id || 'ENMP NAME'|| emp_name || 'SALARY'||salary );
end loop;
CLOSE emp_cursor;
END;


--============================procedure=========================================
CREATE OR REPLACE PROCEDURE raise_salary
  (id  IN emp.employee_id%TYPE,
   percent IN NUMBER)
IS
BEGIN
  UPDATE emp
  SET    salary = salary * (1 + percent/100)
  WHERE  employee_id = id;
END raise_salary;

exec raise_salary(909,5);

select * from emp order by employee_id desc;
--============================FUNCTION=========================================
CREATE or REPLACE FUNCTION get_name
(id emp.employee_id%type) return varchar2
IS
emp_name emp.last_name%type;
BEGIN
select LAST_NAME into emp_name from emp
where employee_id= 100;
return emp_name;
END get_name;

exec DBMS_OUTPUT.put_line(get_name(100));

select * from emp;

--===========================  PACKAGE==========================================

CREATE OR REPLACE PACKAGE hrms   -- SPECIFICATION
IS
PROCEDURE hire(empid  number,
                         fname varchar2,
                         lname varchar2,
                         email  varchar2,
                         hiredate date,
                         jobid   varchar2
);
PROCEDURE fire(empid number);
END;


CREATE OR REPLACE PACKAGE BODY hrms  --BODY
AS
PROCEDURE hire(empid  number,
                         fname varchar2,
                         lname varchar2,
                         email  varchar2,
                         hiredate date,
                         jobid   varchar2) 
                         IS
                         BEGIN 
                         insert into emp(employee_id, first_name, last_name,email,hire_date,job_id)
                         values(empid,fname,lname,email,hiredate,jobid);
                         END hire; 
                        PROCEDURE fire(empid number)
                        IS
                         BEGIN
                        DELETE FROM EMP 
                        WHERE employee_id= empid;
                        commit;
                        END fire;
                       end;
                         
    exec hrms.hire(500, 'Rahim', 'Ahmed','Rahim@gmail.com',to_date('01-JAN-2017'), 'IT_PROG');      
        
    select * from emp where employee_id = 500;      
        
   exec hrms.fire(500);    

--======================== TRIGGER==========================
 
/* Formatted on 6/10/2018 12:50:58 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE TRIGGER secure_emp1
   BEFORE INSERT OR UPDATE OR DELETE
   ON emp
BEGIN
   IF (TO_CHAR (SYSDATE, 'DY') IN ('FRI', 'SUN'))
      OR (TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '09:00' AND '16:00')
   THEN
      IF DELETING
      THEN
         RAISE_APPLICATION_ERROR (-20500,
                                  'You may delete from employee table');
      ELSIF INSERTING
      THEN
         RAISE_APPLICATION_ERROR (-20500,
                                  'You may insert  from employee table');
      ELSIF UPDATING ('SALARY')
      THEN
         RAISE_APPLICATION_ERROR (
            -20500,
            'You may update salary during this session');
      END IF;
   END IF;
END;

update emp
set salary = 5000
where employee_id = 100;







--==================== IF statement==================

DECLARE 
my_age    number:=30;
BEGIN
IF my_age < 20
THEN
DBMS_OUTPUT.PUT_LINE('I am A younger');
ELSE
DBMS_OUTPUT.PUT_LINE('I am A Chield');
END IF;
END;


declare
myage number(3):= &My_Age_is;
begin
if myage <=11
then
dbms_output.put_line(' I am a child');
elsif myage <=20
then
dbms_output.put_line('I am Young');
elsif myage <=30
then
dbms_output.put_line('I am in 30');
elsif myage <=40
then
dbms_output.put_line('I am Old');
else
dbms_output.put_line('I am what I am');
end if;
end;

--================= Bind veriable===============

DECLARE
VARIABLE emp_salary  NUMBER
BEGIN
SELECT salary into :emp_salary
FROM employees 
whetre employee_id =178;
--DBMS_OUTPUT.PUT_LINE('Salaryis '|| emp_salary);
END;

--==============
