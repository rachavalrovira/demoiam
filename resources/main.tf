
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "iam-demo-bucket-876278403405"
    key    = "demoiam/iam-roles/dev/terraform.tfstate"
    region = var.aws_region
  }
}

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

module "lambda_function_1" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.resources_prefix}-dynamodb-writer"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  source_path   = "../src/dynamodb_writer"
  environment_variables = {
    TABLE_NAME = module.dynamodb_table.dynamodb_table_id
  }
  attach_tracing_policy                   = true
  tracing_mode                            = "Active"
  create_current_version_allowed_triggers = false
  create_role                             = false
  lambda_role                             = data.terraform_remote_state.iam.outputs.dynamodb_writer_role_arn
}

module "lambda_function_2" {
  source                                  = "terraform-aws-modules/lambda/aws"
  function_name                           = "${var.resources_prefix}-basic-lambda"
  handler                                 = "index.lambda_handler"
  runtime                                 = "python3.12"
  source_path                             = "../src/basic_lambda"
  attach_tracing_policy                   = true
  tracing_mode                            = "Active"
  create_current_version_allowed_triggers = false
  create_role                             = false
  lambda_role                             = data.terraform_remote_state.iam.outputs.basic_lambda_role_arn
}

module "s3_bucket" {
  source                                = "terraform-aws-modules/s3-bucket/aws"
  bucket                                = "${var.resources_prefix}-example-bucket-${local.account_id}"
  acl                                   = "private"
  force_destroy                         = true
  attach_deny_insecure_transport_policy = true
  control_object_ownership              = true
  object_ownership                      = "ObjectWriter"
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning = {
    enabled = true
  }
}

module "lambda_function_3" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.resources_prefix}-s3-writer"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  source_path   = "../src/s3_reader_writer"
  environment_variables = {
    BUCKET_NAME = module.s3_bucket.s3_bucket_id
  }
  attach_tracing_policy                   = true
  tracing_mode                            = "Active"
  create_current_version_allowed_triggers = false
  create_role                             = false
  lambda_role                             = data.terraform_remote_state.iam.outputs.s3_rw_role_arn
}
