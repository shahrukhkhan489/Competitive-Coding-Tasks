# Assignment 3

## Question

Considering a three-tier app (web server, app server and database).

[ Apache Web server -> Tomcat app server -> database ]

How would you build an app stack (leave out the database) that has no single point of failure and is fault-tolerant?

Explicitly state the assumptions you are making, if any.

## Answer

Architecture displayed in diagram

![Architecture](Architecture.png)


1 HAProxy [High Availability] is first point of access to avoid Single Point of Faliure for Web Server. This will make sure that the website is up. 

2 The HAProxy fetches data from Load Balancer which is responsible for balancing Load between Cluster of Auto Scaling Servers. If one Load Balancer Fails then there is a FailOver Load Balancer.

3 The AutoScaling Servers consists of Apache Server and Tomcat Server Services which are serve as Web Server and Application Server and display data from fetching data from Database

4 The Database can be two Servers or a Cluster of Multiple Servers where algorithms for Replication should be implemented

5 Caching services such as Memcached or Redis can be introduced to improve the Response Time.
