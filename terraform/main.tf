provider "aws" {
  region = "eu-central-1"
}


variable vpc_cidr_block {}
variable subnets_cidr {}
variable "pub_subnets_cidr" {}
variable avail_zones {}
variable env_name {}


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




