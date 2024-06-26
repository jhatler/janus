# tflint-ignore: terraform_unused_declarations
variable "control_repository" {
  type        = string
  description = "The name of the GitHub repository for the control repository."
}

# tflint-ignore: terraform_unused_declarations
variable "control_owner" {
  type        = string
  description = "The owner of the GitHub repository for the control repository."
}

variable "apigateway_logs_role_arn" {
  type        = string
  description = "The ARN of the IAM role that API Gateway should assume to write logs to CloudWatch."
  sensitive   = true
}
