resource "aws_lb" "ecs_load_balancer" {
  load_balancer_type         = "application"
  name                       = var.public_ecs_cluster_loadbalancer_name
  internal                   = false
  security_groups            = [aws_security_group.cloudflare_access_ecs_sg.id]
  subnets                    = var.public_alb_subnets
  idle_timeout               = var.ecs_alb_idle_timeout
  enable_deletion_protection = false
  enable_http2               = true
  ip_address_type            = "ipv4"

  tags = merge(local.common_tags, tomap("Name", "${var.public_ecs_cluster_loadbalancer_name}", "Author", var.author))


  timeouts {
    create = "10m"
    delete = "20m"
    update = "10m"
  }
}

resource "aws_alb_target_group" "ecs_lb_tg_https" {
  name     = var.ecs_lb_tg_https_name
  port     = "443"
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = "5"
  }

  tags = merge(local.common_tags, tomap("Name", "${var.ecs_lb_tg_https_name}", "Author", var.author))

}


resource "aws_lb_listener" "ecs_lb_listener_https" {
  load_balancer_arn = aws_lb.ecs_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_policy
  depends_on        = [aws_alb_target_group.ecs_lb_tg_https]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_lb_tg_https.arn
  }
}