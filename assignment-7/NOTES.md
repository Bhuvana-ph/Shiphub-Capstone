# Decision Record: PostgreSQL vs MongoDB for ShipHub Pickup Addresses

## 1. Context

In ShipHub, each seller can have multiple pickup addresses, such as warehouses, shops, and studios. Some sellers may have no pickup addresses initially.
We need a database design that maintains relationships between sellers and pickup addresses and prevents invalid or duplicate data.

## 2. Decision
We decided to use PostgreSQL to store seller information and pickup addresses in two separate tables: sellers & pickup_addresses
The seller_id in the pickup_addresses table references the sellers table through a foreign key.

## 3. Reasons

- **Referential Integrity:** Foreign keys prevent pickup addresses from referencing sellers who do not exist.
- **Normalization:** Seller information is stored once, avoiding duplicate data.
- **Constraints:** NOT NULL, UNIQUE and CHECK constraints prevent invalid records.
- **Relationships:** One seller can have multiple pickup addresses.
- **Query Support:** SQL JOIN and COUNT make it easy to retrieve seller and pickup information.
- **Transactions:** PostgreSQL supports reliable transactional operations.

## 4. Costs and Trade-offs

- Schema changes may require database migrations.
- Database relationships and constraints need to be maintained.
- PostgreSQL requires backups, monitoring and maintenance.

## 5. Rejected Alternative: MongoDB

MongoDB could store pickup addresses as an array inside each seller document. This makes retrieving all addresses for one seller convenient.

However, PostgreSQL provides built-in foreign key constraints, relational integrity and convenient SQL reporting for this requirement.

## 6. Conclusion

PostgreSQL is the preferred choice for ShipHub pickup addresses because the data has a clear relationship between sellers and pickup locations. It provides strong data integrity, normalization and efficient querying.
