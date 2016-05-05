#!/bin/bash

# Requirements:
# 1. Have the Openstack clients installed
# 2. OpenStack credentials in ENV
# 
# Check The OpenStack "API Quick Start" on 
#   http://docs.openstack.org/api/quick-start/content/

keystone tenant-create --name $1 --description "$1 Team."
