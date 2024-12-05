# How to dockerize Ems-ops?
- Initialized empty repository, using git init command.
- Clone ems-ops repo from github.
- use `git clone <Repo url>` command for clone the repo.
- so we have cloned ems-ops repo.
![image](https://github.com/user-attachments/assets/df62ccce-ade4-4e43-bb2b-77bf92346721)
- Now we are going to list the branches. 
```
git branch -a 
```
![image](https://github.com/user-attachments/assets/40361412-58f5-417e-80bd-d40965f0fc66)
- Use `git checkout phase-o` command and current the star symbol is hovering on `phase-0`
## Now lets see some factors like app structure 

## ReactJS Frontend 
--------------------
* Java SpringBoot backend 

* MySQL RDBMS

###  Tools 

* Java 17  

* Maven 3.8.8 

* NodeJs 14.x 

* MySQL 8.x

## Now lets see the required tools needed for our application.

`Note:` please be very cautious while installing the required dependency,
even a single version mismatch can lead to trouble in executing the application. 

## Tools Installation (Ubuntu based) 

- Java 
```
    sudo apt update 
    sudo apt install openjdk-17-jdk openjdk-17-jre
```
## Output: 
```
Jdk 17 installed successfully
```
## Maven 
```
    wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz 

    tar -xvf apache-maven-3.8.8-bin.tar.gz 

    sudo mv apache-maven-3.8.8 /opt/ 
```

- `Note` we need to use sudo to perform any action in `/opt`

- `mv:` cannot move 'apache-maven-3.8.8' to '/opt/apache-maven-3.8.8': `Permission denied`
  ## Maven M2_HOME Setup
  - Open the profile file `nano ~/.profile` of the user and add the following and save the file.
    ```
    M2_HOME='/opt/apache-maven-3.8.8' 

    PATH="$M2_HOME/bin:$PATH" 

    export PATH 
    ```
    - Exit your session and relog in to check maven version.
    - Verify the version of maven, it should be 3.8.8
    ```
    mvn -version
    ```
    - Output:
    ```
    Apache Maven 3.8.8 (4c87b05d9aedce574290d1acc98575ed5eb6cd39)
    Maven home: /opt/apache-maven-3.8.8
    Java version: 17.0.13, vendor: Ubuntu, runtime: /usr/lib/jvm/java-17-openjdk-amd64
    Default locale: en, platform encoding: UTF-8
    OS name: "linux", version: "5.15.167.4-microsoft-standard-wsl2", arch: "amd64", family: "unix"
    ```
  ## NodeJs:
- 1. Update and install necessary packages in a single layer.
```
 sudo apt-get update
 sudo apt-get upgrade -y
```
- 2. Install Required Dependencies
  ```
  sudo apt-get install -y curl gnupg
  ```
- 3. Add NodeSource Repository
  ```
  curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

  ```
- 4.  Install Node.js
     ```
     sudo apt-get install -y nodejs

     ```
- 5. sudo apt-get install -y nodejs
     ```
      node -v
      npm -v
     ```
 - 6. You should see versions for Node.js 14.x and npm.
## MySQL 

- Install MySQL Server 
```
    sudo apt update 
    sudo apt install mysql-server 
```
- Update root user password 
    ```
     Sudo mysql 
     ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
     Exit 
    ```
- Configure User
   ```
   sudo mysql -u root -p
   CREATE USER 'username'@'%' IDENTIFIED WITH mysql_native_password BY 'password'; 
   GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION; 
   FLUSH PRIVILEGES; 
   exit 
   ```
   - Create Database
      ```
      sudo mysql -u username –p 

      CREATE DATABASE ems;

      Show databases; 
      ```

      ## Backend:
     ----------------------
1. Backend Setup 
- Code Base:
- 1. Java-SpringBoot Code placed under springboot-backend
  2. Update Application Properties `application.properties` file under `springboot-backend/src/main/resources/application.properties` contains details of `DB` . Have to update the `username` , `password` that we have created above.
  3. So we need to update the mysql user name and password here, On the below screen shot I have updated the user name,followed by we are going to update the MySQL password
      ![image](https://github.com/user-attachments/assets/c8445997-d928-4682-84f7-9c5ffc4eaf09)
  4. So on the below line we can see ems? Which is nothing but the data base name we have created earlier while creating MySQL user,
  5.  `spring.datasource.url=jdbc:mysql://localhost:3306/ems?useSSL=false` 


## Maven package init 

- `pom.xml` under the java project folder `springboot-backend` contains all the package and its dependencies, to install them all we use maven tool
- `mvn clean`  must be executed from parent folder `springboot-backend`
- Output:
  
  ![image](https://github.com/user-attachments/assets/9d6475d2-8fb9-4f50-8397-3c9a796a09b7)

## Build the backend 

- Post the package installation is done , we have to build and package the application so that it can be executed as a process and serve the backend service.
- `mvn install` is the command to build and package the application. This will generate a target folder under `springboot-backend` and `*.jar` file will be generated.
  ![image](https://github.com/user-attachments/assets/915ea319-a2c2-4d72-a985-feef4ccf05d0)
- On the above screen shot we can see out build executed successfully, Also we got target file and inside the target fine we have out `springboot-backend-0.0.1-SNAPSHOT.jar`  

- Run the code 

   - `java -jar apppppp.jar` , replace the `apppppp.jar` with the jar file gnerated in the previous step. This command executes the jar as process and in the console, once can see the status og sping boot application
   - `Java backend` is running fine now lets move forward to front end. 


## 2. Frontend Setup 

 

- Code Base 

  - ReactJS Code placed under react-hooks-frontend 
  - Build the frontend application
  - First move to react-hooks-frontend directory  
```
/home/vignesh_selvaraj/devops_2024/Git/EMS-ops/react-hooks-frontend
```

- But before building the app we are going to do some change in the `EmployeeService.js` which is available in the this path `ems-ops/react-hooks-frontend/src/services `
- We are going to replace the local host to the public Ip of the `ec2`, because it will allow the Api to update the data in data base.
- `NOTE`: follow this only if you are running the app on ec2.
- `const EMPLOYEE_BASE_REST_API_URL = 'http://localhost:8080/api/v1/employees'; `
- `const EMPLOYEE_BASE_REST_API_URL = 'http://ec2 pub ip:8080/api/v1/employees'; `
  <img width="959" alt="image" src="https://github.com/user-attachments/assets/0bdbbc22-1ac0-40cc-8aa3-5db908b48f23">

  ## Now we can follow the below steps, 

`npm install` must be executed from parent folder `react-hooks-frontend` to get the packages and dependencies , store them under `node_modules` folder. 
![image](https://github.com/user-attachments/assets/fdfbc0e8-326e-4cfa-ae59-23481015cd1c)

## Run the Application 

- `npm start` must be executed from parent folder `react-hooks-frontend` to start the front end application. By default the application runs on port `3000`
- Use this url to access the app `http://localhost:3000/employees`
  
