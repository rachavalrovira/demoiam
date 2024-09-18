variable "aws_region" {
  type        = string
  description = "The region to use"

}

variable "resources_prefix" {
  type        = string
  description = "The resources prefix"
}

variable "environment" {
  type = string
}
variable "role_arn" {
  description = "The ARN of the role to assume."
  type        = string
  default     = ""
}
variable "session_name" {
  description = "The name to associate with the assumed role session."
  type        = string
  default     = ""

}