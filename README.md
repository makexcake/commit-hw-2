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


## Deployment Guide
In order for this tamplate to work in your own environent the following actions are nessesary:
* Create and upload a certificate to AWS Certificate manager.
* Create task execution role that can get images from ECR.
* Create your own private bucket with images.
* Create ECR repo for the image, build the image first time by yourself and upload it to the registry.

When the following resources are set you are welcome to input your desired values into terraform.tfvars file and input the following command:

```bash
terraform apply -auto-approve
```

When the provisioning of the resources is done URL of the ALB will appear. It is accesible only via https. example link:
```
https://<alb-name>.<your-region>.elb.amazonaws.com
```

To destroy the resources input the command:
```bash
terraform destroy -auto-approve
```
All the resources should automatically be destroyed.