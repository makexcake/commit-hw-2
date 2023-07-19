# Create windows and linux EC2 instances with event bridge 
# that uses lambda function to start and stop tagged instances
# on desired time (from 13:00 to 13:30).

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
module "eventbridge-instance-schedule" {
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