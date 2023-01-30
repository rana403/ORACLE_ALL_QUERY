                          
                            

  SELECT fa.application_id           "Application ID",
fat.application_name        "Application Name",
fa.application_short_name   "Application Short Name",
fa.basepath                 "Basepath"
FROM fnd_application     fa,
fnd_application_tl  fat
WHERE fa.application_id = fat.application_id
AND fat.language      = USERENV('LANG')
 AND fat.application_name LIKE  '%Purcha%'  -- <change it>
 --and fa.application_id= 555
ORDER BY fat.application_name

--==========================================================


SELECT fa.application_name       "Application Name"
,      fa.application_short_name "Application Code"
,      fa.application_id         "Application ID"
,      fa.basepath               "Basepath"
,      fa.product_code           "Product Code"
,      usr1.user_name                                        "Created By"
,      fa.creation_date                                      "Creation Date"
,      usr2.user_name                                        xonly_last_updated_by
,      fa.last_update_date                                   xonly_last_update_date
FROM   fnd_application_vl     fa
,      fnd_user usr1
,      fnd_user usr2
WHERE fa.created_by      = usr1.user_id
--AND fa.application_short_name LIKE 'XX%'
AND    fa.last_updated_by = usr2.user_id
ORDER BY 1