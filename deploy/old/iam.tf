/**
*   EC2 TRUST DOC
*/
data "aws_iam_policy_document" "ec2_trust_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    effect = "Allow"
  }
}

/**
*   EC2 INSTANCE ROLE
*/
resource "aws_iam_role" "ecs_instance_role" {
  name                  = var.ecs_cluster_instance_role_name
  assume_role_policy    = data.aws_iam_policy_document.ec2_trust_doc.json
  force_detach_policies = "true"

  tags = merge(local.common_tags, tomap("Name", "${var.ecs_cluster_instance_role_name}"))
}

resource "aws_iam_instance_profile" "ecs_cluster_instance_profile" {
  name = var.ecs_cluster_instance_profile_name
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role_policy" "instance_role_policy" {
  name = "ecs_cluster-instance-policy"
  role = aws_iam_role.ecs_instance_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
POLICY

}
