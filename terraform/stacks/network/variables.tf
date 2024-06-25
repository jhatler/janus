# tflint-ignore: terraform_unused_declarations
variable "control_repository" {
  type = string
}

# tflint-ignore: terraform_unused_declarations
variable "control_owner" {
  type = string
}

variable "s3_access_logs_bucket_id" {
  type        = string
  description = "The ID of the S3 bucket to use for S3 access logs."
}
