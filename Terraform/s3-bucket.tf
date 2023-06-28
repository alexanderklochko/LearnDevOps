# S3 Buckets
resource "aws_s3_bucket" "crud-bucket" { # main bucket
  bucket = "crudbgadjkfbg2383873879hjadccg"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "dev-bucket-sub1" { # crud bucket
  bucket  = aws_s3_bucket.dev-bucket.id
  key     = "crud/"
  content = ""
}

# DynamoDB
resource "aws_dynamodb_table" "crud-table" {
  name           = "crud"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
