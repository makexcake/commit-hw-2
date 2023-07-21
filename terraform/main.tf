provider "aws" {
  region = "eu-central-1"
}


variable vpc_cidr_block {}
variable subnets_cidr {}
variable "pub_subnets_cidr" {}
variable avail_zones {}
variable env_name {}
variable "region" {
  
}


variable "container_image" {}
variable "container_name" {}
variable "certificate_arn" {}
variable instance_type {}
variable linux_ami_id {}
variable windows_ami_id {}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.env_name}-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.avail_zones
  private_subnets = var.subnets_cidr
  public_subnets = var.pub_subnets_cidr  # ALB must be in a public subnet

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Name = "${var.env_name}-vpc"
  }
}

# Gateway Endpoint to access s3 bucket NOT via public internet
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [ module.vpc.private_route_table_ids[0],
                      module.vpc.private_route_table_ids[1],
                      module.vpc.public_route_table_ids[0]]

  tags = {
    Name = "s3-vpc-endpoint"
  }
}





