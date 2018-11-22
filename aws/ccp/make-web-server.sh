#!/bin/bash
# provision the instance as a web server

# update the OS
yum update -y

# install apache webserver
yum install httpd -y

# copy the html files from s3 bucket
aws s3 cp s3://a-static-website-bucket /var/www/html --recursive

# start the apache web server
service httpd start

# set the server to restart automatically
chkconfig httpd on
