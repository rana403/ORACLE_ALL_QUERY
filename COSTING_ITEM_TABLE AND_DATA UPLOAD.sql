
/***************************************************************************

CASE:  I UPLOADED SOME OPENING BALANCE FOR KPM , BUT AT THE TIME OF UPLOADING OPENING DATA MISTAKENLY UPLODED AMOUNT COLUMN in lue of  RATE COLUMN 

SO to update amount column i planed to create a custome table table 
run a update script 
******************************************************************************/

SELECT * FROM CM_ADJS_DTL where ORGANIZATION_ID=176 order by INVENTORY_ITEM_ID


CREATE TABLE UPDATE_RATE AS SELECT ORGANIZATION_ID, INVENTORY_ITEM_ID, ADJUST_COST FROM CM_ADJS_DTL where ORGANIZATION_ID=176 order by INVENTORY_ITEM_ID

select * from UPDATE_RATE

select  INVENTORY_ITEM_ID, XXGET_ITEM_DESCRIPTION(INVENTORY_ITEM_ID, ORGANIZATION_ID) ITEM from UPDATE_RATE

--DROP TABLE UPDATE_RATE



Select * from tab where tabtype= 'TABLE' and TNAME like '%COST%'

select * from ORG_ORGANIZATION_DEFINITIONS WHERE ORGANIZATION_CODE='KPM'

select * from CST_ITEM_COSTS

select * from XX_ITEM_UPLOAD






select * from XXINV_ITEM_COST


SELECT XXGET_ITEM_DESCRIPTION(A.INVENTORY_ITEM_ID, A.ORGANIZATION_ID) ITEM,  A.* from  CM_ADJS_DTL A where ORGANIZATION_ID = 176 order by XXGET_ITEM_DESCRIPTION(A.INVENTORY_ITEM_ID, A.ORGANIZATION_ID)

SELECT * from  CM_ADJS_DTL where ORGANIZATION_ID = 176   --and trunc(ADJUSTMENT_DATE) between '1-JAN-2022' and '30-JAN-2022'

/*********************************************************
GET COST METHOD NAME 
*********************************************************/

SELECT * FROM CM_MTHD_MST 




SELECT owner, table_name, grantee, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv
  FROM table_privileges
 WHERE grantee = upper(:USER_NAME)
   --AND table_name = upper(:TABLE_NAME)
 ORDER BY owner, table_name
 
 
 SELECT * FROM CM_ADJS_DTL where ORGANIZATION_ID = 176


select *   FROM table_privileges




/*********************************************************
*PURPOSE: Query to find Item Cost                        *
*AUTHOR: Shailender Thallam                              *
**********************************************************/

SELECT msi.segment1 "ITEM_NAME",
  msi.inventory_item_id,
  cic.item_cost ,
  mp.organization_code,
  mp.organization_id,
  cct.cost_type,
  cct.description,
  cic.tl_material,
  cic.tl_material_overhead,
  cic.material_cost,
  cic.material_overhead_cost,
  cic.tl_item_cost,
  cic.unburdened_cost,
  cic.burden_cost
FROM cst_cost_types cct,
  cst_item_costs cic,
  mtl_system_items_b msi,
  mtl_parameters mp
WHERE cct.cost_type_id    = cic.cost_type_id
AND cic.inventory_item_id = msi.inventory_item_id
AND cic.organization_id   = msi.organization_id
AND msi.organization_id   = mp.organization_id
--AND msi.inventory_item_id = 45
--AND mp.organization_id    = 176
--AND cct.cost_type         = 'Frozen'  --'Average' --'Pending'

--======================= Table for Item COst================

DROP TABLE APPS.XXINV_ITEM_COST CASCADE CONSTRAINTS;

CREATE TABLE APPS.XXINV_ITEM_COST
(
  PERIOD_CODE        CHAR(6 BYTE),
  ITEM_CODE          VARCHAR2(163 BYTE),
  INVENTORY_ITEM_ID  NUMBER                     NOT NULL,
  ORGANIZATION_ID    NUMBER                     NOT NULL,
  OP_QTY             NUMBER,
  OP_COST            NUMBER,
  OP_VAL             NUMBER,
  RCV_QTY            NUMBER,
  RCV_COST           NUMBER,
  RCV_VAL            NUMBER,
  ISU_QTY            NUMBER,
  ISU_COST           NUMBER,
  ISU_VAL            NUMBER,
  CLS_QTY            NUMBER,
  CLS_COST           NUMBER,
  CLS_VAL            NUMBER
)
TABLESPACE APPS_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;



