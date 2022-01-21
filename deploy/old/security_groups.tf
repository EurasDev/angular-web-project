
## Instance Security Group
resource "aws_security_group" "ecs_instance_sg" {
  lifecycle {
    create_before_destroy = false
  }

  name   = var.ecs_instance_sg_name
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "http_instance" {
  lifecycle {
    create_before_destroy = true
  }

  security_group_id        = aws_security_group.ecs_instance_sg.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
}