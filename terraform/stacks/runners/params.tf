resource "aws_ssm_parameter" "runner_admin_token" {
  name   = "/github/actions/runners/admin-token"
  type   = "SecureString"
  value  = var.runner_admin_pat
  key_id = var.runners_kms_key_arn
}

resource "aws_ssm_parameter" "runner_cooloff" {
  name   = "/github/actions/runners/cooloff"
  type   = "SecureString"
  value  = "10"
  key_id = var.runners_kms_key_arn
}
