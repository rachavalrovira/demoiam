bucket                   = "terraform-state-datalake-dev-876278403405-us-east-1"
key                      = "terraform.tfstate"
region                   = "us-east-1"
dynamodb_table           = "terraform-state-datalake-dev-876278403405-us-east-1"
workspace_key_prefix     = "demoiam/iam-roles"
role_arn                 = "arn:aws:iam::876278403405:role/github-oidc-automation"
session_name             = "backend-session"