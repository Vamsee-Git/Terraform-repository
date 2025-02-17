provider "aws" {
  region = "ap-south-1"
}

# Configure Remote Backend
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-vamsee"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
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
# S3 bucket for Terraform remote state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-two-tier-Vamsee"  # Ensure this name is globally unique
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
