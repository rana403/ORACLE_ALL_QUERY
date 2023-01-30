--select last_name, job_id, salary of employees whos employee id 141's job_id and 143's greater salary
SELECT last_name, job_id, salary, employee_id
 from employees 
 where job_id = (select job_id from employees where employee_id=141) 
 and salary > (select salary from employees where employee_id=143);
 
 
--display last name salary, job_id from emploies who get les than max salary and  greater than 10000  salary
SELECT last_name, salary, job_id from employees
where salary < (select max(salary) from employees)
and salary > 10000;



--50 dept er minimum salary joto tar theke besi minimum salary kon kon department pae tader department_id and minnimum salary ber koro

select department_id , min(salary) 
from employees 
group by department_id
HAVING min(salary) > (select min(salary) from employees where department_id = 50);

select * from employees where first_name = 'Haas'

-- Has er job id  er soman jader job id tader  last_name and job_id ber koro

select last_name , job_id from employees where job_id  = (select job_id from employees where  last_name = ('Hall'));


SELECT employee_id, last_name, job_id, salary from employees where salary > ANY  (select salary from employees where job_id = 'IT_PROG') 
AND job_id<> 'IT_PROG'
order by salary desc

SELECT employee_id, last_name, job_id, salary from employees where salary < ANY  (select salary from employees where job_id = 'IT_PROG') 
AND job_id<> 'IT_PROG'
order by salary desc

SELECT employee_id, last_name, job_id, salary from employees where salary > ALL  (select salary from employees where job_id = 'IT_PROG') 
AND job_id<> 'IT_PROG'
order by salary desc

SELECT employee_id, last_name, job_id, salary from employees where salary < ALL  (select salary from employees where job_id = 'IT_PROG') 
AND job_id<> 'IT_PROG'
order by salary desc




select last_name, salary  from employees where employee_id  in ( select employee_id  from employees where last_name= 'King' )


