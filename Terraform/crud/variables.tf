variable "aws_region" {
  type    = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet" {
  type = map(any)
}

variable "private_subnet" {
  type = map(any)
}

variable "private_subnet_RDS" {
  type = map(any)
}

variable "allocated_storage" {
  type = string
}

variable "database_name" {
  type = string
}

variable "rds_engine" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "s3_uri" {
  type = string
}

variable "deregistration_delay" {
  type = string
}

variable "check_grace_period" {
  type = string
}

variable "max_size" {
  type = string
}

variable "min_size" {
  type = string
}

variable "add_instance" {
  type = string
}

variable "asg_policy_cooldown" {
  type = string
}

variable "asg_cooldown" {
  type = string
}

variable "instance_warmup" {
  type = string
}

variable "remove_instance" {
  type = string
}

variable "period" {
  type = string
}

variable "threshold" {
  type = string
}

variable "master_username" {
  type = string
}

variable "username" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "ssl_policy" {
  type = string
}

variable "dns_zoneID" {
  type = string
}

variable "allowed_ips" {
  type = string
}

