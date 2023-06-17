resource "aws_security_group" "efs" {
  name        = "${var.environment} efs"
  description = "Allow traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "nfs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "TCP"
    cidr_blocks      = [module.vpc.vpc_cidr_block]
  }
}
#  IAM roles to the nodes to use EFS
resource "aws_iam_policy" "node_efs_policy" {
  name        = "eks_node_efs-${var.environment}"
  path        = "/"
  description = "Policy for EFKS nodes to use EFS"

  policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "elasticfilesystem:DescribeMountTargets",
                "elasticfilesystem:DescribeFileSystems",
                "elasticfilesystem:DescribeAccessPoints",
                "elasticfilesystem:CreateAccessPoint",
                "elasticfilesystem:DeleteAccessPoint",
                "ec2:DescribeAvailabilityZones"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": ""
        }
    ],
    "Version": "2012-10-17"
  }
  )
}

resource "aws_efs_file_system" "kube" {
  creation_token = "eks-efs"
}

resource "aws_efs_mount_target" "mount" {
    file_system_id = aws_efs_file_system.kube.id
    subnet_id = each.key
    for_each = toset(module.vpc.private_subnets )
    security_groups = [aws_security_group.efs.id]
}