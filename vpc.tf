provider "aws" {
  region = "ap-south-1"
}
 
# Data source to fetch availability zones in the region (optional but good practice)
data "aws_availability_zones" "available" {}
 
# Create the VPC
resource "aws_vpc" "new_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "new-vpc"
  }
}
 
# Create a public subnet in one of the availability zones
resource "aws_subnet" "new_public_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]  # Automatically pick the first AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "new-public-subnet"
  }
}
 
# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "new_igw" {
  vpc_id = aws_vpc.new_vpc.id
  tags = {
    Name = "new-igw"
  }
}
 
# Optionally, associate a security group (for public access)
resource "aws_security_group" "new_sg" {
  name        = "new-sg"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.new_vpc.id
 
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all inbound traffic
  }
 
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}
 
output "vpc_id" {
  value = aws_vpc.new_vpc.id
}
 
output "subnet_id" {
  value = aws_subnet.new_subnet.id
}
 
output "internet_gateway_id" {
  value = aws_internet_gateway.new_igw.id
}
