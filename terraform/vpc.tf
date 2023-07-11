# Create a VPC
resource "aws_vpc" "commit-task-2-vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
        Name: "${var.env_name}-vpc"
    }
}


# Creating two subnets
resource "aws_subnet" "commit-task-2-subnet-1" {
    vpc_id = aws_vpc.commit-task-2-vpc.id
    cidr_block = var.subnet_1_cidr_block
    availability_zone = var.avail_zone_1

    tags = {
        Name: "${var.env_name}-private-subnet-1"
    }
}

resource "aws_subnet" "commit-task-2-subnet-2" {
    vpc_id = aws_vpc.commit-task-2-vpc.id
    cidr_block = var.subnet_2_cidr_block
    availability_zone = var.avail_zone_2

    tags = {
        Name: "${var.env_name}-private-subnet-2"
    }
}








# //create internet gateway
# resource "aws_internet_gateway" "commit-task-2-igw" {
#     vpc_id = aws_vpc.commit-task-2-vpc.id

#     tags = {
#         Name: "${var.env_name}-igw"
#     }
# }

# //create route table
# resource "aws_route_table" "commit-task-2-route-table" {
#     vpc_id = aws_vpc.commit-task-2-vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.commit-task-2-igw.id
#     }

#     tags = {
#         Name: "${var.env_name}-rtb"
#     }
# }

# //associate route table with subnet
# resource "aws_route_table_association" "subnet-1-rtb-as" {
#     subnet_id = aws_subnet.commit-task-2-subnet-1.id
#     route_table_id = aws_route_table.commit-task-2-route-table.id
# }

# resource "aws_route_table_association" "subnet-2-rtb-as" {
#     subnet_id = aws_subnet.commit-task-2-subnet-2.id
#     route_table_id = aws_route_table.commit-task-2-route-table.id
# }
