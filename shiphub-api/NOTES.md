# Assignment: Repair, Prove and Document the ShipHub Stack

## Fault 1: MongoDB image incompatible with the host kernel

Symptom: MongoDB container exited during startup.
Evidence:`docker compose ps -a` showed `Exited (1)`. Timestamped logs reported a known incompatibility with Linux kernel 6.19 and newer. Host kernel: `7.0.0-43-generic`.
Cause: The original `mongo:8.0` image could not start correctly on this host.
Fix:Changed the image to `mongo:7.0`.
Proof: MongoDB started and passed its health check.

## Fault 2: Incorrect MongoDB connection address

Symptom:The API could not connect to MongoDB when running inside Docker.
Evidence:The original `.env` used `mongodb://127.0.0.1:27017/shiphub`.
Cause:Inside the API container, `127.0.0.1` refers to the API container itself, not the MongoDB container.
Fix:Changed the URI to `mongodb://mongo:27017/shiphub`, using the Compose service name.
Proof: API logs showed `MongoDB connected successfully`, and the API became healthy.

## Fault 3: Missing MongoDB configuration in the example environment file

Symptom: The example environment file did not provide the MongoDB connection setting.
Evidence: The original `shiphub-api/.env.example` contained only `PORT` and `LOG_LEVEL`.
Cause: The required `MONGODB_URI` setting was missing.
Fix: Added `MONGODB_URI=mongodb://mongo:27017/shiphub`.
Proof: The API and migration service started successfully using the Compose environment configuration.

## Fault 4: Missing service health checks and startup dependencies

Symptom: The original Compose configuration did not verify database readiness before starting dependent services.
Evidence: The original configuration had no MongoDB health check or API health check.
Cause: Container startup alone does not guarantee that the database is ready to accept connections.
Fix: Added MongoDB and API health checks, `service_healthy` for MongoDB dependencies, and `service_completed_successfully` for the migration dependency.
Proof: `docker compose up -d --build --wait` completed with MongoDB and API healthy and migration exited with code 0.

## Fault 5: Migration was not a separate Compose service

Symptom: The original Compose configuration did not run the priority migration as part of stack startup.
Evidence: There was no migration service in the original Compose configuration.
Cause: Database migration execution was not included in the startup sequence.
Fix: Added a separate `migrate` service that runs `migrations/add-priority.js` after MongoDB becomes healthy.
Proof: `docker compose ps -a` showed `shiphub-migrate-1` as `Exited (0)`.

## Fault 6: Missing convenience scripts

Symptom: The root package did not provide the required `npm run up` and `npm run down` commands.
Evidence: The original root package scripts did not contain these commands.
Cause: Compose startup and shutdown commands were not defined as npm scripts.
Fix: Added `up` and `down` scripts to the root `package.json`.
Proof: Both `npm run up` and `npm run down` executed successfully.

## Verification Evidence

`docker compose config --quiet` completed without errors.
Three clean startup runs completed successfully using `npm run up`.
Each successful run showed MongoDB healthy, API healthy, and migration exited with code 0.
Created order: `ORD-1795606933582`.
Ran `npm run down` followed by `npm run up`.
Retrieved the same order successfully using `GET /orders/ORD-1795606933582`.
This proved that the MongoDB volume preserved order data across a normal Compose shutdown and restart.

### Why use service_healthy instead of short dependency syntax?

Short dependency syntax waits for a container to start, not for its service to become ready. `service_healthy` waits until the health check succeeds. This prevents the API and migration from trying to connect to MongoDB before it is ready.

### Why keep migration as a separate service?

Migration is a one-time database task, not a long-running API process. Keeping it separate makes its success or failure visible and allows the API to start only after migration completes successfully.

### One remaining weakness

The stack does not currently define resource limits for its containers. A service could consume too much CPU or memory and affect the other services on the same host.
