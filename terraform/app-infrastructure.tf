# # Create s3 bucket for the app pictures
# resource "aws_s3_bucket" "commit-task-2-bucket" {
#   bucket = "commit-task-2-bucket-tf-edition"

#   tags = {
#     Name        = "${var.env_name}-bucket"
#   }
# }

# # Security group for the cluster to allow the ALB access it 
# resource "aws_security_group" "commit-task-2-ecs-sg" {
#     name = "${var.env_name}-ecs-sg"
#     vpc_id = aws_vpc.commit-task-2-vpc.id


#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#         prefix_list_ids = []
#     }

#     tags = {
#         Name: "${var.env_name}-ecs-sg"
#     }
# }

# # Security group for ALB with the application ports

# resource "aws_security_group" "commit-task-2-alb-sg" {
#     name = "${var.env_name}-alb-sg"
#     vpc_id = aws_vpc.commit-task-2-vpc.id


#     egress {
#         from_port = 0
#         to_port = 80
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         prefix_list_ids = []
#     }

#     tags = {
#         Name: "${var.env_name}-alb-sg"
#     }
# }

# # Create ECS cluster
# resource "aws_ecs_cluster" "commit-task-2-ecs-cluster" {
#   name = "commit-task-2-ecs-cluster"
#   vpc_id = aws_vpc.commit-task-2-vpc.id
#   subnets = [aws_subnet.commit-task-2-subnet-1.id, aws_subnet.commit-task-2-subnet-2.id]
# }

# # Create task definition

# # Create target group 

# # Create ALB

# # Create service