#!/bin/bash
# provision the instance as a jenkins server

# update the yum package management tool
yum update -y

# download the latest jenkins code package
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo

# import a key file from Jenkins-CI to enable installation from the package
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# remove java 1.7
yum remove java-1.7.0 -y

# install java 8 required by jenkins
yum install java-1.8.0 -y

# install jenkins
yum install jenkins -y

# start Jenkins as a service
service jenkins start