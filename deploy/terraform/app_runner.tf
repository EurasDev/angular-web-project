resource "aws_apprunner_service" "this" {
  service_name = "my-angular-app"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "public.ecr.aws/o4x2j9z3/angular_docker_image:latest"
      image_repository_type = "ECR_PUBLIC"
    }
  }
}