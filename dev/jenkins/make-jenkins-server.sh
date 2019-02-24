#!/bin/bash
# provision the instance as a jenkins server

# update the apt package management tool
apt-get update -y

# install docker
apt-get install docker.io -y

# install nfs4
apt-get install nfs-common -y

# make jenkins dir
mkdir /var/jenkins_home

# mount efs volume
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-19294860.efs.us-east-2.amazonaws.com:/ /var/jenkins_home

# run jenkins
docker run -u root --rm \
  -p 49000:8080 \
  -v /var/jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkinsci/blueocean