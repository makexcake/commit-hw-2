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
  public_subnets = var.pub_subnets_cidr

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.env_name
  }
}

module "ecs-fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.52"

  # Container settings
  container_image = var.container_image
  container_name = var.container_name
  name_prefix = var.env_name

  # Container networking settings
  lb_http_ports = { "default_http": { "listener_port": 80, "target_group_port": 3000 } }
  port_mappings = [ { "containerPort": 3000, "hostPort": 3000, "protocol": "tcp" } ]

  # VPC settings
  private_subnets_ids = module.vpc.private_subnets
  public_subnets_ids = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id



  enable_s3_logs = false

    tags = {
    Terraform = "true"
    Environment = var.env_name
  }
}






