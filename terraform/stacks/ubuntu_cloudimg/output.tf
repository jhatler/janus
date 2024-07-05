output "TF_VAR_ubuntu_cloudimg_ecr_repository_url" {
  value       = aws_ecr_repository.ubuntu_cloudimg.repository_url
  sensitive   = true
  description = "The URL of the ECR repository for Ubuntu Cloud Images."
}
