## 1. Dockerfile and .dockerignore
Created inside `shiphub-api/`:
- Dockerfile
- .dockerignore
The Dockerfile uses Node.js 22 Alpine, installs production dependencies, copies the application, runs as a non-root user, and starts the API.

The .dockerignore excludes node_modules, environment files, Git files, tests, and other unnecessary files from the Docker build context.

## 2. Docker image

Build command:
    cd shiphub-api
    docker build -t shiphub-api:v1 .
Image created successfully: shiphub-api:v1

## 3. Docker network

Created a Docker network:
    docker network create shiphub-network
The API, MongoDB, and PostgreSQL containers use this network.

## 4. Database containers

MongoDB:
- Image: mongo:8.0
- Container: shiphub-mongo
- Port: 27017
- Persistent volume: shiphub-mongo-data

PostgreSQL:
- Image: postgres:17
- Container: shiphub-postgres17
- Host port: 5433
- Container port: 5432
- Persistent volume: shiphub-postgres17-data

## 5. API container

Started the API using:

    docker run -d \
      --name shiphub-api \
      --network shiphub-network \
      -p 3000:3000 \
      -e PORT=3000 \
      -e LOG_LEVEL=info \
      -e MONGODB_URI=mongodb://shiphub-mongo:27017/shiphub \
      shiphub-api:v1

API port: 3000

MongoDB connection string uses the Docker container name
shiphub-mongo instead of localhost.

Environment variables are passed at runtime and are not baked into
the Docker image. The .env file is excluded from the build context.

## 6. Application connectivity test

Command:
    curl -s -o /dev/null -w "HTTP status: %{http_code}\n" http://localhost:3000/orders

Result:
    HTTP status: 200

API logs confirmed:
    MongoDB connected successfully

## 7. Restart and persistence tests

MongoDB:
- Restarted shiphub-mongo.
- API remained running.
- GET /orders returned HTTP 200 after the restart.

PostgreSQL:
- Created docker_persistence_test table.
- Inserted a test record.
- Restarted shiphub-postgres17.
- Queried the table again.
- The inserted record was still present.

This verifies PostgreSQL data persistence using the named volume
shiphub-postgres17-data.

## 8. Image vs container

Docker image:
A packaged template containing the application and its required
runtime and dependencies.

Docker container:
A running instance created from a Docker image.

## 9. Important implementation note

The current ShipHub API connects to MongoDB.
PostgreSQL is running as a separate database container, but the
current API code does not yet establish a PostgreSQL connection.
EOF