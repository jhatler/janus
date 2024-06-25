output "TF_VAR_class_b_prefix" {
  value       = var.class_b_prefix
  description = "The class B prefix for the VPC (e.g. 10.0)."
  sensitive   = true
}
