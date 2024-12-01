# Multi-Stage Docker Builds

This is a copy from link: https://dev.to/pavanbelagatti/what-are-multi-stage-docker-builds-1mi9

  <img src="https://github.com/user-attachments/assets/83d4aec6-350b-497f-b9d6-1083cb8f8da7" alt="image" width="500" />


- Every microservice should be its own separate container. If you only use a single-stage Docker build, 
you’re missing out on some powerful features of the build process. 
- On the other hand, a multi-stage Docker build has many advantages over a single-stage build for deploying microservices.
- A multi-stage build is a process that allows you to break the steps in building a Docker image into multiple stages.
- This will enable you to create images that include only the dependencies that are necessary for the desired functionality of the final application,
cutting down on both time and space.
- With a multi-stage build, you will first build the image that contains only the dependencies needed to build your application.
- Then, after the image has been built, you can add in any additional layers needed to create your application and configure it for deployment.
- In this way, you can build images with only the code necessary for building the application.
- This is also strategically used to optimize the container images and make them smaller.

------------------------------------------------------------------------------------------

- As mentioned above, multi-stage builds let you create optimized Docker images with only the dependencies necessary to build your application.
- Combined with Docker’s layered images, this can help you save significant space.
- The multi-stage process saves space on your Docker host and in the Docker image and speeds up the build process.
- In addition, the process will be much quicker than it would be if you included all the code needed to build your application.

------------------------------------------------------------------------------------------
- Creating two Dockerfiles; one for development and one for production is not considered ideal in the DevOps world and that is
where multi-stage Docker builds come handy as we can have one optimized Dockerfile created for all the environments - `Dev`, `Staging` and `Production`.

# Multi-Stage Docker Build Examples
--------------------------------------
## Java Example:
- To understand the concept of Multi-stage Docker builds better, let us consider a simple Java Hello World application.

- Add the following code in a file named `HelloWorld.java`
```
class HelloWorld {
   public static void main(String[] a) {
       System.out.println("Hello world!");
   }
}
```
- Then, create a Dockerfile with the following content in it,

```
FROM openjdk:11-jdk
COPY HelloWorld.java .
RUN javac HelloWorld.java
CMD java HelloWorld
```

- Build the image with the following command,
```
docker build -t helloworld:huge .
```

- Let’s modify our Dockerfile with the following content to show how multi-stage Docker build works.
```
FROM openjdk:11-jdk AS build
COPY HelloWorld.java .
RUN javac HelloWorld.java

FROM openjdk:11-jre AS run
COPY --from=build HelloWorld.class .
CMD java HelloWorld
```
Build the image with the following command,
```
docker build -t helloworld:small .
```
- Now, let’s compare both images. Check the images created with the following command,

- The following are our docker file and to run this use the following command:
-  Dockerfile.small
```
docker build -t helloworld:huge -f Dockerfile.huge .
```
-  Dockerfile.small
```
docker build -t helloworld:small -f Dockerfile.small .
```
- Now, let’s compare both images. Check the images created with the following command,

`docker images`

![image](https://github.com/user-attachments/assets/753a9d99-0e3f-48ac-b4b1-e899ef862590)
------------------------------------------------------------------------------------------

- Hope you can see the difference in size between the two images.
- This way, you can separate the build and runtime environments in the same Dockerfile.
- Use build environment as a dependency `[COPY --from=build HelloWorld.class .]` while creating
   the Dockerfile with the approach of multi-stage docker build.
- This will help minimize the size of Docker images.

## Node.Js Example
- Let’s learn with a simple NodeJs application that has a simple Dockerfile.
```
FROM node:14-alpine
ADD . /app
WORKDIR /app
COPY package.json .
RUN npm install --production
COPY . .
EXPOSE 3002
CMD [ "node", "app.js" ]
```
- Let’s build the image with the following command,
```
docker build -t [DockerHub username]/image name:tag
```
- Push the image to Docker Hub with the command,

```
docker push [DockerHub username]/image name:tag
```
- I pushed the image to DockerHub, and here is the image and size below,

![image](https://github.com/user-attachments/assets/0afb074f-7996-4f6f-90aa-26dc190a7e4d)

- Now, let’s try using the concept of multi-stage Docker build and modify our existing Dockerfile.

```
FROM node:14-alpine as base
ADD . /app
WORKDIR /app
COPY package.json .
RUN npm install 
FROM alpine:latest
COPY --from=stage1 /app /app
WORKDIR /app
EXPOSE 3002
CMD [ "node", "app.js" ]
```

- Let’s build and push the image with the similar commands used above.
- Just make sure to give a different name to the image.
![image](https://github.com/user-attachments/assets/519554e8-ec76-44e2-a991-993acdaee115)

- Now, compare the image sizes. One with the usual Dockerfile is `48.81 MB`, and the other created with a multi-stage Docker build is `7.12 MB`. 
- Can you see the difference? The image created by the multi-stage Docker build approach is more optimized.
- Another example that shows how multi-stage Docker builds can be used efficiently is a scenario where you
like to dissect the Dockerfile for different environments.
- A normal Dockerfile looks as below,

```
FROM node:14-alpine

WORKDIR /src
COPY package.json package-lock.json /src/
RUN npm install --production

COPY . /src

EXPOSE 3000

CMD ["node", "bin/www"]
```
## We will create 3 simple stages from the above Dockerfile.

- `Base stage:` This stage will have things in common with the original Dockerfile
- `Production stage:` This stage will include things useful for the production environment
- `Dev stage:` This stage will have components useful for the Dev environment

### The modified Dockerfile looks as below,

```
FROM node:14-alpine as base



WORKDIR /src

COPY package.json package-lock.json /src/

EXPOSE 3000



FROM base as production

ENV NODE_ENV=production

RUN npm ci

COPY . /src

CMD ["node", "bin/www"]



FROM base as dev

ENV NODE_ENV=development

RUN npm install -g nodemon && npm install

COPY . /src

CMD ["nodemon", "bin/www"]

```
# Some notable advantages of using a multi-stage build,
- Optimizes the overall size of the Docker image
- Removes the burden of creating multiple Dockerfiles for different stages
- Easy to debug a particular build stage
- Able to use the previous stage as a new stage in the new environment
- Ability to use the cached image to make the overall process quicker
- Reduces the risk of vulnerabilities found as the image size becomes smaller with multi-stage builds
