# S3 Buckets
resource "aws_s3_bucket" "dev-bucket" { # main bucket
  bucket = "ms-terraform-aws-eks-ajfdbgadjkfbg2383873879hjadccg"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "dev-bucket-sub1" { # dev bucket
  bucket  = aws_s3_bucket.dev-bucket.id
  key     = "dev/"
  content = ""
}

resource "aws_s3_bucket_object" "dev-bucket-sub2" { # eks bucket
  bucket  = aws_s3_bucket.dev-bucket.id
  key     = "/dev/eks-cluster/"
  content = ""
}

resource "aws_s3_bucket_object" "dev-bucket-sub3" { # lb controller bucket
  bucket = aws_s3_bucket.dev-bucket.id
  key    = "/dev/aws-lbc/"
  content = ""
}

# DynamoDB
resource "aws_dynamodb_table" "dev-eks-cluster" {
  name           = "dev-eks-clusterfdsfsdfsdf"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_table" "dev-lb-controller" {
  name           = "dev-lb-controllersdffsdfsd"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}