output "TF_VAR_class_b_prefix" {
  value       = var.class_b_prefix
  description = "The class B prefix for the VPC (e.g. 10.0)."
  sensitive   = true
}

output "TF_VAR_stack_role_id" {
  value       = aws_iam_role.integration.id
  description = "The ID of the stack role."
  sensitive   = true
}

output "TF_VAR_runners_admin_pat" {
  value       = var.runners_admin_pat
  description = "The personal access token for runner admin."
  sensitive   = true
}
