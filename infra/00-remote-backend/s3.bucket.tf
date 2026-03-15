resource "aws_s3_bucket" "this" {
  bucket = "xavero-workshop-terraform-state"
  region = "us-east-1"

  tags = {
    Name = "xavero-workshop-terraform-state"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
