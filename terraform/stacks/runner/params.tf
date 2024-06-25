# Param Store
resource "aws_ssm_parameter" "runner_admin_token" {
  name  = "/github/actions/runners/admin-token"
  type  = "SecureString"
  value = var.github_token
  tags = {
    "auth.gh-oidc" = "true"
  }
}

resource "aws_ssm_parameter" "runner_cooloff" {
  name  = "/github/actions/runners/cooloff"
  type  = "String"
  value = "10"
  tags = {
    "auth.gh-oidc" = "true"
  }
}

resource "aws_ssm_parameter" "account" {
  name  = "/ansible/bucket"
  type  = "SecureString"
  value = aws_s3_bucket.ssm_session_manager.bucket
  tags = {
    "auth.gh-oidc" = "true"
  }
}
