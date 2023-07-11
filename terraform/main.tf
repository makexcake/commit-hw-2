provider "aws" {
  region = "eu-central-1"
}


variable vpc_cidr_block {}
variable subnets_cidr {}
variable avail_zones {}
variable env_name {}
# variable instance_type {}
# variable linux_ami_id {}
# variable windows_ami_id {}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.env_name}-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.avail_zones
  private_subnets = var.subnets_cidr

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "terraform"
  }
}








