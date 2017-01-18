FROM centos:6

RUN yum update -y && yum install -y \
        wget tar unzip perl mysql-server mysql-devel git

RUN cd && wget --no-cookies --no-check-certificate --header \
        "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm" \
 && yum localinstall -y jdk-7u79-linux-x64.rpm \
 && rm -f jdk-7u79-linux-x64.rpm 

ENV JAVA_HOME=/usr/java/jdk1.7.0_79

RUN cd && wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.65/bin/apache-tomcat-7.0.65.tar.gz \
 && mkdir -p /usr/local/tomcat \
 && tar -zxvf apache-tomcat-7.0.65.tar.gz -C /usr/local/tomcat --strip-components=1 \
 && rm -f apache-tomcat-7.0.65.tar.gz

ENV CATALINA_HOME=/usr/local/tomcat


RUN cd /opt && git clone https://github.com/mayurah/Cloud-Deployment.git

RUN service mysqld start

RUN mysql -u root -e "create database quantiphi_db"

RUN cd /opt/Cloud-Deployment/database && mysql -u root quantiphi_db < db-dump.sql

RUN mysqladmin -u root password 'admin' 

RUN cp /opt/Cloud-Deployment/war-file/learnhub.war /usr/local/tomcat/webapps

RUN cd /usr/local/tomcat && bin/shutdown.sh && bin/startup.sh
