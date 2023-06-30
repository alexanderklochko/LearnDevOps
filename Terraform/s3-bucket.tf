provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "ca-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60"
    }
  }
}

# S3 Buckets
resource "aws_s3_bucket" "main-bucket" { # main bucket
  bucket = "terraform-remote-state-canada-backet"
  versioning {
    enabled = true
  }
}

# DynamoDB
resource "aws_dynamodb_table" "crud-table" {
  name           = "state-locking-table"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
