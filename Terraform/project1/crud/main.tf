provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
  required_version = ">= 1.4"
    backend "s3" {
    region         = "ca-central-1" 
    key            = "terraform.tfstate"
    bucket         = "terraform-remote-state-canada-backet"
    dynamodb_table = "state-locking-table" 
  }
}

module "vpc_crud" {
  source             = "./modules/vpc_crud"
  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  public_subnet      = var.public_subnet
  private_subnet     = var.private_subnet
  private_subnet_RDS = var.private_subnet_RDS
}

module "infrastructure" {
  source                 = "./modules/infrastructure"
  vpc_id                 = module.vpc_crud.vpc_id
  private_subnets_RDS_id = module.vpc_crud.private_subnets_RDS_id
  public_subnets_id      = module.vpc_crud.public_subnets_id
  private_subnets_id     = module.vpc_crud.private_subnets_id
  environment            = var.environment
  allocated_storage      = var.allocated_storage
  database_name          = var.database_name
  rds_engine             = var.rds_engine
  availability_zone      = var.availability_zone
  rds_instance_class     = var.rds_instance_class
  instance_type          = var.instance_type
  s3_uri                 = var.s3_uri
  deregistration_delay   = var.deregistration_delay
  check_grace_period     = var.check_grace_period
  max_size               = var.max_size
  min_size               = var.min_size
  asg_policy_cooldown    = var.asg_policy_cooldown
  asg_cooldown           = var.asg_cooldown
  instance_warmup        = var.instance_warmup
  remove_instance        = var.remove_instance
  add_instance           = var.add_instance
  period                 = var.period
  threshold              = var.threshold
  master_username        = var.master_username
  username               = var.username
  domain_name            = var.domain_name
  ssl_policy             = var.ssl_policy
  dns_zoneID             = var.dns_zoneID
  allowed_ips            = var.allowed_ips
}

