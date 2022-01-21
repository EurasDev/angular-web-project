# User data for ECS cluster
data "template_file" "ecs_cluster_data" {
  template = file(var.policy)

  vars = {
    ecs_cluster = var.ecs_cluster_name
  }
}