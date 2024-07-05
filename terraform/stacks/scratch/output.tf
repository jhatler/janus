output "TF_VAR_scratch_ecr_repository_url" {
  value       = aws_ecr_repository.scratch.repository_url
  sensitive   = true
  description = "The URL of the ECR repository for Scratch Images."
}
