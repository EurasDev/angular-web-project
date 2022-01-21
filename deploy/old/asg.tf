resource "aws_autoscaling_group" "ecs_cluster_autoscaling_group" {
  name                 = ecs_cluster_autoscaling_group_name
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.private_alb_subnets
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name
  health_check_type    = "ELB"

  # As version is passed in at apply time we need to define it in the resource
  # .tfvars don't have access to execution variables

    tags = [
      {
        "key"                 = "Name"
        "value"               = var.ecs_cluster_name
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = var.aws_account
        "propagate_at_launch" = true
      }
    ]
}