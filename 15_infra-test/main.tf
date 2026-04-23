# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tastylog-tfstate-bucket-otytymgc012345"
    key    = "tastylog-dev.tfstate"
    region = "ap-northeast-1"
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# ---------------------------------------------
# Modules
# ---------------------------------------------
module "lambda" {
  source          = "./modules/lambda"
  lambda_zip_path = "${path.module}/app/lambda.zip"
}

module "apigw" {
  source           = "./modules/apigateway"
  integration_type = "AWS_PROXY"
  integration_uri  = module.lambda.invoke_arn
  route_target     = module.lambda.function_name
}