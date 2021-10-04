provider "aws" {}

# resource "aws_s3_bucket" "test_s3" {
#   bucket = "demo-21-bucket-terraform"
#   acl    = "private"
# }

#  resource "aws_ec2_host" "test" {
#   instance_type     = "c5.18xlarge"
#   availability_zone = "ap-south-1a"
#   host_recovery     = "on"
#   auto_placement    = "on"
# }

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

variable "environment" {
    description = "identify the env"
  
}

resource "aws_vpc" "development_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: var.environment
    }
}

# resource "aws_subnet" "development-subnet-1" {
#     vpc_id = aws_vpc.development_vpc.id
#     cidr_block = "10.0.10.0/24"
#     availability_zone = "ap-southeast-2e"
#     map_public_ip_on_launch  = false
#     assign_ipv6_address_on_creation = false
# }

# data "aws_vpc" "existing_vpc"{
#     default = true
# }


