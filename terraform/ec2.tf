resource "aws_security_group" "commit-task-2-sg" {
    name = "${var.env_name}-sg"
    vpc_id = aws_vpc.commit-task-2-vpc.id


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_name}-sg"
    }
}


# Create an Amazon linux instance
resource "aws_instance" "commit-task-2-linux-server" {
    ami = var.linux_ami_id
    instance_type = var.instance_type

    subnet_id = aws_subnet.commit-task-2-subnet-1.id
    vpc_security_group_ids = [aws_security_group.commit-task-2-sg.id]

    associate_public_ip_address = false
    

    tags = {
        Name = "${var.env_name}-linux-server"
    }
}

# Create an Windows Server 2019 Base instance
resource "aws_instance" "commit-task-2-2indows-server" {
    ami = var.windows_ami_id
    instance_type = var.instance_type

    subnet_id = aws_subnet.commit-task-2-subnet-1.id
    vpc_security_group_ids = [aws_security_group.commit-task-2-sg.id]

    associate_public_ip_address = false

    tags = {
        Name = "${var.env_name}-windows-server"
    }
}