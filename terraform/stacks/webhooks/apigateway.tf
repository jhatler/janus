## API Gateway to handle events from GitHub Webhooks
resource "aws_api_gateway_rest_api" "github_webhook" {
  #ts:skip=AWS.APIGateway.NetworkSecurity.Medium.0570 This will be addressed in a future PR

  name = "github-webhook"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  lifecycle {
    create_before_destroy = true
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
  # checkov:skip=CKV_AWS_59:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_53:This will be addressed in a future PR
  #ts:skip=AWS.APGM.IS.LOW.0056 This will be addressed in a future PR
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

  credentials = var.github_webhook_role_arn

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
  # checkov:skip=CKV_AWS_76:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_225:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_51:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_29:This will be addressed in a future PR
  #ts:skip=AWS.APIGateway.Logging.Medium.0567 This will be addressed in a future PR

  deployment_id         = aws_api_gateway_deployment.github_webhook_alpha.id
  rest_api_id           = aws_api_gateway_rest_api.github_webhook.id
  stage_name            = "alpha"
  xray_tracing_enabled  = true
  cache_cluster_enabled = true
}
resource "aws_api_gateway_stage" "github_webhook_beta" {
  # checkov:skip=CKV_AWS_76:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_225:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_51:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_29:This will be addressed in a future PR
  #ts:skip=AWS.APIGateway.Logging.Medium.0567 This will be addressed in a future PR

  deployment_id         = aws_api_gateway_deployment.github_webhook_beta.id
  rest_api_id           = aws_api_gateway_rest_api.github_webhook.id
  stage_name            = "beta"
  xray_tracing_enabled  = true
  cache_cluster_enabled = true
}
resource "aws_api_gateway_stage" "github_webhook_stable" {
  # checkov:skip=CKV_AWS_76:This will be addressed in a future PR
  # checkov:skip=CKV_AWS_225:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_51:This will be addressed in a future PR
  # checkov:skip=CKV2_AWS_29:This will be addressed in a future PR
  #ts:skip=AWS.APIGateway.Logging.Medium.0567 This will be addressed in a future PR

  deployment_id         = aws_api_gateway_deployment.github_webhook_stable.id
  rest_api_id           = aws_api_gateway_rest_api.github_webhook.id
  stage_name            = "stable"
  xray_tracing_enabled  = true
  cache_cluster_enabled = true
}

# Enable logging on all stages
resource "aws_api_gateway_method_settings" "all_alpha" {
  # checkov:skip=CKV_AWS_225:This will be addressed in a future PR

  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  stage_name  = aws_api_gateway_stage.github_webhook_alpha.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
resource "aws_api_gateway_method_settings" "all_beta" {
  # checkov:skip=CKV_AWS_225:This will be addressed in a future PR

  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  stage_name  = aws_api_gateway_stage.github_webhook_beta.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}
resource "aws_api_gateway_method_settings" "all_stable" {
  # checkov:skip=CKV_AWS_225:This will be addressed in a future PR

  rest_api_id = aws_api_gateway_rest_api.github_webhook.id
  stage_name  = aws_api_gateway_stage.github_webhook_stable.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}


