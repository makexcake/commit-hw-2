terraform {

  # bucket for storing tfstate 
  backend "s3" {
    bucket = "bucket-for-terraform-huipipa"
    key = "myapp/terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.7.0"
    }
  }
}

