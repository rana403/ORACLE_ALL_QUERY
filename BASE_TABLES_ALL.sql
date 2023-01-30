ORDER MANAGEMENT BASETABLE:
--============================
oe_order_headers_all
oe_order_lines_all
qp_list_headers
qp_list_lines
qp_pricing_attributes
OE_PRICE_ADJUSTMENTS
OE_ORDER_HOLDS_ALL
OE_ORDER_CREDIT_CHECK_RULES



RECEIVEABLE BASE TABLES
--=====================================
RA_CUSTOMER_TRX_ALL
RA_CUSTOMER_TRX_LINES_ALL
RA_CUST_TRX_LINE_GL_DIST_ALL
RA_CUST_TRX_LINE_SALESREPS_ALL

CUSTOMER BASE TABLE
--=================
HZ_CUST_ACCOUNTS
HZ_CUST_ACCT_SITES_ALL
HZ_CUSTOMER_PROFILES
HZ_CUST_SITE_USES_ALL
HZ_CONTACT_POINTS
HZ_LOCATIONS
HZ_PARTIES
HZ_PARTY_SITES

Customer Transaction/Invoice Table 
--===================================
ra_customer_trx_all
ra_customer_trx_lines_all
ra_cust_trx_line_gl_dist_all -- This table stores the AR Invoice accounting information’s for each line of the AR Invoice
ra_terms

Customer Receipts Tables
--========================
ar_cash_receipts_all
ar_receivable_applications_all 
AR_BATCH_SOURCES_ALL
AR_CASH_RECEIPTS_ALL
AR_CASH_RECEIPT_HISTORY_ALL
AR_DISTRIBUTIONS_ALL
AR_INTERIM_CASH_RECEIPTS_ALL
AR_JOURNAL_INTERIM_ALL
AR_LOCATION_ACCOUNTS_ALL
AR_LOCKBOXES_ALL
AR_MISC_CASH_DISTRIBUTIONS_ALL
AR_PAYMENTS_INTERFACE_ALL
AR_PAYMENT_SCHEDULES_ALL
AR_PERIODS
AR_PERIOD_TYPES
AR_RECEIPT_CLASSES
AR_RECEIPT_METHODS
AR_RECEIVABLES_TRX_ALL
AR_RECEIVABLE_APPLICATIONS_ALL

AR Transaction INTERFACE TABLESPACE
--=======================
Transaction Interface Tables 
RA_INTERFACE_LINES_ALL Transaction Lines interface
RA_INTERFACE_SALESCREDITS_ALL Transaction Sales credit information
RA_INTERFACE_DISTRIBUTIONS_ALL Transaction Distribution information
RA_INTERFACE_ERRORS_ALL Transaction errors table
AR_PAYMENTS_INTERFACE_ALL Interface table to import receipts
AR_INTERIM_CASH_RECEIPTS_ALL Lockbox transfers the receipts that pass validation to the interim tables
AR_INTERIM_CASH_RCPT_LINES_ALL Lockbox transfers the receipts that pass validation to the interim tables

SELECT * FROM AR_RECEIPT_CLASSES -- This table stores the different receipt classes that you define.
select * from RA_CUST_TRX_TYPES_ALL -- This table stores information about each transaction type for all classes of transactions, for example, invoices, commitments, and credit memos.
select * from AR_RECEIPT_METHODS  -- This table stores information about Payment Methods, receipt attributes that you define and assign to Receipt Classes to account for receipts and their applications

XML PUBLISHERS TABLES
=======================
select * from  XDO_CONFIG_PROPERTIES_B
select * from XDO_TEMPLATE_FIELDS
select * from XDO_TRANS_UNITS
select * from XDO_TRANS_UNIT_PROPS
select * from XDO_TRANS_UNIT_VALUES
select * from XDO_TEMPLATES_TL
select * from XDO_CONFIG_PROPERTIES_TL
SELECT * FROM XDO_CONFIG_VALUES
SELECT * FROM XDO_CURRENCY_FORMATS
SELECT * FROM XDO_CURRENCY_FORMAT_SETS_B
select * from XDO_DS_DEFINITIONS_B
select * from XDO_DS_DEFINITIONS_TL
select * from XDO_FONT_MAPPINGS
select * from XDO_FONT_MAPPING_SETS_B
select * from XDO_FONT_MAPPING_SETS_TL
select * from XDO_LOBS








