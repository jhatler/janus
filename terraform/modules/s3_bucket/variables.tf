variable "bucket" {
  type        = string
  description = "The name of the S3 bucket to create."
  sensitive   = true
}

variable "log_bucket" {
  type        = string
  description = "The name of the S3 bucket to which access logs will be written."
  sensitive   = true
}

variable "lifecycle_days_before_ia" {
  type        = number
  description = "The number of days after which objects will be transitioned to the STANDARD_IA storage class."
  sensitive   = true
  default     = 180
}

variable "lifecycle_days_before_glacier" {
  type        = number
  description = "The number of days after which objects will be transitioned to the GLACIER storage class."
  sensitive   = true
  default     = 365
}

variable "lifecycle_days_after_initiation" {
  type        = number
  description = "The number of days after which incomplete multipart uploads will be aborted."
  sensitive   = true
  default     = 7
}

variable "kms_master_key_id" {
  type        = string
  description = "The ARN of the KMS key to use for server-side encryption."
  sensitive   = true
}
