env_name = "commit-hw-tf"
# Vars for VPC module
vpc_cidr_block = "10.10.0.0/16"
subnets_cidr = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
pub_subnets_cidr = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
avail_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

# Vars for ecs fargate module
container_image = "528100219426.dkr.ecr.eu-central-1.amazonaws.com/homework-app-2:1.0"
container_name = "hommework-container"
