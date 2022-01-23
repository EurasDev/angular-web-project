resource "aws_apprunner_auto_scaling_configuration_version" "this" {                            
  auto_scaling_configuration_name = "asg_angular_app"
  min_size = 1
  max_size = 2
}

resource "aws_apprunner_service" "this" {
  service_name = "my-angular-app"
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  source_configuration {
    image_repository {
      image_configuration {
        port = "80"
      }
      image_identifier      = "public.ecr.aws/o4x2j9z3/angular_docker_image:latest"
      image_repository_type = "ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }
}