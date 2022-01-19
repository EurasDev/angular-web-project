#!/bin/bash
SSM_DEPLOY_CREDENTIALS_PATH=/angular/deploy/user_angular_deploy_policy
DKR_IMAGE_NAME="angular-docker-image"

echo "Getting credentials from SSM: $SSM_DEPLOY_CREDENTIALS_PATH"

AAK=$(aws ssm get-parameters --names $SSM_DEPLOY_CREDENTIALS_PATH/access.key)
ASK=$(aws ssm get-parameters --names $SSM_DEPLOY_CREDENTIALS_PATH/secret.key --with-decryption)

export AWS_ACCESS_KEY_ID=$AAK
export AWS_SECRET_ACCESS_KEY=$ASK

echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 247883804977.dkr.ecr.us-east-1.amazonaws.com
if [ $? -ne 0 ]; then
    echo "Failed to login into ECR"
#    exit 3
fi

echo "Building Docker container image..."
docker build -t angular_docker_image .
#docker build --no-cache -t $DKR_IMAGE_NAME .
if [ $? -ne 0 ]; then
    echo "Docker container image build failed"
    #exit 4
fi

echo "Tagging Docker container image..."
#AWS_ECR_URI=247883804977.dkr.ecr.us-east-1.amazonaws.com/$DKR_IMAGE_NAME
#docker tag $DKR_IMAGE_NAME:latest $AWS_ECR_URI:latest
docker tag angular_docker_image:latest 247883804977.dkr.ecr.us-east-1.amazonaws.com/angular_docker_image:latest
if [ $? -ne 0 ]; then
    echo "Docker container image tag failed"
    #exit 5
fi

echo "Pushing Docker container image to ECR repo..."
docker push 247883804977.dkr.ecr.us-east-1.amazonaws.com/angular_docker_image:latest
#docker push $AWS_ECR_URI:latest
if [ $? -ne 0 ]; then
    echo "Docker container image push to ECR failed"
    #exit 6
fi

#exit $?

$SHELL