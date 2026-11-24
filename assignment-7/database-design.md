# DATABASE DESIGN       
            sellers
               |
        INT         seller_id   PK
        VARCHAR     seller_name
                |
                |
               has 
                |
                |
            pickup_addresses
            
        INT     pickup_id   PK
        INT     seller_id   FK
        VARCHAR pickup_label    
        VARCHAR address_line
        VARCHAR city
        VARCHAR pincode
        INT     carrier_count
        BOOLEAN is_default

# Relationship

sellers is the parent table.
pickup_addresses is the child table.
One seller can have multiple pickup addresses.
One seller can also have zero pickup addresses.
Every pickup address must belong to one seller.