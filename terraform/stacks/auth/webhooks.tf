# IAM role for GitHub Webhook API Gateway
resource "aws_iam_policy" "github_webhook_sqs_push" {
  name = "github-webhook-sqs-push"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sqs:SendMessage*"]
        Effect = "Allow"
        Resource = [
          "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:github-webhook.fifo"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "github_webhook" {
  name               = "github-webhook"
  assume_role_policy = data.aws_iam_policy_document.assume_role_apigateway.json
}

resource "aws_iam_role_policy_attachment" "github_webhook_sqs_push" {
  role       = aws_iam_role.github_webhook.name
  policy_arn = aws_iam_policy.github_webhook_sqs_push.arn
}

data "aws_iam_policy_document" "github_webhook_attach" {
  statement {
    effect = "Allow"
    sid    = "AllowFlowLogsRolePass"
    actions = [
      "iam:PassRole"
    ]

    resources = [aws_iam_role.github_webhook.arn]
  }
}

resource "aws_iam_role_policy" "github_webhook_attach" {
  name   = "github-webhook-attach"
  role   = var.stack_role_id
  policy = data.aws_iam_policy_document.github_webhook_attach.json
}

# Policy for webhook lambda and GitHub Actions Workflows to access EC2
data "aws_iam_policy_document" "github_ec2" {
  # checkov:skip=CKV_AWS_111:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_356:This will be addressed in a future PR

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/*"]
  }
}

resource "aws_iam_policy" "github_ec2" {
  name        = "github-ec2"
  path        = "/"
  description = "GitHub EC2 Access"

  policy = data.aws_iam_policy_document.github_ec2.json
}

# Role for lambda execution
resource "aws_iam_policy" "github_webhook_lambda" {
  name = "github-webhook-lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:github-webhook.fifo"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetShardIterator",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:ListStreams"
        ]
        Resource = [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook/index/*",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook/stream/*",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook-counts/index/*",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook-counts/stream/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:ConditionCheckItem",
          "dynamodb:PutItem",
          "dynamodb:DescribeTable",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Resource = [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook-counts",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeLimits"
        ]
        Resource = [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook/index/*",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook-counts",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/github-webhook-counts/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "github_webhook_lambda" {
  name = "github-webhook-lambda"

  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

resource "aws_iam_role_policy_attachment" "github_webhook_lambda" {
  role       = aws_iam_role.github_webhook_lambda.name
  policy_arn = aws_iam_policy.github_webhook_lambda.arn
}

resource "aws_iam_role_policy_attachment" "github_webhook_lambda_oidc" {
  role       = aws_iam_role.github_webhook_lambda.name
  policy_arn = aws_iam_policy.github_ec2.arn
}

data "aws_iam_policy_document" "github_webhook_lambda_attach" {
  statement {
    effect = "Allow"
    sid    = "AllowFlowLogsRolePass"
    actions = [
      "iam:PassRole"
    ]

    resources = [aws_iam_role.github_webhook_lambda.arn]
  }
}

resource "aws_iam_role_policy" "github_webhook_lambda_attach" {
  name   = "github-webhook-lambda-attach"
  role   = var.stack_role_id
  policy = data.aws_iam_policy_document.github_webhook_lambda_attach.json
}
