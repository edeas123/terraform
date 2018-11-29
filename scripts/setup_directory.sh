#!/bin/bash -e

# run this from the desired directory
# create symlink for the base terraform configuration files
ln -f ../../common/* .

# initialize terraform
terraform init .
