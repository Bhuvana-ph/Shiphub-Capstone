Test 1: Invalid Seller ID

INSERT INTO pickup_addresses
(seller_id, pickup_label, address_line, city, pincode, carrier_count)
VALUES
(99, 'Test Warehouse', 'Test Street', 'Bengaluru', '560001', 1);


ERROR:  insert or update on table "pickup_addresses" violates foreign key constraint "fk_pickup_seller"
DETAIL:  Key (seller_id)=(99) is not present in table "sellers".


Test 2: Invalid Pincode


INSERT INTO pickup_addresses
(seller_id, pickup_label, address_line, city, pincode, carrier_count)
VALUES
(1, 'Test Pincode', 'Test Street', 'Bengaluru', '12345', 1);
ERROR:  new row for relation "pickup_addresses" violates check constraint "chk_pickup_pincode"
DETAIL:  Failing row contains (9, 1, Test Pincode, Test Street, Bengaluru, 12345, 1, f).


Test 3: Duplicate Pickup Label

INSERT INTO pickup_addresses
(seller_id, pickup_label, address_line, city, pincode, carrier_count)
VALUES
(1, 'Test Pincode', 'Test Street', 'Bengaluru', '12345', 1);

ERROR:  new row for relation "pickup_addresses" violates check constraint "chk_pickup_pincode"
DETAIL:  Failing row contains (10, 1, Test Pincode, Test Street, Bengaluru, 12345, 1, f).

