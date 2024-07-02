output "TF_VAR_github_webhook_ecr_repository_url" {
  value       = aws_ecr_repository.github_webhook.repository_url
  sensitive   = true
  description = "The URL of the ECR repository for the GitHub Webhook lambda function."
}
