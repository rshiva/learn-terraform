provider "aws" {
    region = "ap-south-1"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}

resource "aws_vpc" "app_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "app_subnet-1" {
    vpc_id = aws_vpc.app_vpc.id
    cidr_block =  var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_route_table" "app_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  route = [{
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.app_internet_gateway.id
      carrier_gateway_id = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id = ""
      ipv6_cidr_block = ""
      local_gateway_id= ""
      nat_gateway_id = ""
      network_interface_id = ""
      transit_gateway_id = ""
      vpc_endpoint_id = ""
      vpc_peering_connection_id = ""
      instance_id = ""

  }]
  tags = {
        Name: "${var.env_prefix}-route_table"
    }
}

resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
        Name: "${var.env_prefix}-internet-gateway"
    }
}

resource "aws_route_table_association" "app_rtba" {
    subnet_id = aws_subnet.app_subnet-1.id
    route_table_id = aws_route_table.app_route_table.id
  
}

resource "aws_security_group" "app-sg" {
    name = "app-sg"

    //range of ports 
    ingress = [
        {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [var.my_ip]
            prefix_list_ids = []
            description = ""
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            self = true
        },
        {
            from_port = 8080
            to_port = 8080
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            prefix_list_ids = []
            description = ""
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            self = true
            
        }
    ]
    egress = [
        {
            from_port = 0
            to_port = 0
            protocol = "-1" #any protocol
            cidr_blocks = ["0.0.0.0/0"]
            prefix_list_ids = []
            description = ""
            ipv6_cidr_blocks = ["::/0"]
            security_groups = []
            self = true
        }
    ]

    tags = {
      Name = "${var.env_prefix}-sg"
    }
  
}