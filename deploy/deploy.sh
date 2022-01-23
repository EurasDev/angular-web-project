#!/bin/bash

echo $'>> Initializing backend...\n'
terraform -chdir=terraform init
if [ $? -ne 0 ] 
then
    echo $'>> Initializing backend failed.\n'
    exit 1
fi

echo $'>> Executing Terraform apply...\n'
terraform -chdir=terraform apply -auto-approve
if [ $? -ne 0 ] 
then
    echo $'>> Executing Terraform apply failed.\n'
    exit 2
fi