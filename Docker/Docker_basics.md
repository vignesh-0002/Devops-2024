# Docker 
- [1.Why Containers required?](#1why-containers-required)
     - [1.1.Container Image and Containers](#11container-image-and-containers)
          - [1.1.1.What is a Container Image?](#111what-is-a-container-image)
          - [1.1.2.What is a container?](#112what-is-a-container)
          - [1.2.3.Start Container in Background or detach mode](#123start-container-in-background-or-detach-mode)
          - [1.2.4.List running Containers](#124list-running-containers)
          - [1.2.5.Docker Stop Docker Containers](#125docker-stop-docker-containers)
          - [1.2.6.List all running and stopped containers](#126list-all-running-and-stopped-containers)
          - [1.2.7.Run vs Start Container](#127run-vs-start-container)
          - [1.2.8.Docker container names](#128docker-container-names)
          - [1.2.9.See logs of a specific container](#129see-logs-of-a-specific-container)
     - [1.2.Commands](#12commands)
          - [1.2.1.Command to Run a Container](#121command-to-run-a-container)
          - [1.2.2.Stop Container foreground process](#122stop-container-foreground-process)
              
- [Docker file Instructions:](#docker-file-instructions)
- [Docker Networks](#docker-networks)



## 1.Why Containers required? 
Containers are required for efficient and consistent application deployment and management, ensuring portability and scalability across different environments.  

## 1.1.Container Image and Containers

### 1.1.1.What is a Container Image?  
A container image is a lightweight, standalone package that includes everything needed to run a piece of software, including:
- Code
- Runtime
- System tools
- Libraries  

### 1.1.2.what is a Container?  
- A **container** is a running instance of an image.  
- You can have many containers running from the same image.

---

## 1.2.Commands

### 1.2.1.Command to Run a Container

Syntax: docker container run --publish <host_port:container_port> <image_name>
## Example:
```docker run -d -p 8080:80 --name my_nginx nginx ```</br>
Also port `8080` is local host port and `80` is container port,
We can run multiple container on same port but thr host port should be unique.
![image](https://github.com/user-attachments/assets/337ed10e-c499-45e0-a3f4-0f9178be1673)
And what if we try to run a conntainer with same host port?
![image](https://github.com/user-attachments/assets/107bf3cd-5904-4296-ad9f-a9d1d8534fe3)


------------
## Output:
![image](https://github.com/user-attachments/assets/8b991c28-848e-4c7c-8512-f57ebdf59afb)
### Docker images:
![image](https://github.com/user-attachments/assets/db4d9ce9-b9d9-46db-ac79-bf8be7540679)
### Docker container:
![image](https://github.com/user-attachments/assets/a817cb17-d7ed-45c0-8bf7-ceeb9be0ad26)

### 1.2.2.Stop Container foreground process 

`ctrl+c` 

### 1.2.3.Start Container in Background or detach mode 

`docker container run - -publish <host_port:container_port> - -detach <image_name> `

### 1.2.4.List running Containers 

 + `docker container ls ` 

+ `docker ps` (Old Way)

### 1.2.5.Docker Stop Docker Containers 

```docker container stop <container_id>``` 

### 1.2.6.List all running and stopped containers 

+ `docker containers ls` 

+ `docker containers ls –a `

### 1.2.7.Run vs Start Container 

`run:` start a new container always 

`start:` start an existing container 

### 1.2.8.Docker container names 

`docker container run - -publish 80:80 - -detach - -name <Name> <Image_Name>` 

### 1.2.9.See logs of a specific container 

`docker container logs <container_name>/<container_id>` 

## See process running inside the containers 

`docker container top <container_id>`

## Remove all unused containers 

`docker container rm <space separated container ids>` 

## View Docker container Resource Consumption 

`docker stats [container_name or container_id] `

## Get detailed information about a container 

`docker inspect [container_name or container_id] `

## Start Container in Interactive Mode 

`docker run -it [image_name or image_id] [command] `

`-i: Keep STDIN open even if not attached. `
`-t: Allocate a pseudo-TTY (terminal). `

## Run Commands in Running Containers 

`docker exec [options] [container_name or container_id] [command] `

`[options]:` Additional options you may want to include. 

`[container_name or container_id]:` The name or ID of the running container. 

`[command]:` The command to be executed inside the container. 
## Basics of docker file: 

Docker can build images automatically by reading the instructions from a Docker file. 

A Docker file is a text document that contains all the commands a user could call on the command line to assemble an image. 

A Docker image consists of read-only layers each of which represents a Docker file instruction. 

## Command to build image from Docker file: 

`docker build -f <dockerfile_path>` 

## Docker file Instructions: 

Docker file Instructions are used to Create the Docker Images. 

### FROM: 

`FROM:` The FROM instruction initializes a new build stage and sets the Base Image for subsequent instructions. 

A valid Docker file must start with a FROM instruction. 

Base Image can be any valid image. 

### Format: 

`FROM <Image_name>:<Image_tag>` 

### LABEL: 

`LABEL:` LABEL added to image to organize images by project, record licensing information. 

For each label, add a line beginning with LABEL and with one or more key-value pairs. 

`LABEL com.example.version=“0.0.1-beta" `

`LABEL vendor1="ACME Incorporated" `

### RUN: 

`RUN :` RUN instruction will execute any commands in a new layer on top of the current image and commit the results. 

The resulting committed image will be used for the next step in the Dockerfile. 
```
FROM ubuntu:14.04 

RUN apt-get update 

RUN apt-get install -y curl 
```
### CMD : 

`CMD :` CMD instruction should be used to run the software contained by your image, along with any arguments. </br>

`CMD [“executable","param1","param2"] `
There can only be one CMD instruction in a Docker file. If you list more than one CMD then only the last CMD will take effect.

### EXPOSE : 
`EXPOSE :` EXPOSE instruction indicates the ports on which a container listens for connections. </br>

`EXPOSE <port> `

### ENV : 

`ENV :` ENV instruction sets the environment variable to the value. 

To make new software easier to run, you can use ENV to update the PATH environment variable for the software your container installs. 

`ENV PATH /usr/local/nginx/bin:$PATH `
### ADD : 

`ADD :` ADD instruction copies new files, directories or remote file URLs from and adds them to the filesystem of the image at the path .  

 `ADD hom* /mydir/ # adds all files starting with “hom" `
### VOLUME : 

`VOLUME :` VOLUME instruction should be used to expose any database storage area, configuration storage, or files/ folders created by your docker container. 
### WORKDIR : 

`WORKDIR :` WORKDIR instruction sets the working directory for any `RUN,CMD, ADD` instructions that follow it in the Dockerfile.

## Simple docker file to run a container.
```
# Use the official Nginx image as the base
FROM nginx:latest

# Copy your custom static site files into the default Nginx directory
COPY ./static-site /usr/share/nginx/html

# Expose the default Nginx port
EXPOSE 80

# Command to start Nginx when the container is run
CMD ["nginx", "-g", "daemon off;"]
```
+ `FROM nginx:latest` we are instructin to use nginx official Nginx image from Docker Hub.
`latest` tag ensures the most recent stable version of Nginx is pulled
+ `COPY ./static-site /usr/share/nginx/html` this line is to Copy your local static website files into the default Nginx directory. `./static-site` The source directory on your local machine containing the website files.
`/usr/share/nginx/html` The default directory in the Nginx container where Nginx looks for files to serve.
+ `EXPOSE 80` This line declares that the container listens on port 80. Port `80` is the default HTTP port that Nginx serves.It's not mandatory to include EXPOSE, but it helps document the intended port.
+ `CMD ["nginx", "-g", "daemon off;"]` The `CMD` instruction specifies the default command to run when a container is started from the Docker image.
    * nginx
       `nginx` is the executable command to start the Nginx web server.Launches the Nginx server to serve content `(e.g., websites, APIs, or static files)`
    * `nginx -g "daemon off;"` This tells Nginx to stay running in the foreground, overriding its default setting to run in the background.
      * Foreground vs Background Processes:
      * ## Foreground Process:
        A process that is active and interacts directly with the user.
        #### Example:
        Running a text editor like vim in the terminal.
      * ## Background Process
        A process that runs in the background, independent of user interaction.
        #### Example:
        Does not occupy the terminal. Running a web server like Nginx or Apache.
            
                 
## File structure:
    ├── Docker
    │   ├── Dockerfile
    │   └── static-site/
    │       └── index.html  # Main HTML file (required for Nginx to serve by default)

## What is inside index.html?
```
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Docker Session</title>
    <style>
        /* Style for the body */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            text-align: center;
            color: blue; /* Text color */
        }

        /* Style for the heading */
        h1 {
            margin-top: 20%;
            font-size: 3em;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.7);
        }
    </style>
</head>
<body>
    <h1>Hello, team! Hope you are enjoying this session!!!!</h1>
</body>
</html>

```
We need to rn this command where our docker is available:
+ Command to build a docke file: ` docker build -t my-nginx-image .`
+ Command to run a image: `docker run -d -p 8080:80 my-nginx-image`

# Docker Networks

## Docker Network Overview
Docker networks allow containers to communicate with each other and the host machine. These networks enable seamless communication between containers and services, regardless of the operating systems (Linux, Windows, or a mix) that the Docker hosts are running.

- Containers and services can communicate without needing to be aware of where they are deployed.
- Each container connects to a virtual private network called **‘bridge’**.

## Bridge Network
The **bridge** is the default network driver for Docker. Containers deployed in the default bridge network can communicate with each other using their IP addresses. 

### Key Points:
- The bridge network is isolated within a cluster. Containers in different clusters cannot communicate with each other unless configured differently.
  
### Best Practices for Creating Networks
- **network “sql_php_nwt”**: Use for MySQL and PHP containers.
- **network “mongo_nwt”**: Use for MongoDB and PHP containers.

## Bridge Networking: 

By default, containers are connected to a Docker bridge 

network, allowing them to communicate with each other on the same host. 

However, containers on different hosts cannot communicate without additional 

configuration.

# lets have a hands on to understand this:
### Start a Docker container with the default bridge network
* Run a container (for example, a simple Ubuntu container):
  ```
  docker run -d --name container1 ubuntu sleep 1000
  ```
* check the container's network settings:
  ```
  docker inspect container1

  ```
### Start another container in the same bridge network
* container2:
```
docker run -d --name container2 ubuntu sleep 1000
```
### Check the IP address of each container: 
* container1
   ```
   docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container1
   ```
* container2
  ```
  docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container2

  ```
### Test communication between the two containers
Now that both containers are on the same bridge network, they should be able to communicate with each other using their IP addresses.
* Ping from container1 to container2
* First, open a shell in container1:
```
docker exec -it container1 bash
```
`ping <container2_ip_address>`
### we need to install the following to `ping`
```
apt-get update
apt-get install iputils-ping -y

```

# Docker netwirk commands:
* `docker network ls`
* `docker network inspect <network_name_or_id>`

### Create a custom bridge network:

```
docker network create --driver bridge my-bridge-network

```
* Run container3 on the new network:
```
docker run -d --name container3 --network my-bridge-network ubuntu sleep 1000
```
* so now we can check the difference between this n/w.
  

### Overlay Networking:

This model enables communication between containers across different hosts. Technologies like VXLAN or IPSec are often used to create 
virtual networks that span multiple hosts. 

### Container Network Interfaces (CNI):  

CNI is a specification that defines how container runtimes interact with networking plugins. It allows different container 
runtimes to be combined with various networking solutions. 

In simple terms, CNI provides the necessary interface to connect containers to networks, ensuring that containers can communicate with each other and with the external world.

* `Modular:` CNI is designed to be modular and pluggable, meaning that different networking plugins can be used based on the requirements.
* `Cross-platform:` CNI can be used in different container runtimes like Docker, Kubernetes, and others.
* `Focus on Simplicity:` CNI focuses on the actual network configuration of containers, providing only the necessary functionality to attach a container to a network, assign IP addresses, and ensure connectivity.

CNI operates using plugins to perform the actual network configuration. When a container is started, CNI ensures the following:
# How CNI Works
* `Network Creation:` If the container needs to join a network, CNI makes sure the network exists and is ready.
* `IP Assignment:` CNI assigns an IP address to the container from the available pool.
* `Network Attachment:` CNI configures the container's network interface (e.g., eth0) to connect to the network.
* `Container Cleanup:` When the container is removed, CNI ensures any resources like IP addresses and network interfaces are cleaned up.

# Example in Simple Terms:
Imagine you have two containers, like two apps running in a box (a container):

* Without CNI: These apps wouldn’t know how to "talk" to each other, because they wouldn’t have an address or network to connect through.
* With CNI: CNI gives each app (container) an address and sets up a network that allows them to communicate, even if one is on a different computer.
