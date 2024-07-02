output "TF_VAR_runners_ssh_private_key" {
  value       = tls_private_key.runners.private_key_pem
  description = "The private SSH key for the GitHub Actions runners."
  sensitive   = true
}

