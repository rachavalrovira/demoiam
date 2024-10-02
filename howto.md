
## IAM Module

Located in the `demoiam/iam/` directory, this module is responsible for creating IAM roles:

1. `basic_lambda_role`: A basic execution role for Lambda functions.
2. `dynamodb_writer_role`: A role for Lambda functions that need to write to DynamoDB.
3. `s3_rw_role`: A role for Lambda functions that need read and write access to S3 buckets.

### Key Files:
- `main.tf`: Defines the IAM roles using the `terraform-aws-modules/iam/aws//modules/iam-assumable-role` module.
- `outputs.tf`: Exports the ARNs of the created roles.
- `variables.tf`: Defines input variables for the module.
- `versions.tf`: Specifies the required Terraform and provider versions.

## Resources Module

Located in the `demoiam/resources/` directory, this module creates the application resources:

1. A DynamoDB table
2. Three Lambda functions:
   - `dynamodb_writer`
   - `basic_lambda`
   - `s3_writer`
3. An S3 bucket

### Key Files:
- `main.tf`: Defines the resources using various AWS modules.
- `variables.tf`: Defines input variables for the module.
- `versions.tf`: Specifies the required Terraform and provider versions.

## How They Interact

1. The IAM module creates the necessary roles.
2. The Resources module uses `terraform_remote_state` to fetch the role ARNs created by the IAM module.
3. The Lambda functions in the Resources module are associated with the appropriate roles from the IAM module.

## Deployment

1. Deploy the IAM module first:
   ```
   cd demoiam/iam
   terraform init
   terraform apply -var-file=dev/dev.tfvars
   ```

2. Then deploy the Resources module:
   ```
   cd demoiam/resources
   terraform init -backend-config=dev/backend.hcl
   terraform apply -var-file=dev/dev.tfvars
   ```

## Important Notes

- The project uses S3 backend for storing Terraform state.
- It assumes a role (`github-oidc-automation`) for operations, which is useful for CI/CD pipelines.
- Environment-specific variables are stored in `dev.tfvars` files.
- The `backend.hcl` file in the resources module configures the S3 backend.

## Security Considerations

- IAM roles are created with least privilege principles.
- S3 bucket is configured with encryption and secure transport policy.
- DynamoDB table uses provisioned capacity for predictable performance.

Remember to review and adjust permissions and configurations as needed for your specific use case and security requirements.
