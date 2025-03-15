# How to containerize our app?

## React-hooks-frontend
- create this docker file under `/home/vignesh_selvaraj/devops_2024/Git/EMS-ops/react-hooks-frontend`
  
```dockerfile
# Use a base image with Node.js installed
FROM node:14-alpine

# Set the working directory
WORKDIR /react-hooks-frontend/

# Copy the application files
COPY . /react-hooks-frontend/


# ENV
ARG REACT_APP_BACKEND_URL
ENV REACT_APP_BACKEND_URL=$REACT_APP_BACKEND_URL

# Install dependencies
RUN npm install

# Expose port 3000
EXPOSE 3000

# Command to run
ENTRYPOINT ["npm","start"]

```

## springboot-backend
- create this docker file under `/home/vignesh_selvaraj/devops_2024/Git/EMS-ops/springboot-backend`
```dockerfile
# Use a base image with Java and Maven installed
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy source code and build the application
COPY . .

# Optional: skip tests during build
RUN mvn clean package -DskipTests

# -----------------------------
# Create a new clean image just for running
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the compiled JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Optional: Set environment variables (these can be overridden at runtime)
ENV SPRING_DATASOURCE_URL=""
ENV SPRING_DATASOURCE_USERNAME=""
ENV SPRING_DATASOURCE_PASSWORD=""
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=""

# Expose port
EXPOSE 8080

# Run the jar with env variables
ENTRYPOINT ["java", "-jar", "app.jar"]
```
## Docker compose: 
- create this compose file on `/home/vignesh_selvaraj/devops_2024/Git/EMS-ops`
SS:
![image](https://github.com/user-attachments/assets/16cdc012-b728-491a-946e-b55566032b51)

```dockerfile
version: '3.8'

services:
  frontend:
    build:
      context: ./react-hooks-frontend
      dockerfile: Dockerfile
    ports:
      - "5000:3000"
    environment:
      - REACT_APP_BACKEND_URL=http://34.235.89.173:8080
    depends_on:
      - backend
    networks:
      - ems-ops

  backend:
    build:
      context: ./springboot-backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://database-1.c0n8mseiazqy.us-east-1.rds.amazonaws.com:3306/ems?useSSL=false&allowPublicKeyRetrieval=true
      - SPRING_DATASOURCE_USERNAME=username
      - SPRING_DATASOURCE_PASSWORD=password
      - SPRING_JPA_HIBERNATE_DDL_AUTO=update
    depends_on:
      database:
        condition: service_healthy
    networks:
      - ems-ops

  database:
    image: mysql:8.0
    container_name: mysql_container
    ports:
      - "3307:3306"  # Expose MySQL port
    environment:
      MYSQL_USER: username
      MYSQL_PASSWORD: password
      MYSQL_ROOT_PASSWORD: password  # Set root password
      MYSQL_DATABASE: ems                # Optionally initialize the ems database
    healthcheck:
      test: ["CMD","mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10
    volumes:
      - db_data:/var/lib/mysql            # Persistent storage
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql  # Mount init.sql file
    networks:
      - ems-ops

volumes:
  db_data:

networks:
  ems-ops:
    external: true

```
- Use `docker-compose up`to run spin up the containers.
![image](https://github.com/user-attachments/assets/fd1a131e-68c5-4dfb-96dd-053757ac91d8)
- We can access our app on `http://localhost:5000/`
- I have addes the following data on my EMS-ops app:
  ![image](https://github.com/user-attachments/assets/232bbac3-d61c-475e-827b-00989a5920cb)
