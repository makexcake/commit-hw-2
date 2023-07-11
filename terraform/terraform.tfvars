env_name = "commit-hw-tf"
# Vars for VPC module
vpc_cidr_block = "10.10.0.0/16"
subnets_cidr = ["10.10.1.0/24", "10.10.2.0/24"]
avail_zones = ["eu-central-1a", "eu-central-1b"]

# Vars for ecs fargate module
container_image = "528100219426.dkr.ecr.eu-central-1.amazonaws.com/homework-app-2:1.0"
container_name = "hommework-container"
