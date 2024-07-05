output "TF_VAR_janus_ecr_repository_url" {
  value       = aws_ecr_repository.janus.repository_url
  sensitive   = true
  description = "The URL of the ECR repository for Janus Images."
}
