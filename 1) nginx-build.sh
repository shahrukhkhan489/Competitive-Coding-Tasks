#!/bin/bash

# Q1. Write a program to build a deb package from the nginx source package.
# Please refer to the following to build and configure the source.
# http://nginx.org/en/docs/configure.html

nginxVersion="1.11.5"

sudo apt-get update
sudo apt-get install -y build-essential automake autoconf libtool pkg-config libcurl4-openssl-dev intltool libxml2-dev libgtk2.0-dev libnotify-dev libglib2.0-dev libevent-dev checkinstall

wget http://nginx.org/download/nginx-$nginxVersion.tar.gz
tar -xzf nginx-$nginxVersion.tar.gz 
cd nginx-$nginxVersion
./configure && make && sudo checkinstall

sudo mv  nginx_$nginxVersion*.deb ~/
cd ~/
ll -ltr nginx_$nginxVersion*.deb