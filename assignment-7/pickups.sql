-- Create sellers table
CREATE TABLE sellers (
    seller_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_name VARCHAR(100) NOT NULL UNIQUE
);
-- Create pickup_addresses table
CREATE TABLE pickup_addresses (
    pickup_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    seller_id INT NOT NULL,

    pickup_label VARCHAR(50) NOT NULL,

    address VARCHAR(255) NOT NULL,

    pincode VARCHAR(6) NOT NULL,

    carrier_count INT NOT NULL DEFAULT 0,

    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_pickup_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id),

    CONSTRAINT chk_pincode
        CHECK (pincode ~ '^[0-9]{6}$'),

    CONSTRAINT chk_carrier_count
        CHECK (carrier_count >= 0),

    CONSTRAINT uq_seller_pickup_label
        UNIQUE (seller_id, pickup_label)
);
-- Seed sellers
INSERT INTO sellers (seller_name)
VALUES
    ('ABC Stores'),
    ('XYZ Stores'),
    ('New Seller Ltd');
-- Seed pickup addresses
INSERT INTO pickup_addresses
    (seller_id, pickup_label, address, pincode, carrier_count, is_default)
VALUES
    (1, 'Warehouse', 'Bengaluru Warehouse', '560001', 3, TRUE),
    (1, 'Shop', 'Mysore Shop', '570001', 2, FALSE),
    (1, 'Studio', 'Bengaluru Studio', '560002', 1, FALSE),
    (2, 'Office', 'Chennai Office', '600001', 2, TRUE);
