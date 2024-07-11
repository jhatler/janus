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

variable "kernel_cidr_prefix" {
  type        = string
  description = "The CIDR prefix for the control VPC (e.g. 10.0)."
  sensitive   = true
}

variable "s3_access_logs_bucket_id" {
  type        = string
  description = "The ID of the S3 bucket to use for S3 access logs."
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
