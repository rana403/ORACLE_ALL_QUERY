-- FORMULA COLUMN  For Planket PO Balance 
function CF_BALANCEFormula return Number is
V_NO NUMBER;
V_NET_VAL NUMBER;
V_RCPT NUMBER;

begin

IF 
    :RETURN_QTY=0    THEN 
SELECT :PO_QUANTITY-SUM(nvl(RECEIPT_QTY,0))+NVL(SUM( NVL(RETURN_QTY,0)),0)+NVL(SUM(NVL(DLV_RETURN_QTY,0)),0)-- ,RECEIPT_NO
INTO V_NO--,V_RCPT
FROM WBI_INV_RCV_TRANSACTIONS_F 
WHERE  TRANSACTION_TYPE='RECEIVE' AND PO_LINE_ID=:PO_LINE_ID AND RECEIPT_NO <=NVL(:GRN_NUMBER,RECEIPT_NO) AND ORGANIZATION_ID=NVL(:INV_ORG,ORGANIZATION_ID)
GROUP BY PO_QTY;
--ORDER BY RECEIPT_NO  ;

--V_NET_VAL:=nvl(V_NET_VAL,0)-V_NO;

SELECT NVL((NVL(SUM( NVL(RETURN_QTY,0)),0)+NVL(SUM(NVL(DLV_RETURN_QTY,0)),0))+nvl(V_NO,0),0)--,RECEIPT_NO
INTO V_NET_VAL--,V_RCPT
FROM WBI_INV_RCV_TRANSACTIONS_F
WHERE TRANSACTION_TYPE='RECEIVE'
and PO_LINE_ID=:PO_LINE_ID
AND RECEIPT_NO=NVL(:GRN_NUMBER,RECEIPT_NO)
AND ORGANIZATION_ID=NVL(:INV_ORG,ORGANIZATION_ID);
--GROUP BY RETURN_QTY,DLV_RETURN_QTY;
--ORDER BY RECEIPT_NO;
--:V_NET_VAL=V_NO-V_NET_VAL;

ELSIF 
        :RETURN_QTY>0  THEN
        
        
SELECT V_NET_VAL - SUM(nvl(RECEIPT_QTY,0))--+NVL(SUM( NVL(RETURN_QTY,0)),0)+NVL(SUM(NVL(DLV_RETURN_QTY,0)),0)-- ,RECEIPT_NO
INTO V_NO--,V_RCPT
FROM WBI_INV_RCV_TRANSACTIONS_F 
WHERE  TRANSACTION_TYPE='RECEIVE' AND PO_LINE_ID=:PO_LINE_ID AND RECEIPT_NO <=NVL(:GRN_NUMBER,RECEIPT_NO) AND ORGANIZATION_ID=NVL(:INV_ORG,ORGANIZATION_ID)
GROUP BY PO_QTY;
--ORDER BY RECEIPT_NO  ;


SELECT NVL((NVL(SUM( NVL(RETURN_QTY,0)),0)+NVL(SUM(NVL(DLV_RETURN_QTY,0)),0))+nvl(V_NO,0),0)--,RECEIPT_NO
INTO V_NET_VAL--,V_RCPT
FROM WBI_INV_RCV_TRANSACTIONS_F
WHERE TRANSACTION_TYPE='RECEIVE'
and PO_LINE_ID=:PO_LINE_ID
AND RECEIPT_NO=NVL(:GRN_NUMBER,RECEIPT_NO)
AND ORGANIZATION_ID=NVL(:INV_ORG,ORGANIZATION_ID);


ELSE V_NET_VAL:=:PO_QUANTITY;
END IF;
RETURN(V_NET_VAL);

EXCEPTION
WHEN OTHERS THEN
RETURN (0);
end;


--================================================

function CF_TOT_BALFormula return Number is
  V_TOT_VAL number;
begin
IF 
  :CF_BAL > 0 THEN 
  V_TOT_VAL := :CF_BAL - :RECEIVE_QTY;
  
  
  ELSE  V_TOT_VAL := :CF_BAL;
  END IF;
   RETURN(V_TOT_VAL);
  EXCEPTION WHEN OTHERS THEN 
    return(0);
  end;
  
  --============================
  function CF_BALANCEFormula return Number is

V_NET_VAL NUMBER;
begin
    
  V_NET_VAL:=:PO_QUANTITY - :RECEIVE_QTY + :RETURN_QTY;
 --    V_NET_VAL:=V_NET_VAL-(NVL(:DIS_PER,0)/100*V_NET_VAL)-NVL(:DIS_AMT,0);
 
 IF 
 V_NET_VAL >  0 THEN
     
  V_NET_VAL := V_NET_VAL - :RECEIVE_QTY;


 ELSE 
      V_NET_VAL := :RECEIVE_QTY;
-- RETURN(V_NET_VAL);
END IF;
EXCEPTION
WHEN OTHERS THEN
RETURN (0);
end;

--============================ CF_1==========================
function CF_1Formula return Char is
vword_tot varchar2(200);
begin
      IF :CURRENCY_CODE='BDT' THEN      
      vword_tot:=XX_AMOUNT_IN_WORD(:cf_4);--,:CURRENCY_CODE);
      return(vword_tot);
      ELSE 
          vword_tot:=ap_amount_utilities_pkg.ap_convert_number (:cf_4)||' '||:CURRENCY_CODE;
          return(vword_tot);
          END IF;
      --NULL;
EXCEPTION WHEN OTHERS THEN 
    return(NULL);
end;

--================================== CF2==================================
function CF_2Formula return Char is
V_VAT varchar2(25);
V_ZERO number;
begin
    IF :VAT>0 THEN
        V_VAT :=:cs_1*(:vat/100);
        return(V_VAT);
    ELSE
      V_VAT :='VAT Not Included';
      return(V_VAT);
  END IF;
EXCEPTION WHEN OTHERS THEN 
    return(0);
end;
--=========================================== CF3===============================
function CF_3Formula return Char is
V_GRND varchar(40);
begin
    if :CF_2='VAT Not Included' then 
--        V_GRND :=:cs_1;
            V_GRND :='VAT be Included';
        return(V_GRND);
    else
        V_GRND :=:cs_1+:CF_2;
            return(V_GRND);
            end if;
EXCEPTION WHEN OTHERS THEN 
    return(0);
end;


--============================== CF4==================================

function CF_4Formula return Number is
val number;
begin
  val := round(:cs_1+nvl(:carrying_cost,0),2);
  return (val);
  EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
end;

--=======================================