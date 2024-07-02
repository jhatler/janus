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

variable "runners_role_arn" {
  type        = string
  description = "The ARN of the IAM role that the GitHub Actions runners should assume."
  sensitive   = true
}

variable "runners_controlled_role_arn" {
  type        = string
  description = "The ARN of the IAM role that the GitHub Actions runners should pass to temporary instances."
  sensitive   = true
}

variable "github_webhook_lambda_role_arn" {
  type        = string
  description = "The ARN of the IAM role that the GitHub Webhook Lambda should assume."
  sensitive   = true
}

variable "ssm_agent_role_arn" {
  type        = string
  description = "The ARN of the IAM role for generic SSM agent access."
  sensitive   = true
}
