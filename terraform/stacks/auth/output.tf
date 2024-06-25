output "TF_VAR_vpc_flow_role_arn" {
  value       = aws_iam_role.vpc_flow.arn
  description = "The ARN of the IAM role to be used for VPC Flow Logs"
  sensitive   = true
}
