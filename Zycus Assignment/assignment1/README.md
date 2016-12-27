#Assignment 1 

## Question

Write a Dockerfile (CentOS 6) to install the following in a Docker continer: 

Python 2.7 

MongoDB - any version 

Apache tomcat 7 - running on port 8080


Please include comments at every command explaining what it does. Write the command to run the Dockerfile such that once the container boots, apache tomcat's home page is accessible from the host on port 7080.


## Answer

### Go into Task Directory
cd task

### Build the Docker Image from DockerFile
docker build -t task .

### Run the Docker Image and map 8080 port of Docker Container with external port 7080 of the System
docker run -p 7080:8080 task
