# angular-web-project

## Build

The build.sh script compiles the angular application, builds it as a Docker image and pushes it to ECR.

## Deploy

To deploy the application locally, run /deploy/deploy.sh which will grab the image above and provision an AWS App Runner service using that image.
