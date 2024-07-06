output "TF_VAR_s3_access_logs_bucket_id" {
  value       = module.s3_access_logs.id
  description = "The ID of the S3 bucket to use for S3 access logs."
  sensitive   = true
}
