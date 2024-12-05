# How to containerize our app?

## React-hooks-frontend
- create this docker file under `/home/vignesh_selvaraj/devops_2024/Git/EMS-ops/react-hooks-frontend`
  
```
# Use a base image with Node.js installed
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /react-hooks-frontend/

# Copy package.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY . .

# Expose port 3000
EXPOSE 3000

# Command to run
ENTRYPOINT ["npm","start"]
```

## springboot-backend
- create this docker file under `/home/vignesh_selvaraj/devops_2024/Git/EMS-ops/springboot-backend`
```
# Use a base image with Java and Maven installed
FROM maven:3.8.4-openjdk-17

# Set the working directory in the container
WORKDIR /springboot-backend/

# Copy the compiled JAR file from the build stage
COPY target/springboot-backend-0.0.1-SNAPSHOT.jar springboot-backend.jar

# Expose the port on which the Spring Boot application will run
EXPOSE 8080

# Command to run
ENTRYPOINT ["java", "-jar", "springboot-backend.jar"]
```
## Docker compose: 
- create this compose file on `/home/vignesh_selvaraj/devops_2024/Git/EMS-ops`
SS:
![image](https://github.com/user-attachments/assets/16cdc012-b728-491a-946e-b55566032b51)

```
  version: '3.8'

services:
  frontend:
    build:
      context: ./react-hooks-frontend
      dockerfile: Dockerfile
    ports:
      - "5000:3000"
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
      - SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/ems?useSSL=false&allowPublicKeyRetrieval=true
      - SPRING_DATASOURCE_USERNAME=username
      - SPRING_DATASOURCE_PASSWORD=password
      - SPRING_JPA_HIBERNATE_DDL_AUTO=update
    depends_on:
      - database
    networks:
      - ems-ops

  database:
    image: mysql:8.0
    container_name: mysql_container
    ports:
      - "3307:3306"  # Expose MySQL port
    environment:
      MYSQL_ROOT_PASSWORD: password  # Set root password
      MYSQL_DATABASE: ems                # Optionally initialize the ems database
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
