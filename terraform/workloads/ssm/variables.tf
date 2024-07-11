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
