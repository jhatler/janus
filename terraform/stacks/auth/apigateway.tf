data "aws_iam_policy_document" "assume_role_apigateway" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AmazonAPIGatewayPushToCloudWatchLogs" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role" "apigateway_logs" {
  name               = "apigateway-logs"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_apigateway.json

  managed_policy_arns = [
    data.aws_iam_policy.AmazonAPIGatewayPushToCloudWatchLogs.arn
  ]
}
