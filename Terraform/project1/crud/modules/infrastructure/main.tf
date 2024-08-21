# Generate SSH keys for connecting to EC2 which are created by ASG
resource "tls_private_key" "aws_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "aws_key"
  public_key = tls_private_key.aws_key.public_key_openssh
}

resource "local_sensitive_file" "pem_file" {
  filename = pathexpand("~/.ssh/aws_key.pem")
  file_permission = "400"
  directory_permission = "700"
  content = tls_private_key.aws_key.private_key_pem
}

# Create secrets for RDS usage
resource "random_password" "password" {
  count   = 2
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "rds_credentials_master" {
  name = "${var.environment}-cred-master"
}

resource "aws_secretsmanager_secret" "rds_credentials_user" {
  name = "${var.environment}-cred-user"
}

resource "aws_secretsmanager_secret_version" "rds_credentials_master" {
  secret_id     = aws_secretsmanager_secret.rds_credentials_master.id
  secret_string = <<EOF
{
  "username": "${var.master_username}",
  "password": "${random_password.password[0].result}"
}
EOF
}

resource "aws_secretsmanager_secret_version" "rds_credentials_user" {
  secret_id     = aws_secretsmanager_secret.rds_credentials_user.id
  secret_string = <<EOF
{
  "username": "${var.username}",
  "password": "${random_password.password[1].result}"
}
EOF
}

locals {
  master_cred = jsondecode(aws_secretsmanager_secret_version.rds_credentials_master.secret_string)
  user_cred = jsondecode(aws_secretsmanager_secret_version.rds_credentials_user.secret_string)
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "ami-aws_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# ---------------------------------- Security Groups ----------------------------------
# DB security group
resource "aws_security_group" "rds_security_group" {
  name        = "allow_mysql"
  description = "Allow connect to standart MySQL port from ASG security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.ASG_security_group.id]
  }
}

# ASG security group
resource "aws_security_group" "ASG_security_group" {
  name        = "ASG_security_group"
  description = "Allow connect to HTTP port from ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.ALB_security_group.id]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# ALB security group
resource "aws_security_group" "ALB_security_group" {
  name        = "ALB_security_group"
  description = "Allow connect to HTTP port from ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [var.allowed_ips]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.allowed_ips]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DB subnet group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "main"
  subnet_ids = tolist(var.private_subnets_RDS_id)

  tags = {
    Name = "${var.environment}-db_subnet_group"
  }
}

# RDS db instance
resource "aws_db_instance" "RDS-crud" {
  identifier                  = "${var.environment}-rds-db-instance"
  vpc_security_group_ids      = [aws_security_group.rds_security_group.id]
  allocated_storage           = var.allocated_storage
  db_name                     = var.database_name
  engine                      = var.rds_engine
  storage_encrypted           = false
  availability_zone           = var.availability_zone
  instance_class              = var.rds_instance_class
  username                    = local.master_cred.username
  password                    = local.master_cred.password
  db_subnet_group_name        = aws_db_subnet_group.subnet_group.name
  skip_final_snapshot         = true
  backup_retention_period     = 0
  apply_immediately           = true

  tags = {
    Name = "${var.environment}-RDS"
  }
}

# ------------------------------ ALB ------------------------------
# Application load balancer
resource "aws_lb" "ALB_crud" {
  name               = "alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_security_group.id]
  subnets            = tolist(var.public_subnets_id)

  tags = {
    Name = var.environment
  }
}

# HTTP_Listener
resource "aws_lb_listener" "HTTP_listener" {
  load_balancer_arn = aws_lb.ALB_crud.arn
  port              = "80"
  protocol          = "HTTP"

  /* default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_crud.arn
  } */
  default_action {
    type = "redirect"
  
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
} 

# HTTPS_Listener
resource "aws_lb_listener" "HTTPS_listener" {
  load_balancer_arn = aws_lb.ALB_crud.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = aws_acm_certificate.cert_crud.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_crud.arn
  }
}

# Target group
resource "aws_lb_target_group" "target_group_crud" {
  name                              = "${var.environment}-target-group"
  target_type                       = "instance"
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"
  port                              = 80
  protocol                          = "HTTP"
  deregistration_delay              = var.deregistration_delay
  vpc_id                            = var.vpc_id
  
  health_check {
    enabled             = true
    interval            = 90
    path                = "/"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200"
  } 
  tags = {
    Name = var.environment
  }
}

# Launch template
resource "aws_launch_template" "crud_launch_template" {
  name                 = "${var.environment}-launch_template"
  description          = "Launch Template for instalation php, apache, mysql-client and configuration connect to DB"
  image_id             = data.aws_ssm_parameter.ami-aws_linux_2.value
  instance_type        = var.instance_type
  key_name             = "aws_key"

  iam_instance_profile {
    name = "crud_instance_profile"
  }
  
  network_interfaces {
    associate_public_ip_address = false
    device_index                = 0
    security_groups             = [aws_security_group.ASG_security_group.id]
  }
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    s3_bucket    = var.s3_uri,
    db_hostname  = element(split(":", aws_db_instance.RDS-crud.endpoint), 0)
    db_name      = var.database_name,
    db_user      = local.user_cred.username,
    db_pass      = local.user_cred.password,
    db_root_pass = local.master_cred.password,
    db_root_user = local.master_cred.username
    }))
}

