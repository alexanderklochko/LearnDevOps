# General parameters
aws_region  = "ca-central-1"
environment = "crud"
allowed_ips = "31.129.232.108/30"

# Network parameter
vpc_cidr = "10.0.0.0/16"
public_subnet = {
  public_1 = {
    cidr = "10.0.1.0/24"
    az   = "ca-central-1b"
  },
  public_2 = {
    cidr = "10.0.2.0/24"
    az   = "ca-central-1a"
  }
}
private_subnet = {
  private_1 = {
    cidr = "10.0.3.0/24"
    az   = "ca-central-1b"
  },
  private_2 = {
    cidr = "10.0.4.0/24"
    az   = "ca-central-1a"
  }
}
private_subnet_RDS = {
  private_RDS_1 = {
    cidr = "10.0.5.0/24"
    az   = "ca-central-1b"
  },
  private_RDS_2 = {
    cidr = "10.0.6.0/24"
    az   = "ca-central-1a"
  }
}

# RDS
allocated_storage  = 20
database_name      = "crud"
rds_engine         = "mysql"
availability_zone  = "ca-central-1b"
rds_instance_class = "db.t3.micro"
master_username    = "root"
username           = "aleks"

# ASG
instance_type   = "t2.micro"
s3_uri          = "s3://crudprivatebacket/php-mysql-crud/" 
max_size        = 3
min_size        = 1  
instance_warmup = 60
asg_cooldown    = 60

# ASG_dynamic_policy
remove_instance     = -1
add_instance        = 1
asg_policy_cooldown = 60

# TARGET_GROUP
deregistration_delay = 60
check_grace_period   = 120

# CLOUDWATCH
period    = 30
threshold = 10

# ACM & Route53
domain_name = "oleksandrklochko.click"
ssl_policy  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
dns_zoneID  = "Z0791780307CLL6KUZTNH"
