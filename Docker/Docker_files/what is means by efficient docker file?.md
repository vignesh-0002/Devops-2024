# Best Practices for Writing a Dockerfile
Reffered from `https://www.geeksforgeeks.org/best-practices-for-writing-a-dockerfile/`
- If you are a Docker developer or you have been trying to get your hands dirty on Docker,
  you must have noticed the importance of creating an efficient dockerfile.
- A Dockerfile allows you to mention a sequence of instructions that
are executed step by step and each execution creates an intermediate image layer on top of the base image.
- After executing the last instruction, you get your final Docker image.
- The performance of the Docker Container can vary depending upon the sequence of steps you have specified in your dockerfile.
- Thus, it’s very important that you take the utmost care of the steps that you include inside your dockerfile.
- In this article, we are going to discuss the best practices that you can adopt in order to make
sure that your final Docker Image builds and runs efficiently with low resource consumption.

----------------------------------------------------------------------------------------------------------------------

# 1. Avoid installing unnecessary packages.
- If you install unnecessary packages in your dockerfile, it will increase the build time and the size of the image.
- Also, each time you make changes in the dockerfile, you will have to go through all the steps to build that same large image again and again.
-  This creates a cascading downward effect on the performance.
-  To avoid this, it’s always advised that only include those packages
   that are of utmost importance and try avoiding installing the same packages again and again.

----------------------------------------------------------------------------------------------------------------------

# 2. Chain all RUN commands.
- Each RUN command creates a cacheable unit and builds a new intermediate image layer every time.
- You can avoid this by chaining all your RUN commands into a single RUN command.
- Also, try to avoid chaining too much cacheable RUN commands because
it would then lead to the creation of a large cache and would ultimately lead to cache burst.

```Docker
RUN apt-get -y install firefox
RUN apt-get -y install vim
RUN apt-get -y update
```
- The above commands can be chained into a single RUN command.
```
RUN apt-get -y install firefox \
   && apt-get -y install vim \
   && apt-get -y update
```
# 3. Use a .dockerignore file.
- Similar to `.gitignore` file,
  you can specify files and directories inside `.dockerignore` file which you would like to exclude from your Docker build context.
- This would result in removing unnecessary files from your Docker Container,
reduce the size of the Docker Image, and boost up the build performance.

# 4. Use the best order of statements
- Include the most frequently changing statements at the end of your dockerfile. The reason behind this is that
when you change a statement in your dockerfile, its cache gets invalidated and all the subsequent statements cache will also break.
- For example, include RUN commands to the top and COPY commands to the bottom.
  Include the CMD, ENTRYPOINT commands at the end of the dockerfile.

# 5. Avoid installing unnecessary package dependencies 
- You can use the –no-install-recommends flag while building the image.
It will tell the apt package manager to not install redundant dependencies.
- Installing unnecessary packages only increases the build time and size of the image which would lead to degraded performance.
- To conclude, how not choosing the proper order while writing your dockerfile can increase the build time, size of the image,
and decrease the performance of the whole process.
- We also discussed some of the top tips you can follow to improve the overall build performance,
reduce the number of caches that builds an intermediate image layer.

# 6. Using a minimal base image:
- Using a larger base image with more packages and libraries 
installed can increase the size of the final Docker image and potentially decrease performance.
- It is generally recommended to use a minimal base image, such as Alpine Linux,
as a starting point for building a Docker image.
- This can help to reduce the size and complexity of the final image,
leading to better performance and faster build times.
- Additionally, using a minimal base image can also improve security by reducing the number of potential vulnerabilities
that may be present in the final image.

