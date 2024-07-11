variable "kernel" {
  type        = string
  description = "The fully qualified path to the operating kernel."
  sensitive   = false
}

variable "kernel_namespace" {
  type        = string
  description = "The namespace of the operating kernel."
  sensitive   = false
}

variable "kernel_repository" {
  type        = string
  description = "The name of the operating kernel's repository on GitHub."
  sensitive   = false
}

variable "kernel_owner" {
  type        = string
  description = "The owner of the operating kernel's repository on GitHub."
  sensitive   = false
}

variable "kernel_branch" {
  type        = string
  description = "The branch in use from the operating kernel's repository."
  sensitive   = false
}

variable "kernel_registry" {
  type        = string
  description = "The URL for the Terraform registry in use by the operating kernel."
  sensitive   = true
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
