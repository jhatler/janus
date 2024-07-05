output "TF_VAR_ubuntu_cloudimgs_ecr_repository_url" {
  value       = aws_ecr_repository.ubuntu_cloudimgs.repository_url
  sensitive   = true
  description = "The URL of the ECR repository for Ubuntu Cloud Images."
}
