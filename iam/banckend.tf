terraform {
  backend "s3" {
    bucket         = "iam-demo-bucket-876278403405"
    key            = "iam-demo-iam.tfstate"
    region         = "us-east-1"
    dynamodb_table = "iam-demo-locks"
    encrypt        = true
  }
}