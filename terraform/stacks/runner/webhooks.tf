# Queue for incoming webhook events
resource "aws_sqs_queue" "github_webhook" {
  name                        = "github-webhook.fifo"
  fifo_queue                  = true
  visibility_timeout_seconds  = 300
  message_retention_seconds   = 345600
  max_message_size            = 262144
  receive_wait_time_seconds   = 0
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
  content_based_deduplication = true
}

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
          aws_sqs_queue.github_webhook.arn
        ]
      },
    ]
  })
}

resource "aws_iam_role" "github_webhook" {
  name = "github-webhook"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_webhook_sqs_push" {
  role       = aws_iam_role.github_webhook.name
  policy_arn = aws_iam_policy.github_webhook_sqs_push.arn
}

## API Gateway to handle events from GitHub Webhooks
resource "aws_api_gateway_rest_api" "github_webhook" {
  name = "github-webhook"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# define /incoming resource
resource "aws_api_gateway_resource" "github_webhook_incoming" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  parent_id   = aws_api_gateway_rest_api.github_webhook.root_resource_id
  path_part   = "incoming"
}

# method to handle all /incoming requests
resource "aws_api_gateway_method" "github_webhook_incoming" {
  rest_api_id   = aws_api_gateway_rest_api.github_webhook.id
  resource_id   = aws_api_gateway_resource.github_webhook_incoming.id
  http_method   = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "github_webhook_incoming_sqs" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  resource_id = aws_api_gateway_resource.github_webhook_incoming.id
  http_method = aws_api_gateway_method.github_webhook_incoming.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration_response" "github_webhook_incoming_sqs" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  resource_id = aws_api_gateway_resource.github_webhook_incoming.id
  http_method = aws_api_gateway_method.github_webhook_incoming.http_method
  status_code = aws_api_gateway_method_response.github_webhook_incoming_sqs.status_code
}

# send /incoming requests to SQS
resource "aws_api_gateway_integration" "github_webhook_incoming_sqs" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  resource_id = aws_api_gateway_resource.github_webhook_incoming.id
  http_method = aws_api_gateway_method.github_webhook_incoming.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:sqs:path/${data.aws_caller_identity.current.account_id}/${aws_sqs_queue.github_webhook.name}"

  credentials = aws_iam_role.github_webhook.arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-amz-json-1.0'",
    "integration.request.header.X-Amz-Target" = "'AmazonSQS.SendMessage'"
  }

  request_templates = {
    "application/json" = templatefile("${path.module}/templates/gh-webhook-request.json.tftpl", {
      QueueUrl = aws_sqs_queue.github_webhook.url
    })
  }
}

# redeploy based on upstream resource changes
resource "aws_api_gateway_deployment" "github_webhook_alpha" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.github_webhook_incoming.id,
      aws_api_gateway_resource.github_webhook_incoming.id,
      aws_api_gateway_integration.github_webhook_incoming_sqs.id,
      aws_api_gateway_integration.github_webhook_incoming_sqs.request_templates,
      aws_api_gateway_method_response.github_webhook_incoming_sqs.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "github_webhook_beta" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id

  triggers = {
    redeployment = sha1(jsonencode([
      "INDEX=0"
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "github_webhook_stable" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id

  triggers = {
    redeployment = sha1(jsonencode([
      "INDEX=0"
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# maintain stages for deployments
resource "aws_api_gateway_stage" "github_webhook_alpha" {
  deployment_id        = aws_api_gateway_deployment.github_webhook_alpha.id
  rest_api_id          = aws_api_gateway_rest_api.github_webhook.id
  stage_name           = "alpha"
  xray_tracing_enabled = false
}
resource "aws_api_gateway_stage" "github_webhook_beta" {
  deployment_id        = aws_api_gateway_deployment.github_webhook_beta.id
  rest_api_id          = aws_api_gateway_rest_api.github_webhook.id
  stage_name           = "beta"
  xray_tracing_enabled = false
}
resource "aws_api_gateway_stage" "github_webhook_stable" {
  deployment_id        = aws_api_gateway_deployment.github_webhook_stable.id
  rest_api_id          = aws_api_gateway_rest_api.github_webhook.id
  stage_name           = "stable"
  xray_tracing_enabled = false
}

# Enable logging on all stages
resource "aws_api_gateway_method_settings" "all_alpha" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  stage_name  = aws_api_gateway_stage.github_webhook_alpha.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "ERROR"
  }
}
resource "aws_api_gateway_method_settings" "all_beta" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  stage_name  = aws_api_gateway_stage.github_webhook_beta.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "ERROR"
  }
}
resource "aws_api_gateway_method_settings" "all_stable" {
  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  stage_name  = aws_api_gateway_stage.github_webhook_stable.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = false
    logging_level   = "ERROR"
  }
}

## DynamoDB tables to store GitHub webhook events
resource "aws_dynamodb_table" "github_webhook" {
  name         = "github-webhook"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "X-GitHub-Delivery"

  attribute {
    name = "X-GitHub-Delivery"
    type = "S"
  }
}
resource "aws_dynamodb_table" "github_webhook_counts" {
  name         = "github-webhook-counts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_type"

  attribute {
    name = "event_type"
    type = "S"
  }
}

## Lambda function to handle github events via SQS
# policy for lambda to access SQS and Logs
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
          aws_sqs_queue.github_webhook.arn
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
          "${aws_dynamodb_table.github_webhook.arn}/index/*",
          "${aws_dynamodb_table.github_webhook.arn}/stream/*",
          "${aws_dynamodb_table.github_webhook_counts.arn}/index/*",
          "${aws_dynamodb_table.github_webhook_counts.arn}/stream/*"
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
          aws_dynamodb_table.github_webhook.arn,
          aws_dynamodb_table.github_webhook_counts.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeLimits"
        ]
        Resource = [
          "${aws_dynamodb_table.github_webhook.arn}",
          "${aws_dynamodb_table.github_webhook.arn}/index/*",
          "${aws_dynamodb_table.github_webhook_counts.arn}",
          "${aws_dynamodb_table.github_webhook_counts.arn}/index/*"
        ]
      }
    ]
  })
}

# Role for lambda execution
resource "aws_iam_role" "github_webhook_lambda" {
  name = "github-webhook-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "github_webhook_lambda" {
  role       = aws_iam_role.github_webhook_lambda.name
  policy_arn = aws_iam_policy.github_webhook_lambda.arn
}

resource "aws_iam_role_policy_attachment" "github_webhook_lambda_oidc" {
  role       = aws_iam_role.github_webhook_lambda.name
  policy_arn = aws_iam_policy.gh_oidc_ec2.arn
}

resource "aws_ecr_repository" "github_webhook" {
  name = "github-webhook"
}

# /incoming Lambda Function
resource "aws_lambda_function" "github_webhook_incoming" {
  function_name = "github-webhook"
  role          = aws_iam_role.github_webhook_lambda.arn
  architectures = ["x86_64"]
  image_uri     = "${aws_ecr_repository.github_webhook.repository_url}@sha256:07d99e016e73e45cf41386fb838921c85a295527d4e396172411312c38e5fe9b"
  package_type  = "Image"
  timeout       = 300
  memory_size   = 256
  image_config {
    command = [
      "lambda_function.incoming"
    ]
  }
}

# Events from SQS
resource "aws_lambda_event_source_mapping" "github_webhook" {
  event_source_arn = aws_sqs_queue.github_webhook.arn
  function_name    = aws_lambda_function.github_webhook_incoming.arn
  scaling_config {
    maximum_concurrency = 10
  }
}
