terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
    helm = {
      source = "hashicorp/helm"
      #version = "2.10.0"
      version = "~> 2.10.1"
    }
    http = {
      source = "hashicorp/http"
      #version = "3.3.0"
      version = "~> 3.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21.1"
    }
  }
# Adding Backend as S3 for Remote State Storage
    backend "s3" {
    bucket = "ms-terraform-aws-eks-ajfdbgadjkfbg2383873879hjadccg"
    key    = "dev/aws-lbc/terraform.tfstate"
    region = "eu-north-1"
    profile = "new_profile"

    # For State Locking
    dynamodb_table = "dev-lb-controllersdffsdfsd"
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "new_profile"
}

# Terraform HTTP Provider Block
provider "http" {
  # Configuration options
}