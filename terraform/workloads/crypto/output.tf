output "TF_VAR_vpc_flow_kms_key_arn" {
  value       = module.kms_key_vpc_flow.arn
  description = "The ARN of the KMS key used for VPC Flow Logs"
  sensitive   = true
}

output "TF_VAR_runners_kms_key_arn" {
  value       = module.kms_key_runners.arn
  description = "The ARN of the KMS key used for CI Runners"
  sensitive   = true
}

output "TF_VAR_ssm_session_manager_kms_key_arn" {
  value       = module.kms_key_ssm_session_manager.arn
  description = "The ARN of the KMS key used for AWS Session Manager (SSM) Session Manager."
  sensitive   = true
}

output "TF_VAR_s3_access_logging_kms_key_arn" {
  value       = module.kms_key_s3_access.arn
  description = "The ARN of the KMS key used for S3 access logging."
  sensitive   = true
}
