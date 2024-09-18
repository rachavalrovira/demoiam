terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0"
    }
  }
  backend "s3" {
    encrypt = true
    acl     = "bucket-owner-full-control"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      project = lower("datalake")
    }
  }
  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  assume_role {
    role_arn     = var.role_arn
    session_name = var.session_name
    # # Depending on your use case, you might need to add other optional fields here.
    # # For example, external_id if your role requires it.
  }
}