SELECT              xiv.ou_name,
                    xiv.io_code,
                    xiv.io_name,
                    msik.concatenated_segments item_code,
                    msik.description item_name,
                    msik.primary_uom_code UOM,
                    mic.segment1 item_type,
                    mic.segment2 item_group,
                    mic.segment3 item_sub_group,
                    mic.segment4 segment4,
                    (select cat.CATEGORY_CONCAT_SEGS  from mtl_item_categories_v cat where mic.organization_id=cat.organization_id and mic.inventory_item_id=cat.inventory_item_id and CATEGORY_SET_ID=1100000041) FINANCE_CATEGORY,
                    (select cat.CATEGORY_CONCAT_SEGS from mtl_item_categories_v cat  where mic.organization_id=cat.organization_id and mic.inventory_item_id=cat.inventory_item_id and CATEGORY_SET_ID=1) Inventory_category,
--                    msik.EXPENSE_ACCOUNT,
--                    GCC.CODE_COMBINATION_ID,
                    GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6||GCC.SEGMENT7||'.'||GCC.SEGMENT8||'.'||GCC.SEGMENT9||'.'||GCC.SEGMENT10 EXPENSE_ACCOUNT
             FROM   mtl_system_items_kfv msik,
                    mtl_item_categories_v mic,
                    xx_inv_iooule_v xiv,
                    MTL_PARAMETERS_VIEW MPV,
                    GL_CODE_COMBINATIONS GCC
            WHERE       msik.organization_id = mic.organization_id
                    AND msik.inventory_item_id = mic.inventory_item_id
                    AND mic.segment1<>'DEFAULT'
                    AND msik.EXPENSE_ACCOUNT=GCC.CODE_COMBINATION_ID
                    AND msik.organization_id = MPV.organization_id
                    AND mic.structure_id = 101
                    AND msik.organization_id = xiv.io_id
                    AND (xiv.LE_ID = :p_legal_entity_id or :p_legal_entity_id is null)
                    AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                    AND (:P_ORGANIZATION_ID IS NULL  OR  msik.organization_id = :P_ORGANIZATION_ID)
                    AND (:p_item_id IS NULL OR  msik.inventory_item_id = :p_item_id)
                    AND mic.segment1=NVL(:P_ITEM_TYPE,mic.segment1)
                    AND mic.segment2=NVL(:P_ITEM_GROUP,mic.segment2)
                    AND mic.segment3=NVL(:P_ITEM_SUB_GROUP,mic.segment3)
                    AND NVL(mic.CATEGORY_CONCAT_SEGS,'XXXX')=NVL(:P_FINANCE_CATEGORY,NVL(mic.CATEGORY_CONCAT_SEGS,'XXXX'))
                    AND msik.INVENTORY_ITEM_STATUS_CODE = 'Active'
                    order by xiv.ou_id, xiv.io_code










SELECT   --xiv.le_id,
                    --xiv.le_code,
                    --xiv.le_name,
                    --xiv.ou_id,
                    --xiv.ou_code,
                    xiv.ou_name,
                    xiv.io_code,
                    xiv.io_name,
                    --msik.organization_id,
                    --msik.inventory_item_id,
                    msik.concatenated_segments item_code,
                    msik.description item_name,
                    msik.primary_uom_code UOM,
                    --msik.primary_unit_of_measure p_uom_name,
                    --msik.secondary_uom_code s_uom_code,
                    mic.segment1 item_type,
                    mic.segment2 item_group,
                    mic.segment3 item_sub_group,
                    mic.segment4 segment4,
                    (select cat.CATEGORY_CONCAT_SEGS  from mtl_item_categories_v cat where mic.organization_id=cat.organization_id and mic.inventory_item_id=cat.inventory_item_id and CATEGORY_SET_ID=1100000041) FINANCE_CATEGORY,
                    (select cat.CATEGORY_CONCAT_SEGS from mtl_item_categories_v cat  where mic.organization_id=cat.organization_id and mic.inventory_item_id=cat.inventory_item_id and CATEGORY_SET_ID=1) Inventory_category 
                    ,msik.EXPENSE_ACCOUNT,
                    msik.INVENTORY_ITEM_STATUS_CODE
             FROM   mtl_system_items_kfv msik,
                    mtl_item_categories_v mic,
                    xx_inv_iooule_v xiv,
                    MTL_PARAMETERS_VIEW MPV
            WHERE       msik.organization_id = mic.organization_id
                    AND msik.inventory_item_id = mic.inventory_item_id
                    AND mic.segment1<>'DEFAULT'
                    AND msik.organization_id = MPV.organization_id
                    AND mic.structure_id = 101
                    AND msik.organization_id = xiv.io_id
                    AND (xiv.LE_ID = :p_legal_entity_id or :p_legal_entity_id is null)
                    AND (:P_OPERATING_UNIT IS NULL OR xiv.OU_ID=:P_OPERATING_UNIT)
                    AND (:P_ORGANIZATION_ID IS NULL  OR  msik.organization_id = :P_ORGANIZATION_ID)
                    AND (:p_item_id IS NULL OR  msik.inventory_item_id = :p_item_id)
                    AND mic.segment1=NVL(:P_ITEM_TYPE,mic.segment1)
                    AND mic.segment2=NVL(:P_ITEM_GROUP,mic.segment2)
                    AND mic.segment3=NVL(:P_ITEM_SUB_GROUP,mic.segment3)
                    AND NVL(mic.CATEGORY_CONCAT_SEGS,'XXXX')=NVL(:P_FINANCE_CATEGORY,NVL(mic.CATEGORY_CONCAT_SEGS,'XXXX'))
--                    AND msik.INVENTORY_ITEM_STATUS_CODE = 'Active'
                    order by xiv.ou_id, xiv.io_code