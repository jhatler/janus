output "s3_access_logs_bucket_id" {
  value       = aws_s3_bucket.s3_access_logs.id
  description = "The ID of the S3 bucket to use for S3 access logs."
}
