#!/bin/bash
DEPLOY_ENVIRONMENT=$1  # {dv|st|pr|ops}
AWS_ACCESS_KEY_ID=$2
AWS_SECRET_ACCESS_KEY=$3

# Removed for local deploy
#echo $'>> Initializing backend...\n'
#terraform init \
#    -backend-config="$DEPLOY_ENVIRONMENT/backend-config.tfvars" 

#if [ $? -ne 0 ] 
#then
#    echo $'>> Initializing backend failed.\n'
#    exit 1
#fi

echo $'>> Executing Terraform apply...\n'
terraform apply \
    -var-file="$DEPLOY_ENVIRONMENT/variables.tfvars" \
    -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
    -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY" \
    -auto-approve 

if [ $? -ne 0 ] 
then
    echo $'>> Executing Terraform apply failed.\n'
    exit 1
fi