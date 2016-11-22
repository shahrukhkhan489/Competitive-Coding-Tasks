# Zycus_Assignent

## Assignment 1 :
 
Write a Dockerfile (CentOS 6) to install the following in a Docker continer:
Python 2.7
MongoDB - any version
Apache tomcat 7 - running on port 8080
 
Please include comments at every command explaining what it does.
Write the command to run the Dockerfile such that once the container boots, apache tomcat's home page is accessible from the host on port 7080.
 
## Assignment 2 :
 
Write a bash/python script that takes list of hostnames (comma separated) as an argument.
This script, when executed, should connect to all the servers via. SSH (standard port) (assume password-less connectivity) and give a single prompt to the user.
When the user executes a command on this prompt, the script should run the command on all connected servers and display the output.
Make this as efficient as possible, code comments appreciated.
 
## Assignment 3: 
 
Considering a three-tier app (web server, app server and database).
[ Apache Web server -> Tomcat app server -> database ]
How would you build an app stack (leave out the database) that has no single point of failure and is fault-tolerant?
Explicitly state the assumptions you are making, if any.
 
