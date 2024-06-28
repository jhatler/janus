output "TF_VAR_ssm_session_manager_bucket" {
  value       = aws_s3_bucket.ssm_session_manager.bucket
  description = "The name of the S3 bucket used for AWS Session Manager (SSM) Session Manager."
  sensitive   = true
}
