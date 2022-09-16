terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "sns" {
    source = "./modules/sns"
    name = var.name
}

module "iam" {
    source = "./modules/iam"
    name = var.name
}

module "s3" {
    source = "./modules/s3"
    name = var.name
}

module "lambda" {
    source = "./modules/lambda"
    name = var.name
    commits_topic_arn = module.sns.commits_topic_arn
    access_user_arn = module.iam.access_user_arn
}