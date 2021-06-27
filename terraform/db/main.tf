provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_db_instance" "database" {
  identifier_prefix = "makushatnik"
  engine            = "postgresql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "treasury"
  username          = admin
  password          = data.aws_secrets_manager_secret_version.db_password.secret_string
}

data "aws_secrets_manager_secret_version" "db_password" {
  secret_id = "postgres-admin-pass"
}

terraform {
  backend "s3" {
    bucket         = "makushatnik-state-bucket"
    key            = "db/postgres.tfstate"
    region         = "us-east-2"
    dynamodb_table = "treasury"
    encrypt        = true
  }
}
