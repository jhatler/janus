resource "aws_cloudwatch_log_group" "ssm_session_manager" {
  name       = "ssm-session-manager"
  kms_key_id = var.ssm_session_manager_kms_key_arn

  retention_in_days = 365
}
