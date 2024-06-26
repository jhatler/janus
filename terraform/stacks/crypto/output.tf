output "TF_VAR_vpc_flow_kms_key_arn" {
  value       = aws_kms_key.vpc_flow.arn
  description = "The ARN of the KMS key used for VPC Flow Logs"
  sensitive   = true
}

output "TF_VAR_runners_kms_key_arn" {
  value       = aws_kms_key.runners.arn
  description = "The ARN of the KMS key used for CI Runners"
  sensitive   = true
}
