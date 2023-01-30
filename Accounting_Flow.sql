 SELECT SL,
 XX_GET_EMP_NAME_FROM_USER_ID(:P_USER_ID) USER_NAME,
         XX_GET_HR_OPERATING_UNIT (ORG_ID) UNIT,
         GET_FLEX_VALUES_FROM_FLEX_ID (BAL_SEG, 1) COMPANY_SHORT_NAME,
         INVOICE_ID,
         XX_GET_PARTY_NAME (PARTY_ID) SUPPLIER,
         XX_GET_VENDOR_NUMBER_FROM_ID (VENDOR_ID) VENDOR_NUM,
        XX_GET_VENDOR_NUMBER_SITE_ID (INVOICE_ID)SUPPLIER_SITE,
         INVOICE_NUM,
         INVOICE_DATE,
         GL_DATE,
         XX_GET_EMP_NAME_FROM_USER_ID (CREATED_BY) CREATED_BY,
         CREATION_DATE,
         XX_GET_RECEIPT_NUMBER_FROM_INV (INVOICE_ID) RECEIPT_NUM,
         GET_MAX_CHECK_NUM_FROM_INVOICE (INVOICE_ID) CHECK_NUMBER,
         GET_MAX_CHK_DATE_FROM_INVOICE (INVOICE_ID) CHECK_DATE,
         GET_MAX_ACCT_NAME_FROM_INVOICE (INVOICE_ID) BANK_ACCT_NUM,
         XX_GET_INVOICE_CURRENCY_CODE (INVOICE_ID) CURRENCY_CODE,
         VOUCHER,
         GL_CODE_AND_DESC,
         DESCRIPTION,
DFF_INFO,
         DECODE (SIGN (SUM (DR_AMOUNT - CR_AMOUNT)), -1, 0, SUM (DR_AMOUNT - CR_AMOUNT)) DR_AMOUNT,
         DECODE (SIGN (SUM (CR_AMOUNT - DR_AMOUNT)), -1, 0, SUM (CR_AMOUNT - DR_AMOUNT)) CR_AMOUNT,
       ATTRIBUTE_CATEGORY,
      ATTRIBUTE1,
       ATTRIBUTE2,
      ATTRIBUTE3,
      ATTRIBUTE4,
      ATTRIBUTE5,
      RCV_TRANSACTION_ID,
     PO_DISTRIBUTION_ID
    FROM XX_AP_INVOICE_VOUCHER_V
   WHERE     (:P_ORG_ID IS NULL OR ORG_ID = :P_ORG_ID)
         AND (:P_VENDOR_ID IS NULL OR VENDOR_ID = :P_VENDOR_ID)
         AND (:P_FROM_DATE IS NULL OR TRUNC(GL_DATE) BETWEEN :P_FROM_DATE AND :P_TO_DATE)
         AND (:P_FROM_VOUCHER IS NULL OR VOUCHER BETWEEN :P_FROM_VOUCHER AND :P_TO_VOUCHER)
     --    AND (:P_EMP_NUM IS NULL OR XX_GET_USER_NAME (CREATED_BY) = :P_EMP_NUM)
         --AND XX_GET_INVOICE_STATUS (INVOICE_ID) IN  ('Available', 'Fully Applied', 'Permanent Prepayment', 'Unpaid', 'Validated')
GROUP BY SL,
         ORG_ID,
         BAL_SEG,
         INVOICE_ID,
         PARTY_ID,
         VENDOR_ID,
         INVOICE_NUM,
         INVOICE_DATE,
         GL_DATE,
         CREATED_BY,
         CREATION_DATE,
         VOUCHER,
         GL_CODE_AND_DESC,
         DESCRIPTION, 
DFF_INFO,
ATTRIBUTE_CATEGORY,
   ATTRIBUTE1,
   ATTRIBUTE2,
   ATTRIBUTE3,
   ATTRIBUTE4,
   ATTRIBUTE5,
  RCV_TRANSACTION_ID,
  PO_DISTRIBUTION_ID
HAVING DECODE (SIGN (SUM (DR_AMOUNT - CR_AMOUNT)), -1, 0, SUM (DR_AMOUNT - CR_AMOUNT)) + DECODE (SIGN (SUM (CR_AMOUNT - DR_AMOUNT)), -1, 0, SUM (CR_AMOUNT - DR_AMOUNT)) >0
ORDER BY ORG_ID, VOUCHER ASC,DR_AMOUNT DESC



--ACCOUNTING ENTRIES IN INVENTORY , PAYABLES AND RECEIVABLES

-- 1. When Creating a receipt:
INVENTORY RECEIVING A/C DR
AP ACCRUAL ACCOUNT CR

--2. At the time of Receiving transactions:
ASSET CLEARING A/C DR OR INVENTORY VALUATION A/C DR
INVENTORY RECEIVING A/C CR

--3. When a Payables invoice matched with PO OR GRN :
AP ACCRUAL A/C DR
LIABILITY A/C CR

--4. when asset addition done:
ASSET A/C DR
ASSET CLEARING A/C CR(ASSET ITEM)
           (OR)
