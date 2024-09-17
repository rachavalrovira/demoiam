provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "current" {}

module "dynamodb_table" {
  source         = "terraform-aws-modules/dynamodb-table/aws"
  name           = "${var.resources_prefix}-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}



module "lambda_function" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.resources_prefix}-dynamodb-writer"
  handler       = "index.handler"
  runtime       = "python3.12"
  source_path   = "../src/dynamodb_writer"
  environment_variables = {
    TABLE_NAME = module.dynamodb_table.dynamodb_table_id
  }
  attach_tracing_policy                   = true
  tracing_mode                            = "Active"
  create_current_version_allowed_triggers = false
  create_role                             = false
  lambda_role                             = "arn:aws:iam::${local.account_id}:role/${var.resources_prefix}-lambda-dynamodb-writer-role"
}
