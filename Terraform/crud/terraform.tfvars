# General parameters
aws_region  = "eu-central-1"
environment = "crud"
allowed_ips = "31.129.232.108/30"

# Network parameter
vpc_cidr = "10.0.0.0/16"
public_subnet = {
  public_1 = {
    cidr = "10.0.1.0/24"
    az   = "eu-central-1b"
  },
  public_2 = {
    cidr = "10.0.2.0/24"
    az   = "eu-central-1c"
  }
}
private_subnet = {
  private_1 = {
    cidr = "10.0.3.0/24"
    az   = "eu-central-1b"
  },
  private_2 = {
    cidr = "10.0.4.0/24"
    az   = "eu-central-1c"
  }
}
private_subnet_RDS = {
  private_RDS_1 = {
    cidr = "10.0.5.0/24"
    az   = "eu-central-1b"
  },
  private_RDS_2 = {
    cidr = "10.0.6.0/24"
    az   = "eu-central-1c"
  }
}

# RDS
allocated_storage  = 20
database_name      = "crud"
rds_engine         = "mysql"
availability_zone  = "eu-central-1c"
rds_instance_class = "db.t3.micro"
master_username    = "root"
username           = "aleks"

# ASG
instance_type   = "t2.medium"
s3_uri          = "s3://crudprivatebacket/php-mysql-crud/" 
max_size        = 3
min_size        = 1  
instance_warmup = 180
asg_cooldown    = 60

# ASG_dynamic_policy
remove_instance     = -1
add_instance        = 1
asg_policy_cooldown = 60

# TARGET_GROUP
deregistration_delay = 60
check_grace_period   = 240

# CLOUDWATCH
period    = 300
threshold = 10

# ACM & Route53
domain_name = "oleksandrklochko.click"
ssl_policy  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
dns_zoneID  = "Z0791780307CLL6KUZTNH"
