# General parameters

environment = "crud"
aws_region  = "eu-central-1"
environment = "crud"
allowed_ips = "31.129.232.111/30"

# RDS
allocated_storage  = 20
database_name      = "crud"
rds_engine         = "mysql"
availability_zone  = "eu-central-1b"
rds_instance_class = "db.t3.micro"
master_username    = "root"
username           = "aleks"

# ASG
instance_type   = "t2.micro"
s3_uri          = "s3://crudprivatebacket/php-mysql-crud/" 
max_size        = 3
min_size        = 1  
instance_warmup = 180
asg_cooldown    = 120

# ASG_dynamic_policy
remove_instance     = -1
add_instance        = 1
asg_policy_cooldown = 120

# TARGET_GROUP
deregistration_delay = 120
check_grace_period   = 300

# CLOUDWATCH
period    = 300
threshold = 10

# ACM & Route53
domain_name = "oleksandrklochko.click"
ssl_policy  = "ELBSecurityPolicy-TLS13-1-2-2021-06"
dns_zoneID  = "Z0791780307CLL6KUZTNH"