EXPENSE A/C DR
INVENTORY VALUATION A/C(INVENTORY ITEM) CR

--==========================================================================================
--WHEN WE CREATE ACCOUNTING FOR AN INVOICE, THE ACCOUNTING WILL BE GENERATED WITH RESPECT TO THE FOLLOWING ACCOUNTS.
--==========================================================================================
--1. Invoice: 
AP Accrual  A/C      DR
Liability  A/C             CR

-- 2. At the time of Payment:

Supplier Liability A/C               DR
Cash Clearing A/C      CR

--3. At the time of Clearance:

Cash Clearing A/C    DR
Cash A/C                  CR

--===================================================================================================
-- RECEIVABLES : WHEN WE ENTER TRANSACTIONS IN RECEIVABLES, THE ACCOUNTING ENTRIES WILL GET GENERATED WITH RESPECT TO THE FOLLOWING ACCOUNTS.
--====================================================================================================

--1. Accounting for invoice:
Receivables A/C DR
Revenue Account Cr

--2. Credit memo:
Revenue Dr
Receivables A/C CR

--3. Receipts:
Cash A/C DR
Receivables A/c CR


--=================================================
--- ALL ACCOUNTING
--=================================================
Procure-to- Pay Accounting Entries:


WHEN WE RECEIVE THE GOODS IN THE STAGING AREA THE ACCOUNTING ENTRY WOULD BE (GRN):

Receiving Inventory --- Dr-----It will pick from receiving options. 

Ap Accrual --- Cr---It will pick from Purchasing Options.

When we are moving the Goods from Staging area to Sub-Inv (Recv Trans):

Material A/C --- Dr-----It will pick from Inventory Options

Receiving Inv --- Cr----It will pick from Receiving Options

While Creating Invoice: 

Ap Accrual --- Dr

Liability ---- Cr-----It will pick from supplier Liability 

While Making Payment:

Liability – Dr

Cash Clearing – Cr-----It will pick from Bank

Reconciliation:

Cash Clearing – Dr

Cash – Cr

Standard Invoice Entry : 

Ap Accrual --- Dr

Liability ---- Cr

Debit and Credit Memo Entries:

Liability --- Dr 

Ap Accrual --- Cr

Prepayment Entries:

While Creating Prepayment Invoice:

Prepayment – Dr ----It will pick from supplier

Liability – Cr----It will pick from supplier

While Making Payment to Prepayment:

Liability – Dr

Cash – Cr

While applying Prepayment on Standard Invoice:

Liability --- Dr

Prepayment – Cr

INTEREST INVOICE ENTRY WHILE MAKING PAYMENT:

Interest expenses –- Dr-----It will pick from Financial options

Liability ---------------- Dr

Cash ---------------------Cr

EXPENSE REPORT ENTRY:

Item Expense A/C – Dr

Liability – Cr



PAYMENT REQUEST INVOICE ENTRY :

Item Expense – Dr

Liability – Cr

FUTURE DATED PAYMENT ENTRY :

When Bills Issued:

Item Expense – Dr

Bills Payable – Cr

When Maturity Date Con?rmed:

Bills Payable – Dr---It will pick from Supplier or Financial options

Liability – Cr

WITH HOLDING TAX ENTRY :

When Withholding tax applied on standard Invoice:

Item Expense –  Dr

Liability – Cr

Withholding – Cr-----It will pick from WHT codes 

Auto Generated WHT Entry:

Item Expense – Dr

Liability --- Cr

RETAINAGE RELEASE ACCOUNTING ENTRY:

When Invoice matched with PO accounting entry would be: 

Accrual ------ Dr

Liability ---- Cr

Retainage ---Cr----It will pick from ?nancial options

While making payment to the invoice matched with PO:

Liability ---- Dr

Cash --------Cr

When Retainage Release Invoice Matched with PO accounting entry would be:

Retainage --------Dr

Liability ----------- Cr

While making Payment to Retainage Release:

Liability ---Dr

Cash --------Cr

--Order - to- Cash ENTRIES:

Pick Release:

Receiving Inventory – Dr

Item Expense/Material ac – Cr

Ship Confirmation:

COGS – Dr----It will pick from Inv Information

Receiving Inv (Sub-Inv) – Cr

While Creating Transaction:

Receivable ---- Dr

Revenue ------- Cr

Freight --------Cr

Tax -------------Cr

While Recording Receipt: WHEN STATE IS CONFIRMED

Confirmed Cash--------------Dr

Receivables ----Cr

When Remitted: WHEN STATE IS REMITTED

Remitted Cash ---- Dr

Confirmed Cash--------Cr

When Reconciled: WHEN STATE IS CLEARED

Cash -------Dr

Remitted Cash --- Cr

DEPOSIT ACCOUNTING ENTRY:

When we create DEPOSIT invoice the accounting entry would be:

Receivable --- Dr 

Accrual (Unearned Revenue) -------- Cr

When we create Sales Invoice:

Receivable---Dr

Revenue----- Cr

When Deposit adjusts with actual transaction invoice the entry would be:

