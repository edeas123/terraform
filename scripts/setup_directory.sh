#!/bin/bash -ex
 
# create symlink for the base terraform configuration files
# run this from the desired directory
ln ../base/* .

# initialize terraform
terraform init
