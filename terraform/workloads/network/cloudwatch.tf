# Cloudwatch Setup
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name       = "vpc-flow"
  kms_key_id = var.vpc_flow_kms_key_arn

  retention_in_days = 365
}
