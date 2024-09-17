provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "current" {}

module "basic_lambda_role" {
  source               = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version              = "~> 5.0"
  create_role          = true
  role_requires_mfa    = false
  trusted_role_actions = ["sts:AssumeRole"]
  role_name            = "lambda-basic-generic-role"
  trusted_role_services = [
    "lambda.amazonaws.com"
  ]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

module "dynamodb_writer_role" {
  source               = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version              = "~> 5.0"
  create_role          = true
  role_requires_mfa    = false
  trusted_role_actions = ["sts:AssumeRole"]
  role_name            = "${var.resources_prefix}-lambda-dynamodb-writer-role"
  trusted_role_services = [
    "lambda.amazonaws.com"
  ]
  inline_policy_statements = [
    {
      sid = "DynamoDBActions"
      actions = [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:BatchWriteItem"
      ]
      effect    = "Allow"
      resources = ["arn:aws:dynamodb:${var.aws_region}:${local.account_id}:table/${var.resources_prefix}*"]
    }
  ]
}


module "s3_rw_role" {
  source               = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version              = "~> 5.0"
  create_role          = true
  role_requires_mfa    = false
  trusted_role_actions = ["sts:AssumeRole"]
  role_name            = "${var.resources_prefix}-lambda-s3-rw-role"
  trusted_role_services = [
    "lambda.amazonaws.com"
  ]
  inline_policy_statements = [
    {
      sid = "DynamoDBActions"
      actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ]
      effect = "Allow"
      resources = [
        "arn:aws:s3:::${var.resources_prefix}*",
        "arn:aws:s3:::${var.resources_prefix}*/*"
      ]
    }
  ]
}
