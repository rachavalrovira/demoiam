variable "aws_region" {
  type        = string
  description = "The region to use"
  default     = "us-east-1"
}

variable "resources_prefix" {
  type        = string
  description = "The resources prefix"
  default     = "iam-demo"
}