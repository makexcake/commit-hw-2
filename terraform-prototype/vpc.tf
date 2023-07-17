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