--=========================== ITEM UPLOAD TABLE ===================================


CREATE TABLE APPS.XX_ITEM_UPLOAD
(
  INVENTORY_ITEM_ID               NUMBER,
  ORGANIZATION_ID                 NUMBER,
  LAST_UPDATE_DATE                DATE,
  LAST_UPDATED_BY                 NUMBER,
  CREATION_DATE                   DATE,
  CREATED_BY                      NUMBER,
  LAST_UPDATE_LOGIN               NUMBER,
  SUMMARY_FLAG                    VARCHAR2(1 BYTE),
  ENABLED_FLAG                    VARCHAR2(1 BYTE),
  START_DATE_ACTIVE               DATE,
  END_DATE_ACTIVE                 DATE,
  DESCRIPTION                     VARCHAR2(240 BYTE),
  BUYER_ID                        NUMBER,
  ACCOUNTING_RULE_ID              NUMBER,
  INVOICING_RULE_ID               NUMBER,
  SEGMENT1                        VARCHAR2(40 BYTE),
  SEGMENT2                        VARCHAR2(40 BYTE),
  SEGMENT3                        VARCHAR2(40 BYTE),
  SEGMENT4                        VARCHAR2(40 BYTE),
  SEGMENT5                        VARCHAR2(40 BYTE),
  SEGMENT6                        VARCHAR2(40 BYTE),
  SEGMENT7                        VARCHAR2(40 BYTE),
  SEGMENT8                        VARCHAR2(40 BYTE),
  SEGMENT9                        VARCHAR2(40 BYTE),
  SEGMENT10                       VARCHAR2(40 BYTE),
  SEGMENT11                       VARCHAR2(40 BYTE),
  SEGMENT12                       VARCHAR2(40 BYTE),
  SEGMENT13                       VARCHAR2(40 BYTE),
  SEGMENT14                       VARCHAR2(40 BYTE),
  SEGMENT15                       VARCHAR2(40 BYTE),
  SEGMENT16                       VARCHAR2(40 BYTE),
  SEGMENT17                       VARCHAR2(40 BYTE),
  SEGMENT18                       VARCHAR2(40 BYTE),
  SEGMENT19                       VARCHAR2(40 BYTE),
  SEGMENT20                       VARCHAR2(40 BYTE),
  ATTRIBUTE_CATEGORY              VARCHAR2(30 BYTE),
  ATTRIBUTE1                      VARCHAR2(240 BYTE),
  ATTRIBUTE2                      VARCHAR2(240 BYTE),
  ATTRIBUTE3                      VARCHAR2(240 BYTE),
  ATTRIBUTE4                      VARCHAR2(240 BYTE),
  ATTRIBUTE5                      VARCHAR2(240 BYTE),
  ATTRIBUTE6                      VARCHAR2(240 BYTE),
  ATTRIBUTE7                      VARCHAR2(240 BYTE),
  ATTRIBUTE8                      VARCHAR2(240 BYTE),
  ATTRIBUTE9                      VARCHAR2(240 BYTE),
  ATTRIBUTE10                     VARCHAR2(240 BYTE),
  ATTRIBUTE11                     VARCHAR2(240 BYTE),
  ATTRIBUTE12                     VARCHAR2(240 BYTE),
  ATTRIBUTE13                     VARCHAR2(240 BYTE),
  ATTRIBUTE14                     VARCHAR2(240 BYTE),
  ATTRIBUTE15                     VARCHAR2(240 BYTE),
  PURCHASING_ITEM_FLAG            VARCHAR2(1 BYTE),
  SHIPPABLE_ITEM_FLAG             VARCHAR2(1 BYTE),
  CUSTOMER_ORDER_FLAG             VARCHAR2(1 BYTE),
  INTERNAL_ORDER_FLAG             VARCHAR2(1 BYTE),
  SERVICE_ITEM_FLAG               VARCHAR2(1 BYTE),
  INVENTORY_ITEM_FLAG             VARCHAR2(1 BYTE),
  ENG_ITEM_FLAG                   VARCHAR2(1 BYTE),
  INVENTORY_ASSET_FLAG            VARCHAR2(1 BYTE),
  PURCHASING_ENABLED_FLAG         VARCHAR2(1 BYTE),
  CUSTOMER_ORDER_ENABLED_FLAG     VARCHAR2(1 BYTE),
  INTERNAL_ORDER_ENABLED_FLAG     VARCHAR2(1 BYTE),
  SO_TRANSACTIONS_FLAG            VARCHAR2(1 BYTE),
  MTL_TRANSACTIONS_ENABLED_FLAG   VARCHAR2(1 BYTE),
  STOCK_ENABLED_FLAG              VARCHAR2(1 BYTE),
  BOM_ENABLED_FLAG                VARCHAR2(1 BYTE),
  BUILD_IN_WIP_FLAG               VARCHAR2(1 BYTE),
  REVISION_QTY_CONTROL_CODE       NUMBER,
  ITEM_CATALOG_GROUP_ID           NUMBER,
  CATALOG_STATUS_FLAG             VARCHAR2(1 BYTE),
  CHECK_SHORTAGES_FLAG            VARCHAR2(1 BYTE),
  RETURNABLE_FLAG                 VARCHAR2(1 BYTE),
  DEFAULT_SHIPPING_ORG            NUMBER,
  COLLATERAL_FLAG                 VARCHAR2(1 BYTE),
  TAXABLE_FLAG                    VARCHAR2(1 BYTE),
  QTY_RCV_EXCEPTION_CODE          VARCHAR2(25 BYTE),
  ALLOW_ITEM_DESC_UPDATE_FLAG     VARCHAR2(1 BYTE),
  INSPECTION_REQUIRED_FLAG        VARCHAR2(1 BYTE),
  RECEIPT_REQUIRED_FLAG           VARCHAR2(1 BYTE),
  MARKET_PRICE                    NUMBER,
  HAZARD_CLASS_ID                 NUMBER,
  RFQ_REQUIRED_FLAG               VARCHAR2(1 BYTE),
  QTY_RCV_TOLERANCE               NUMBER,
  LIST_PRICE_PER_UNIT             NUMBER,
  UN_NUMBER_ID                    NUMBER,
  PRICE_TOLERANCE_PERCENT         NUMBER,
  ASSET_CATEGORY_ID               NUMBER,
  ROUNDING_FACTOR                 NUMBER,
  UNIT_OF_ISSUE                   VARCHAR2(25 BYTE),
  ENFORCE_SHIP_TO_LOCATION_CODE   VARCHAR2(25 BYTE),
  ALLOW_SUBSTITUTE_RECEIPTS_FLAG  VARCHAR2(1 BYTE),
  ALLOW_UNORDERED_RECEIPTS_FLAG   VARCHAR2(1 BYTE),
  ALLOW_EXPRESS_DELIVERY_FLAG     VARCHAR2(1 BYTE),
  DAYS_EARLY_RECEIPT_ALLOWED      NUMBER,
  DAYS_LATE_RECEIPT_ALLOWED       NUMBER,
  RECEIPT_DAYS_EXCEPTION_CODE     VARCHAR2(25 BYTE),
  RECEIVING_ROUTING_ID            NUMBER,
  INVOICE_CLOSE_TOLERANCE         NUMBER,
  RECEIVE_CLOSE_TOLERANCE         NUMBER,
  AUTO_LOT_ALPHA_PREFIX           VARCHAR2(30 BYTE),
  START_AUTO_LOT_NUMBER           VARCHAR2(30 BYTE),
  LOT_CONTROL_CODE                NUMBER,
  SHELF_LIFE_CODE                 NUMBER,
  SHELF_LIFE_DAYS                 NUMBER,
  SERIAL_NUMBER_CONTROL_CODE      NUMBER,
  START_AUTO_SERIAL_NUMBER        VARCHAR2(30 BYTE),
  AUTO_SERIAL_ALPHA_PREFIX        VARCHAR2(30 BYTE),
  SOURCE_TYPE                     NUMBER,
  SOURCE_ORGANIZATION_ID          NUMBER,
  SOURCE_SUBINVENTORY             VARCHAR2(10 BYTE),
  EXPENSE_ACCOUNT                 NUMBER,
  ENCUMBRANCE_ACCOUNT             NUMBER,
  RESTRICT_SUBINVENTORIES_CODE    NUMBER,
  UNIT_WEIGHT                     NUMBER,
  WEIGHT_UOM_CODE                 VARCHAR2(3 BYTE),
  VOLUME_UOM_CODE                 VARCHAR2(3 BYTE),
  UNIT_VOLUME                     NUMBER,
  RESTRICT_LOCATORS_CODE          NUMBER,
  LOCATION_CONTROL_CODE           NUMBER,
  SHRINKAGE_RATE                  NUMBER,
  ACCEPTABLE_EARLY_DAYS           NUMBER,
  PLANNING_TIME_FENCE_CODE        NUMBER,
  DEMAND_TIME_FENCE_CODE          NUMBER,
  LEAD_TIME_LOT_SIZE              NUMBER,
  STD_LOT_SIZE                    NUMBER,
  CUM_MANUFACTURING_LEAD_TIME     NUMBER,
  OVERRUN_PERCENTAGE              NUMBER,
  MRP_CALCULATE_ATP_FLAG          VARCHAR2(1 BYTE),
  ACCEPTABLE_RATE_INCREASE        NUMBER,
  ACCEPTABLE_RATE_DECREASE        NUMBER,
  CUMULATIVE_TOTAL_LEAD_TIME      NUMBER,
  PLANNING_TIME_FENCE_DAYS        NUMBER,
  DEMAND_TIME_FENCE_DAYS          NUMBER,
  END_ASSEMBLY_PEGGING_FLAG       VARCHAR2(1 BYTE),
  REPETITIVE_PLANNING_FLAG        VARCHAR2(1 BYTE),
  PLANNING_EXCEPTION_SET          VARCHAR2(10 BYTE),
  BOM_ITEM_TYPE                   NUMBER,
  PICK_COMPONENTS_FLAG            VARCHAR2(1 BYTE),
  REPLENISH_TO_ORDER_FLAG         VARCHAR2(1 BYTE),
  BASE_ITEM_ID                    NUMBER,
  ATP_COMPONENTS_FLAG             VARCHAR2(1 BYTE),
  ATP_FLAG                        VARCHAR2(1 BYTE),
  FIXED_LEAD_TIME                 NUMBER,
  VARIABLE_LEAD_TIME              NUMBER,
  WIP_SUPPLY_LOCATOR_ID           NUMBER,
  WIP_SUPPLY_TYPE                 NUMBER,
  WIP_SUPPLY_SUBINVENTORY         VARCHAR2(10 BYTE),
  PRIMARY_UOM_CODE                VARCHAR2(3 BYTE),
  PRIMARY_UNIT_OF_MEASURE         VARCHAR2(25 BYTE),
  ALLOWED_UNITS_LOOKUP_CODE       NUMBER,
  COST_OF_SALES_ACCOUNT           NUMBER,
  SALES_ACCOUNT                   NUMBER,
  DEFAULT_INCLUDE_IN_ROLLUP_FLAG  VARCHAR2(1 BYTE),
  INVENTORY_ITEM_STATUS_CODE      VARCHAR2(10 BYTE),
  INVENTORY_PLANNING_CODE         NUMBER,
  PLANNER_CODE                    VARCHAR2(10 BYTE),
  PLANNING_MAKE_BUY_CODE          NUMBER,
  FIXED_LOT_MULTIPLIER            NUMBER,
  ROUNDING_CONTROL_TYPE           NUMBER,
  CARRYING_COST                   NUMBER,
  POSTPROCESSING_LEAD_TIME        NUMBER,
  PREPROCESSING_LEAD_TIME         NUMBER,
  FULL_LEAD_TIME                  NUMBER,
  ORDER_COST                      NUMBER,
  MRP_SAFETY_STOCK_PERCENT        NUMBER,
  MRP_SAFETY_STOCK_CODE           NUMBER,
  MIN_MINMAX_QUANTITY             NUMBER,
  MAX_MINMAX_QUANTITY             NUMBER,
  MINIMUM_ORDER_QUANTITY          NUMBER,
  FIXED_ORDER_QUANTITY            NUMBER,
  FIXED_DAYS_SUPPLY               NUMBER,
  MAXIMUM_ORDER_QUANTITY          NUMBER,
  ATP_RULE_ID                     NUMBER,
  PICKING_RULE_ID                 NUMBER,
  RESERVABLE_TYPE                 NUMBER,
  POSITIVE_MEASUREMENT_ERROR      NUMBER,
  NEGATIVE_MEASUREMENT_ERROR      NUMBER,
  ENGINEERING_ECN_CODE            VARCHAR2(50 BYTE),
  ENGINEERING_ITEM_ID             NUMBER,
  ENGINEERING_DATE                DATE,
  SERVICE_STARTING_DELAY          NUMBER,
  VENDOR_WARRANTY_FLAG            VARCHAR2(1 BYTE),
  SERVICEABLE_COMPONENT_FLAG      VARCHAR2(1 BYTE),
  SERVICEABLE_PRODUCT_FLAG        VARCHAR2(1 BYTE),
  BASE_WARRANTY_SERVICE_ID        NUMBER,
  PAYMENT_TERMS_ID                NUMBER,
  PREVENTIVE_MAINTENANCE_FLAG     VARCHAR2(1 BYTE),
  PRIMARY_SPECIALIST_ID           NUMBER,
  SECONDARY_SPECIALIST_ID         NUMBER,
  SERVICEABLE_ITEM_CLASS_ID       NUMBER,
  TIME_BILLABLE_FLAG              VARCHAR2(1 BYTE),
  MATERIAL_BILLABLE_FLAG          VARCHAR2(30 BYTE),
  EXPENSE_BILLABLE_FLAG           VARCHAR2(1 BYTE),
  PRORATE_SERVICE_FLAG            VARCHAR2(1 BYTE),
  COVERAGE_SCHEDULE_ID            NUMBER,
  SERVICE_DURATION_PERIOD_CODE    VARCHAR2(10 BYTE),
  SERVICE_DURATION                NUMBER,
  WARRANTY_VENDOR_ID              NUMBER,
  MAX_WARRANTY_AMOUNT             NUMBER,
  RESPONSE_TIME_PERIOD_CODE       VARCHAR2(30 BYTE),
  RESPONSE_TIME_VALUE             NUMBER,
  NEW_REVISION_CODE               VARCHAR2(30 BYTE),
  INVOICEABLE_ITEM_FLAG           VARCHAR2(1 BYTE),
  TAX_CODE                        VARCHAR2(50 BYTE),
  INVOICE_ENABLED_FLAG            VARCHAR2(1 BYTE),
  MUST_USE_APPROVED_VENDOR_FLAG   VARCHAR2(1 BYTE),
  REQUEST_ID                      NUMBER,
  PROGRAM_APPLICATION_ID          NUMBER,
  PROGRAM_ID                      NUMBER,
  PROGRAM_UPDATE_DATE             DATE,
  OUTSIDE_OPERATION_FLAG          VARCHAR2(1 BYTE),
  OUTSIDE_OPERATION_UOM_TYPE      VARCHAR2(25 BYTE),
  SAFETY_STOCK_BUCKET_DAYS        NUMBER,
  AUTO_REDUCE_MPS                 NUMBER(22),
  COSTING_ENABLED_FLAG            VARCHAR2(1 BYTE),
  CYCLE_COUNT_ENABLED_FLAG        VARCHAR2(1 BYTE),
  DEMAND_SOURCE_LINE              VARCHAR2(30 BYTE),
  COPY_ITEM_ID                    NUMBER,
  SET_ID                          VARCHAR2(10 BYTE),
  REVISION                        VARCHAR2(3 BYTE),
  AUTO_CREATED_CONFIG_FLAG        VARCHAR2(1 BYTE),
  ITEM_TYPE                       VARCHAR2(30 BYTE),
  MODEL_CONFIG_CLAUSE_NAME        VARCHAR2(10 BYTE),
  SHIP_MODEL_COMPLETE_FLAG        VARCHAR2(1 BYTE),
  MRP_PLANNING_CODE               NUMBER,
  RETURN_INSPECTION_REQUIREMENT   NUMBER,
  DEMAND_SOURCE_TYPE              NUMBER,
  DEMAND_SOURCE_HEADER_ID         NUMBER,
  TRANSACTION_ID                  NUMBER,
  PROCESS_FLAG                    NUMBER,
  ORGANIZATION_CODE               VARCHAR2(3 BYTE),
  ITEM_NUMBER                     VARCHAR2(700 BYTE),
  COPY_ITEM_NUMBER                VARCHAR2(81 BYTE),
  TEMPLATE_ID                     NUMBER,
  TEMPLATE_NAME                   VARCHAR2(30 BYTE),
  COPY_ORGANIZATION_ID            NUMBER,
  COPY_ORGANIZATION_CODE          VARCHAR2(3 BYTE),
  ATO_FORECAST_CONTROL            NUMBER,
  TRANSACTION_TYPE                VARCHAR2(10 BYTE),
  MATERIAL_COST                   NUMBER,
  MATERIAL_SUB_ELEM               VARCHAR2(10 BYTE),
  MATERIAL_OH_RATE                NUMBER,
  MATERIAL_OH_SUB_ELEM            VARCHAR2(10 BYTE),
  MATERIAL_SUB_ELEM_ID            NUMBER,
  MATERIAL_OH_SUB_ELEM_ID         NUMBER,
  RELEASE_TIME_FENCE_CODE         NUMBER,
  RELEASE_TIME_FENCE_DAYS         NUMBER,
  CONTAINER_ITEM_FLAG             VARCHAR2(1 BYTE),
  VEHICLE_ITEM_FLAG               VARCHAR2(1 BYTE),
  MAXIMUM_LOAD_WEIGHT             NUMBER,
  MINIMUM_FILL_PERCENT            NUMBER,
  CONTAINER_TYPE_CODE             VARCHAR2(30 BYTE),
  INTERNAL_VOLUME                 NUMBER,
  SET_PROCESS_ID                  NUMBER        NOT NULL,
  WH_UPDATE_DATE                  DATE,
  PRODUCT_FAMILY_ITEM_ID          NUMBER,
  PURCHASING_TAX_CODE             VARCHAR2(50 BYTE),
  OVERCOMPLETION_TOLERANCE_TYPE   NUMBER,
  OVERCOMPLETION_TOLERANCE_VALUE  NUMBER,
  EFFECTIVITY_CONTROL             NUMBER,
  GLOBAL_ATTRIBUTE_CATEGORY       VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE1               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE2               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE3               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE4               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE5               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE6               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE7               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE8               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE9               VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE10              VARCHAR2(150 BYTE),
  OVER_SHIPMENT_TOLERANCE         NUMBER,
  UNDER_SHIPMENT_TOLERANCE        NUMBER,
  OVER_RETURN_TOLERANCE           NUMBER,
  UNDER_RETURN_TOLERANCE          NUMBER,
  EQUIPMENT_TYPE                  NUMBER,
  RECOVERED_PART_DISP_CODE        VARCHAR2(30 BYTE),
  DEFECT_TRACKING_ON_FLAG         VARCHAR2(1 BYTE),
  USAGE_ITEM_FLAG                 VARCHAR2(1 BYTE),
  EVENT_FLAG                      VARCHAR2(1 BYTE),
  ELECTRONIC_FLAG                 VARCHAR2(1 BYTE),
  DOWNLOADABLE_FLAG               VARCHAR2(1 BYTE),
  VOL_DISCOUNT_EXEMPT_FLAG        VARCHAR2(1 BYTE),
  COUPON_EXEMPT_FLAG              VARCHAR2(1 BYTE),
  COMMS_NL_TRACKABLE_FLAG         VARCHAR2(1 BYTE),
  ASSET_CREATION_CODE             VARCHAR2(30 BYTE),
  COMMS_ACTIVATION_REQD_FLAG      VARCHAR2(1 BYTE),
  ORDERABLE_ON_WEB_FLAG           VARCHAR2(1 BYTE),
  BACK_ORDERABLE_FLAG             VARCHAR2(1 BYTE),
  WEB_STATUS                      VARCHAR2(30 BYTE),
  INDIVISIBLE_FLAG                VARCHAR2(1 BYTE),
  LONG_DESCRIPTION                VARCHAR2(4000 BYTE),
  DIMENSION_UOM_CODE              VARCHAR2(3 BYTE),
  UNIT_LENGTH                     NUMBER,
  UNIT_WIDTH                      NUMBER,
  UNIT_HEIGHT                     NUMBER,
  BULK_PICKED_FLAG                VARCHAR2(1 BYTE),
  LOT_STATUS_ENABLED              VARCHAR2(1 BYTE),
  DEFAULT_LOT_STATUS_ID           NUMBER,
  SERIAL_STATUS_ENABLED           VARCHAR2(1 BYTE),
  DEFAULT_SERIAL_STATUS_ID        NUMBER,
  LOT_SPLIT_ENABLED               VARCHAR2(1 BYTE),
  LOT_MERGE_ENABLED               VARCHAR2(1 BYTE),
  INVENTORY_CARRY_PENALTY         NUMBER,
  OPERATION_SLACK_PENALTY         NUMBER,
  FINANCING_ALLOWED_FLAG          VARCHAR2(1 BYTE),
  EAM_ITEM_TYPE                   NUMBER,
  EAM_ACTIVITY_TYPE_CODE          VARCHAR2(30 BYTE),
  EAM_ACTIVITY_CAUSE_CODE         VARCHAR2(30 BYTE),
  EAM_ACT_NOTIFICATION_FLAG       VARCHAR2(1 BYTE),
  EAM_ACT_SHUTDOWN_STATUS         VARCHAR2(30 BYTE),
  DUAL_UOM_CONTROL                NUMBER,
  SECONDARY_UOM_CODE              VARCHAR2(3 BYTE),
  DUAL_UOM_DEVIATION_HIGH         NUMBER,
  DUAL_UOM_DEVIATION_LOW          NUMBER,
  CONTRACT_ITEM_TYPE_CODE         VARCHAR2(30 BYTE),
  SUBSCRIPTION_DEPEND_FLAG        VARCHAR2(1 BYTE),
  SERV_REQ_ENABLED_CODE           VARCHAR2(30 BYTE),
  SERV_BILLING_ENABLED_FLAG       VARCHAR2(1 BYTE),
  SERV_IMPORTANCE_LEVEL           NUMBER,
  PLANNED_INV_POINT_FLAG          VARCHAR2(1 BYTE),
  LOT_TRANSLATE_ENABLED           VARCHAR2(1 BYTE),
  DEFAULT_SO_SOURCE_TYPE          VARCHAR2(30 BYTE),
  CREATE_SUPPLY_FLAG              VARCHAR2(1 BYTE),
  SUBSTITUTION_WINDOW_CODE        NUMBER,
  SUBSTITUTION_WINDOW_DAYS        NUMBER,
  IB_ITEM_INSTANCE_CLASS          VARCHAR2(30 BYTE),
  CONFIG_MODEL_TYPE               VARCHAR2(30 BYTE),
  LOT_SUBSTITUTION_ENABLED        VARCHAR2(1 BYTE),
  MINIMUM_LICENSE_QUANTITY        NUMBER,
  EAM_ACTIVITY_SOURCE_CODE        VARCHAR2(30 BYTE),
  LIFECYCLE_ID                    NUMBER,
  CURRENT_PHASE_ID                NUMBER,
  TRACKING_QUANTITY_IND           VARCHAR2(30 BYTE),
  ONT_PRICING_QTY_SOURCE          VARCHAR2(30 BYTE),
  SECONDARY_DEFAULT_IND           VARCHAR2(30 BYTE),
  VMI_MINIMUM_UNITS               NUMBER,
  VMI_MINIMUM_DAYS                NUMBER,
  VMI_MAXIMUM_UNITS               NUMBER,
  VMI_MAXIMUM_DAYS                NUMBER,
  VMI_FIXED_ORDER_QUANTITY        NUMBER,
  SO_AUTHORIZATION_FLAG           NUMBER,
  CONSIGNED_FLAG                  NUMBER,
  ASN_AUTOEXPIRE_FLAG             NUMBER,
  VMI_FORECAST_TYPE               NUMBER,
  FORECAST_HORIZON                NUMBER,
  EXCLUDE_FROM_BUDGET_FLAG        NUMBER,
  DAYS_TGT_INV_SUPPLY             NUMBER,
  DAYS_TGT_INV_WINDOW             NUMBER,
  DAYS_MAX_INV_SUPPLY             NUMBER,
  DAYS_MAX_INV_WINDOW             NUMBER,
  DRP_PLANNED_FLAG                NUMBER,
  CRITICAL_COMPONENT_FLAG         NUMBER,
  CONTINOUS_TRANSFER              NUMBER,
  CONVERGENCE                     NUMBER,
  DIVERGENCE                      NUMBER,
  CONFIG_ORGS                     VARCHAR2(30 BYTE),
  CONFIG_MATCH                    VARCHAR2(30 BYTE),
  ATTRIBUTE16                     VARCHAR2(240 BYTE),
  ATTRIBUTE17                     VARCHAR2(240 BYTE),
  ATTRIBUTE18                     VARCHAR2(240 BYTE),
  ATTRIBUTE19                     VARCHAR2(240 BYTE),
  ATTRIBUTE20                     VARCHAR2(240 BYTE),
  ATTRIBUTE21                     VARCHAR2(240 BYTE),
  ATTRIBUTE22                     VARCHAR2(240 BYTE),
  ATTRIBUTE23                     VARCHAR2(240 BYTE),
  ATTRIBUTE24                     VARCHAR2(240 BYTE),
  ATTRIBUTE25                     VARCHAR2(240 BYTE),
  ATTRIBUTE26                     VARCHAR2(240 BYTE),
  ATTRIBUTE27                     VARCHAR2(240 BYTE),
  ATTRIBUTE28                     VARCHAR2(240 BYTE),
  ATTRIBUTE29                     VARCHAR2(240 BYTE),
  ATTRIBUTE30                     VARCHAR2(240 BYTE),
  CAS_NUMBER                      VARCHAR2(30 BYTE),
  CHILD_LOT_FLAG                  VARCHAR2(1 BYTE),
  CHILD_LOT_PREFIX                VARCHAR2(30 BYTE),
  CHILD_LOT_STARTING_NUMBER       NUMBER,
  CHILD_LOT_VALIDATION_FLAG       VARCHAR2(1 BYTE),
  COPY_LOT_ATTRIBUTE_FLAG         VARCHAR2(1 BYTE),
  DEFAULT_GRADE                   VARCHAR2(150 BYTE),
  EXPIRATION_ACTION_CODE          VARCHAR2(32 BYTE),
  EXPIRATION_ACTION_INTERVAL      NUMBER,
  GRADE_CONTROL_FLAG              VARCHAR2(1 BYTE),
  HAZARDOUS_MATERIAL_FLAG         VARCHAR2(1 BYTE),
  HOLD_DAYS                       NUMBER,
  LOT_DIVISIBLE_FLAG              VARCHAR2(1 BYTE),
  MATURITY_DAYS                   NUMBER,
  PARENT_CHILD_GENERATION_FLAG    VARCHAR2(1 BYTE),
  PROCESS_COSTING_ENABLED_FLAG    VARCHAR2(1 BYTE),
  PROCESS_EXECUTION_ENABLED_FLAG  VARCHAR2(1 BYTE),
  PROCESS_QUALITY_ENABLED_FLAG    VARCHAR2(1 BYTE),
  PROCESS_SUPPLY_LOCATOR_ID       NUMBER,
  PROCESS_SUPPLY_SUBINVENTORY     VARCHAR2(10 BYTE),
  PROCESS_YIELD_LOCATOR_ID        NUMBER,
  PROCESS_YIELD_SUBINVENTORY      VARCHAR2(10 BYTE),
  RECIPE_ENABLED_FLAG             VARCHAR2(1 BYTE),
  RETEST_INTERVAL                 NUMBER,
  CHARGE_PERIODICITY_CODE         VARCHAR2(3 BYTE),
  REPAIR_LEADTIME                 NUMBER,
  REPAIR_YIELD                    NUMBER,
  PREPOSITION_POINT               VARCHAR2(1 BYTE),
  REPAIR_PROGRAM                  NUMBER,
  SUBCONTRACTING_COMPONENT        NUMBER,
  OUTSOURCED_ASSEMBLY             NUMBER,
  SOURCE_SYSTEM_ID                NUMBER,
  SOURCE_SYSTEM_REFERENCE         VARCHAR2(255 BYTE),
  SOURCE_SYSTEM_REFERENCE_DESC    VARCHAR2(240 BYTE),
  GLOBAL_TRADE_ITEM_NUMBER        VARCHAR2(14 BYTE),
  CONFIRM_STATUS                  VARCHAR2(3 BYTE),
  CHANGE_ID                       NUMBER,
  CHANGE_LINE_ID                  NUMBER,
  ITEM_CATALOG_GROUP_NAME         VARCHAR2(820 BYTE),
  REVISION_IMPORT_POLICY          VARCHAR2(30 BYTE),
  GTIN_DESCRIPTION                VARCHAR2(240 BYTE),
  INTERFACE_TABLE_UNIQUE_ID       NUMBER,
  GDSN_OUTBOUND_ENABLED_FLAG      VARCHAR2(1 BYTE),
  TRADE_ITEM_DESCRIPTOR           VARCHAR2(35 BYTE),
  STYLE_ITEM_ID                   NUMBER,
  STYLE_ITEM_FLAG                 VARCHAR2(1 BYTE),
  STYLE_ITEM_NUMBER               VARCHAR2(700 BYTE),
  COPY_REVISION_ID                NUMBER,
  BUNDLE_ID                       NUMBER,
  MESSAGE_TIMESTAMP               DATE,
  MESSAGE_ID                      NUMBER,
  OPERATION                       VARCHAR2(80 BYTE),
  TOP_ITEM_FLAG                   VARCHAR2(1 BYTE),
  GPC_CODE                        VARCHAR2(8 BYTE),
  GLOBAL_ATTRIBUTE11              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE12              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE13              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE14              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE15              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE16              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE17              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE18              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE19              VARCHAR2(150 BYTE),
  GLOBAL_ATTRIBUTE20              VARCHAR2(150 BYTE),
  DEFAULT_MATERIAL_STATUS_ID      NUMBER,
  IB_ITEM_TRACKING_LEVEL          VARCHAR2(30 BYTE)
)
TABLESPACE APPS_TS_TX_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
