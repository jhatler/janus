output "ecr_repository_github_webhook_url" {
  value = aws_ecr_repository.github_webhook.repository_url
}
