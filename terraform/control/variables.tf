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
variable "class_b_prefix" {
  type        = string
  description = "The class B prefix for the VPC (e.g. 10.0)."
  sensitive   = true
}

variable "runners_admin_pat" {
  type        = string
  description = "The personal access token for runner admin."
  sensitive   = true
}
