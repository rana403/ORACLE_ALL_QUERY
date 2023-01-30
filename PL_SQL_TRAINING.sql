LEARN PL/SQL FROM ORACLE 
--================

2 Using Constant:- We don’t change modifications in entire block

DECLARE
A CONSTANT NUMBER := 3.142;
B NUMBER (5) := 100;
BEGIN
B := 50;
DBMS_OUTPUT.put_line (a + b);
END;


3. Change output automatically by using the program

Declare
A number (5):= &n;
B number (5):= &m;
Begin
Dbms_output.put_line (a+b);
end;


4. Write a program to calculate the area of the circle by knowing the radius

DECLARE
a NUMBER (5, 3);
r NUMBER (5) := &n; --2
p CONSTANT NUMBER := 3.142;
BEGIN
a := p * POWER (r, 2);
-- (or you can use p*r*r)
DBMS_OUTPUT.put_line ('Area of the circle ' || a);
END;




5. Write a program to display 1 to 10 numbers

declare
x number(5) :=1;
begin
loop
exit when x > 10;
dbms_output.put_line(x);
x:=x+1;
end loop;
end;






--- FOR PRINT FROM 1 TO 5
--====================
set dbms_output on

DECLARE 
 i number;
BEGIN
i :=1;
LOOP
dbms_output.put_line(i);
i :=i+1;
exit when i >5;

END LOOP;
END;








--   https://www.youtube.com/watch?v=qCOryRcv-Vk&list=PLw_xy-MdhRdLeUS2IzjudsXeBK4cJBuVv&index=5



-- BASIC LOOP
--==========

DECLARE 
L_MIN NUMBER :=0 ;
L_MAX NUMBER := 5;
BEGIN
DBMS_OUTPUT.PUT_LINE('---------- BASIC LOOP--------------------');

LOOP

DBMS_OUTPUT.PUT_LINE(L_MIN);

L_MIN := L_MIN+1;


EXIT WHEN L_MIN > L_MAX;

END LOOP;


DBMS_OUTPUT.PUT_LINE('---------- WHILE LOOP--------------------');

LOOP

DBMS_OUTPUT.PUT_LINE(L_MIN);

L_MIN := L_MIN+1;


EXIT WHEN L_MIN > L_MAX;

END LOOP;



END;





--========================================
--DECLARE
--L_A NUMBER := 100;
--L_B VARCHAR2 (100) := 'Hellow World';
--L_C  DATE := SYSDATE;
--L_D BOOLEAN := TRUE;
--BEGIN
--DBMS_OUTPUT.PUT_LINE(L_A);
--DBMS_OUTPUT.PUT_LINE(L_B);
--DBMS_OUTPUT.PUT_LINE(L_C);
--
--IF (L_D) THEN 
--DBMS_OUTPUT.PUT_LINE('TRUE');
--ELSE
--DBMS_OUTPUT.PUT_LINE('FALSE');
--END IF;
--END;

---==================================
--DECLARE 
--L_A NUMBER;
--L_B NUMBER;
--V_C NUMBER;
--BEGIN
--L_A := 10;
--L_B := 20;
--
--V_C := L_A+L_B;
--
--DBMS_OUTPUT.PUT_LINE(V_C);
--
--END;


--==============================

--BEGIN
--NULL;
--
--DBMS_OUTPUT.PUT_LINE('Hellow World');
--
--END;