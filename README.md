# Terraform Branch
Branch for homework provisioning infrastructure using Terraform.

## Files Description
* lambda folder: Contains python code for the lambda functions to start and stop tagged instances with the tag "scheduled":  "true".
* Terraform folder: Contains terraform files that provision the resources described below.

## Resources Description
* VPC with 2 private and 2 public subnets
* Internet Gateway and Gateway Endpoint to S3.
* 2 EC2 instances with the tag "scheduled": "true" in the private subnet
* EventBridge rule to trigger the start and stop lambda functions.
* ALB with https listener that uses my very own certificate (created it via openSSL) stored in AWS Cerrificate Manager.
* ECS Fargate cluster with service that provisions 2 containers.
* The setup uses SSL Offload which means that the traffic from the internet to ALB use https protocol and from ALB to the continer http.
* AWS CodePipeline pipeline with 3 stages: Source, Build, Deploy. In every push to the app branch the pipeline initiated.

