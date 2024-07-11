output "TF_VAR_kernel" {
  value       = "${var.kernel_owner}/${var.kernel_repository}/${var.kernel_branch}/${var.kernel_namespace}"
  description = "The fully qualified path distinguishing the kernel from others."
  sensitive   = false
}

output "TF_VAR_kernel_namespace" {
  value       = var.kernel_namespace
  description = "The namespace for the kernel and all resources operated by it."
  sensitive   = false
}

output "TF_VAR_kernel_token" {
  value       = var.kernel_token
  description = "The admin PAT for the kernel repository."
  sensitive   = true
}

output "TF_VAR_kernel_repository" {
  value       = var.kernel_repository
  description = "The name of the kernel repository on GitHub."
  sensitive   = false
}

output "TF_VAR_kernel_owner" {
  value       = var.kernel_owner
  description = "The owner of the kernel repository on GitHub."
  sensitive   = false
}

output "TF_VAR_kernel_branch" {
  value       = var.kernel_branch
  description = "The branch to use on the kernel repository."
  sensitive   = false
}

output "TF_VAR_kernel_registry" {
  value       = var.kernel_registry
  description = "The URL for the Terraform registry associated with the kernel."
  sensitive   = true
}

output "TF_VAR_spacelift_organization" {
  value       = var.spacelift_organization
  description = "The name of the Spacelift organization running the kernel."
  sensitive   = true
}

output "TF_VAR_spacelift_api_key_endpoint" {
  value       = var.spacelift_api_key_endpoint
  description = "The endpoint for your Spacelift organization."
  sensitive   = true
}

output "TF_VAR_spacelift_api_key_id" {
  value       = var.spacelift_api_key_id
  description = "The ID of the API key for Spacelift."
  sensitive   = true
}

output "TF_VAR_spacelift_api_key_secret" {
  value       = var.spacelift_api_key_secret
  description = "The secret for the API key for Spacelift."
  sensitive   = true
}

output "TF_VAR_aikido_secret_key" {
  value       = var.aikido_secret_key
  description = "The secret key for the Aikido access."
  sensitive   = true
}

output "TF_VAR_infracost_api_key" {
  value       = var.infracost_api_key
  description = "The API key for Infracost."
  sensitive   = true
}

output "TF_VAR_kernel_cidr_prefix" {
  value       = var.kernel_cidr_prefix
  description = "The CIDR prefix for the kernel VPC (e.g. 10.0)."
  sensitive   = true
}

output "TF_VAR_workloads_role_id" {
  value       = aws_iam_role.workloads.id
  description = "The ID of the stack role."
  sensitive   = true
}

output "TF_VAR_kernel_modules_ids" {
  value       = [for module in spacelift_module.kernel_modules : module.id]
  description = "The kernel module IDs."
  sensitive   = false
}
