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

variable "runners_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used for CI Runners"
  sensitive   = true
}

variable "runners_admin_pat" {
  type        = string
  description = "The personal access token for runner admin."
  sensitive   = true
}
