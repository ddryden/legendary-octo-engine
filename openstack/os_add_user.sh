#!/bin/bash

# Requirements:
# 1. Have the Openstack clients installed
# 2. OpenStack credentials in ENV
# 
# Check The OpenStack "API Quick Start" on 
#   http://docs.openstack.org/api/quick-start/content/

#TODO: Might want to check for OS env. variables and warn user to authenticate.

#TODO: Check args have come correct
username=$1
project=$2
password=`openssl rand 9 -base64`
firstname=$3
lastname=$4
domain=$5

#TODO: Check $project exists?

#Add user
echo "keystone user-create --name $username --tenant $project --pass $password --email $username@$domain"
#Check it worked?
#Email User
python sendemail.py $firstname $lastname $username $password