select last_name, salary, job_id
from employees
where manager_id = any (select employee_id
                                from employees
                                where last_name = 'King')
                                
     --same query with join table                           
  select e.Department_id ,e.last_name, e.job_id, d.department_name  from employees e ,departments d    where e.department_id= d.department_id
  and d.department_name = 'Executive'
   --same query with  subquery       
  select department_id, last_name, job_id from employees where department_id in (select department_id from departments where department_name ='Executive');
  
  select last_name , to_char(hire_date)  from employees where department_id in (select department_id  from employees where  last_name = '&enter_name3' and last_name <> '&enter_name3');
  
   
  select department_id  from employees where last_name = '&last_name'
  
  select * from  employees where Department_id= 20 departments
  
  select count(department_id) from employees where last_name ='King'
  
     --same query with  subquery   
  select employee_id , last_name from employees where department_id in (select department_id  from employees where last_name like '%u%');
  
     --same query with join table     
    select e.employee_id , e.last_name, d.department_name from employees e, departments d  where e.department_id = d.department_id and e.department_id in (select department_id  from employees where last_name like '%u%');
  
  
 select distinct(department_id)  from employees where last_name like '%u%'
 
 -- LSSON -06
 
 select location_id,STREET_ADDRESS,city,STATE_PROVINCE,COUNTRY_NAME FROM locations natural join countries;
 
  select location_id,STREET_ADDRESS,city,STATE_PROVINCE,COUNTRY_NAME FROM countries natural join locations ;
  
  select e.employee_id, e.last_name, e.department_id, d.department_name from employees e, departments d where e.department_id = d.department_id
  
  select e.last_name, e.job_id, e.department_id, d.department_name, l.city  from employees e, departments d, locations l,countries c 
  where e.department_id = d.department_id 
  AND d.location_id = l.location_id 
  AND e.manager_id = d.manager_id
  AND l.city = 'Toronto'
  
  select  last_name, salary, to_char(hire_date) from employees where hire_date > (select to_char(hire_date) from employees where last_name = 'Davies')
  
  select MIN(to_char(hire_date)) from employees where last_name = 'Davies'
  
    select MAX(to_char(hire_date)) from employees
    
      select MIN(to_char(hire_date)) from employees

    select last_name , employee_id, manager_id from employees where department_id = 60;
  
  
  select * from locations where upper(city)  like '%TOR%'
  
  select * from locations
  
    select * from employees
    
    select e.employee_id ,e.first_name,e.last_name Employee ,e.manager_id ,m.last_name Manager from employees e , employees m where e.manager_id=  m.employee_id --and m.employee_id=201;
    
    
    select e.employee_id ,e.first_name,e.last_name Employee ,e.manager_id ,m.last_name Manager from employees e , employees m where e.manager_id=  m.employee_id and m.employee_id=100;
    
    select  distinct(department_id) from employees where department_id in (select department_id  from employees where  last_name = 'King')
    
    
    select distinct(manager_id) from employees where manager_id  is not null
    
    SELECT last_name FROM   employees WHERE  salary > (SELECT salary FROM   employees  WHERE  last_name = 'Abel')
    
    select * from JOB_HISTORY where job_id = 'IT_PROG' 
    
    SELECT last_name, job_id, salary FROM   employees WHERE  salary  =  (SELECT min(salary)   FROM   employees);  
    
    SELECT   department_id, MIN(salary) FROM   employees GROUP BY department_id HAVING   MIN(salary) >  (SELECT MIN(salary)   FROM   employees  WHERE  department_id = 50);
    
    
   select employee_id, job_id from employees 
   INTERSECT  
   select employee_id, job_id from job_history  order by employee_id
   
    
     select employee_id, job_id from employees 
    UNION ALL -- INTERSECT  
   select employee_id, job_id from job_history  
   where job_id in ('SA_REP', 'SA_REP')
   order by employee_id 
    

    select employee_id, job_id from employees 
    INTERSECT  
   select employee_id, job_id from job_history  
   order by employee_id 
   
   
  select employee_id, job_id from employees 
    minus 
   select employee_id, job_id from job_history  order by employee_id 
   order by employee_id 
 
 
   select employee_id, job_id from employees 
    minus 
   select employee_id, job_id from job_history  order by employee_id 
   
   
   select last_name,department_id , to_number(NULL) Location, hire_date from employees 
   UNION ALL
   select  null,department_id, location_id, to_date(NULL) from departments
   
   
select employee_id, JOB_ID, SALARY FROM EMPLOYEES
where manager_id is not null
UNION 
select employee_id, JOB_ID, 0 FROM job_history
where employee_id= 176

SELECT 'sing' AS "MY DREAM", 3 A_DUMMY FROM DUAL
UNION
SELECT 'I d like to teach' AS "MY DREAM", 2 A_DUMMY FROM DUAL
UNION
SELECT 'the world' AS "MY DREAM", 1 A_DUMMY FROM DUAL
order by  A_DUMMY
 
   
  select department_id from departments 
   MINUS
    select department_id from job_history
    where job_id <> 'ST_CLERK'
         


select c.country_id , c.country_name from countries c 
minus
select c.country_id,c.country_name  from COUNTRIES c, locations l, departments d
where c.country_id=l.country_id
and l.location_id= d.location_id

select job_id, department_id, 1 A_DUMMY 
 from employees 
where department_id = 10
UNION 
select job_id, department_id, 2 A_DUMMY  
from employees 
where department_id = 50
UNION
select job_id, department_id , 3 A_DUMMY 
from employees 
where department_id = 20
order by A_DUMMY 

   select employee_id, job_id from employees 
  MINUS-- INTERSECT  
   select employee_id, job_id from job_history  order by employee_id
   
   select employee_id from employees 
   
   --====================================
    
   select  last_name, department_id, NULL Department
   from employees 
 where department_id= 60
   UNION 
 select NULL , d.department_id , d.department_name
    from departments d
    
    select 
    
    select distinct(job_id) from jobs
    
     select job_id from jobs
     
     select * from jobs
    


