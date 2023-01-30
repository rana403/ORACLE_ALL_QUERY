/*<TOAD_FILE_CHUNK>*/
--Class1: 28-4-2018
set serveroutput on size ultimate

--Anonimus block:
declare 
name varchar2(50);
salary  number;
BEGIN 
SELECT first_name||'-'||Last_name full_name, salary into name,salary
from employees
where employee_id=100;
DBMS_OUTPUT.PUT_LINE('FULL NAME IS:'||name || 'and salary is:' || salary);
end;



--CLASS2:30-APR-2018
--===============

DECLARE 
myname varchar2(20);
mobile   number;
address varchar2(50);
BEGIN
--DBMS_OUTPUT.PUT_LINE('MY NAME IS: '||myname );
myname := 'Sohel Hossain';
address := 'KSRM';
mobile :=01913658403;
DBMS_OUTPUT.PUT_LINE('MY NAME IS: '||myname ||' and Mobile' ||mobile ||' and address  ' ||address );
END;


DECLARE
event VARCHAR2(15);
BEGIN
event := 'Father''s day';
DBMS_OUTPUT.PUT_LINE('3rd Sunday in June is :
'||event);
event := 'Mother''s day';
DBMS_OUTPUT.PUT_LINE('2nd Sunday in May is :
'||event);
event := 'Brother''s day';
DBMS_OUTPUT.PUT_LINE('4rth monday in May is :
'||event);
END;
/
/*<TOAD_FILE_CHUNK>*/





--==========CLASS 3 === 6-may-2018=========
set serveroutput on;


declare 
desc_size NUMBER(15);
porduct_description VARCHAR2(170) := 'you can use this prodicts ';
BEGIN
desc_size := LENGTH(porduct_description);
DBMS_OUTPUT.PUT_LINE('TOTAL LENGTH IS: ' ||desc_size);
END;

DECLARE 
SALARY NUMBER:=6000;
SALARY_INC VARCHAR2(6) := '1000';
total_salary salary%type;
BEGIN
total_salary := SALARY + SALARY_INC;
DBMS_OUTPUT.PUT_LINE('Total Salary is: '||total_salary );
END;

--=============================

DECLARE 
outer_variable VARCHAR2(30) := 'GLOBAL VARIABLE';
BEGIN
   DECLARE
   inner_variable varchar2(40) := 'LOCAL VARIABLE';
   BEGIN
   DBMS_OUTPUT.PUT_LINE(inner_variable);
   DBMS_OUTPUT.PUT_LINE(outer_variable);
   END;
  DBMS_OUTPUT.PUT_LINE(outer_variable);
END;


--=================================

DECLARE 
weight number(3):=600;
message VARCHAR2(255):='PRODUCT 110002';
BEGIN
      DECLARE
             weight number(3):=1;
             message VARCHAR2(250):= 'product 1100001';
            new_locn varchar2(50);
            BEGIN
              weight number(3) :=weight +1;
               DBMS_OUTPUT.PUT_LINE(weight);
              new_locn            := 'Western ' ||new_locn;
               DBMS_OUTPUT.PUT_LINE(new_locn);
            END;
            weight number(3):=weight +1;
            DBMS_OUTPUT.PUT_LINE(weight);
 END;
  
 
 DECLARE
 weight    NUMBER(3) := 600;
 message   VARCHAR2(255) := 'Product 10012';
BEGIN
  DECLARE
   weight  NUMBER(3) := 1;
   message   VARCHAR2(255) := 'Product 11001';
   new_locn  VARCHAR2(50) := 'Europe';
  BEGIN
   --weight := weight + 1;
   --new_locn := 'Western ' || new_locn;
    DBMS_OUTPUT.PUT_LINE(weight);
     DBMS_OUTPUT.PUT_LINE(new_locn);
  END;
 --weight := weight + 1;
 --message := message || ' is in stock';
     DBMS_OUTPUT.PUT_LINE(weight);
     --DBMS_OUTPUT.PUT_LINE(new_locn);
END;


--Class4 8-5-2018
--=================

DECLARE 
emp_hiredate employees.hire_date%type;
emp_salary    employees.salary%type;
BEGIN
select hire_date, salary 
INTO emp_hiredate,emp_salary
from employees
WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Employee Hire Dateis : '||to_char(emp_hiredate, 'DD-MON-YYYY') || ' And');
   DBMS_OUTPUT.PUT_LINE('Employee salary is: '||emp_salary);
END;


DECLARE 
sum_salary NUMBER(10,2);
deptno       NUMBER NOT NULL :=60;
BEGIN
SELECT SUM(SALARY) 
INTO sum_salary
FROM employees
WHERE department_id = :deptno;
DBMS_OUTPUT.PUT_LINE('Sum salary is: '||sum_salary);
END;


DECLARE 
sum_salary NUMBER(10,2);
deptno       NUMBER NOT NULL :=:deptno;
BEGIN
SELECT SUM(SALARY) 
INTO sum_salary
FROM employees
WHERE department_id = :deptno;
DBMS_OUTPUT.PUT_LINE(' salary of Dept no '||deptno ||' is'||sum_salary);
END;


DECLARE
EMP_SALARY NUMBER := :EMP_SALARY;
BEGIN
SELECT salary INTO :EMP_SALARY
FROM employees
where employee_id = 101;
DBMS_OUTPUT.PUT_LINE(EMP_SALARY);
END;


select MAX(employee_id) from emp;

DECLARE 
EMP_ID  NUMBER;
F_NAME  VARCHAR2(50);
L_NAME   VARCHAR2(50);
mail        VARCHAR2(50);
hiredate   DATE;
jobid        VARCHAR2(50);
SAL         NUMBER;



DECLARE
EMPSEQ   NUMBER;
BEGIN
SELECT max(employee_id) into EMPSEQ from emp;
EMPSEQ := EMPSEQ +1;
INSERT INTO emp
(employee_id, first_name, last_name, email,hire_date, job_id,salary)
VALUES(EMPSEQ, 'mamun','Hossain','mamun@gmail.com','25-APR-1999', 'IT-PROG',50000 );
END;

select * from emp order by employee_id desc;

--=============================================================


DECLARE
sal_increase   emp.salary%type := 800;
BEGIN
UPDATE emp
SET SALARY = SALARY + sal_increase
WHERE JOB_ID='IT-PROG'
AND employee_id = '208';
END;


--===============================10-MAY-2018===================

DECLARE
myage number := 31;
BEGIN
myage :=&myage;
if myage < 11
THEN
DBMS_OUTPUT.PUT_LINE('I am a chiled and My age is '||myage);
else
DBMS_OUTPUT.PUT_LINE('I am Young ');
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


DECLARE
grade char(1) := upper('&grade');
appraisal       varchar2(30);
BEGIN
 appraisal  := 
     CASE grade
          WHEN 'A'   THEN 'Excellient'
          WHEN 'B'   THEN 'Very good'
          WHEN 'C'   THEN 'Good'
          ELSE   'NO search grade'  
          END;
   dbms_output.put_line('Grade is:  ' || grade || '  and  Appraisal is :   ' ||appraisal ) ;         
END;

--================================================

DECLARE
grade char(1) := upper('&grade');
appraisal       varchar2(30);
BEGIN
 appraisal  := 
     CASE 
          WHEN  grade = 'A'   THEN 'Excellient'
          WHEN  grade in('B' ,'C' )  THEN ' good'
          ELSE   'NO search grade'  
          END;
   dbms_output.put_line('Grade is:  ' || grade || '  and  Appraisal is :   ' ||appraisal ) ;         
END;
--======================================================

declare
deptid number ;
deptname varchar2(50);
emps number;
mngid number := 108;
BEGIN
 CASE mngid
 WHEN 108 THEN
 select department_id, department_name into deptid,deptname from departments
 WHERE manager_id = '&mngid';
 SELECT count(*) into emps from employees 
 where department_id = '&deptid';
 END CASE;
  dbms_output.put_line('you are working in the '||deptname || 'There are '|| emps||  '  employees in the department');
END;

select * from dept order by department_id desc;

create table loc as select * from locations

select * from loc  where country_id =  'CA';



DECLARE
countryid loc.country_id%type := 'CA';
loc_id        loc.location_id%type;
counter    number(2) := 1;
new_city       loc.city%type := 'Montril';
BEGIN
  SELECT MAX(location_id) into loc_id FROM loc
  WHERE country_id = countryid;
  LOOP
    INSERT INTO loc(location_id, city,country_id)
    VALUES( (loc_id +counter ), new_city,countryid);
    counter := counter+1;
    EXIT WHEN counter > 3;
    END LOOP;
END;



--Class6 13-5-2018
--================
--Case statement

--Loop 3 types  : BAsic LOOP, For Loop, while loop


--WHILE LOOP

DECLARE
countryid loc.country_id%type := 'CA';
loc_id        loc.location_id%type;
counter    number(2) := 1;
new_city       loc.city%type := 'Montril';
BEGIN
  SELECT MAX(location_id) into loc_id FROM loc
  WHERE country_id = countryid;
  WHILE counter<= 3   LOOP
    INSERT INTO loc(location_id, city,country_id)
    VALUES( (loc_id +counter ), new_city,countryid);
    counter := counter+1;
    END LOOP;
END;

select * from loc  where country_id =  'CA';


--FOR LOOP

DECLARE
countryid loc.country_id%type := 'CA';
loc_id        loc.location_id%type;
--counter    number(2) := 1;
new_city       loc.city%type := 'Montril';
BEGIN
  SELECT MAX(location_id) into loc_id FROM loc
  WHERE country_id = countryid;
 FOR i in 1..3  LOOP
    INSERT INTO loc(location_id, city,country_id)
    VALUES( (loc_id +1 ), new_city,countryid);
    --counter := counter+1;
    END LOOP;
    dbms_output.put_line(loc_id );
END;

dbms_output.put_line();

select * from loc  where country_id =  'CA';

create table retired_emp as select * from employees;



select * from employees order by department_id desc;

delete retired_emp;

select * from retired_emp;

select * from  emp_rec;

/* Formatted on 5/13/2018 12:43:00 PM (QP5 v5.163.1008.3004) */
DECLARE
   emp_rec   employees%ROWTYPE;
BEGIN
   SELECT *
     INTO emp_rec
     FROM employees
    WHERE employee_id = &employeenumber;   
   INSERT INTO retired_emp (EMPLOYEE_ID,
                            FIRST_NAME,
                            LAST_NAME,
                            EMAIL,
                            PHONE_NUMBER,
                            HIRE_DATE,
                            JOB_ID,
                            SALARY,
                            COMMISSION_PCT,
                            MANAGER_ID,
                            DEPARTMENT_ID)
        VALUES (emp_rec.EMPLOYEE_ID,
                emp_rec.FIRST_NAME,
                emp_rec.LAST_NAME,
                emp_rec.EMAIL,
                emp_rec.PHONE_NUMBER,
                emp_rec.HIRE_DATE,
                emp_rec.JOB_ID,
                emp_rec.SALARY,
                emp_rec.COMMISSION_PCT,
                emp_rec.MANAGER_ID,
                emp_rec.DEPARTMENT_ID);
END;

--====================================================

CREATE TABLE retired_empployee
(
   EMPNO       NUMBER (6),
   ENAME       VARCHAR2 (10),
   JOB         VARCHAR2 (10),
   MGR         NUMBER (4),
   HIREDATE    DATE,
   LEAVEDATE   DATE,
   SAL         NUMBER (8, 2),
   COMM        NUMBER (2, 2),
   DEPTNO      NUMBER (4)
);


drop table retired_emps;

select * from retired_emps;


SELECT * into retired_emps FROM employees;

INSERT INTO retired_emps(EMPNO,ENAME,JOB,MGR,HIREDATE,LEAVEDATE,SAL,COMM,DEPTNO)
                                    values();
 

                                   
DECLARE
   emp_rec   employees%ROWTYPE;
BEGIN   
   INSERT INTO retired_emps (EMPNO,ENAME,JOB,MGR,HIREDATE,LEAVEDATE,SAL,COMM,DEPTNO)
    SELECT  e.EMPLOYEE_ID,
                e.FIRST_NAME,
                e.JOB_ID,
                e.HIRE_DATE,
                null,
                e.SALARY,
                e.COMMISSION_PCT,
                e.DEPARTMENT_ID
                FROM employees e
                where e.employee_id = &emp_id;
END;
 
 


 --===============================
 
 alter table retired_emps
modify ename varchar2(50); 

alter table retired_emps
modify job varchar2(10); 

alter table retired_emps
modify deptno number(4);


INSERT INTO retired_emps (EMPNO,
                          ENAME,
                          JOB,
                          MGR,
                          HIREDATE,
                          LEAVEDATE,
                          SAL,
                          COMM,
                          DEPTNO)
  ( SELECT EMPLOYEE_ID,
          LAST_NAME,
          JOB_ID,
          MANAGER_ID,
          HIRE_DATE,
          NULL,
          SALARY,
          COMMISSION_PCT,
          NULL
     FROM employees
     );
    
     
     
     select count(*) from employees;
     
     select * from retired_emps;
     
     delete retired_emps;
     
     
    DECLARE
    emp_rec retired_emps%rowtype;
     BEGIN 
     SELECT * into emp_rec from retired_emps ;
     emp_rec.hire_date := SYSDATE;
     UPDATE retired_emps SET ROW = emp_rec WHERE 
     employeeid = &employee_id;
     END;
     
     
     
   DECLARE emp_recs    employees%rowtype;
    BEGIN 
    select* into emp_recs from employees
    WHERE employee_id = 100;
     dbms_output.put_line(emp_recs );
    END;
     
    
    
   /* Formatted on 5/15/2018 12:43:14 PM (QP5 v5.163.1008.3004) */
   
   
    -- INDEX BY
DECLARE
   TYPE emp_table_type IS TABLE OF employees%ROWTYPE
                             INDEX BY PLS_INTEGER;
   my_emp_table   emp_table_type;
   max_count      NUMBER (3) := 104;
BEGIN
   FOR i IN 100 .. max_count
   LOOP
      SELECT *
        INTO my_emp_table (i)
        FROM employees
       WHERE employee_id = i;
   END LOOP;
   FOR i IN my_emp_table.FIRST .. my_emp_table.LAST
   LOOP
      DBMS_OUTPUT.put_line (my_emp_table (i).last_name||'  '  ||my_emp_table (i).salary);
   END LOOP;
END;


--=========================================

--CURSOR IS A LOCATOR
/* Formatted on 5/17/2018 11:10:32 AM (QP5 v5.163.1008.3004) */
DECLARE
   CURSOR emp_cursor
   IS
      SELECT employee_id, last_name,salary
        FROM employees
       WHERE department_id = 30;
   empno   employees.employee_id%TYPE;
   lname   employees.last_name%TYPE;
   salary   employees.salary%type;
BEGIN
   OPEN emp_cursor;
   LOOP
      FETCH emp_cursor
      INTO empno, lname,salary;
      EXIT WHEN emp_cursor%NOTFOUND;
      DBMS_OUTPUT.put_line (  'employee_id= ' || empno || '    ' || 'and name is' || lname|| 'salary '||salary);
   END LOOP;
   CLOSE emp_cursor;
END;

--============================

/* Formatted on 5/17/2018 11:30:24 AM (QP5 v5.163.1008.3004) */
DECLARE
   CURSOR emp_cursor
   IS
      SELECT employee_id, last_name
        FROM employees
       WHERE department_id = 90;
BEGIN
   FOR emp_record IN emp_cursor
   LOOP
      DBMS_OUTPUT.put_line ( emp_record.employee_id || ' ' || emp_record.last_name);
   END LOOP;
END;



--==========================


DECLARE 
empno employees.employee_id%type;
empname  employees.last_name%type;
esal            employees.salary%type;
CURSOR  emp_cursor IS select employee_id, last_name, salary  from employees order by employee_id desc;
BEGIN
OPEN emp_cursor;
LOOP
FETCH emp_cursor INTO empno,empname,esal;
EXIT WHEN emp_cursor%rowcount > 10 or
emp_cursor%NOTFOUND ;
 DBMS_OUTPUT.put_line('EMP ID '||empno||'  '  ||'EMP NAME '||empname||'salary'||esal);
END LOOP;
END;


--======================

/* Formatted on 5/17/2018 12:17:41 PM (QP5 v5.163.1008.3004) */
BEGIN
   FOR emp_record IN (SELECT employee_id, last_name
                        FROM employees
                       WHERE department_id = 30)
   LOOP
      DBMS_OUTPUT.put_line (
            'EMP ID '
         || emp_record.employee_id
         || '  and  '
         || 'EMP NAME '
         || emp_record.last_name);
   END LOOP;
END;


DECLARE
CURSOR emp_cursor (deptno number) IS
SELECT employee_id , last_name FROM employees
WHERE department_id = deptno;
dept_id number;
lname varchar2(15);
BEGIN
open emp_cursor (10);
loop
FETCH emp_cursor INTO dept_id,lname;
DBMS_OUTPUT.put_line (dept_id || '' ||lname);
CLOSE emp_cursor;
END loop;
END;


--============================

DECLARE
  empno    employees.employee_id%TYPE;
  ename    employees.last_name%TYPE;
  CURSOR emp_cursor (dept_id number) IS 
  SELECT employee_id,  last_name FROM employees 
  where department_id = dept_id;
BEGIN
  OPEN emp_cursor (20);
  LOOP
   FETCH emp_cursor INTO empno, ename;
   EXIT WHEN emp_cursor%ROWCOUNT > 10 OR  
                     emp_cursor%NOTFOUND;        
   DBMS_OUTPUT.PUT_LINE(TO_CHAR(empno)||' '|| ename);
  END LOOP;
  CLOSE emp_cursor;
    OPEN emp_cursor (30);
  LOOP
   FETCH emp_cursor INTO empno, ename;
   EXIT WHEN emp_cursor%ROWCOUNT > 10 OR  
                     emp_cursor%NOTFOUND;        
   DBMS_OUTPUT.PUT_LINE(TO_CHAR(empno)||' '|| ename);
  END LOOP;
  CLOSE emp_cursor;
   OPEN emp_cursor (30);
  LOOP
   FETCH emp_cursor INTO empno, ename;
   EXIT WHEN emp_cursor%ROWCOUNT > 40 OR  
                     emp_cursor%NOTFOUND;        
   DBMS_OUTPUT.PUT_LINE(TO_CHAR(empno)||' '|| ename);
  END LOOP;
  CLOSE emp_cursor;
END ;

--===========================================


declare 
dd number:=&dd;
cursor emp_cursor (deptno number) is 
select department_id, last_name from employees
where department_id=dd;
dept_id number;
lname varchar2(25);
begin
            open emp_cursor(dd);
            loop
            fetch emp_cursor into dept_id, lname;
            exit when emp_cursor%rowcount > 3 or  emp_cursor%notfound;
            dbms_output.put_line (dept_id||'- '||lname);
            CLOSE EMP_CURSOR;
            end loop;
end;


--=======================
--FOR UPDATE CLAUSE

DECLARE
   p1_emp   employees%ROWTYPE;
   CURSOR cur
   IS
      SELECT *
        FROM emp
       WHERE department_id = 20
      FOR UPDATE;
BEGIN
   OPEN cur;
   LOOP
      FETCH cur INTO p1_emp;
      EXIT WHEN cur%NOTFOUND;
      UPDATE emp
           SET salary = 11000 
           WHERE CURRENT OF cur;
   END LOOP;
--   COMMIT;
   CLOSE cur;
END;




--Class12 27-5-2018
--================

CREATE OR REPLACE procedure HR.raise_salary
(id in emp.employee_id%type, percent in number)
is 
begin
update emp
set salary = salary*(1+percent/60)
where employee_id = '&id';
end raise_salary;
/
/*<TOAD_FILE_CHUNK>*/

select * from emp order by employee_id desc;


alter table dept
add constraint dept_dpt_id_pk primary key (department_id);

create table dept as select * from departments

drop table  dept


/* Formatted on 5/27/2018 10:59:33 AM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PROCEDURE add_dept (
   id     IN departments.department_id%TYPE,
   name   IN departments.department_name%TYPE,
   loc    IN departments.location_id%TYPE)
IS
BEGIN
   INSERT INTO dept (department_id, department_name, location_id)
        VALUES (id, name, loc);
END add_dept;

exec add_dept(280, 'TRAINING', 2500);

exec add_dept(290, 'EDUCATION', 2600);

exec add_dept(300, 'EDUCATION', 2600);



select * from dept

select * from emp where lower(last_name)  = 'king';
commit;

CREATE OR REPLACE PROCEDURE process_employees
IS
CURSOR emp_cursor IS
SELECT employee_id
FROM emp;
BEGIN
FOR i IN emp_cursor
LOOP
raise_salary(i.employee_id, 10);
END LOOP;


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




CREATE OR REPLACE PROCEDURE process_employees
IS
   CURSOR emp_cursor IS
    SELECT employee_id
    FROM   emp;
BEGIN
   FOR i IN emp_cursor 
   LOOP
     raise_salary(i.employee_id, 10);
   END LOOP;    
   COMMIT;
END process_employees;

exec process_employees

--==========

drop table emp;

create table emp as 
select * from employees

alter table emp
add constraint emp_emp1_id_pk primary key (employee_id);

select * from emp

--========================
CREATE PROCEDURE add_department (
  name varchar2;
)

select text from user_source where name = 'ADD_DEPT' and type ='PROCEDURE';

select distinct(type) from user_source ;

select object_name from user_objects
where object_type = 'PROCEDURE';

select object_name from user_objects
where object_type = 'FUNCTION';

select object_name from user_objects
where object_type = 'TRIGGER';

--===================

declare
fname varchar2(25);
BEGIN 
SELECT last_name into fname from emp
WHERE employee_id= 196;
DBMS_OUTPUT.put_line(fname);
END;

DECLARE
 SUM_SAL number;
 DEPT_NO number := '&DEPT_NO';
 BEGIN
 select sum(salary) into sum_sal from employees
 where department_id = '&DEPT_NO';
 DBMS_OUTPUT.put_line(SUM_SAL ||' ' ||DEPT_NO );
 END;


CREATE SEQUENCE empl_seq
 START WITH     1000
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
 
 drop sequence empl_seq;
 
 create table empl as select * from employees where last_name = 'rana'
 
  select * from empl where last_name = 'rana'
  
  delete from empl where last_name = 'rana';
  
  alter table empl 
  add constraint empl_empid_pk primary key(employee_id);
 
 BEGIN 
 INSERT INTO empl (employee_id,first_name, last_name,email, hire_date,job_id, salary)
 VALUES(empl_seq.nextval, 'sohel', 'rana','sohel@gmail.com','01-JAN-1999', 'IT_PROG', 202000);
 END;
 
 
DECLARE 
sal_increase   employees.salary%type := 800;
begin
update employees
set salary = salary + sal_increase
where job_id = 'ST_CLERK';
end;


--Class13 31-5-2018
--================
--Stored Function




CREATE or REPLACE FUNCTION get_sal
(id emp.employee_id%type) return number
IS
sal emp.salary%type :=0;
BEGIN
select salary into sal from emp
where employee_id= id;
return sal;
END get_sal;


exec DBMS_OUTPUT.put_line(get_sal(100));


DECLARE sal emp.salary%type;
BEGIN
sal := get_sal(100);
DBMS_OUTPUT.put_line(sal);
END get_sal;

SELECT job_id , get_sal(employee_id) FROM emp;

alter table emp 
drop column salary;

CREATE OR REPLACE FUNCTION tax(VAL IN NUMBER)
RETURN NUMBER IS
BEGIN
RETURN ( VAL * 10);
END tax;


SELECT employee_id, last_name , salary, tax(salary)
FROM employees
where department_id = 60;

exec DBMS_OUTPUT.put_line(tax(50000));

drop table emp;

create table emp as select * from employees;

select employee_id ,tax(salary)
from employees
where tax(salary) > (select max(tax(salary))
from employees
where department_id = 30)
order by tax(salary) desc;




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

CREATE OR REPLACE FUNCTION dml_call_sql(sal NUMBER)
RETURN number
IS
BEGIN
INSERT INTO emp(employee_id, last_name, email,hire_date,job_id,salary)
VALUES (1200, 'sohel', 'sohel@gmail.com', sysdate, 'SA_MAN', sal);
RETURN (sal + 100);
END;

exec DBMS_OUTPUT.put_line(dml_call_sql(8000));


select * from emp where employee_id = 1200;


delete emp where employee_id = 1200;


alter table emp add constraint emp_id_pk primary key(employee_id);

select object_name
from user_objects
where object_type = 'FUNCTION'


select object_name
from user_objects
where object_type = 'PROCEDURE'

select object_name
from user_objects
where object_type = 'TRIGGER'


--Class14           3-6-2018
--================
--Package

CREATE OR REPLACE PACKAGE comm_pkg IS
  std_comm NUMBER := 0.10;  --initialized to 0.10
  PROCEDURE reset_comm(new_comm NUMBER);
END comm_pkg;



CREATE OR REPLACE PACKAGE BODY comm_pkg IS
  FUNCTION validate(comm NUMBER)
   RETURN BOOLEAN 
   IS
    max_comm employees.commission_pct%type;
  BEGIN
    SELECT MAX(commission_pct) INTO max_comm
    FROM   employees;
    RETURN (comm BETWEEN 0.0 AND max_comm);
  END validate;
  PROCEDURE reset_comm (new_comm NUMBER) IS BEGIN
    IF validate(new_comm) THEN
      std_comm := new_comm; -- reset public var
    ELSE  RAISE_APPLICATION_ERROR(
            -20210, 'Bad Commission');
    END IF;
  END reset_comm;
END comm_pkg;

exec  comm_pkg.reset_comm(0.15);

rollback;


select employee_Id , last_name ,commission_pct from employees
where commission_pct is not null;




CREATE OR REPLACE PACKAGE hrm
IS
PROCEDURE hire(empno number,
                           fname   varchar2,
                           lname varchar2,
                           email   varchar2,
                           hdate    date,
                           jobid     varchar2
                           );
 PROCEDURE fire(empno number);
 END;
 
 
 CREATE OR REPLACE PACKAGE BODY hrm
 AS
 PROCEDURE hire(empno number,
                           fname   varchar2,
                           lname varchar2,
                           email   varchar2,
                           hdate    date,
                           jobid     varchar2
                           )
IS 
BEGIN
insert into emp(EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
VALUES(empno, email, lname,email ,to_date(hdate),jobid);
COMMIT;
end hire;
PROCEDURE fire(empno number)
IS
BEGIN 
DELETE from emp 
WHERE employee_id = empno;
commit;
END fire;
END;

exec hrm.hire(500, 'Rahim', 'Ahmed','Rahim@gmail.com',to_date('01-JAN-2017'), 'IT_PROG');

exec hrm.fire(500);

select * from emp where employee_id = 500;

--=======================================================
create or replace package body comm_pkg
IS
function validate(comm number) 
return boolean 
IS
max_comm employees.commission_pct%type ;
begin
select max(commission_pct) INTO max_comm
from employees;
return (comm between 0.0 and max_comm);
END validate;
procedure reset_comm(new_comm number)
is 
begin
if validate (new_comm) then 
std_comm := new_comm;
else RAISE_EXCEPTION_ERROR(-20210,'Bad commission');
end if;
end reset_comm;
end comm_pkg;

--===================================
--Class15           10-JUN-2018
--================
--Trigger

 --trigger 2 prokar ,application trigger, database trigger    
  --trigger 2 type ,statement  trigger, raw trigger     
  --three event a trigger fire hoe -- insert, update , delete    
  
 select object_name
from user_objects
where object_type = 'TRIGGER'

SECURE_EMPLOYEES

UPDATE_JOB_HISTORY
  
/* Formatted on 6/10/2018 12:51:12 PM (QP5 v5.163.1008.3004) */
INSERT INTO employees
     VALUES (207,
             'William',
             'Gietz',
             'WGIETZ@gmail.com',
             '515.123.8181',
             '6-JUN-1994',
             'AC_ACCOUNT',
             8300,
             NULL,
             205,
             110);
 
commit;

delete from employees
where employee_id = 207; 

 
update employees
set salary = 20000
where employee_id = 206;
  
ALTER TRIGGER HR.SECURE_EMPLOYEES DISABLE;

ALTER TRIGGER HR.SECURE_EMPLOYEES ENABLE;

ALTER TRIGGER HR.secure_emp DISABLE;
 
 
/* Formatted on 6/10/2018 12:50:43 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE TRIGGER secure_emp
   BEFORE INSERT
   ON employees
BEGIN
   IF (TO_CHAR (SYSDATE, 'DY') IN ('FRI', 'SUN'))
      OR (TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '09:00' AND '16:00')
   THEN
      RAISE_APPLICATION_ERROR (
         -20500,
            'you may insert'
         || 'employees table only during '
         || 'BUsiness Houre');
   END IF;
END;
 
 
/* Formatted on 6/10/2018 12:50:58 PM (QP5 v5.163.1008.3004) */
CREATE OR REPLACE TRIGGER secure_emp
   BEFORE INSERT OR UPDATE OR DELETE
   ON employees
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
 
 CREATE OR REPLACE TRIGGER restrict_salary
 BEFORE INSERT OR UPDATE OF SALARY ON EMPLOYEES
 FOR EACH row
 BEGIN
 IF NOT(:NEW.JOB_ID in ('AD_PRES' , 'AD_VP'))
 AND :new.SALARY >15000 THEN
 RAISE_APPLICATION_ERROR (-20202 , 'USER CAN NOT EARN MORE THAN $15000.');
 END IF;
 END;
  
update employees
set salary = 5000
where employee_id = 107


 
 UPDATE_JOB_HISTORY
 
 CREATE OR REPLACE TRIGGER HR.update_job_history
  AFTER UPDATE OF job_id, department_id ON HR.EMPLOYEES   FOR EACH ROW
BEGIN
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


CREATE OR REPLACE PROCEDURE HR.add_job_history
  (  p_emp_id          job_history.employee_id%type
   , p_start_date      job_history.start_date%type
   , p_end_date        job_history.end_date%type
   , p_job_id          job_history.job_id%type
   , p_department_id   job_history.department_id%type
   )
IS
BEGIN
  INSERT INTO job_history (employee_id, start_date, end_date,
                           job_id, department_id)
    VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history;
/
/*<TOAD_FILE_CHUNK>*/

 
 
 select * from employees
 
INSERT INTO employees
     VALUES (207,
             'William',
             'Gietz',
             'WGIETZ@gmail.com',
             '515.123.8181',
             '6-JUN-1994',
             'AC_ACCOUNT',
             8300,
             NULL,
             205,
             110);

update employees 
set job_id = 'AC_MGR'
where employee_id = 107

commit;
--============================= instade of trigger===================

--Creating customer_details table.
 
CREATE TABLE customer_details
(
    customer_id number(10) primary key,
    customer_name varchar2(20),
    country varchar2(20)
);


 
--Creating projects_details table.
 
CREATE TABLE projects_details
(
    project_id number(10) primary key,
    project_name varchar2(30),
    project_start_Date date,
    customer_id number(10) references customer_details(customer_id)
);

--Creating VIEW customer_projects_view
 
CREATE OR REPLACE VIEW customer_projects_view AS
   SELECT cust.customer_id, cust.customer_name, cust.country,
          projectdtls.project_id, projectdtls.project_name, projectdtls.project_start_Date
   FROM customer_details cust, projects_details projectdtls
   WHERE cust.customer_id = projectdtls.customer_id;


INSERT INTO customer_projects_view VALUES (1,'XYZ Enterprise','Japan',101,'Library management',sysdate);


--Creating trigger
 
CREATE OR REPLACE TRIGGER trg_cust_proj_view_insert
   INSTEAD OF INSERT ON customer_projects_view
   DECLARE
     duplicate_info EXCEPTION;
     PRAGMA EXCEPTION_INIT (duplicate_info, -00001);
   BEGIN
     
   INSERT INTO customer_details
       (customer_id,customer_name,country)
     VALUES (:new.customer_id, :new.customer_name, :new.country);
     
   INSERT INTO projects_details (project_id, project_name, project_start_Date, customer_id)
   VALUES (
     :new.project_id,
     :new.project_name,
     :new.project_start_Date,
     :new.customer_id);
  
   EXCEPTION
     WHEN duplicate_info THEN
       RAISE_APPLICATION_ERROR (
         num=> -20107,
         msg=> 'Duplicate customer or project id');
   END trg_cust_proj_view_insert;
   
   
   
INSERT INTO customer_projects_view VALUES (1,'XYZ Enterprise','Japan',101,'Library management',sysdate);

INSERT INTO customer_projects_view VALUES (2,'ABC Infotech','India',202,'HR management',sysdate);

INSERT INTO customer_projects_view VALUES (3,'ABC Infotech','India',203,'HR management',sysdate);


--==============================================================================================================================

select * from AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'EMPLOYEE' and CREATION_DATE between '01-JAN-2019' and '03-JuN-2019'

select * from AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'FOREIGN SUPPLIER'

select * from AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'SERVICE PROVIDER'

select * from AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'LOCAL SUPPLIER'

select * from AP_SUPPLIERS where VENDOR_TYPE_LOOKUP_CODE = 'DRIVER'

---======================================================== 


--========================================================












select distinct VENDOR_TYPE_LOOKUP_CODE from ap_suppliers
