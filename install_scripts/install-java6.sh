#!/bin/sh
#TODO Switch to u31 or some other hbase-approved java
sudo sh -c \
"echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main' | tee -a /etc/apt/sources.list; \
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main' | tee -a /etc/apt/sources.list; \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886; \
apt-get update; \
apt-get install oracle-java6-installer"
