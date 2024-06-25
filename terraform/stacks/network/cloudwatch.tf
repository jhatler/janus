# Cloudwatch Setup
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name       = "vpc-flow"
  kms_key_id = aws_kms_key.vpc_flow.arn

  retention_in_days = 365
}
