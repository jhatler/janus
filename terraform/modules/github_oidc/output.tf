output "role_arn" {
  value       = aws_iam_role.gh_oidc.arn
  description = "The ARN of the IAM role to use for GitHub OIDC."
}