Unearned Rev (Accrual) -----Dr

Receivables-------Cr

GAURANTEE ACCOUNTING ENTRY:

When we crate Guarantee transaction:

Unbilled receivable----Dr

Unearned Revenue ---Cr

When we create sales Invoice:

Receivable ----Dr

Revenue -------Cr

When Guarantee transaction adjusts with sales invoice:

Unearned Revenue ---Dr

Unbilled Receivable—Cr

REVENUE RECOGNISATION:

INVOICE ADVANCE:

When we create sales invoice and set invoicing rule as IN ADVANCE(FIXED SCH):

Receivables ---- Dr

Unearned Revenue -------- Cr

Once we recognize the Revenue the accounting entry would be:

Unearned Revenue ---- Dr

Revenue------------------Cr 

And the Final entry would be:

Receivable ------Dr

Revenue ---------Cr

INVOICE ARREARS:

REVENUE RECOGNISATION using Invoice Arrears Schedule:

Unbilled Receivables—Dr

Revenue-----------------Cr

Once we have billed the customer

Receivables---------------Dr

Unbilled Receivables—Cr

ON-ACCOUNT ACCOUNTING ENTRY:

When we created the Receipt and applied to On Account :

Cash ---Dr

Receivables ----CR,

ONACCOUNT -----Cr

CUSTOMER REFUND ACCOUNTING ENTRY :

When we release the On account and Refund the Amount:

Cash ----Dr

Receivables----Cr

On Account Cash ---Cr

Unapplied Cash -----Dr

Refund----------------Cr

ASSET

Asset Addition

The process of adding a Fixed Asset either through detailed, quick or mass addition is called asset addition. Detail and quick addition are carried out only in Oracle Assets.



The journal entry in Oracle Assets during detailed or quick addition is

 Asset Cost – Dr

Asset clearing account – Cr



Asset clearing account is used to reconcile the transactions between Oracle Payables and Oracle Assets. When an asset is added through detailed or quick additions, the credit goes to the asset clearing account.
Also for mass addition process, oracle assets use Asset Clearing account for reconciliation.



In Oracle Assets the journal entry remains the same



Asset Cost – Dr

Asset clearing account – Cr

In AP

Asset Clearing Account – Dr

Accounts Payables – Cr

Changes:

Changes refer to change in Asset Cost or Depreciation method or Depreciation rate for one or more assets. Oracle Assets would use the new cost or depreciation method or rate 
from the period of change to arrive at the depreciation amount. Also it recalculates the depreciation that should have been calculated so far, compares with the actual depreciation and passes an adjusting entry.

If the transaction results in addition to the cost of asset, then the journal entry created is

Dr. Asset Cost

Cr. Asset Clearing

Hence an adjusting entry to incorporate depreciation as per the new cost of the asset should be incorporated. Also due to change in method or rate the new depreciation calculated may be lower or greater than the depreciation calculated so far.

If the accumulated depreciation recalculated is lower than the accumulated depreciation calculated until now,

Dr. Accumulated Depreciation

Cr. Depreciation Expense (Adjustment)

If it is greater than the Accumulated depreciation until now,

Dr. Depreciation Expense (Adjustment)

CR. Accumulated Depreciation

Transfer

Transfers refer to change in Location, expense account, and employee assignment. If there is a change in expense account, for e.g. If an asset is transferred from department 001 to department 002,The journal entry for accounting the asset cost is

Dr. Asset Cost (002)

Cr. Asset Cost (001)

The journal entry for accounting the accumulated depreciation is

Dr. Accumulated Depreciation (001)

Cr. Accumulated Depreciation (002)

Revaluation

Revaluation is a process so as to re?ect current market price of the Asset.

The journal entry created by revaluing a ?xed asset is as follows:

Revalue Accumulated Depreciation is enabled at the Book Controls level:

The amount of revaluation would be credited to Accumulated Depreciation and Revaluation reserve in the same proportion as the existing Accumulates Depreciation and Net Book value.

Dr. Asset Cost Cr. Accumulated Depreciation 

Cr. Revaluation Reserve

Revalue Accumulated Depreciation is disabled at the Book Controls level:

To the extend of the revaluation amount, the following journal entry would be passed.

Dr. Asset Cost 

Cr. Revaluation Reserve 

Also, the existing depreciation reserve would also be transferred to the Revaluation Reserve

Dr. Accumulated Depreciation 

Cr. Revaluation Reserve

Oracle Assets passes the following journal entry for retirement. If the retirement transaction resulted in a Gain, the journal entry passed would be.

Dr. Accumulated Depreciation

Dr. Proceeds of sale

Cr. Asset Cost

Cr. Gain / Loss

If the retirement transaction resulted in a Loss, the journal entry passed would be.

Dr. Accumulated Depreciation

Dr. Proceeds of sale

Dr. Gain / Loss

Cr. Asset Cost

Depreciation:

Running depreciation (as applicable to a particular asset) during the period end would pass a journal entry

Dr. Depreciation Expense 

Cr. Accumulated Depreciation