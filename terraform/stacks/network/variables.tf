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

variable "s3_access_logs_bucket_id" {
  type        = string
  description = "The ID of the S3 bucket to use for S3 access logs."
  sensitive   = true
}

variable "class_b_prefix" {
  type        = string
  description = "The class B prefix for the VPC (e.g. 10.0)."
  sensitive   = true
}

variable "vpc_flow_role_arn" {
  type        = string
  description = "The ARN of the IAM role to be used for VPC Flow Logs."
  sensitive   = true
}

variable "vpc_flow_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used for VPC Flow Logs."
  sensitive   = true
}
