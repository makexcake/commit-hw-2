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
  # ALB must be in a public subnet
  public_subnets = var.pub_subnets_cidr

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.env_name
  }
}




# Create linux ec2 instance
resource "aws_instance" "linux-server" {
  
  instance_type = var.instance_type
  ami = var.linux_ami_id
  subnet_id = module.vpc.private_subnets[0]

  associate_public_ip_address = false

  tags = {
    Name = "${var.env_name}-linux-server"
    scheduled = "true"
  }
}

# Create windows ec2 instance
resource "aws_instance" "windows-server" {
  
  instance_type = var.instance_type
  ami = var.windows_ami_id
  subnet_id = module.vpc.private_subnets[0]

  associate_public_ip_address = false

  tags = {
    Name = "${var.env_name}-windows-server"
    scheduled = "true"
  }
}


# Event bridge, it will invoke lambda function that will 
# start and stop instances with the tag "scheduled" = "true"
module "eventbridge_start" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "ec2-start" # "default" bus already support schedule_expression in rules

  attach_lambda_policy = true
  lambda_target_arns   = ["arn:aws:lambda:eu-central-1:528100219426:function:start-tagged-ec2",
                          "arn:aws:lambda:eu-central-1:528100219426:function:stop-tagged-ec2"]

  schedules = {
    # invoke start instance lambda function at 13:00
    lambda-cron-start = {
      description         = "Trigger for a Lambda"
      schedule_expression = "cron(00 13 ? * SUN-FRI *)"
      timezone            = "Asia/Jerusalem"
      arn                 = "arn:aws:lambda:eu-central-1:528100219426:function:start-tagged-ec2"
      input               = jsonencode({ "job" : "cron-by-tod" })
    },
    
    # invoke stop instance lambda function at 13:30
    lambda-cron-stop = {
      description         = "Trigger for a Lambda"
      schedule_expression = "cron(30 13 ? * SUN-FRI *)" # "cron(30 13 ? * SUN-FRI *)"
      timezone            = "Asia/Jerusalem"
      arn                 = "arn:aws:lambda:eu-central-1:528100219426:function:stop-tagged-ec2"
      input               = jsonencode({ "job" : "cron-by-tod" })
    }
  }
}



# # Security groups for Fargate and ALB
# resource "aws_security_group" "fargate-sg" {
#   name        = "${var.env_name}-fargate-sg"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "health checks from ALB"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "tcp"
#     security_groups = [aws_security_group.alb-sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.env_name}-fargate-sg"
#   }
# }

# resource "aws_security_group" "alb-sg" {
#   name        = "${var.env_name}-alb-sg"
#   description = "Allow TLS and HTTP inbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "TLS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#     ingress {
#     description = "TLS from VPC"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${var.env_name}-alb-sg"
#   }
# }


# Fargate module for the app
module "ecs-fargate" {
  source  = "cn-terraform/ecs-fargate/aws"
  version = "2.0.52"

  # Container settings
  container_image = var.container_image
  container_name = var.container_name
  name_prefix = var.env_name

  # Container networking settings
  lb_http_ports = { "default_http": { "listener_port": 80, "target_group_port": 3000 } }
  lb_https_ports = { "default_http": { "listener_port": 443, "target_group_port": 3000 } }
  port_mappings = [ { "containerPort": 3000, "hostPort": 3000, "protocol": "tcp" } ]

  # Security groups for Fargate cluster and ALB
  # lb_security_groups = [aws_security_group.alb-sg.id]
  # ecs_service_security_groups = [aws_security_group.fargate-sg.id]

  # My very own self signed certificate
  default_certificate_arn = var.certificate_arn

  # VPC settings
  private_subnets_ids = module.vpc.private_subnets
  public_subnets_ids = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id

  lb_target_group_health_check_enabled = false
  assign_public_ip = true

  enable_s3_logs = false

    tags = {
    Terraform = "true"
    Environment = var.env_name
  }
}






