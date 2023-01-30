 -- API to Create Supplier

DECLARE
   l_vendor_rec       ap_vendor_pub_pkg.r_vendor_rec_type;
   l_return_status   VARCHAR2(10);
   l_msg_count       NUMBER;
   l_msg_data         VARCHAR2(1000);
   l_vendor_id        NUMBER;
   l_party_id           NUMBER;

BEGIN
   -- --------------
   -- Required
   -- --------------
   l_vendor_rec.segment1          := '0000235916';
   l_vendor_rec.vendor_name   := 'TEST_SUPP';
 
   -- -------------
   -- Optional
   -- --------------
   l_vendor_rec.match_option  :='R';
 
   pos_vendor_pub_pkg.create_vendor
   (    -- -------------------------
        -- Input Parameters
        -- -------------------------
        p_vendor_rec      => l_vendor_rec,
        -- ----------------------------
        -- Output Parameters
        -- ----------------------------
        x_return_status   => l_return_status,
        x_msg_count       => l_msg_count,
        x_msg_data         => l_msg_data,
        x_vendor_id        => l_vendor_id,
        x_party_id           => l_party_id
   );
 
   COMMIT;
EXCEPTION
      WHEN OTHERS THEN
                   ROLLBACK;
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

/


--=====================================================================