# Autoscaling group
resource "aws_autoscaling_group" "crud_ASG" {
  name                      = "${var.environment}"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.check_grace_period
  vpc_zone_identifier       = tolist(var.private_subnets_id)
  target_group_arns         = [aws_lb_target_group.target_group_crud.arn]
  health_check_type         = "ELB"
  default_instance_warmup   = var.instance_warmup
  default_cooldown          = var.asg_cooldown

  launch_template {
    id      = aws_launch_template.crud_launch_template.id
    version = aws_launch_template.crud_launch_template.latest_version
  }
}

# Configuration dynamic autoscalling policy
resource "aws_autoscaling_policy" "add-instance" {
  name                      = "${var.environment}-add-instance"
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "SimpleScaling"
  scaling_adjustment        = var.add_instance
  autoscaling_group_name    = aws_autoscaling_group.crud_ASG.name
  cooldown                  = var.asg_policy_cooldown
}

resource "aws_autoscaling_policy" "remove-instance" {
  name                      = "${var.environment}-remove-instance"
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "SimpleScaling"
  scaling_adjustment        = var.remove_instance
  autoscaling_group_name    = aws_autoscaling_group.crud_ASG.name
  cooldown                  = var.asg_policy_cooldown
}

# Configuration cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "crud" {
  alarm_name          = "request-per-target"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = var.period
  statistic           = "Sum"
  threshold           = var.threshold

  dimensions = {
    TargetGroup  = aws_lb_target_group.target_group_crud.arn_suffix
    LoadBalancer = aws_lb.ALB_crud.arn_suffix
  }

  alarm_description = "This metric monitors count request per target"
  alarm_actions     = [aws_autoscaling_policy.add-instance.arn]
  ok_actions        = [aws_autoscaling_policy.remove-instance.arn]
}

# ---------------------------------- IAM ----------------------------------
#IAM_role for copying application code from S3 bucket to EC2 instances
resource "aws_iam_role" "role-s3-read-only" {
  name = "role-s3-read-only"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
      }
    },
  ]
})
}

resource "aws_iam_instance_profile" "crud_profile" {
  name = "crud_instance_profile"
  role = aws_iam_role.role-s3-read-only.name
}

resource "aws_iam_policy" "policy-s3-read-only" {
  name        = "iam-policy-for-s3-read-only"
  description = "iam-policy-for-copying-files-from-private-s3-bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:Get*","s3:List*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role-s3-read-only.name
  policy_arn = aws_iam_policy.policy-s3-read-only.arn
}

# ---------------------------------- ACM & Route53 ----------------------------------
resource "aws_acm_certificate" "cert_crud" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.dns_zoneID
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.ALB_crud.dns_name
    zone_id                = aws_lb.ALB_crud.zone_id
    evaluate_target_health = true
  }
}