select * from employees where job_id = 'IT_PROG'  



SELECT employee_id, job_id FROM   employees
union
 SELECT employee_id, job_id FROM   job_history; 
 
 
 SELECT employee_id, job_id, department_id 
 FROM   employees 
 UNION ALL 
 SELECT employee_id, job_id, department_id
  FROM   job_history 
  Where Employee_id = 101
  ORDER BY  employee_id; 
  
  
  
  
  SELECT employee_id, job_id, department_id
  FROM   employees 
  where employee_id in (176, 200)
    UNION -- ALL --INTERSECT 
  SELECT employee_id, job_id, department_id
  FROM   job_history; 
  
  select * from employees where employee_id in (176, 200)
  
  SELECT employee_id ,job_id 
  FROM   employees 
  MINUS 
  SELECT employee_id, job_id FROM   job_history
  
   select distinct(employee_id) FROM   job_history;
   
   
      select distinct(employee_id) FROM   job_history;
      
         select distinct(job_id) FROM   job_history;
         
            select distinct(department_id) FROM   job_history;
   
   select * from job_history
   
   
   select * from employees where job_id = 'IT_PROG'  
  
  
 
 select * from job_history where job_id='IT_PROG'
 
  select job_id from employees where employee_id= '101'               --'176'
  
  select e.last_name, d.department_name , j.job_id , e.employee_id from employees e, departments d, job_history j
  where e.department_id = d.department_id 
  AND d.department_id = j.department_id
  AND e.job_id = j.job_id
  AND e.employee_id = j.employee_id
 --AND j.end_date is not null
 
 
 select  e.employee_id , e.job_id, e.department_id from employees e
Intersect
 select j.employee_id , j.job_id, j.department_id from job_history j
 
 SELECT employee_id,job_id , department_id
  FROM   job_history 
 MINUS
 SELECT employee_id,job_id , department_id
  FROM   employees  ;
  
    select * from employees where employee_id in (176, 200)
    
    
    SELECT employee_id,job_id FROM   employees MINUS SELECT employee_id,job_id FROM   job_history; 
    
    
    select * from employees where job_id = 'ST_CLERK'
    
    
        select * from employees where department_id = '80' 
        
      
      select salary from employees where job_id = 'SA_MAN'  
      
      SELECT employee_id, job_id, salary FROM   employees 
      UNION  
       SELECT employee_id, job_id, 0 FROM   job_history order by 1;
       
       
       --===========================================
       -- CREATE , DELETE, 
       
           create table dept as select * from departments;
            create table dept_copy  as select * from departments;
           create table emp as select * from employees ;
       
       
       select * from emp
       
       drop table emp;
       DELETE from dept_copy
       truncate table dept_copy  -- ALL data will be deleted
       drop table dept_copy -- all data with structure will be deleted
       
       delete from emp where employee_id = 207
       

select * from dept;

select * from emp
where employee_id = 207
order by employee_id desc;

insert into emp (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, HIRE_DATE,JOB_ID)
VALUES(207, 'SOHEL', 'HOSSAIN','sohel.hossain@ksrm.com.bd','01-MAR-2017','IT_PROG')

