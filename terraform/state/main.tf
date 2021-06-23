terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_s3_bucket" "app_state" {
  bucket    = "makushatnik-state-bucket"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES_256"
      }
    }
  }
}

resource "aws_dynamodb_table" "locks" {
  name          = "locks"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "makushatnik-state-bucket"
    key            = "global/s3.tfstate"
    region         = "us-east-2"
    dynamodb_table = "locks"
    encrypt        = true
  }
}