# Environment name
region = "eu-central-1"
env_name = "commit-hw-tf"

# Vars for VPC module
vpc_cidr_block = "10.10.0.0/16"
subnets_cidr = ["10.10.10.0/24", "10.10.11.0/24"]
pub_subnets_cidr = ["10.10.20.0/24", "10.10.21.0/24"]
avail_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

# Vars for EC2 instances
instance_type = "t2.micro"
linux_ami_id = "ami-0aea56f3589631913"    # amazon linux 2 
windows_ami_id = "ami-02076a196031326b2"  # windows server 2019 base

# Vars for ecs fargate module "makecake/node-app:1.0" 
container_image =  "528100219426.dkr.ecr.eu-central-1.amazonaws.com/homework-app-2:latest" 
container_name = "hommework-container"

# Self signed certificate arn
certificate_arn = "arn:aws:acm:eu-central-1:528100219426:certificate/a24bff49-df38-4a21-b4fc-b62b66e69bde"
