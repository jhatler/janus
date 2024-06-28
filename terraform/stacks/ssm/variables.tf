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

variable "ssm_session_manager_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used for AWS Session Manager (SSM) Session Manager."
  sensitive   = true
}

variable "s3_access_logs_bucket_id" {
  type        = string
  description = "The ID of the S3 bucket to use for S3 access logs."
  sensitive   = true
}
