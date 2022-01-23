#!/bin/bash
echo "Compiling application..."
pushd ./src/
ng build
popd
if [ $? -ne 0 ]; then
    echo "Failed to compile"
    exit 1
fi

IMAGE_NAME="angular_docker_image"

echo "Logging in to Amazon ECR..."
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/o4x2j9z3
if [ $? -ne 0 ]; then
    echo "Failed to login into ECR"
    exit 2
fi

echo "Building Docker container image..."
docker build --no-cache -t $IMAGE_NAME .
if [ $? -ne 0 ]; then
    echo "Docker container image build failed"
    exit 3
fi

echo "Tagging Docker container image..."
AWS_ECR_URI=public.ecr.aws/o4x2j9z3/$IMAGE_NAME:latest
docker tag $IMAGE_NAME:latest $AWS_ECR_URI
if [ $? -ne 0 ]; then
    echo "Docker container image tag failed"
    exit 4
fi

echo "Pushing Docker container image to ECR repo..."
docker push $AWS_ECR_URI
if [ $? -ne 0 ]; then
    echo "Docker container image push to ECR failed"
    exit 5
fi

exit $?