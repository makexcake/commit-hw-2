# CloudFormation Branch
Branch for homework provisioning infrastructure using CloudFormation.

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

## Deployment Instructions
* Create and upload a certificate to AWS Certificate manager. Domain name *.amazonaws.com.
* Create task execution role that can get images from ECR.
* Create your own private bucket with images.
* Create ECR repo for the image, build the image first time by yourself and upload it to the registry.
* You will need CF role that have premission to create the resources in the template on your behalf.
* The template can be used via the CloudFormation console or via AWS CLI, just don't forget to adjust the values to your cpecific needs (region, ami, etc.).

### Notes: 
* The template is half portable, with the default values it can be used in eu-central-1 region.
* Next step is to separate it to nested stacks for nesting and future reuse.

