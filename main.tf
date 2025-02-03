provider "aws" {
  region = "ap-south-1"
}
 
# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-Vamsee"
 
  lifecycle {
    prevent_destroy = true
  }
 
  versioning {
    enabled = true
  }
 
  tags = {
    Name = "Terraform State Bucket"
  }
}
 
# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = {
    Name = "Terraform Lock Table"
  }
}
 
# Configure Remote Backend
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-Vamsee"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
 
# Create an EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-00bb6a80f01f03502" # Example Amazon Linux 2 AMI
  instance_type = "t2.micro"
 
  tags = {
    Name = "MyEC2Instance"
  }
}