insert  into dept(DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES(280, 'ERP');

insert into emp 
select * from employees 
where department_id = 70

select * from dept order by department_id desc

select * from emp where employee_id = 207 order by employee_id desc


update emp 
set job_id = (select job_id
                    from employees
                       where employee_id = 100),
       salary =(select salary from employees where  employee_id = 100)
  where employee_id =207
                
   SELECT *  from emp where last_name = 'HOSSAIN'             
 DELETE from emp where last_name = 'HOSSAIN'
 
 
select * FROM EMPLOYEES WHERE MANAGER_ID IS NULL

select department_name from departments where department_id =90

select * FROM employees where department_ID = 90

select * from jobs 
 
 delete from emp
 where department_id = (select department_id
                                      from departments where department_name like '%Public%')
  
 select * from emp where department_id like '%70%'
                                     
 update emp
 SET department_id
 where department_id = (select department_id
                                      from departments where department_name like '%Public%') ;                                   
 
      select * from departments  where department_name like '%Public%'
      
      
            select * from dept  where department_name like '%Public%'           
            select * from emp where department_id = 70            
            select * from employees where department_id = 70
            insert into emp ()

insert into dept(DEPARTMENT_ID,DEPARTMENT_NAME,LOCATION_ID)
VALUES(&DEPT_ID, '&DEPARTMENT_NAME', &LOCATION_ID);

COMMIT;

select * from dept where department_name = 'ICT'

delete from  dept where department_name = 'ICT'

select * from departments order by department_id desc;





insert into emp (EMPLOYEE_ID, LAST_NAME, SALARY, COMMISSION_PCT,EMAIL, hire_date, job_id)
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, COMMISSION_PCT, EMAIL, hire_date, job_id
FROM EMPLOYEES 
WHERE JOB_ID LIKE '%REP%';

select * from emp where job_id like '%REP%'

delete from emp where job_id like '%REP%'



SELECT EMPLOYEE_ID, LAST_NAME, SALARY, COMMISSION_PCT, EMAIL, hire_date, job_id
FROM emp WHERE JOB_ID LIKE '%REP%';

insert into employees (employee_id, first_name, last_name, email, hire_date,job_id, ) 

update emp
SET salary  = 1000
where salary < 900;

select * from emp where salary  < 900

select * from emp where department_id = 280

commit;




--=====================================================
   -- CREATE , DELETE, 
       
           create table dept as select * from departments;
           
            create table dept_copy  as select * from departments;
            
           create table emp as select * from employees ;
              
       select * from emp
       
       drop table emp;
       DELETE from dept_copy
       truncate table dept_copy  -- ALL data will be deleted
       drop table dept_copy -- all data with structure will be deleted


--===================================

select * from emp where first_name ='MAMUN'

insert into emp (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, HIRE_DATE,JOB_ID)
VALUES(208, 'MAMUN', 'HOSSAIN','mamun.hossain@ksrm.com.bd','01-MAR-2017','IT_PROG')

savepoint a

commit;

select * from emp where first_name ='MAMUN'

 update emp 
set job_id = (select job_id from employees where employee_id = 100), salary =(select salary from employees where  employee_id = 100) where employee_id =208

savepoint b

commit;

rollback to savepoint a ;

select * from emp  where employee_id=208 ;

delete from emp where employee_id=208 ;

select * from emp;

delete from emp;

rollback;

select * from emp where first_name ='MAMUN';

rollback;

--=======================================

DROP TABLE EMP2;

DESC EMP2;

CREATE TABLE  EMP2
(
EMP_ID              number   PRIMARY KEY,
EMP_NAME         varchar2(40),
EMAIL                varchar2(25),
JOB_ID                varchar2(25),
DOB                   date,
JOIN_DATE         date,
NID                   number,
salary              number
);





insert into EMP2 (EMP_ID, EMP_NAME,EMAIL,JOB_ID,DOB,JOIN_DATE,NID) VALUES(1, 'MAMUN','mamun@gmail.com','IT_PROG','01-MAR-2010', '01-APR-1988', 1123212222);

update emp2  set salary = 20000;

truncate table emp2;

SELECT * FROM EMP2;

select * from emp where department_id = 50

select * from emp where employee_id = 99999

INSERT INTO         (SELECT employee_id, last_name,                 email, hire_date, job_id, salary,                  department_id          FROM   emp         WHERE  department_id = 50)  VALUES (99999, 'Taylor', 'DTAYLOR',         TO_DATE('07-JUN-99', 'DD-MON-RR'),         'ST_CLERK', 5000, 50);

SELECT employee_id, last_name,   email, hire_date, job_id, salary,   department_id          FROM   employees       WHERE  department_id = 50;

select * from emp where employee_id = 99999

commit;

 delete from emp where employee_id = 99999
 
rollback;

REGIONS           =  REGION_ID  
COUNTRIES       =  REGION_ID                    
LOCATIONS       = COUNTRY_ID                  
DEPARTMENTS  =  LOCATION_ID              
JOBS                 =    JOB_ID            
EMPLOYEES       =  DEPARTMENT_ID ,  MANAGER_ID,    JOB_ID                   
JOB_HISTORY    = JOB_ID  ,  DEPARTMENT_ID, EMPLOYEE_ID  

INSERT INTO dept (department_id, department_name, location_id) VALUES(&DEPARTMENT_ID, '&department_name','&location');
 

select * from dept
WHERE department_id= 300

CREATE TABLE Bank_K (
Bank_Account_No VARCHAR2 (50) PRIMARY KEY not null,
Bank_Name  VARCHAR2 (50) not null,
Branch_Name  VARCHAR2 (50) not null,
LE_Name  VARCHAR2 (50) not null,
Opening_Date Date
)

CREATE TABLE KSRM_EMP
(
employee_id number(6) CONSTRAINT KSRM_EMP_ID_PK PRIMARY KEY,
first_name  varchar2(30),
last_name  varchar2(30) CONSTRAINT KSRM_EMP_LAST_NM NOT NULL,
email         varchar2(30) CONSTRAINT KSRM_EMP_EMIL_NM NOT NULL CONSTRAINT KSRM_EMP_EMAIL_UK  UNIQUE,
phone_number   varchar2(18),
hire_date date CONSTRAINT KSRM_EMP_HIRE_D NOT NULL,
job_id   varchar2(20) CONSTRAINT KSRM_EMP_JOB_ID NOT NULL,
salary   number(8,2) CONSTRAINT KSRM_EMP_SALAY_CK  CHECK (SALARY>0),
commission_pct number(2,2),
manager_id number(6),
department_id  number(4) CONSTRAINT KSRM_EMP_DEPT_FK REFERENCES departments(department_id));


drop table KSRM_EMP;

commit;


select * from KSRM_EMP;

insert into KSRM_EMP
(select * from hr.employees);

--======================================================

-- SECOND HIGHEST SALARY
SELECT  MAX(salary) AS salary
  FROM employees
 WHERE salary < (SELECT MAX(salary)
                 FROM employees);
                 
                 select max(salary) from employees 
                 where salary<(select max(salary) from employees) where salary < (select max(salary) from employees )
                 
                 
                 
                 
                  
 -- THIRD HIGHEST SALARY              
select MAX(Salary) from employees where salary <(select MAX(Salary) from employees where salary <(select MAX(Salary) from employees) );






-- TOP  2 SALARY list
select FIRST_NAME|| ' '||LAST_NAME NAME, SALARY  from (select * from employees order by salary desc ) where rownum <3  

select rownum, salary from employees order by rownum

select rownum, salary from (select salary from employees order by salary desc) 



-- LOWEST 2 SALARY list
select FIRST_NAME|| ' '||LAST_NAME NAME, SALARY  from (select * from employees order by salary ) where rownum< 3



--======================SEQUENCE =================================


Create SEQUENCE DEPT_ID_SEQUENCE
INCREMENT BY 10
START WITH 400 
MAXVALUE 9999;


ALTER  SEQUENCE DEPT_ID_SEQUENCE
INCREMENT BY 20
MAXVALUE 9999;


DROP SEQUENCE DEPT_ID_SEQUENCE

select DEPT_ID_SEQUENCE.NEXTVAL FROM DUAL

select DEPT_ID_SEQUENCE.CURRVAL FROM DUAL

select * from dept where department_name = 'KML' order by department_id desc

INSERT INTO DEPT (department_ID, DEPARTMENT_NAME, location_id)
                      values (DEPT_ID_SEQUENCE.nextval, 'KML', 2500)
                      
                      
--================= INDEX=======================
--INDEX IS A SCEMA OBJECT

CREATE INDEX EMP_LAST_NAME_INDXS
ON EMPLOYEES EMPLOYEES(first_name);

drop index EMP_LAST_NAME_INDX;



CREATE PUBLIC SYNONYM  EMP_SUM
FOR KSRM_EMP

select * from user_tables



--======================================

select * from (select distinct salary from employees order by salary desc) where rownum <=3
and  salary not in (SELECT )


select * from (select distinct salary 
from employees
order by salary desc)
where rownum <=1
and salary not in (select * from (select distinct salary from employees
order by salary desc)
where rownum <=1)

DICTIONARY

SELECT *  FROM all_users;

SELECT * FROM USER_OBJECTS where CREATED between  '01-APR-2018' and '07-APR-2018' and object_type = 'TABLE'

SELECT * FROM ALL_OBJECTS WHERE OBJECT_TYPE = 'VIEW'

SELECT * FROM ALL_PROCEDURES ''


SELECT count(OBJECT_NAME) from USER_OBJECTS where object_type = 'INDEX'


SELECT  count(OBJECT_NAME) from USER_OBJECTS where status = 'INVALID'

SELECT* from USER_TABLES 

SELECT * FROM USER_TAB_COLUMNS;

select * from user_constraints;

select OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION,R_CONSTRAINT_NAME,DELETE_RULE,STATUS
 from user_constraints 
where lower(table_name) = 'emp'


SELECT TEXT
FROM user_views
WHERE VIEW_NAME = 'EMP_DETAILS_VIEW';

COMMENT ON TABLE employees 
IS 'employee Information';

ALL_COL_COMMENTS


--=========CLASS 6 EXERCISE=============
--Write a query for the HR department to produce the addresses of all the departments. Use the LOCATIONS and COUNTRIES tables. Show the location ID, street address, city, state or province, and country in the output. Use a NATURAL JOIN to produce the results. 
 countries
 locations  
 
 SELECT 
  c.LOCATION_ID     
 , c.STREET_ADDRESS 
 ,c.CITY,
 c.STATE_PROVINCE
 , l.COUNTRY_NAME,
 COUNTRY_ID
 FROM LOCATIONS l , COUNTRIES c
 NATURAL JOIN    COUNTRY_ID;    
 
 1.
 
 SELECT LOCATION_ID,STREET_ADDRESS,POSTAL_CODE,CITY , COUNTRY_NAME
 FROM LOCATIONS 
 NATURAL JOIN COUNTRIES

2.

SELECT
e.last_name, e.department_id, d.department_name from employees e, departments d
where e.department_id = d.department_id

3.

SELECT e.last_name, e.job_id, d.department_id, d.department_name, l.city, countrY_NAME c 
 from employees e,
 departments d,
 locations l, 
 countries C
 where e.department_id = d.department_id 
 and d.location_id = l.location_id
 and e.manager_id = d.manager_id
 and C.COUNTRY_ID = L.COUNTRY_ID
and l.city = 'Toronto';




SELECT e.first_name ||'-' ||e.last_name, e.job_id, e.department_id, m.manager_id
 from employees e, employees m
 where e.manager_id = m.employee_id
 AND m.manager_id is  null;
 
 
 departments d,
 locations l
 where e.department_id = d.department_id 
 and d.location_id = l.location_id
 AND l.manager_id= 
and l.city = 'Toronto';

select e.last_name, e.job_id, e.department_id, d.department_name, l.city  from employees e, departments d, locations l,countries c 
  where e.department_id = d.department_id 
  AND d.location_id = l.location_id 
  AND e.manager_id = d.manager_id
  AND l.city = 'Toronto'
  
  select e.last_name, e.job_id, e.department_id, d.department_name, l.city  from employees e, departments d, locations l,countries c 
  where e.department_id = d.department_id 
  AND d.location_id = l.location_id 
  AND e.manager_id = d.manager_id
  AND l.city = 'Toronto'
  
  SELECT e.last_name, e.job_id, d.department_id, d.department_name, l.city
 from employees e,
 departments d,
 locations l, 
 countries C
 where e.department_id = d.department_id 
 and d.location_id = l.location_id
 and e.manager_id = d.manager_id
 and C.COUNTRY_ID = L.COUNTRY_ID
and l.city = 'Toronto';


6.

select last_name , department_id from employees where department_id = '&DEPT_ID'

7.

SELECT LAST_NAME, TO_CHAR(HIRE_DATE) 
FROM EMPLOYEES WHERE HIRE_DATE >= (SELECT to_char(HIRE_DATE) FROM EMPLOYEES WHERE LAST_NAME='Davies' )

8. 

select LAST_NAME , HIRE_DATE 
FROM EMPLOYEES WHERE Hire_date in (SELECT Hire_date from employees where manager_id is not null )

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID=80


--===================================================================================

select  a.last_name , a.department_id , a.salary, b.avgsal , b.department_name
from employees a, (select d.department_id, d.department_name, ROUND(AVG(e.salary)) avgsal from employees e, departments d where e.department_id = d.department_id group by d.department_id, d.department_name ) b
where a.department_id = b.department_id 
and a.salary > b.avgsal


select  e.last_name , e.department_id , e.salary, round(avgsal), d.department_name from employees e, (select department_id, AVG(salary) avgsal from employees group by department_id ) b, departments d
where e.department_id = b.department_id 
AND e.department_id = d.department_id
and e.salary > b.avgsal


--==========================================================
select * FROM tab;

create table emp3 as select * from employees;

select * from emp3;

alter table emp3 
add constraint emp2_pk   primary key(employee_id);


alter table emp3
add constraint emp2_mangr_fk
 FOREIGN KEY(manager_id)
 REFERENCES employees(employee_id)
 
 alter table emp3 
 add (sohel VARCHAR2(20));
 
 
 
 HR wants to display highest paid employee of every department..
Show last name, department name & salary amount

select last_name,department_id, salary from employees
where salary in (select max(salary) from employees group by department_id);

select distinct(department_id) from departments
order by department_id desc;

select last_name, department_id, salary
from ( ) e
where salary = dept_max_sal;


select last_name, department_id, salary
from (select last_name, department_id, salary, max(salary) from employees group by department_id) e
where salary = dept_max_sal;


select * from departments


select * from employees where department_id is null

select distinct(department_id) from employees
order by department_id desc


SELECT employee_id, department_id, COUNT(*) 
OVER (PARTITION BY employee_id) DEPT_COUNT
FROM employees;

SELECT employee_id, department_id, COUNT(*) 
--OVER (PARTITION BY department_id) DEPT_COUNT
group by employee_id, department_id
FROM emp;

REGIONS           =  REGION_ID  
COUNTRIES       =  REGION_ID                    
LOCATIONS       = COUNTRY_ID                  
DEPARTMENTS  =  LOCATION_ID              
JOBS                 =    JOB_ID            
EMPLOYEES       =  DEPARTMENT_ID ,  MANAGER_ID,    JOB_ID                   
JOB_HISTORY    = JOB_ID  ,  DEPARTMENT_ID, EMPLOYEE_ID 

--=======================

CREATE TABLE Bank_K (
Bank_Account_No VARCHAR2 (50), --PRIMARY KEY not null,
Bank_Name  VARCHAR2 (50) not null,
Branch_Name  VARCHAR2 (50) not null,
LE_Name  VARCHAR2 (50) not null,
manager_id number(20),
Opening_Date Date
);

drop table Bank_k;

alter table Bank_k
modify Bank_Account_No PRIMARY KEY;

alter table Bank_k
add CONSTRAINT manager_id_Fk
foreign KEY (manager_id)
REFERENCES employees(manager_id);



