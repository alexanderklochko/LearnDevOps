terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
# Adding Backend as S3 for Remote State Storage
    backend "s3" {
    bucket = "ms-terraform-aws-eks-ajfdbgadjkfbg2383873879hjadccg"
    key    = "dev/eks-cluster/terraform.tfstate"
    region = "eu-north-1"
    profile = "new_profile"

    # For State Locking
    dynamodb_table = "dev-eks-clusterfdsfsdfsdf"
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "new_profile"
}
