output "TF_VAR_vpc_flow_role_arn" {
  value       = aws_iam_role.vpc_flow.arn
  description = "The ARN of the IAM role to be used for VPC Flow Logs"
  sensitive   = true
}

output "TF_VAR_apigateway_logs_role_arn" {
  value       = aws_iam_role.apigateway_logs.arn
  description = "The ARN of the IAM role that API Gateway should assume to write logs to CloudWatch."
  sensitive   = true
}

output "TF_VAR_github_webhook_role_arn" {
  value       = aws_iam_role.github_webhook.arn
  description = "The ARN of the IAM role that the GitHub Webhook API Gateway should assume to send messages to SQS."
  sensitive   = true
}

output "TF_VAR_github_webhook_lambda_role_arn" {
  value       = aws_iam_role.github_webhook_lambda.arn
  description = "The ARN of the IAM role that the GitHub Webhook Lambda should assume."
  sensitive   = true
}
