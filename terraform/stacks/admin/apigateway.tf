resource "aws_api_gateway_account" "self" {
  cloudwatch_role_arn = var.apigateway_logs_role_arn
}
