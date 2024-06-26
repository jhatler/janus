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

# tflint-ignore: terraform_unused_declarations
variable "github_webhook_role_arn" {
  type        = string
  description = "The ARN of the IAM role that the GitHub Webhook API Gateway should assume to send messages to SQS."
  sensitive   = true
}

# tflint-ignore: terraform_unused_declarations
variable "github_webhook_lambda_role_arn" {
  type        = string
  description = "The ARN of the IAM role that the GitHub Webhook Lambda should assume."
  sensitive   = true
}
