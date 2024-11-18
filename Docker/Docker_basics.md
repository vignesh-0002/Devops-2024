# Docker 
- [Why Containers required?](#why-containers-required)
## Why Containers required? 
Containers are required for efficient and consistent application deployment and management, ensuring portability and scalability across different environments.  

## Container Image and Containers

### What is a Container Image?  
A container image is a lightweight, standalone package that includes everything needed to run a piece of software, including:
- Code
- Runtime
- System tools
- Libraries  

### What is a Container?  
- A **container** is a running instance of an image.  
- You can have many containers running from the same image.

---

## Commands

### Command to Run a Container

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

## Stop Container foreground process 

`ctrl+c` 

## Start Container in Background or detach mode 

`docker container run - -publish <host_port:container_port> - -detach <image_name> `

## List running Containers 

 + `docker container ls ` 

+ `docker ps` (Old Way)

## Docker Stop Docker Containers 

```docker container stop <container_id>``` 

## List all running and stopped containers 

+ `docker containers ls` 

+ `docker containers ls –a `

## Run vs Start Container 

`run:` start a new container always 

`start:` start an existing container 

## Docker container names 

`docker container run - -publish 80:80 - -detach - -name <Name> <Image_Name>` 

## See logs of a specific container 

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


## Docker commands to run word press app and mariadb db: 
```
docker container run --detach --env MARIADB_USER=user --env
MARIADB_PASSWORD=password --env MARIADB_DATABASE=fe-app --env 
MARIADB_ROOT_PASSWORD=pass  --network wp-app --name fb-app mariadb 
```
 
```
docker container run -d -e WORDPRESS_DB_HOST=fb-app -e
WORDPRESS_DB_USER=user -e WORDPRESS_DB_PASSWORD=password -e
WORDPRESS_DB_NAME=fe-app -p 8080:80 --network wp-app  --name fb-app1 wordpress
```