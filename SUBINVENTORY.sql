
To Check Item Category For Inventory master (No Of Segments May Varry)

SELECT distinct ood.organization_name,ood.organization_code, mcs.CATEGORY_SET_NAME ,
segment1|| '-'|| segment2|| '-'|| segment3 catgory
FROM org_organization_definitions ood,
mtl_categories_vl mcv,
mtl_category_sets mcs
WHERE mcs.structure_id = mcv.structure_id
AND ood.organization_code='KWM'
ORDER BY ood.organization_name


select CATEGORY_SET_NAME , DESCRIPTION  from mtl_category_sets

SELECT  distinct SEGMENT1 ,  SEGMENT2 ,SEGMENT3  FROM mtl_categories_vl 



Check Locators for inventory Inventory Org Wise(Number of segment may varry)

-- GET LOCATOR Information
--==========================

SELECT mil.segment1 loc_seg1, mil.segment11 loc_seg11, mil.segment2 loc_seg2,
mil.segment3 loc_seg3, mil.segment4 loc_seg4, mil.segment5 loc_seg5,
mil.segment6 loc_seg6,ood.ORGANIZATION_NAME,mil.SUBINVENTORY_CODE
FROM mtl_item_locations mil,org_organization_definitions ood
where mil.ORGANIZATION_ID = ood.ORGANIZATION_ID and mil.segment1 = 'KSM'


SELECT DISTINCT LOCATOR_ID,SUBINVENTORY_CODE  FROM MTL_ITEM_LOC_DEFAULTS   where SUBINVENTORY_CODE = 'KSM_MStore'

SELECT * FROM MTL_ITEM_LOC_DEFAULTS where SUBINVENTORY_CODE = 'KSM_MStore'


select* from mtl_item_locations where SUBINVENTORY_CODE = 'KSM_MStore'


--===========================================
--DISPLAY ALLS UB INVENTORIES SETUP
--==========================================


select msi.secondary_inventory_name, MSI.SECONDARY_INVENTORY_NAME "Subinventory", MSI.DESCRIPTION "Description",
MSI.DISABLE_DATE "Disable Date", msi.PICKING_ORDER "Picking Order",
gcc1.concatenated_segments "Material Account",
gcc2.concatenated_segments "Material Overhead Account",
gcc3.concatenated_segments "Resource Account",
gcc4.concatenated_segments "Overhead Account",
gcc5.concatenated_segments "Outside Processing Account",
gcc6.concatenated_segments "Expense Account",
gcc7.concatenated_segments "Encumbrance Account",
msi.material_overhead_account,
msi.resource_account,
msi.overhead_account,
msi.outside_processing_account,
msi.expense_account,
msi.encumbrance_account
from mtl_secondary_inventories msi,
gl_code_combinations_kfv gcc1,
gl_code_combinations_kfv gcc2,
gl_code_combinations_kfv gcc3,
gl_code_combinations_kfv gcc4,
gl_code_combinations_kfv gcc5,
gl_code_combinations_kfv gcc6,
gl_code_combinations_kfv gcc7
where msi.material_account = gcc1.CODE_COMBINATION_ID(+)
and msi.material_overhead_account = gcc2.CODE_COMBINATION_ID(+)
and msi.resource_account = gcc3.CODE_COMBINATION_ID(+)
and msi.overhead_account = gcc4.CODE_COMBINATION_ID(+)
and msi.outside_processing_account = gcc5.CODE_COMBINATION_ID(+)
and msi.expense_account = gcc6.CODE_COMBINATION_ID(+)
and msi.encumbrance_account = gcc7.CODE_COMBINATION_ID(+)
order by msi.secondary_inventory_name