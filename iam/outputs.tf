output "basic_lambda_role_arn" {
    value = module.basic_lambda_role.iam_role_arn
}

output "dynamodb_writer_role" {
    value = module.dynamodb_writer_role.iam_role_arn
}

output "s3_rw_role" {
    value = module.s3_rw_role.iam_role_arn
}