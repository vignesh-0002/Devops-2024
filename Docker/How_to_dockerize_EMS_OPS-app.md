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
### Now lets see some factors like app structure 

* ReactJS Frontend 

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
- Update and install necessary packages in a single layer.
```
  RUN apt-get update && \
    apt-get install -y nodejs npm curl && \
```
- Install NVM and Node versions:
  ```
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  ```
- Optionally check versions (these can be omitted or redirected to a file to save on image size)
```
node -v && npm -v
```
