# This tf file contains configuration of the app cluster

# Defining security groups for app and alb
resource "aws_security_group" "alb-sg" {

    vpc_id = module.vpc.vpc_id

    # Allow access from internet
    ingress {
        from_port = 0
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_name}-alb-sg"
    }
}
resource "aws_security_group" "service-sg" {

    vpc_id = module.vpc.vpc_id

    # Allow access from alb
    ingress {
        from_port = 0
        to_port = 3000
        protocol = "tcp"
        security_groups = [resource.aws_security_group.alb-sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_name}-service-sg"
    }
}



# Application lb
resource "aws_lb" "alb" {
  name               =  "${var.env_name}-alb" 
  internal           =  false
  load_balancer_type =  "application"
  security_groups    =  [resource.aws_security_group.alb-sg.id]
  subnets            =  module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.env_name}-alb"
  }
}
# Create listener for https
resource "aws_lb_listener" "alb-https-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hw-app-service.arn
  }

    tags = {
        Name = "${var.env_name}-alb-listener"
    }
}

# Create target group
resource "aws_lb_target_group" "hw-app-service" {
  name        = "${var.env_name}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      =  module.vpc.vpc_id

    tags = {
        Name = "${var.env_name}-target-group"
    }
}


# Fargate ECS cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.env_name}-cluster"

    tags = {
        Name = "${var.env_name}-ecs-cluster"
    }

}

# Task definition for the app
resource "aws_ecs_task_definition" "hw-app-task-definition" {
  family = "service"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

    cpu = 256
    memory = 512

   container_definitions = <<-JSON
    [{
        "name": "homework-app",
        "image": "makecake/homework-app:2.0",
        "essential": true,
        "portMappings": [
        {
            "containerPort": 3000,
            "hostPort": 3000,
            "protocol": "tcp"
        }
        ]
    }]
   JSON
    tags = {
        Name = "${var.env_name}-task-definition"
    }

}
# ECS service
resource "aws_ecs_service" "homework-app-service" {

    name            = "homework-app"
    cluster         = aws_ecs_cluster.ecs-cluster.id
    launch_type = "FARGATE"
    task_definition = aws_ecs_task_definition.hw-app-task-definition.id
    desired_count   = 2
    force_new_deployment = true
   
    network_configuration {
        security_groups = [aws_security_group.service-sg.id]
        subnets         = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
        assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.hw-app-service.arn
      container_name   = "homework-app"
      container_port   = 3000
    }

    tags = {
        Name = "${var.env_name}-service"
    }
}


# DNS name of the ALB
output "alb_dns" {
  value = aws_lb.alb.dns_name
}